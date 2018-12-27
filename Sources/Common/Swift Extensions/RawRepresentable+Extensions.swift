//
//  RawRepresentable+Extensions.swift
//  Common
//
//  Created by Noah Emmet on 11/23/18.
//  Copyright © 2018 Sticks. All rights reserved.
//

import Foundation

public extension RawRepresentable {
    init(_ rawValue: RawValue) throws {
        guard let value = Self.init(rawValue: rawValue) else {
            throw BasicError.unknownValue(rawValue)
        }
        self = value
    }
}
