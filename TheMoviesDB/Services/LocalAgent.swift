//
//  LocalAgent.swift
//  TheMoviesDB
//
//  Created by Max Gribov on 10.12.2021.
//

import Foundation

class LocalAgent: LocalAgentProtocol {
    
    let cacheFolderName: String

    private let serialsFileName = "serials.json"
    private var serials: [String: Int]
    private let fileManager = FileManager.default
    
    init(rootFolderName: String) {
        
        self.cacheFolderName = rootFolderName
        self.serials = [:]
        
        do {
            
            let serialsData = try Data(contentsOf: fileURL(with: serialsFileName))
            self.serials = try JSONDecoder().decode([String: Int].self, from: serialsData)
            
        } catch{
            
            self.serials = [:]
        }
    }
    
    func store<T>(_ data: [T], serial: Int?) throws where T: Cachable {
        
        let dataFileName = fileName(for: T.self)
        let data = try JSONEncoder.movieDB.encode(data)
        try data.write(to: fileURL(with: dataFileName))
        
        serials[dataFileName] = serial
        let serialsData = try JSONEncoder().encode(serials)
        try serialsData.write(to: fileURL(with: serialsFileName))
        
    }
    
    func load<T>(type: T.Type) -> [T]? where T : Cachable {

        let fileName = fileName(for: type)
        
        do {
            
            let data = try Data(contentsOf: fileURL(with: fileName))
            let decodedData = try JSONDecoder.movieDB.decode([T].self, from: data)
            
            return decodedData
            
        } catch  {
            
            return nil
        }
    }
    
    func serial<T>(for type: T.Type) -> Int? where T : Cachable {
        
        let fileName = fileName(for: type)
        
        return serials[fileName]
    }
    
    func rootFolderURL() throws -> URL {
        
        return try fileManager.rootFolderURL(with: cacheFolderName)
    }
    
    func fileURL(with name: String) throws -> URL {
        
        return try rootFolderURL().appendingPathComponent(name)
    }
}
