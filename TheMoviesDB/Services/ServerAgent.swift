//
//  ServerAgent.swift
//  TheMoviesDB
//
//  Created by Max Gribov on 03.12.2021.
//

import Foundation

class ServerAgent: ServerAgentProtocol {
    
    let baseURL: String
    let apiKey: String
    
    private let session = URLSession.shared
    private let decoder = JSONDecoder.movieDB
    
    init(baseURL: String, apiKey: String) {
        
        self.baseURL = baseURL
        self.apiKey = apiKey
    }
    
    func execute<Command, Result>(command: Command, completion: @escaping (ServerResponse<Result, ServerAgentError>) -> Void) where Command : ServerCommand, Result : Decodable {
        
        guard let request = request(from: command) else {
            
            completion(.failed(.unableCreateRequest))
            return
        }
        
        execute(request: request) { response in
            
            completion(response)
        }
    }
    
    private func execute<Result>(request: URLRequest, completion: @escaping (ServerResponse<Result, ServerAgentError>) -> Void) where Result : Decodable {
        
        session.dataTask(with: request) { data, response, error in
            
            if let error = error {
                
                completion(.failed(.sessionError(error)))
                return
            }
            
            guard let data = data else {
                
                completion(.failed(.emptyData))
                return
            }
            
            do {
                
                let result = try self.decoder.decode(Result.self, from: data)
                completion(.succeed(result))
                
            } catch {
                
                completion(.failed(.curruptedData(error)))
            }
            
        }.resume()
    }
    
    private func request<Command>(from command: Command) -> URLRequest? where Command : ServerCommand {
        
        guard let url = URL(string: baseURL + command.endpoint + "?api_key=\(apiKey)" + command.parameters) else {
            return nil
        }
        
        return URLRequest(url: url)
    }
}
