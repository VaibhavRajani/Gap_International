//
//  MainContentView.swift
//  Gap_International
//
//  Created by Vaibhav Rajani on 10/17/23.
//

import SwiftUI
import AVKit
import AVFoundation
import Combine

struct Chapter: Identifiable {
    var id = UUID()
    var name: String
    var videoURL: URL
}

struct CommentPopover: View {
    @Binding var selectedChapter: Chapter?
    @Binding var commentInput: String
    var saveAction: () -> Void
    @State private var isPopoverPresented = true
    @State private var isTextFieldFocused = false
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.3)
                .ignoresSafeArea()
            
            VStack {
                Text("Add a Comment")
                    .font(.title)
                    .padding()
                
                Text("Chapter: \(selectedChapter?.name ?? "N/A")")
                
                TextEditor(text: $commentInput)
                    .frame(height: 100)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                    .padding(.horizontal)
                    .background(Color.white)
                    .cornerRadius(8)
                    .onTapGesture {
                        isTextFieldFocused = true
                    }
                
                HStack {
                    Button("Cancel") {
                        isPopoverPresented = false
                    }
                    
                    Button("Done") {
                        saveAction()
                        isPopoverPresented = false
                    }
                }
                .padding()
            }
            .frame(width: 300, height: 300)
            .background(Color.white)
            .cornerRadius(12)
        }
        .opacity(isPopoverPresented ? 1 : 0)
        .onTapGesture {
            isTextFieldFocused = false
            isPopoverPresented = false
        }
        .transition(.scale)
    }
}

struct VideoControlBar: View {
    @Binding var isPlaying: Bool
    @Binding var currentTime: Double
    var player: AVPlayer?
    @Binding var duration: Double
    var seekAction: (Double) -> Void
    var previousAction: () -> Void
    var nextAction: () -> Void
    var pipAction: () -> Void
    var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        HStack {
            Spacer()
            
            Button(action: {
                isPlaying.toggle()
            }) {
                Image(systemName: isPlaying ? "pause.circle" : "play.circle")
                    .font(.title)
            }
            
            Slider(value: $currentTime, in: 0...duration, onEditingChanged: { _ in
                seekAction(currentTime)
                print("seekaction")
            })
            .onReceive(timer, perform: { _ in
                if let currentItem = player?.currentItem {
                    let currentTime1 = CMTimeGetSeconds(currentItem.currentTime())
                    self.currentTime = currentTime1
                    print("Duration: \(duration) s")
                    print("Current time: \(currentTime) s")
                    if(currentTime > duration - 1 && currentTime < duration){
                        print("Video over")
                        let alert = UIAlertController(title: "Video Complete.", message: "Please leave a comment before proceeding to the next chapter.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default))
                        UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true)
                    }
                }
            })
            
            Button(action: {
                previousAction()
            }) {
                Image(systemName: "arrow.left.circle")
                    .font(.title)
            }
                        
            Button(action: {
                nextAction()
            }) {
                Image(systemName: "arrow.right.circle")
                    .font(.title)
            }
            
            Button(action: {
                pipAction()
            }) {
                Image(systemName: "pip")
                    .font(.title)
            }
            Spacer()
            
        }
        .padding()
        
        
    }
}

