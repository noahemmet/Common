//
//  URLSession+Extensions.swift
//  Common
//
//  Created by Noah Emmet on 7/27/18.
//  Copyright © 2018 Sticks. All rights reserved.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

public extension URLSession {
    func sendSyncronousRequest(url: URL) -> (Data?, URLResponse?, Error?) {
        let semaphore = DispatchSemaphore(value: 0)
        var data: Data?
        var response: URLResponse?
        var error: Error?
        let task = self.dataTask(with: url) { taskData, taskResponse, taskError in
            data = taskData
            response = taskResponse
            error = taskError
            semaphore.signal()
        }
        task.resume()
        semaphore.wait()
        return (data, response, error)
    }
}
