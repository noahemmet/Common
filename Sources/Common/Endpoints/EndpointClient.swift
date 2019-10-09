//
//  EndpointClient.swift
//  Common
//
//  Created by Noah Emmet on 7/27/18.
//  Copyright © 2018 Sticks. All rights reserved.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

open class EndpointClient: NSObject {
    public typealias ResponseHandler<Response: EndpointResponse> = (Response) -> Void
    private typealias DownloadsByRequests = [ObjectIdentifier: Any]
    private var downloadsByRequests: DownloadsByRequests = [:]
    private let environment: NetworkEnvironment
    private var dataStore: DataStore
    
    public init(environment: NetworkEnvironment, dataStore: DataStore) {
        self.environment = environment
        self.dataStore = dataStore
    }
    
    // MARK: - Network Calls
    
    /// Async
    open func send<Request: EndpointRequesting>(_ request: Request, responseHandler: ResponseHandler<Request.Response>?) {
        self.setDownloadState(.loading, for: request)
        let urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
        
        let url = environment.url(with: request.path)
        let dataTask = urlSession.dataTask(with: url) { (data, response, error) in
            do {
                let data = try unwrap { data }
                let anyJSON = try JSONSerialization.jsonObject(with: data, options: [])
                let response = try request.response(response as? HTTPURLResponse, json: JSON(anyJSON))
                responseHandler?(response)
            } catch let error {
                print(error)
            }
        }
        dataTask.resume()
    }
    
    /// Syncronous
    open func response<Request: EndpointRequesting>(for request: Request) -> Request.Response {
        let urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
        let url = environment.url(with: request.path)
        let (data, urlResponse, _) = urlSession.sendSyncronousRequest(url: url)
        let httpURLResponse = urlResponse as? HTTPURLResponse
        do {
            let data = try unwrap { data }
            let anyJSON = try JSONSerialization.jsonObject(with: data, options: [])
            let response = try request.response(httpURLResponse, json: JSON(anyJSON))
            return response
        } catch let error {
            let response = Request.Response(httpURLResponse, error: error)
            return response
        }
    }
//    
    // MARK: - Caching
    
    open func getDownloadState<Value, Request: EndpointRequesting>(for request: Request) -> DownloadState<Value> {
        let anyDownloadState = downloadsByRequests[ObjectIdentifier(Request.self), default: DownloadState<Value>.none]
        let downloadState = anyDownloadState as! DownloadState<Value>
        return downloadState
    }
    
    open func setDownloadState<Request: EndpointRequesting>(_ downloadState: DownloadState<Request.Response>, for request: Request) {
        downloadsByRequests[ObjectIdentifier(Request.self)] = request
    }
}

extension EndpointClient: URLSessionDelegate {
   
}

extension EndpointClient {
    public enum DownloadState<Response> {
        case none
        case loading
        case finished(Response)
    }
}
