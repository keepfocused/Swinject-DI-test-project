/// Copyright (c) 2018 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit

internal class BitcoinViewController: UIViewController {
  
  @IBOutlet weak private var checkAgain: UIButton!
  @IBOutlet weak private var primary: UILabel!
  @IBOutlet weak private var partial: UILabel!
  
  var fetcher: PriceFetcher?
  
  private let dollarsDisplayFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.maximumFractionDigits = 0
    formatter.numberStyle = .currency
    formatter.currencySymbol = ""
    formatter.currencyGroupingSeparator = ","
    return formatter
  }()
  
  private let standardFormatter = NumberFormatter()
  
  // MARK: - View lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    /*
     HTTPNetworkingClass.networkingSharedManager.requestPrice(completion: { price in
     self.updateLabel(price: price)
     })*/
    
    requestPrice()
  }

  // MARK: - Actions
  @IBAction private func checkAgainTapped(sender: UIButton) {
    print("update tapped")
    requestPrice()
    
    
    /*
     HTTPNetworkingClass.networkingSharedManager.requestPrice(completion: { price in
     self.updateLabel(price: price)
     })*/
  }
  
  func requestPrice() {
    guard let fetcher = fetcher else { fatalError("Missing dependencies") }
    fetcher.fetch { response in
      guard let response = response else { return }
      DispatchQueue.main.async { [weak self] in
        self?.updateLabel(price: response.data)
      }
    }
  }
  
  // MARK: - Private methods
  private func updateLabel(price: Price) {
    guard let dollars = price.components().dollars,
          let cents = price.components().cents,
          let dollarAmount = standardFormatter.number(from: dollars) else { return }
    DispatchQueue.main.async { [weak self] in
      self?.primary.text = self?.dollarsDisplayFormatter.string(from: dollarAmount)
      self?.partial.text = ".\(cents)"
    }
  }
  
  /*
  func requestPrice() {
    networking.request(from: Coinbase.bitcoin) { data, error in
      if let error = error {
        print("Error received requesting Bitcoin price: \(error.localizedDescription)")
        return
      }
      let decoder = JSONDecoder()
      guard let data = data, let response = try? decoder.decode(PriceResponse.self, from: data) else { return }
      
      print("Price returned: \(response.data.amount)")
      
      DispatchQueue.main.async { [weak self] in
        self?.updateLabel(price: response.data)
      }
    }
  }*/
}
