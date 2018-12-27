//
//  UniqueIdentifiable.swift
//  Common
//
//  Created by Noah Emmet on 7/5/18.
//  Copyright © 2018 Sticks. All rights reserved.
//

import Foundation

public protocol UniqueIdentifiable: Hashable {
    associatedtype IdentifiedType = Identifier<Self> 
    var id: Identifier<Self> { get }
}

extension Array where Element: UniqueIdentifiable {
    public var ids: [Identifier<Element>] {
        return self.map { $0.id }
    }
}


extension UniqueIdentifiable {
    static func === (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
}

extension UniqueIdentifiable {
    public mutating func update(in dataStore: DataStore) throws {
        let latest = try dataStore.value(for: self.id)
        self = latest
    }
}

extension Array where Element: UniqueIdentifiable {
    
    public mutating func update(in dataStore: DataStore) throws {
        let latest = try self.map { try dataStore.value(for: $0.id) }
        self = latest
    }
}

//extension Array where Element: Identifier {
//    public var uuids: [UUID] {
//        return self.map { $0.uuid }
//    }
//}

extension UniqueIdentifiable {
//    func value<Value: UniqueIdentifiable>(_ keyPath: PartialKeyPath<Value>, in dataStore: DataStore) throws -> Value {
//        let identifier = self[keyPath: keyPath] as! Identifier<Value>
//        let value = try dataStore.value(for: identifier)
//        return value
//    }
}
//mutating func replaceFirst<Property: Equatable>(_ element: Element, uniquedBy keyPath: PartialKeyPath<Element>, propertyType: Property.Type = Property.self) {
//    if let property = element[keyPath: keyPath] as? Property,
//        let matchingIndex = self.firstIndex(where: { $0[keyPath: keyPath] as! Property == property }) {
//        remove(at: matchingIndex)
//        insert(element, at: matchingIndex)
//    } else {
//        append(element)
//    }
//}
