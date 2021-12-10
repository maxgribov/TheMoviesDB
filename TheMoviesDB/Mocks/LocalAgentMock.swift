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
    
    func load<T>(type: T.Type) -> (data: [T], serial: Int?)? where T : Cachable {

        let fileName = fileName(for: type)
        
        guard let data = cache[fileName] as? [T] else {
            return nil
        }
        
        let serial = serials[fileName]
        
        return (data, serial)
    }
}
