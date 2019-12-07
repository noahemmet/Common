//
//  JSON.swift
//  Common
//
//  Created by Noah Emmet on 7/26/18.
//  Copyright © 2018 Sticks. All rights reserved.
//

import Foundation

public typealias JSONObject = [String: JSON]
public typealias JSONArray = [JSON]

public typealias AnyJSONObject = [String: Any]
public typealias AnyJSONArray = [Any]

public enum JSON {
  case object(JSONObject)
  case array(JSONArray)
  case string(String)
  case bool(Bool)
  case int(Int)
  case float(Float)
  case uuid(UUID)
  case null
  
  public init(_ any: Any) throws {
    switch any {
    case let object as [String: Any]: 
      let jsonObject = try object.mapValues { try JSON($0) }
      self = .object(jsonObject)
    case let array as [Any]:
      let jsonArray = try array.map { try JSON($0) }
      self = .array(jsonArray)
//        case let json as JSON:
//            let anyJSON = json.anyValue
//            self = try JSON(anyJSON)
    case let nsArray as NSArray:
      // nsArray check must happen after the Swift.Array, or it will always succeed.
      let array = nsArray as Array
      let convertedArray: [JSON] = try array.map { element in
        if let json = element as? JSON {
          return json
        } else {
          return try JSON(element)
        }
      }
//            let array = try (nsArray as? [[String: Any]]).unwrap(orThrow: Error.unknownType(any))
      self = .array(convertedArray)
    case let string as String:
      self = .string(string)
    case let float as Float:
      self = .float(float)
    case let int as Int:
      self = .int(int)
    case let bool as Bool:
      self = .bool(bool)
    case let nsNumber as NSNumber:
      // This isn't great…
      let floatValue = nsNumber.floatValue
      try self.init(floatValue)
    case _ as NSNull:
      self = .null
    case let uuid as UUID:
      self = .uuid(uuid)
    default:
      dump(type(of: any))
      throw JSON.Error.unknownType(any)
    }
  }
  
  public var jsonValue: Any {
    switch self {
    case .object(let object): return object
    case .array(let array): return array
    case .string(let string): return string
    case .bool(let bool): return bool
    case .int(let int): return int
    case .float(let float): return float
    case .null: return ()
    case .uuid(let uuid): return uuid
    }
  }
  
  public var anyValue: Any {
    switch self {
    case .object(let object): return object.mapValues { $0.anyValue }
    case .array(let array): return array.map { $0.anyValue }
    default: return jsonValue
    }
  }
  
  public func anyObject() throws -> AnyJSONObject {
    switch self {
    case .object(let object): 
      return object.mapValues { $0.anyValue }
    default:
      throw Error.primitive(self)
    }
  }
  
  public func anyArray() throws -> AnyJSONArray {
    switch self {
    case .array(let array):
      return array.map { $0.anyValue }
    default:
      throw Error.primitive(self)
    }
  }
  
  public func object() throws -> JSONObject {
    guard case .object(let object) = self else {
      throw JSON.Error.expected(JSONObject.self, received: self)
    }
    return object
  }
  
  public func array() throws -> JSONArray {
    guard case .array(let array) = self else {
      throw JSON.Error.expected(JSONArray.self, received: self)
    }
    return array
  }
  
  public enum Error: Swift.Error {
    case unknownType(Any)
    case expected(Any.Type, received: Any)
    case primitive(Any)
  }
}

//extension JSON: CustomStringConvertible {
//    public var description: String {
//        let data = try! JSONSerialization.data(withJSON: self, options: .prettyPrinted)
//        let prettyString = String(data: data, encoding: .utf8)!
//        return prettyString
//    }
//}

public extension JSONSerialization {
  static func json(with data: Data, options: JSONSerialization.ReadingOptions) throws -> JSON {
    let anyJSON = try jsonObject(with: data, options: options)
    let json = try JSON(anyJSON)
    return json
  }
  
  static func json(from string: String, options: JSONSerialization.ReadingOptions) throws -> JSON {
    guard let data = string.data(using: .utf8) else {
      throw JSON.Error.unknownType(string)
    }
    let json = try self.json(with: data, options: options)
    return json
  }
  
  static func data(withJSON json: JSON, options: JSONSerialization.WritingOptions = []) throws -> Data {
    switch json {
    case .array:
      let anyArray = try json.anyArray() 
      return try self.data(withJSONObject: anyArray, options: options)
    case .object:
      let anyObject = try json.anyObject()
      return try self.data(withJSONObject: anyObject, options: options)
    case .string(let string):
      guard let data = string.data(using: .utf8) else {
        throw JSON.Error.unknownType(string)
      }
      return data
    default:
      // This could handle other primitives too, like `String`.
      throw JSON.Error.unknownType(json)
    }
  }
}

