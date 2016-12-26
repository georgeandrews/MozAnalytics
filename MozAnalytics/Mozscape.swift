//
//  Mozscape.swift
//  iMoz
//
//  Created by George Andrews on 5/15/15.
//  Copyright (c) 2015 George Andrews. All rights reserved.
//

<<<<<<< HEAD
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
=======
import Foundation

let LinksURL = "https://lsapi.seomoz.com/linkscape/url-metrics/"
let Cols = Metrics.responseFields.values.reduce(0){ (total, value) in total + (value[1] as! Int) }

class Mozscape {
    
    class func retrieveDataFromMozAPI(searchURL: String, accessID: String, secretKey: String, completion: ((data: NSData?, httpResponse: NSURLResponse?) -> Void)) {
        
        let expiresInterval = (floor(NSDate().timeIntervalSince1970 + 300) as NSNumber).stringValue
        
        var mozDataURL = LinksURL + searchURL.lowercaseString.urlencode()
        mozDataURL += "?Cols=" + String(Cols) + "&Limit=1"
        mozDataURL += "&AccessID=" + accessID
        mozDataURL += "&Expires=" + expiresInterval
        
        let urlSafeSignature = buildURLSafeSignature(accessID, secretKey: secretKey, expiresInterval: expiresInterval)
        
        mozDataURL += "&Signature=" + urlSafeSignature
        
        loadDataFromURL(NSURL(string: mozDataURL)!) { data, response in
            completion(data: data, httpResponse: response)
        }
        
    }
    
    private static func buildURLSafeSignature(accessID: String, secretKey: String, expiresInterval: String) -> String {
        
        let stringToSign = (accessID + "\n" + expiresInterval)
        let sha1Digest = stringToSign.hmacsha1(secretKey)
        let base64Encoded = sha1Digest.base64EncodedDataWithOptions([])
        
        return (NSString(data: base64Encoded, encoding: NSUTF8StringEncoding) as! String).urlencode()
    }
    
    private static func loadDataFromURL(url: NSURL, completion:(data: NSData?, httpResponse: NSURLResponse?) -> Void) {
        
        let session = NSURLSession.sharedSession()
        
        let loadDataTask = session.dataTaskWithURL(url, completionHandler: { (data: NSData?, response: NSURLResponse?, error: NSError?) in
            
            completion(data: data, httpResponse: response)
            
        })
>>>>>>> bcb94d1ccb0c9baa6ed6da445d1295720734e259
        
        loadDataTask.resume()
    }
    
}
<<<<<<< HEAD
=======

extension String {
    
    func urlencode() -> String {
        let stringToEncode = self.stringByReplacingOccurrencesOfString(" ", withString: "+")
        return stringToEncode.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())!
    }
    
    func hmacsha1(key: String) -> NSData {
        
        let dataToDigest = self.dataUsingEncoding(NSUTF8StringEncoding)
        let keyData = key.dataUsingEncoding(NSUTF8StringEncoding)
        
        let digestLength = Int(CC_SHA1_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.alloc(digestLength)
        
        CCHmac(CCHmacAlgorithm(kCCHmacAlgSHA1), keyData!.bytes, keyData!.length, dataToDigest!.bytes, dataToDigest!.length, result)
        
        return NSData(bytes: result, length: digestLength)
        
    }
    
}
>>>>>>> bcb94d1ccb0c9baa6ed6da445d1295720734e259
