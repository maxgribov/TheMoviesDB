//
//  MainScreenUITests.swift
//  TheMoviesDBUITests
//
//  Created by Max Gribov on 27.12.2021.
//

import XCTest
@testable import TheMoviesDB

class MainScreenUITests: XCTestCase {

    func testFirstItemTitle() throws {
   
        // given
        let app = XCUIApplication()
        app.launchArguments += ["UI-TESTING"]
        app.launch()
        let expected = "Test 1"
        
        // when
        let tablesQuery = XCUIApplication().tables
        let test1Cell = tablesQuery.cells.element(boundBy: 0)
        let titleLabel = test1Cell.children(matching: .staticText).element
        
        // then
        XCTAssertEqual(titleLabel.label, expected)
    }
    
    func testFirstItemTitle2() throws {
   
        // given
        let app = XCUIApplication()
        app.launchArguments += ["UI-TESTING"]
        app.launch()
        let expected = "Test 1"
        
        // when
        let tablesQuery = XCUIApplication().tables
        let test1Cell = tablesQuery.cells.element(boundBy: 0)
        let titleLabel = test1Cell.children(matching: .staticText).element
        
        // then
        XCTAssertEqual(titleLabel.label, expected)
    }
}
