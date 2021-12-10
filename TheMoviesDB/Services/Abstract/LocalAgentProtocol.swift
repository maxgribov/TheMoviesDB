//
//  LocalAgentProtocol.swift
//  TheMoviesDB
//
//  Created by Max Gribov on 10.12.2021.
//

import Foundation

protocol LocalAgentProtocol {
    
    func store<T>(_ data: [T], serial: Int?) throws where T: Cachable
    func load<T>(type: T.Type) -> [T]? where T : Cachable
    func serial<T>(for type: T.Type) -> Int? where T : Cachable
    func fileName<T>(for type: T.Type) -> String
}

extension LocalAgentProtocol {
    
    func fileName<T>(for type: T.Type) -> String {
        
        "\(type.self)s.json".lowercased()
    }
}
