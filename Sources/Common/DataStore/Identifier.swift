//
//  Identifier.swift
//  Common
//
//  Created by Noah Emmet on 7/14/18.
//  Copyright © 2018 Sticks. All rights reserved.
//

import Foundation

public struct Identifier<Value: UniqueIdentifiable>: Codable, Hashable {
    public let uuid: UUID

    public init(uuid: UUID = UUID()) {
        self.uuid = uuid
    }
    
    public init?(optionalUUID: UUID?) {
        guard let optionalUUID = optionalUUID else { return nil }
        self.uuid = optionalUUID
    }
    
    public func map<Other: UniqueIdentifiable>(as otherType: Other.Type = Other.self) -> Identifier<Other> {
        return Identifier<Other>(uuid: self.uuid)
    }
    
    public func value(in dataStore: DataStore) throws -> Value {
        let value = try dataStore.value(for: self)
        return value
    }
}

public extension UUID {
    func map<Other: UniqueIdentifiable>(as otherType: Other.Type = Other.self) -> Identifier<Other> {
        return Identifier<Other>(uuid: self)
    }
}

//extension Array where Element == Identifier<UniqueIdentifiable> {
//    public func values(in dataStore: DataStore) throws -> [Value] {
//        let values = try dataStore.values(for: self)
//        return value
//    }
//}

extension Identifier: CustomStringConvertible, CustomDebugStringConvertible {
    public var description: String {
        return "\(Value.self)Identifier(\(uuid))"
    }
    public var debugDescription: String {
        return description
    }
}
