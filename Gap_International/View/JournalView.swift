//
//  JournalView.swift
//  Gap_International
//
//  Created by Vaibhav Rajani on 10/20/23.
//

import SwiftUI

struct JournalView: View {
    @Binding var isLoggedIn: Bool
    var username: String

    @StateObject var controller = JournalController()

    @State private var selectedComment: Comment?

    var body: some View {
        NavigationView {
            List(controller.userComments) { comment in
                Button(action: {
                    selectedComment = comment
                }) {
                    VStack(alignment: .leading, spacing: 5) {
                        HStack{
                            Text("Chapter: \(comment.chapterName)")
                                .font(.headline)
                                .foregroundStyle(.black)

                            Spacer()
                            Text("Date: \(comment.date)")
                                .font(.caption)
                                .foregroundStyle(.black)

                        }
                        
                        Text("Comment: \(comment.comment)")
                            .font(.body)
                            .foregroundStyle(.black)
                    }
                }
            }
            .navigationBarTitle("Journal")
            
            if let comment = selectedComment {
                Text("Selected Comment:")
                VStack {
                    Text("Chapter: \(comment.chapterName)")
                        .font(.headline)
                    Text("Date: \(comment.date)")
                        .font(.caption)
                    Text("Comment: \(comment.comment)")
                        .font(.body)
                }
                .padding()
            }
        }
        .onAppear {
            controller.loadUserComments(username: username)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview{
    ContentView()
}



