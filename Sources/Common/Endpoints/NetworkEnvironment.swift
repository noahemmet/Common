//
//  Environment.swift
//  Common
//
//  Created by Noah Emmet on 7/27/18.
//  Copyright © 2018 Sticks. All rights reserved.
//

import Foundation

public enum NetworkEnvironment {
    case production
    case staging
    
    public var baseURL: URL {
        switch self {
        case .production: return URL(string: "google.com")!
        case .staging: return URL(string: "google.com")!
        }
    }
    public func url(with path: String) -> URL {
        return URL(string: path, relativeTo: baseURL)!
    }
}
