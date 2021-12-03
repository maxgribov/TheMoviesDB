//
//  ServerAgentProtocol.swift
//  TheMoviesDB
//
//  Created by Max Gribov on 03.12.2021.
//

import Foundation

protocol ServerAgentProtocol {
    
    var baseURL: String { get }
    var apiKey: String { get }
    
    func execute<Command: ServerCommand, Result: Decodable>(command: Command, completion: @escaping (ServerResponse<Result, ServerAgentError>) -> Void)
    func execute<Result: Decodable>(request: URLRequest, completion: @escaping (ServerResponse<Result, ServerAgentError>) -> Void)
    func request<Command: ServerCommand>(from command: Command) -> URLRequest?
}

protocol ServerCommand {

    var endpoint: String { get }
    var method: ServerCommandMethod { get }
    var parameters: String { get }
}

enum ServerResponse<T: Decodable, E: Error> {
    
    case succeed(T)
    case failed(E)
}

enum ServerAgentError: Error {
    
    case unableCreateRequest
    case sessionError(Error)
    case unknownResponse
    case emptyData
    case curruptedData(Error)
}

enum ServerCommandMethod: String {
    
    case post = "POST"
    case get = "GET"
}


