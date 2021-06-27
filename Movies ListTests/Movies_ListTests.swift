//
//  Movies_ListTests.swift
//  Movies ListTests
//
//  Created by Asad Ullah on 6/27/21.
//

import XCTest
import Combine

@testable import Movies_List

class Movies_ListTests: XCTestCase {
    var sut: MovieListViewModel!
    private var bindings = Set<AnyCancellable>()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
        sut = MovieListViewModel()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
        try super.tearDownWithError()
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    
    func test_loading_when_fetching() {
        
        var loadingStatus = false
        let stateValueHandler: (ListViewModelState) -> Void = { state in
            switch state {
            case .loading:
                loadingStatus = true
                print("Loading")
            case .finishedLoading:
                print("Finished Loading")
            case .error(let error):
                print("Finished with error", error)
            }
        }
        
        sut.$state
            .receive(on: RunLoop.main)
            .sink(receiveValue: stateValueHandler)
            .store(in: &bindings)
        
        XCTAssertFalse( loadingStatus )
    }

    
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
