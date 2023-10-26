//
//  JournalController.swift
//  Gap_International
//
//  Created by Vaibhav Rajani on 10/23/23.
//

import Foundation

class JournalController: ObservableObject {
    @Published var userComments: [Comment] = []

    func loadUserComments(username: String) {
        let apiService = APIService()
        apiService.getUserComments(username: username) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let comments):
                    self.userComments = comments
                case .failure(let error):
                    print("Error loading user comments: \(error)")
                }
            }
        }
    }
}
