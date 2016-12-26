//
//  MozResult.swift
//  MozAnalytics
//
//  Created by Andrews Jr, George on 9/15/15.
//  Copyright (c) 2015 Andrews Jr, George. All rights reserved.
//

import Foundation
import CoreData

<<<<<<< HEAD
class MozResult: NSManagedObject {

    @NSManaged var canonicalURL: String
    @NSManaged var mozRank: NSNumber
=======
@objc(MozResult)
class MozResult: NSManagedObject {

    @NSManaged var title: String
    @NSManaged var canonicalURL: String
    @NSManaged var mozRank: NSNumber
    @NSManaged var mozSpam: NSNumber
>>>>>>> bcb94d1ccb0c9baa6ed6da445d1295720734e259
    @NSManaged var mozTrust: NSNumber
    @NSManaged var pageAuthority: NSNumber
    @NSManaged var domainAuthority: NSNumber
    @NSManaged var externalLinks: NSNumber
    
<<<<<<< HEAD
    required convenience init(canonicalURL: String, mozRank: NSNumber, pageAuthority: NSNumber, domainAuthority: NSNumber, externalLinks: NSNumber, entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext!) {
        self.init(entity: entity, insertInto: context)
        self.canonicalURL = canonicalURL
        self.mozRank = mozRank
        self.pageAuthority = pageAuthority
        self.domainAuthority = domainAuthority
        self.externalLinks = externalLinks
    }
    
    override func value(forKey key: String) -> Any? {
        switch key {
=======
    override func valueForKey(key: String) -> AnyObject? {
        switch key {
        case ResponseField.TITLE.rawValue:
            return title
>>>>>>> bcb94d1ccb0c9baa6ed6da445d1295720734e259
        case ResponseField.URL.rawValue:
            return canonicalURL
        case ResponseField.MOZ_RANK.rawValue:
            return mozRank
<<<<<<< HEAD
=======
        case ResponseField.MOZ_TRUST.rawValue:
            return mozTrust
        case ResponseField.SPAM_SCORE.rawValue:
            return mozSpam
>>>>>>> bcb94d1ccb0c9baa6ed6da445d1295720734e259
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
