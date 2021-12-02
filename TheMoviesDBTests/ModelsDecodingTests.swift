//
//  ModelsDecodingTests.swift
//  TheMoviesDBTests
//
//  Created by Max Gribov on 02.12.2021.
//

import XCTest
@testable import TheMoviesDB

class ModelsDecodingTests: XCTestCase {
    
    let bundle = Bundle(for: ModelsDecodingTests.self)
    let decoder = JSONDecoder.movieDB

    func testMovie() throws {
     
        // given
        let url = bundle.url(forResource: "Movie", withExtension: "json")!
        let json = try Data(contentsOf: url)
        
        // when
        let result = try decoder.decode(Movie.self, from: json)
        
        // then
        XCTAssertEqual(result.id, 580489)
        XCTAssertEqual(result.title, "Venom: Let There Be Carnage")
    }
    
    func testDiscoverResponse() throws {
     
        // given
        let url = bundle.url(forResource: "DiscoverResponse", withExtension: "json")!
        let json = try Data(contentsOf: url)
        
        // when
        let result = try decoder.decode(ServerCommands.Discover.Response.self, from: json)
        
        // then
        XCTAssertEqual(result.page, 1)
        XCTAssertEqual(result.results[0].id, 580489)
    }
}
