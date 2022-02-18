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
        let firstTable = tablesQuery.firstMatch
        let firstTableCell = firstTable.cells.element(boundBy: 0)
        let firstTableCellLabels = firstTableCell.children(matching: .staticText)
        let titleLabel = firstTableCellLabels.matching(identifier: "Movie Title").firstMatch
        
        // then
        XCTAssertEqual(titleLabel.label, expected)
    }
    
    func testFaforites() throws {
        
        // given
        let app = XCUIApplication()
        app.launchArguments += ["UI-TESTING"]
        app.launch()
    
        // when
        let tablesQuery = app.tables
        let firstTable = tablesQuery.firstMatch
        let tableCells = firstTable.cells
        let secondTableCell = tableCells.element(boundBy: 1)
        secondTableCell.tap()
        app.navigationBars["Red Notice"].buttons["Favorite"].tap()
        app.tabBars["Tab Bar"].buttons["Favorites"].tap()
        
        let favoritesScrollView = app.scrollViews.firstMatch
        let firstFavCell = favoritesScrollView.children(matching: .other).element(boundBy: 0).children(matching: .other).element
        let firstCellTitle = firstFavCell.children(matching: .staticText).matching(identifier: "Favorites Movie Title").element
                
        XCTAssertEqual(firstCellTitle.label, "Red Notice")
    }
    
}
