//
//  MozResult.swift
//  MozAnalytics
//
//  Created by Andrews Jr, George on 9/15/15.
//  Copyright (c) 2015 Andrews Jr, George. All rights reserved.
//

import Foundation
import CoreData

@objc(MozResult)
class MozResult: NSManagedObject {

    @NSManaged var title: String
    @NSManaged var canonicalURL: String
    @NSManaged var mozRank: NSNumber
    @NSManaged var mozSpam: NSNumber
    @NSManaged var mozTrust: NSNumber
    @NSManaged var pageAuthority: NSNumber
    @NSManaged var domainAuthority: NSNumber
    @NSManaged var externalLinks: NSNumber
    
    override func valueForKey(key: String) -> AnyObject? {
        switch key {
        case ResponseField.TITLE.rawValue:
            return title
        case ResponseField.URL.rawValue:
            return canonicalURL
        case ResponseField.MOZ_RANK.rawValue:
            return mozRank
        case ResponseField.MOZ_TRUST.rawValue:
            return mozTrust
        case ResponseField.SPAM_SCORE.rawValue:
            return mozSpam
        case ResponseField.PAGE_AUTHORITY.rawValue:
            return pageAuthority
        case ResponseField.DOMAIN_AUTHORITY.rawValue:
            return domainAuthority
        case ResponseField.EXT_EQUITY_LINKS.rawValue:
            return externalLinks
        default:
            return nil
        }
    }

}
