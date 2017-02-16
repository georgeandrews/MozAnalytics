//
//  MozResult.swift
//  MozAnalytics
//
//  Created by Andrews Jr, George on 9/15/15.
//  Copyright (c) 2015 Andrews Jr, George. All rights reserved.
//

import Foundation
import CoreData

class MozResult: NSManagedObject {
  
  @NSManaged var canonicalURL: String
  @NSManaged var mozRank: NSNumber
  @NSManaged var mozTrust: NSNumber
  @NSManaged var pageAuthority: NSNumber
  @NSManaged var domainAuthority: NSNumber
  @NSManaged var externalLinks: NSNumber
  
  required convenience init(canonicalURL: String, mozRank: NSNumber, pageAuthority: NSNumber, domainAuthority: NSNumber, externalLinks: NSNumber, entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext!) {
    self.init(entity: entity, insertInto: context)
    self.canonicalURL = canonicalURL
    self.mozRank = mozRank
    self.pageAuthority = pageAuthority
    self.domainAuthority = domainAuthority
    self.externalLinks = externalLinks
  }
  
  ///
  /// Helper method for retrieving property values for a MozResult
  /// object when populating ResponseField UITableViewCell(s).
  ///
  override func value(forKey key: String) -> Any? {
    switch key {
    case ResponseField.URL.rawValue:
      return canonicalURL
    case ResponseField.MOZ_RANK.rawValue:
      return mozRank
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
