//
//  Gap_InternationalTests.swift
//  Gap_InternationalTests
//
//  Created by Vaibhav Rajani on 10/13/23.
//

import XCTest
@testable import Gap_International
import SwiftUI
import AVKit
import AVFoundation
import Combine

final class Gap_InternationalTests: XCTestCase {
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

class APIServiceTests: XCTestCase {
    
    func testLogin() {
        let apiService = APIService()
        
        let expectation = XCTestExpectation(description: "Login completion")
        
        apiService.login(username: "testUser", password: "testPassword") { result in
            switch result {
            case .success(let response):
                XCTAssertEqual(response, "Success")
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
        
        apiService.signUp(username: "testUser", password: "testPassword") { result in
            switch result {
            case .success(let response):
                XCTAssertEqual(response, "Success")
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
        
        apiService.saveComment(username: "testUser", chapterName: "Chapter1", comment: "Test comment", level: 1) { result in
            switch result {
            case .success(let response):
                XCTAssertEqual(response, "Comment saved successfully")
            case .failure:
                XCTFail("Save comment should not fail")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
}

class MainContentViewTests: XCTestCase{
    
    func testNextActionWhenVideoOver() {
        let controller = MainContentViewController()
        controller.selectedChapterIndex = 0
        controller.hasCommented = true
        controller.chapters = [Chapter(name: "Chapter1", videoURL: URL(string: "https://example.com/video1.mp4")!), Chapter(name: "Chapter2", videoURL: URL(string: "https://example.com/video2.mp4")!)]
        
        controller.nextAction()
        
        XCTAssertEqual(controller.selectedChapterIndex, 1)
    }
    
    func testNextActionWhenVideoNotOver() {
        let controller = MainContentViewController()
        controller.selectedChapterIndex = 0
        controller.hasCommented = false
        controller.chapters = [Chapter(name: "Chapter1", videoURL: URL(string: "https://example.com/video1.mp4")!), Chapter(name: "Chapter2", videoURL: URL(string: "https://example.com/video2.mp4")!)]
        
        controller.nextAction()
        
        XCTAssertEqual(controller.selectedChapterIndex, 0)
    }
    
    func testSideBarWhenOver() {
        let controller = MainContentViewController()
        controller.selectedChapterIndex = 0
        controller.hasCommented = true
        controller.chapters = [Chapter(name: "Chapter1", videoURL: URL(string: "https://example.com/video1.mp4")!), Chapter(name: "Chapter2", videoURL: URL(string: "https://example.com/video2.mp4")!)]
        controller.currentTime = 21
        controller.duration = 20
        
        controller.sideBar()
        
        XCTAssertEqual(controller.selectedChapterIndex, 1)
    }

    func testSideBarWhenOverWithoutComment() {
        let controller = MainContentViewController()
        controller.selectedChapterIndex = 0
        controller.hasCommented = false
        controller.chapters = [Chapter(name: "Chapter1", videoURL: URL(string: "https://example.com/video1.mp4")!), Chapter(name: "Chapter2", videoURL: URL(string: "https://example.com/video2.mp4")!)]
        controller.currentTime = 21
        controller.duration = 20
        
        controller.sideBar()
        
        XCTAssertEqual(controller.selectedChapterIndex, 0)
    }
}

