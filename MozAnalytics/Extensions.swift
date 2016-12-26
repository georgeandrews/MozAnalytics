//
//  Extensions.swift
//  MozAnalytics
//
//  Created by George Andrews on 10/22/16.
//

import UIKit

// MARK: - Extension for Mozscape-related Strings
extension String {
    
    func urlencode() -> String {
        let stringToEncode = self.replacingOccurrences(of: " ", with: "+")
        return stringToEncode.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed)!
    }
    
    func hmacsha1(key: String) -> Data {
        
        let dataToDigest = self.data(using: String.Encoding.utf8)
        let keyData = key.data(using: String.Encoding.utf8)
        
        let digestLength = Int(CC_SHA1_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLength)
        
        CCHmac(CCHmacAlgorithm(kCCHmacAlgSHA1), (keyData! as NSData).bytes, keyData!.count, (dataToDigest! as NSData).bytes, dataToDigest!.count, result)
        
        return Data(bytes: UnsafePointer<UInt8>(result), count: digestLength)
        
    }
    
}

extension URL {
    
    static func validateUrl(_ urlString: String?, completion:@escaping (_ success: Bool, _ urlString: String? , _ error: NSString) -> Void) {
        // Description: This function will validate the format of a URL, re-format if necessary, then attempt to make a header request to verify the URL actually exists and responds.
        // Return Value: This function has no return value but uses a closure to send the response to the caller.
        
        var formattedUrlString : String?
        
        // Ignore Nils & Empty Strings
        if (urlString ?? "").isEmpty {
            completion(false, nil, "Url String was empty")
            return
        }
        
        // Ignore prefixes (including partials)
        let prefixes = ["http://www.", "https://www.", "www."]
        for prefix in prefixes {
            if ((prefix.range(of: urlString!, options: NSString.CompareOptions.caseInsensitive, range: nil, locale: nil)) != nil) {
                completion(false, nil, "Url String was prefix only")
                return
            }
        }
        
        // Ignore URLs with spaces (NOTE - You should use the below method in the caller to remove spaces before attempting to validate a URL)
        if urlString!.rangeOfCharacter(from: CharacterSet.whitespaces) != nil {
            completion(false, nil, "Url String cannot contain whitespaces")
            return
        }
        
        // Check that URL already contains required 'http://' or 'https://', prepend 'http://' if it does not
        formattedUrlString = urlString
        if (!formattedUrlString!.hasPrefix("http://")
            && !formattedUrlString!.hasPrefix("https://")) {
            formattedUrlString = "http://" + urlString!
        }
        
        // Check that an NSURL can actually be created with the formatted string
        if let validatedUrl = URL(string: formattedUrlString!) {
            // Test that URL actually exists by sending a URL request that returns only the header response
            let request = NSMutableURLRequest(url: validatedUrl)
            request.httpMethod = "HEAD"
            
            let session = URLSession.shared
            
            let loadDataTask = session.dataTask(with: validatedUrl, completionHandler: { (data: Data?, response: URLResponse?, error: NSError?) in
                
                let url = validatedUrl.absoluteString
                
                // URL failed - No Response
                if (error != nil) {
                    completion(false, url, "The url: \(url) received no response" as NSString)
                    return
                }
                
                // URL Responded - Check Status Code
                if let urlResponse = response as? HTTPURLResponse {
                    // 200-399 = Valid Responses, 405 = Valid Response (Weird Response on some valid URLs)
                    if ((urlResponse.statusCode >= 200 && urlResponse.statusCode < 400) || urlResponse.statusCode == 405) {
                        completion(true, url, "The url: \(url) is valid!" as NSString)
                        return
                    } else {
                        completion(false, url, "The url: \(url) received a \(urlResponse.statusCode) response" as NSString)
                        return
                    }
                }
                
            } as! (Data?, URLResponse?, Error?) -> Void)
            
            loadDataTask.resume()
            
        }
        
    }
}

// MARK: - EZ Alerts
extension UIViewController {
    
    func presentAlert(title: String, message: String) {
        present(UIAlertController(title: title, message: message, preferredStyle: .alert).withOKAction())
    } // Note: preferredStyle of .Alert is required for iPads
    
    fileprivate func present(_ alertController: UIAlertController) {
        self.present(alertController, animated: true, completion: nil)
    }
}

extension UIAlertController {
    fileprivate func withOKAction() -> UIAlertController {
        addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        return self
    }
}

extension UITableViewDataSource {
    func populateResponseFieldCell(_ cell: UITableViewCell, description: String, value: AnyObject?) {
        if let valueString = value as? String {
            cell.textLabel!.text = "\(description): \(valueString)"
        } else if let valueNumber = value as? NSNumber {
            cell.textLabel!.text = "\(description): \(valueNumber.stringValue)"
        } else {
            cell.textLabel!.text = "\(description): "
        }
    }
}
