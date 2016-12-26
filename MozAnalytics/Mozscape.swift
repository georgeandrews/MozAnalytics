//
//  Mozscape.swift
//  iMoz
//
//  Created by George Andrews on 5/15/15.
//  Copyright (c) 2015 George Andrews. All rights reserved.
//

class Mozscape {
    
    static let urlMetricsURL = "https://lsapi.seomoz.com/linkscape/url-metrics/"
    static let colsValue = Metrics.responseFieldDetails.values.reduce(0){ (total, value) in total + (value[1] as! Int64) }
    
    class func retrieveDataFromMozAPI(_ urlToSearchFor: String, accessID: String, secretKey: String, completion: @escaping ((_ data: Data?, _ httpResponse: URLResponse?) -> Void)) {
        
        let mozscapeURL = makeMozscapeURL(urlToSearchFor: urlToSearchFor, accessID: accessID, secretKey: secretKey)
        
        loadDataFrom(url: mozscapeURL) { data, response in
            completion(data, response)
        }
        
    }
    
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
    
    fileprivate static func makeSignature(accessID: String, expiresInterval: String, secretKey: String) -> String {
        
        let stringToSign = (accessID + "\n" + expiresInterval)
        let sha1Digest = stringToSign.hmacsha1(key: secretKey)
        let base64EncodedData = sha1Digest.base64EncodedData(options: [])
        
        return NSString(data: base64EncodedData, encoding: String.Encoding.utf8.rawValue) as! String
    }
    
    fileprivate static func loadDataFrom(url: URL, completion:@escaping (_ data: Data?, _ httpResponse: URLResponse?) -> Void) {
        
        let loadDataTask = URLSession.shared.dataTask(with: url) {
            data, response, error in
            completion(data, response)
        }
        
        loadDataTask.resume()
    }
    
}
