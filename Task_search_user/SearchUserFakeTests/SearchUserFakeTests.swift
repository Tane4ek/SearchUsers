//
//  SearchUserFakeTests.swift
//  SearchUserFakeTests
//
//  Created by Поздняков Игорь Николаевич on 05.02.2022.
//

import XCTest
@testable import Task_search_user

class SearchUserFakeTests: XCTestCase {
    
    var networkingSut: UserNetworkService!
    var sut: UserListPresenter!
    
    

    override func setUpWithError() throws {
        try super.setUpWithError()
        networkingSut = UserNetworkService()
        sut = UserListPresenter()
    }

    override func tearDownWithError() throws {
        networkingSut = nil
        sut = nil
    }

    func testPressSearchUserButton() {
//        given
        let stubbedData = "[1]".data(using: .utf8)
        let urlString = "https://api.github.com/search/users?q=Tane4ek"
        let url = URL(string: urlString)!
        let stubbedResponse = HTTPURLResponse(
          url: url,
          statusCode: 200,
          httpVersion: nil,
          headerFields: nil)
//      let urlSessionStub = URLSessionStub(
//        data: stubbedData,
//        response: stubbedResponse,
//        error: nil)
//        sut.urlSession = urlSessionStub
//        let promise = expectation(description: "Value Received")
//    //    when
//        sut.buttonSearchTapped(text: <#T##String#>) {
//    //      then
//    //      2
//          XCTAssertEqual(self.sut.targetValue, 1)
//          promise.fulfill()
//        }
//        wait(for: [promise], timeout: 5)
      }

}
