//
//  MainContentViewController.swift
//  Gap_International
//
//  Created by Vaibhav Rajani on 10/24/23.
//

import Foundation
import AVKit
import SwiftUI

class MainContentViewController: ObservableObject {
    @Published var chapters: [Chapter] = []
    @Published var selectedChapterIndex: Int = 0
    @Published var selectedChapter: Chapter?
    @Published var player: AVPlayer?
    @Published var duration = 0.0
    @Published var hasCommented = false
    @Published var isVideoOver = false
    @Published var currentTime = 0.0

    func loadChaptersFromPlist() {
        if let plistURL = Bundle.main.url(forResource: "Chapters", withExtension: "plist"),
           let data = try? Data(contentsOf: plistURL),
           let plist = try? PropertyListSerialization.propertyList(from: data, options: [], format: nil),
           let dict = plist as? [String: Any],
           let chaptersArray = dict["Chapters"] as? [[String: String]] {
            chapters = chaptersArray.compactMap { chapterDict in
                if let name = chapterDict["name"], let urlString = chapterDict["url"], let videoURL = URL(string: urlString) {
                    return Chapter(name: name, videoURL: videoURL)
                }
                return nil
            }
        }
    }
    
    func isPortrait() -> Bool {
        return UIDevice.current.orientation.isPortrait
    }
    
    func prevAction(){
        if selectedChapterIndex > 0 {
            print("Going to the previous chapter")
            
            selectedChapterIndex -= 1
            selectedChapter = chapters[selectedChapterIndex]
            player = AVPlayer(url: selectedChapter!.videoURL)
            self.duration = selectedChapter!.videoDuration()
            print("Selected chapter: \(selectedChapter?.name ?? "N/A")")
        }
    }
    
    func nextAction(){
        if hasCommented {
            if selectedChapterIndex < chapters.count - 1 {
                print("Going to the next chapter")
                selectedChapterIndex += 1
                selectedChapter = chapters[selectedChapterIndex]
                player = AVPlayer(url: selectedChapter!.videoURL)
                self.duration = selectedChapter!.videoDuration()
                hasCommented = false
                isVideoOver = false
                print("Selected chapter: \(selectedChapter?.name ?? "N/A")")
            }
        } else {
            let alert = UIAlertController(title: "Comment Required", message: "Please leave a comment before proceeding to the next chapter.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true)
        }
    }
    
    func sideBar(){
        if hasCommented {
            if selectedChapterIndex < chapters.count - 1 {
                if currentTime >= duration {
                    selectedChapterIndex += 1
                    selectedChapter = chapters[selectedChapterIndex]
                    player = AVPlayer(url: selectedChapter!.videoURL)
                    self.duration = selectedChapter!.videoDuration()
                    
                    hasCommented = false
                    print("Selected chapter: \(selectedChapter?.name ?? "N/A")")
                } else {
                    let alert = UIAlertController(title: "Video Not Fully Watched", message: "Please ensure the current video is fully watched before proceeding to the next chapter.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true)
                }
            }
        } else {
            let alert = UIAlertController(title: "Comment Required", message: "Please leave a comment before proceeding to the next chapter.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true)
        }
    }
}
