//
//  DataProviding.swift
//  Common
//
//  Created by Noah Emmet on 7/9/18.
//  Copyright © 2018 Sticks. All rights reserved.
//

import Foundation

public enum DataProvidingFetchCache {
  case none
}

public protocol DataProviding {
  associatedtype Model
  typealias FetchHandler = (Result<Model>) -> Void
  func fetch(from dataStore: DataStore, cache: DataProvidingFetchCache, fetchHandler: FetchHandler)
  func observe(_ fetchHandler: FetchHandler)
}

public struct DataQuery {
  func fetch<Model>(type: Model.Type = Model.self) {}
}
