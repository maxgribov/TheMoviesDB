//
//  ServerAgentMock.swift
//  TheMoviesDB
//
//  Created by Max Gribov on 03.12.2021.
//

import Foundation

class ServerAgentMock: ServerAgentProtocol {
    
    let baseURL: String = ""
    let apiKey: String = ""
    
    private let bundle = Bundle(for: ServerAgentMock.self)
    private let decoder = JSONDecoder.movieDB
    
    func execute<Command, Result>(command: Command, completion: @escaping (ServerResponse<Result, ServerAgentError>) -> Void) where Command : ServerCommand, Result : Decodable {
        
        DispatchQueue.global().asyncAfter(deadline: .now() + .milliseconds(200)) {
            
            switch command {
            case let payload as ServerCommands.Discover:
                
                guard payload.page == 1 else {
                    
                    completion(.failed(.emptyData))
                    return
                }
                
                do {
                    let url = self.bundle.url(forResource: "DiscoverResponseMock", withExtension: "json")!
                    let json = try Data(contentsOf: url)
                    let result = try self.decoder.decode(Result.self, from: json)
                    
                    completion(.succeed(result))
                    
                } catch {
                    
                    completion(.failed(.curruptedData(error)))
                }

            default:
                completion(.failed(.unknownResponse))
            }
        }
    }
}
