//
//  Mozscape.swift
//  iMoz
//
//  Created by George Andrews on 5/15/15.
//  Copyright (c) 2015 George Andrews. All rights reserved.
//

import Foundation

class Mozscape {
  
  static let urlMetricsURL = "https://lsapi.seomoz.com/linkscape/url-metrics/"
  
  ///
  /// Accumulates values for response fields used in this application
  /// as one Cols value for the Mozscape API Request.
  ///
  static let colsValue = Metrics.responseFieldDetails.values.reduce(0){ (total, value) in total + (value[1] as! Int64) }
  
  ///
  /// Retrieves data from Mozscape API with a urlToSearchFor,
  /// an Access ID, and a Secret Key. A Moz Pro or Community Account
  /// is required to use the Mozscape API.
  ///
  /// URL for Managing Mozscape API Key: https://moz.com/products/api/keys
  ///
  class func retrieveDataFromMozAPI(_ urlToSearchFor: String, accessID: String, secretKey: String, completion: @escaping ((_ data: Data?, _ httpResponse: HTTPURLResponse?) -> Void)) {
    
    let mozscapeURL = makeMozscapeURL(urlToSearchFor: urlToSearchFor, accessID: accessID, secretKey: secretKey)
    
    loadDataFrom(url: mozscapeURL) { data, response in
      completion(data, response)
    }
    
  }
  
  ///
  /// Creates Mozscape URL to use when submitting Mozscape API Request.
  ///
  fileprivate static func makeMozscapeURL(urlToSearchFor: String, accessID: String, secretKey: String) -> URL {
    
    let expiresInterval = (floor(Date().timeIntervalSince1970 + 300) as NSNumber).stringValue
    let signature = makeSignature(accessID: accessID, expiresInterval: expiresInterval, secretKey: secretKey)
    
    let urlString = urlMetricsURL
      + urlToSearchFor.lowercased().urlencode()
      + "?Cols=" + String(colsValue)
      + "&Limit=1"
      + "&AccessID=" + accessID
      + "&Expires=" + expiresInterval
      + "&Signature=" + signature.urlencode()
    
    return URL(string: urlString)!
  }
  
  ///
  /// Creates base64 encoded Signature for Mozscape API Request using
  /// Access ID, Expires parameter, and the Secret Key.
  /// See: https://moz.com/help/guides/moz-api/mozscape/getting-started-with-mozscape/signed-authentication
  ///
  fileprivate static func makeSignature(accessID: String, expiresInterval: String, secretKey: String) -> String {
    
    let stringToSign = (accessID + "\n" + expiresInterval)
    let sha1Digest = stringToSign.hmacsha1(key: secretKey)
    let base64EncodedData = sha1Digest.base64EncodedData(options: [])
    
    return NSString(data: base64EncodedData, encoding: String.Encoding.utf8.rawValue) as! String
  }
  
  ///
  /// Submits the data task for retrieving data from the Mozscape API.
  ///
  fileprivate static func loadDataFrom(url: URL, completion:@escaping (_ data: Data?, _ httpResponse: HTTPURLResponse?) -> Void) {
    
    let loadDataTask = URLSession.shared.dataTask(with: url) {
      data, response, error in
      completion(data, response as? HTTPURLResponse) // ignoring error here and will instead interrogate data later...
    }
    
    loadDataTask.resume()
  }
  
}
