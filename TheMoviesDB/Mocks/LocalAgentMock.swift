//
//  LocalAgentMock.swift
//  TheMoviesDB
//
//  Created by Max Gribov on 11.12.2021.
//

import Foundation

class LocalAgentMock: LocalAgentProtocol {

    var cache: [String: [Codable]] = [:]
    var serials: [String: Int] = [:]
    
    func store<T>(_ data: [T], serial: Int?) throws where T: Cachable {
        
        let fileName = fileName(for: T.self)
        cache[fileName] = data
        serials[fileName] = serial
    }
    
    func load<T>(type: T.Type) -> [T]? where T : Cachable {

        let fileName = fileName(for: type)
        
        guard let data = cache[fileName] as? [T] else {
            return nil
        }
        
        return data
    }
    
    func clear<T>(type: T.Type) throws where T : Cachable {
        
        let fileName = fileName(for: type)
        cache[fileName] = nil
        serials[fileName] = nil
    }
    
    func serial<T>(for type: T.Type) -> Int? where T : Cachable {
        
        let fileName = fileName(for: type)
        
        return serials[fileName]
    }
}
