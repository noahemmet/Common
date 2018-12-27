//
//  Handler.swift
//  Common
//
//  Created by Noah Emmet on 7/2/18.
//  Copyright © 2018 Sticks. All rights reserved.
//

import Foundation

// MARK: - Returns

/// A default `() -> Void` closure
public typealias ReturnVoid = () -> Void

/// A default `() -> Bool` closure
public typealias ReturnBool = () -> Bool

/// A default `() -> String` closure
public typealias ReturnString = () -> String

/// A generic `() -> T` closure
public typealias ReturnGeneric<T> = () -> T

// MARK: - Params

/// A default `(Bool) -> Void` closure
public typealias BoolParam = (Bool) -> Void

/// A default `(String) -> Void` closure
public typealias ParamString = (String) -> Void

/// A generic `(T) -> Void` closure
public typealias ParamGeneric<T> = (T) -> Void

/// A generic `(Result<T>) -> Void` closure
public typealias ParamResult<T> = (Result<T>) -> Void
