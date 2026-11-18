import XCTest

final class StayUnexposedUITests: XCTestCase {
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func testBrowseDetailAndFavorite() throws {
        let app = XCUIApplication()
        app.launch()

        XCTAssertTrue(app.navigationBars["Home"].waitForExistence(timeout: 15))

        let firstRow = app.cells.firstMatch
        XCTAssertTrue(firstRow.waitForExistence(timeout: 15))
        firstRow.tap()

        XCTAssertTrue(app.navigationBars["Detail"].waitForExistence(timeout: 5))

        app.buttons["Add to favorites"].firstMatch.tap()

        app.navigationBars["Detail"].buttons.firstMatch.tap()

        app.tabBars.buttons["Favorites"].tap()

        XCTAssertTrue(app.navigationBars["Favorites"].waitForExistence(timeout: 5))
        XCTAssertFalse(app.staticTexts["No favorites yet"].exists)
    }

    @MainActor
    func testSearchShowsNoMatches() throws {
        let app = XCUIApplication()
        app.launch()

        app.navigationBars["Home"].waitForExistence(timeout: 15)

        let searchField = app.searchFields.firstMatch
        XCTAssertTrue(searchField.waitForExistence(timeout: 5))
        searchField.tap()
        searchField.typeText("zzzzz")

        XCTAssertTrue(app.staticTexts["No matches"].waitForExistence(timeout: 5))
    }
}
