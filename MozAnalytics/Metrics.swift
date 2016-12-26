//
//  URLMetrics.swift
//  MozAnalytics
//
//  Created by Andrews Jr, George on 9/15/15.
//  Copyright (c) 2015 Andrews Jr, George. All rights reserved.
//

/// An enumeration for the response fields used in this application.
enum ResponseField: String {
    case TITLE = "ut",
    URL = "uu",
    MOZ_RANK = "umrp",
    MOZ_TRUST = "utrp",
    SPAM_SCORE = "fspsc",
    PAGE_AUTHORITY = "upa",
    DOMAIN_AUTHORITY = "pda",
    EXT_EQUITY_LINKS = "ueid",
    TIME_LAST_CRAWLED = "ulc"
}

class Metrics {
    
    ///
    /// ResponseField values to use when querying Mozscape API.
    ///
    static let responseFields = [ResponseField.URL, ResponseField.MOZ_RANK, ResponseField.PAGE_AUTHORITY, ResponseField.DOMAIN_AUTHORITY, ResponseField.EXT_EQUITY_LINKS]
    
    ///
    /// Dictionary containing description and value details for each
    /// response field used in this application.
    ///
    static let responseFieldDetails: [ResponseField:[Any]] = [
        ResponseField.TITLE:["Page Title", 1 as Int64],
        ResponseField.URL:["Canonical URL", 4 as Int64],
        ResponseField.EXT_EQUITY_LINKS:["External Equity Links", 32 as Int64],
        ResponseField.MOZ_RANK:["MozRank: URL", 16384 as Int64],
        ResponseField.MOZ_TRUST:["MozTrust", 131072 as Int64],
        ResponseField.SPAM_SCORE:["Subdomain Spam Score", 67108864 as Int64],
        ResponseField.PAGE_AUTHORITY:["Page Authority", 34359738368 as Int64],
        ResponseField.DOMAIN_AUTHORITY:["Domain Authority", 68719476736 as Int64],
        ResponseField.TIME_LAST_CRAWLED:["Time Last Crawled", 144115188075855872 as Int64]
    ]
}
