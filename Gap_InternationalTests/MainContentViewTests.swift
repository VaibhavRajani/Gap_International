//
//  MainContentViewTests.swift
//  Gap_InternationalTests
//
//  Created by Vaibhav Rajani on 10/30/23.
//

import Foundation
import XCTest
@testable import Gap_International

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
