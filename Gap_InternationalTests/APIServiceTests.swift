//
//  APIServiceTests.swift
//  Gap_InternationalTests
//
//  Created by Vaibhav Rajani on 10/30/23.
//

import XCTest
@testable import Gap_International

class APIServiceTests: XCTestCase {
    
    func testLogin() {
        let apiService = APIService()
        
        let expectation = XCTestExpectation(description: "Login completion")
        
        apiService.login(username: "Vaibhav", password: "1728") { result in
            switch result {
            case .success(let response):
                XCTAssertEqual(response, "{\"Result\":\"Success\"}")
            case .failure:
                XCTFail("Login should not fail")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }

    func testSignUp() {
        let apiService = APIService()
        
        let expectation = XCTestExpectation(description: "Sign-up completion")
        
        apiService.signUp(username: "testUser29110904", password: "testPassword") { result in
            switch result {
            case .success(let response):
                XCTAssertEqual(response, "{\"Result\":\"success\"}")
            case .failure:
                XCTFail("Sign-up should not fail")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testSaveComment() {
        let apiService = APIService()
        
        let expectation = XCTestExpectation(description: "Save comment completion")
        
        apiService.saveComment(username: "testUser29110904", chapterName: "Chapter3", comment: "Test comment", level: 1) { result in
            switch result {
            case .success(let response):
                XCTAssertEqual(response, "{\"Result\":\"Success\"}")
            case .failure:
                XCTFail("Save comment should not fail")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
}