struct MainContentView: View {
    @State private var isChapterMenuVisible = true
    @State private var selectedChapter: Chapter?
    @State private var chapters: [Chapter] = []
    @State private var player: AVPlayer?
    @State private var userComment = ""
    @Binding var isLoggedIn: Bool
    var username: String
    @State private var isPlaying = false
    @State private var currentTime = 0.0
    @State private var duration = 0.0
    @State private var selectedChapterIndex: Int = 0
    @State private var commentInput = ""
    @State private var isCommentPopoverPresented = false
    @State private var hasCommented = false
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    var body: some View {
        NavigationView {
            ZStack {
                HStack(spacing: 0) {
                    // Sidebar (Chapter Menu)
                    if isChapterMenuVisible {
                        VStack {
                            List(chapters) { chapter in
                                Button(action: {
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
                                }) {
                                    HStack {
                                        Text(chapter.name)
                                            .font(.title)
                                            .padding(.vertical, 30)
                                        Image(systemName: "chevron.right")
                                    }
                                }
                                .listRowBackground(Color(red: 74/255, green: 92/255, blue: 142/255))
                                .listRowSeparatorTint(.white)
                            }
                            .listStyle(SidebarListStyle())
                            .navigationTitle("Sidebar")
                            .frame(width: 350)
                            .background(Color(red: 74/255, green: 92/255, blue: 142/255))
                            .foregroundColor(.white)
                            .scrollContentBackground(.hidden)
                        }
                    }
                    
                    VStack() {
                        HStack {
                            if isPortrait() {
                                
                                Button(action: {
                                    withAnimation {
                                        isChapterMenuVisible.toggle()
                                    }
                                }) {
                                    Image(systemName: "line.horizontal.3")
                                        .font(.title)
                                }
                            }
                            Spacer()
                            Text("Gap International")
                                .font(.title)
                            Spacer()
                            NavigationLink(
                                destination: JournalView(isLoggedIn: $isLoggedIn, username: username),
                                label: {
                                    Text("Journal")
                                        .font(.title)
                                }
                            )
                            
                            Button(action: {
                                isLoggedIn = false
                            }) {
                                Text("Logout")
                                    .font(.title)
                            }
                        }
                        
                        .frame(maxWidth: .infinity, maxHeight: 80)
                        
                        if selectedChapterIndex < chapters.count {
                            VStack {
                                Text(selectedChapter?.name ?? "")
                                    .font(.largeTitle)
                                
                                VideoPlayer(player: player) {
                                }
                                .onReceive([isPlaying].publisher) { _ in
                                    if isPlaying {
                                        player?.play()
                                    } else {
                                        player?.pause()
                                    }
                                }
                                .frame(width: 700, height: 500)
                                .background(Color(.systemGray6))
                                
                                VideoControlBar(isPlaying: $isPlaying, currentTime: $currentTime, player: player, duration: $duration, seekAction: { newTime in
                                    player!.seek(to: CMTime(seconds: newTime, preferredTimescale: 1))
                                }, previousAction: {
                                    if selectedChapterIndex > 0 {
                                        print("Going to the previous chapter")
                                        
                                        selectedChapterIndex -= 1
                                        selectedChapter = chapters[selectedChapterIndex]
                                        player = AVPlayer(url: selectedChapter!.videoURL)
                                        self.duration = selectedChapter!.videoDuration()
                                        print("Selected chapter: \(selectedChapter?.name ?? "N/A")")
                                    }
                                }, nextAction: {
                                    if hasCommented {
                                        if selectedChapterIndex < chapters.count - 1 {
                                            print("Going to the next chapter")
                                            selectedChapterIndex += 1
                                            selectedChapter = chapters[selectedChapterIndex]
                                            player = AVPlayer(url: selectedChapter!.videoURL)
                                            self.duration = selectedChapter!.videoDuration()
                                            hasCommented = false
                                            print("Selected chapter: \(selectedChapter?.name ?? "N/A")")
                                        }
                                    } else {
                                        let alert = UIAlertController(title: "Comment Required", message: "Please leave a comment before proceeding to the next chapter.", preferredStyle: .alert)
                                        alert.addAction(UIAlertAction(title: "OK", style: .default))
                                        UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true)
                                    }
                                }, pipAction: {
                                })
                                Button(action: {
                                    guard currentTime >= duration else {
                                        let alert = UIAlertController(title: "Video Not Fully Watched", message: "Cannot save comment until the video is fully over.", preferredStyle: .alert)
                                        alert.addAction(UIAlertAction(title: "OK", style: .default))
                                        UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true)
                                        return
                                    }
                                    isCommentPopoverPresented = true
                                    hasCommented = true
                                }) {
                                    Text("Leave A Comment")
                                        .padding()
                                        .background(Color.blue)
                                        .foregroundColor(.white)
                                        .cornerRadius(8)
                                }
                                .popover(isPresented: $isCommentPopoverPresented, content: {
                                    CommentPopover(selectedChapter: $selectedChapter, commentInput: $commentInput) {
                                        saveComment()
                                    }
                                })
                                
                                Text("A description of the video.")
                                    .font(.subheadline)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .onAppear {
                                self.duration = selectedChapter!.videoDuration()
                                player = AVPlayer(url: selectedChapter!.videoURL)
                            }
                        }
                    }
                    .padding()
                }
            }
            .background(Color(.systemGray4))
            .edgesIgnoringSafeArea(.all)
            .onAppear {
                loadChaptersFromPlist()
                selectedChapter = chapters.first
            }
            .navigationBarTitle("")
            .navigationBarHidden(true)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    func isPortrait() -> Bool {
        return UIDevice.current.orientation.isPortrait
    }
    
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
    
    func saveComment() {
        guard let selectedChapter = selectedChapter, !commentInput.isEmpty else {
            return
        }
        
        let apiService = APIService()
        apiService.saveComment(username: username, chapterName: selectedChapter.name, comment: commentInput, level: 1) { result in
            switch result {
            case .success(let response):
                print("Comment saved successfully: \(response)")
            case .failure(let error):
                print("Error saving comment: \(error)")
            }
        }
    }
}

extension AVPlayer {
    func currentItemDuration() -> Double {
        return currentItem?.duration.seconds ?? 0
    }
}

extension Chapter {
    func videoDuration() -> Double {
        let asset = AVURLAsset(url: videoURL)
        return asset.duration.seconds
    }
}

#Preview{
    ContentView()
}

