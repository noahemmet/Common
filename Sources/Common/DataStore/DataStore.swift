//
//  DataStore.swift
//  Common
//
//  Created by Noah Emmet on 7/5/18.
//  Copyright © 2018 Sticks. All rights reserved.
//

import Foundation

/// A place for data. Can be observed for changes.
public class DataStore {
    
    /// A dictionary of models keyed by their UUID
    public typealias ModelsByUUID = [UUID: Any]
    /// A dictionary keyed by object type with values of models keyed by their UUID.
    public typealias Storage = [ObjectIdentifier: ModelsByUUID]
    public private(set) var storage: Storage = [:]
    private let storageKey: String
    public var autosave = true
    
    public static var empty: DataStore { return DataStore(storage: [:]) }
    
    public convenience init(storage: Storage = [:]) {
        self.init()
        self.storage = storage
    }
    
    public convenience init() {
        self.init(storageKey: "defaultStorageKey")
    }
    
    public convenience init(testClass: AnyObject) {
        self.init(storageKey: "\(testClass)")
    }
    
    public init(storageKey: String) {
        self.storageKey = storageKey
        // temp disabling loading from disk
//        guard let storageData: Data = try? UserDefaults.standard.value(forKey: storageKey) else {
//            return
//        }
//        storage = (try? JSONSerialization.jsonObject(with: storageData, options: []) as! Storage) ?? [:]
    }
    
    private func encode() {
//        let data = try! JSONSerialization.data(withJSONObject: storage, options: [])
//        try! UserDefaults.standard.setValue(data, forKey: storageKey)
    }
    
    public func revert(to oldStorage: Storage) {
        self.storage = oldStorage
    }
    
    // MARK: Multiple Values
    
    public func allValues<Value: UniqueIdentifiable>(ofType valueType: Value.Type = Value.self) throws -> Set<Value> {
        let valuesByUUIDs = storage[ObjectIdentifier(Value.self)] ?? [:]
        let values = valuesByUUIDs.compactMap { $0.value as? Value }
        return Set(values)
    }
    
    public func setValues<Value: UniqueIdentifiable>(_ values: [Value]) {
        self.setValues(Set(values))
    }
    
    public func setValues<Value: UniqueIdentifiable>(_ values: Set<Value>) {
        for value in values {
            storage[ObjectIdentifier(Value.self), default: [:]][value.id.uuid] = value
        }
        if autosave {
            encode()
        }
        fireObserver(valueType: Value.self)
    }
    
    // MARK: Single Value
    
    public func value<Value: UniqueIdentifiable>(ofType valueType: Value.Type = Value.self, for id: Identifier<Value>) throws -> Value {
        let values: Set<Value> = try self.allValues()
        let value = values.first(where: { $0.id == id })
        return try unwrap { value }
    }
    
    public func setValue<Value: UniqueIdentifiable>(_ value: Value) {
        storage[ObjectIdentifier(Value.self), default: [:]][value.id.uuid] = value
        if autosave {
            encode()
        }
        fireObserver(valueType: Value.self)
    }
    
    // inout assignment doesn't work :(
//    public func updateValue<Value: UniqueIdentifiable>(_ value: inout Value) throws {
//        let currentValue: Value = try self.value(for: value.identifier)
//        value = currentValue
//    }
    
    // MARK: - Optionals
    
//    public func value<Value: UniqueIdentifiable>(ofType valueType: Value.Type = Value.self, identifier: Identifier<Value>) throws -> Value {
//        let values: [Value] = try self.allValues()
//        let value = values.first(where: { $0.identifier == identifier })
//        return try unwrap { value }
//    }
//    
//    public func setValue<Value: UniqueIdentifiable>(_ value: Value) {
//        storage[ObjectIdentifier(Value.self), default: [:]][value.identifier.uuid] = value
//        if autosave {
//            save()
//        }
//        fireObserver(valueType: Value.self)
//    }
    
    // MARK: Observers
    
    public typealias UpdateObserver<Value: Hashable> = (Set<Value>) -> Void
    public typealias AnyObserver = ([Any]) -> Void
    private var observers: [String: AnyObserver] = [:]
    
    public func observe<Value>(valueType: Value.Type, update: @escaping AnyObserver) {
        let key = String(describing: Value.self)
        observers[key] = update
    }
    
    private func fireObserver<Value: UniqueIdentifiable>(valueType: Value.Type) {
        let key = String(describing: Value.self)
        if let observer = observers[key],
            let newValues = try? self.allValues(ofType: Value.self) {
            observer(Array(newValues)) // Why do i need to cast this?
        }
    }
}

extension DataStore: CustomDebugStringConvertible {
    public var debugDescription: String {
        let storageStrings: [String] = storage.map { objectIdentifier, modelsByUUID in
            let modelType: String
            if let model = modelsByUUID.values.first {
                modelType = "\(type(of: model.self))(s)"
            } else {
                modelType = "Empty"
            }
            let valueStrings: [String] = modelsByUUID.values.map { value in
                return " \(value)"
            }
            return "\(modelType):\n\(valueStrings.joined(separator: "\n"))\n"
        }
        return """
        key: \(storageKey), storage:
        \(storageStrings.joined(separator: "\n"))
        """
    }
}
