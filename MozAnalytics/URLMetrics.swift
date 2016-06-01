//
//  URLMetrics.swift
//  MozAnalytics
//
//  Created by Andrews Jr, George on 9/15/15.
//  Copyright (c) 2015 Andrews Jr, George. All rights reserved.
//

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
    
    static let valuesToPull = [TITLE, URL, MOZ_RANK, PAGE_AUTHORITY, DOMAIN_AUTHORITY, EXT_EQUITY_LINKS, TIME_LAST_CRAWLED]
}

class Metrics {
    static let responseFields: [ResponseField:[AnyObject]] = [
        ResponseField.TITLE:["Page Title", 1],
        ResponseField.URL:["Canonical URL", 4],
        ResponseField.EXT_EQUITY_LINKS:["External Equity Links", 32],
        ResponseField.MOZ_RANK:["MozRank: URL", 16384],
        ResponseField.MOZ_TRUST:["MozTrust", 131072],
        ResponseField.SPAM_SCORE:["Subdomain Spam Score", 67108864],
        ResponseField.PAGE_AUTHORITY:["Page Authority", 34359738368],
        ResponseField.DOMAIN_AUTHORITY:["Domain Authority", 68719476736],
        ResponseField.TIME_LAST_CRAWLED:["Time Last Crawled", 144115188075855872]
    ]
}
