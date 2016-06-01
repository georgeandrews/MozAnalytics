//
//  Mozscape.swift
//  iMoz
//
//  Created by George Andrews on 5/15/15.
//  Copyright (c) 2015 George Andrews. All rights reserved.
//

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
        
        loadDataTask.resume()
    }
    
}

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