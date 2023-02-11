//
//  AcronymsSearchTests.swift
//  AcronymsSearchTests
//
//  Created by Gireesh on 11/02/23.
//

import XCTest
@testable import AcronymsSearch

class AcronymsSearchViewModelTests: XCTestCase {

    var viewModel: AcronymsSearchViewModel!
    var searchService: AcronymsSearchServiceMock!

    override func setUpWithError() throws {
        searchService = AcronymsSearchServiceMock()
        viewModel = AcronymsSearchViewModel(acronymsSearchService: searchService)
    }

    override func tearDownWithError() throws {
        viewModel = nil
        searchService = nil
    }
    
    func test_validateSearchInput_EmptyString_ReturnValidationFailure() {
        let keyword = ""
        let result = viewModel.validateSearchInput(keyword: keyword)
        XCTAssertFalse(result)
    }

    func test_validateSearchInput_StartWithNumber_ReturnValidationFailure() {
        let keyword = "2Nasa"
        let result = viewModel.validateSearchInput(keyword: keyword)
        XCTAssertFalse(result)
    }
    
    func test_validateSearchInput_StartWithWhiteSpace_ReturnValidationFailure() {
        let keyword = " Nasa"
        let result = viewModel.validateSearchInput(keyword: keyword)
        XCTAssertFalse(result)
    }
    
    func test_validateSearchInput_ValidInput_ReturnValidationSuccess() {
        let keyword = "Nasa"
        let result = viewModel.validateSearchInput(keyword: keyword)
        XCTAssertTrue(result)
    }
    
    func test_getAcronyms_InvalidRequest_ReturnEmptyResponse() {
        searchService.testScenario = .emptyResponse
        let expectation = self.expectation(description: #function)
        viewModel.getAcronymsFor(keyword: "n") {
            XCTAssertTrue(self.viewModel.acronymsCellViewModels.count == 0)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 20)
    }
    
    func test_getAcronyms_InvalidRequest_ReturnApiErrorResponse() {
        searchService.testScenario = .failure
        let expectation = self.expectation(description: #function)
        viewModel.getAcronymsFor(keyword: "n") {
            XCTAssertTrue(self.viewModel.acronymsCellViewModels.count == 0)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 20)
    }
    
    func test_getAcronyms_ValidRequest_ReturnResponse() {
        searchService.testScenario = .success
        let expectation = self.expectation(description: #function)
        viewModel.getAcronymsFor(keyword: "Nasa") {
            XCTAssertTrue(self.viewModel.acronymsCellViewModels.count > 0)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 20)
    }

    func test_numberOrRows() {
        searchService.testScenario = .success
        let expectation = self.expectation(description: #function)
        var responseCount:Int = 0
        viewModel.getAcronymsFor(keyword: "Nasa") {
            XCTAssertTrue(self.viewModel.acronymsCellViewModels.count > 0)
            responseCount = self.viewModel.acronymsCellViewModels.count
            expectation.fulfill()
        }
        waitForExpectations(timeout: 20)
        let numberOfRows = viewModel.numberOrRows()
        XCTAssertEqual(responseCount, numberOfRows)
    }
    
    func test_getCellViewModel() {
        searchService.testScenario = .success
        let expectation = self.expectation(description: #function)
        viewModel.getAcronymsFor(keyword: "Nasa") {
            XCTAssertTrue(self.viewModel.acronymsCellViewModels.count > 0)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 20)
        let cellForRow = viewModel.getCellViewModel(at: IndexPath(row: 0, section: 0))
        XCTAssertNotNil(cellForRow)
    }
}
