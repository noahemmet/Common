//
//  Either.swift
//  Common
//
//  Created by Noah Emmet on 7/17/18.
//  Copyright © 2018 Sticks. All rights reserved.
//

import Foundation

public enum Either<Left, Right> {
    case left(Left)
    case right(Right)
    
    public init(_ left: Left) {
        self = .left(left)
    }
    
    public init(_ right: Right) {
        self = .right(right)
    }
    
    public init(_ left: Left?, _ right: Right?) throws {
        switch (left, right) {
        case (let leftValue?, nil):
            self.init(leftValue)
        case (nil, let rightValue?):
            self.init(rightValue)
        case (nil, nil):
            throw Error.nilValues
        case (_, _):
            throw Error.twoNonNilValues
        }
    }
    
    public var leftValue: Left? {
        guard case .left(let left) = self else { return nil }
        return left
    }
    
    public var rightValue: Right? {
        guard case .right(let right) = self else { return nil }
        return right
    }
}

extension Either {
    public enum Error: Swift.Error {
        case nilValues
        case twoNonNilValues
    }
}

extension Either: Equatable where Left: Equatable, Right: Equatable { }

extension Either: Hashable where Left: Hashable, Right: Hashable { }

