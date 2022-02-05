//
//  Task_search_userTests.swift
//  Task_search_userTests
//
//  Created by Поздняков Игорь Николаевич on 05.02.2022.
//

import XCTest
@testable import Task_search_user


class  SearchUserSlowTests: XCTestCase {
    
    var sut: URLSession!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = URLSession(configuration: .default)
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }

    func testValidApiCallGetHTTPStatusCode200() throws {
//        given
        let urlString = "https://api.github.com/search/users?q=Tane4ek"
        
        let url = URL(string: urlString)!
        
        let promise = expectation(description: "Status code: 200")
        
//        when
        let dataTask = sut.dataTask(with: url) { _, response, error in
            if let error = error {
                XCTFail("Error: \(error.localizedDescription)")
                return
            } else if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if statusCode == 200 {
                promise.fulfill()
            } else {
                XCTFail("Status code: \(statusCode)")
            }
        }
    }
        dataTask.resume()
        
        wait(for: [promise], timeout: 5)
    }
    
    func testApiCallCompletes() throws {
//        given
        let urlString = "https://api.github.com/search/users?q=Tane4ek"
        
        let url = URL(string: urlString)!
        
        let promise = expectation(description: "Completion handler invoked")
        var statusCode: Int?
        var responseError: Error?
//        when
        let dataTask = sut.dataTask(with: url) {_, response, error in
            statusCode = (response as? HTTPURLResponse)?.statusCode
            responseError = error
            promise.fulfill()
        }
        dataTask.resume()
        wait(for: [promise], timeout: 5)
        
//        then
        XCTAssertNil(responseError)
        XCTAssertEqual(statusCode, 200)
    }
}
