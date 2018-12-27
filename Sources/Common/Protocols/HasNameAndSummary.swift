//
//  HasNameAndSummary.swift
//  Common
//
//  Created by Noah Emmet on 5/23/18.
//  Copyright © 2018 Sticks. All rights reserved.
//

import Foundation

public protocol HasName {
    var name: String { get }
}

public protocol HasSummary {
    var summary: String { get }
}

public typealias HasNameAndSummary = HasName & HasSummary
