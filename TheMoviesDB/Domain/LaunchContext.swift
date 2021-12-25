//
//  LaunchContext.swift
//  TheMoviesDB
//
//  Created by Max Gribov on 25.12.2021.
//

import Foundation

enum LaunchContext {
    
    static let testingUIArgumentKey = "UI-TESTING"
    
    static var environment: Environment {
        
        if ProcessInfo.processInfo.arguments.contains(testingUIArgumentKey) {
            
            return .testUI
            
        } else {
            
            return .prod
        }
    }
}

extension LaunchContext {
    
    enum Environment {
        
        case prod
        case testUI
    }
}
