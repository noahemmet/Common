//
//  Error+Extensions.swift
//  Common
//
//  Created by Noah Emmet on 7/28/18.
//  Copyright © 2018 Sticks. All rights reserved.
//

import Foundation

public enum BasicError: Error, Hashable {
  case reason(String)
}

public struct ThrownError: Error, CustomStringConvertible {
  public let error: Error
  public let file: String
  public let line: Int
  public let function: String

  public init(_ error: Error, file: String = #file, line: Int = #line, function: String = #function) {
    self.error = error
    self.file = file
    self.line = line
    self.function = function
    dump(self)
  }

  public init(_ reason: String, file: String = #file, line: Int = #line, function: String = #function) {
    self.init(BasicError.reason(reason), file: file, line: line, function: function)
  }

  public var debugDescription: String {
    return localizedDescription
  }

  public var description: String {
    return localizedDescription
  }

  public var localizedDescription: String {
    return "error: \(error), \nFile: \(file),\nline: \(line),\nfunction: \(function)\n"
  }
}

public func fatalError(_ error: @autoclosure () -> Error, file: StaticString = #file, line: UInt = #line) -> Never {
  let errorString = "\(error())"
  print(errorString)
  return fatalError(errorString, file: file, line: line)
}
