//
//  DateFormater+Extensions.swift
//  TheMoviesDB
//
//  Created by Max Gribov on 11.12.2021.
//

import Foundation

extension DateFormatter {
    
    static let movieDB: DateFormatter = {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd" // "2017-10-25"
        
        return formatter
    }()
}
