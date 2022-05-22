/// Copyright (c) 2022 Razeware LLC
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

import Foundation

protocol Networking {
  typealias CompletionHandler = (Data?, Swift.Error?) -> Void
  
  func request(from: Endpoint, completion: @escaping CompletionHandler)
}

struct HTTPNetworking: Networking {
  func request(from: Endpoint, completion: @escaping CompletionHandler) {
    guard let url = URL(string: from.path) else { return }
    let request = createRequest(from: url)
    let task = createDataTask(from: request, comletion: completion)
    task.resume()
  }
  
  private func createRequest(from url: URL) -> URLRequest {
    let request = URLRequest(url: url)
    return request
  }
  
  private func createDataTask(from request: URLRequest, comletion: @escaping CompletionHandler) -> URLSessionDataTask {
    return URLSession.shared.dataTask(with: request) { data, respons, error in
      comletion(data, error)
    }
  }
}

































class HTTPNetworkingClass {
  
  static let networkingSharedManager = HTTPNetworkingClass()
  
   func requestPrice(completion: @escaping (Price) -> Void) {
    let bitcoin = Coinbase.bitcoin.path
    
    // 1. Make URL request
    guard let url = URL(string: bitcoin) else { return }
    var request = URLRequest(url: url)
    request.cachePolicy = .reloadIgnoringCacheData
    
    // 2. Make networking request
    let task = URLSession.shared.dataTask(with: request) { data, _, error in
      
      // 3. Check for errors
      if let error = error {
        print("Error received requesting Bitcoin price: \(error.localizedDescription)")
        return
      }
      
      // 4. Parse the returned information
      let decoder = JSONDecoder()

      guard let data = data,
            let response = try? decoder.decode(PriceResponse.self,
                                               from: data) else { return }
      
      print("Price returned: \(response.data.amount)")
      
      completion(Price(base: .BTC, amount: response.data.amount, currency: .USD))
      
      //price = response.data

    }

    task.resume()
  }
}





/*
private func requestPrice()  {
  let bitcoin = Coinbase.bitcoin.path
  
  // 1. Make URL request
  guard let url = URL(string: bitcoin) else { return }
  var request = URLRequest(url: url)
  request.cachePolicy = .reloadIgnoringCacheData
  
  // 2. Make networking request
  let task = URLSession.shared.dataTask(with: request) { data, _, error in
    
    // 3. Check for errors
    if let error = error {
      print("Error received requesting Bitcoin price: \(error.localizedDescription)")
      return
    }
    
    // 4. Parse the returned information
    let decoder = JSONDecoder()

    guard let data = data,
          let response = try? decoder.decode(PriceResponse.self,
                                             from: data) else { return }
    
    print("Price returned: \(response.data.amount)")
    
    // 5. Update the UI with the parsed PriceResponse
    DispatchQueue.main.async { [weak self] in
      self?.updateLabel(price: response.data)
    }
  }

  task.resume()
}*/
