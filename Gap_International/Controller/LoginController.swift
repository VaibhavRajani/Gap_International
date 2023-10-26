//
//  LoginController.swift
//  Gap_International
//
//  Created by Vaibhav Rajani on 10/23/23.
//

import Foundation
import SwiftUI
import Combine

class LoginController: ObservableObject {
    @Published var isLoggedIn: Bool = false
    @Published var loginError: Bool = false
    @Published var signUpUsername: String = ""
    @Published var signUpPassword: String = ""
    @Published var isShowingAlert = false
    @Published var isSignUp = false

    init() {
            self.isLoggedIn = false
            self.loginError = false
            self.signUpUsername = ""
            self.signUpPassword = ""
            self.isShowingAlert = false
            self.isSignUp = false
        }
        
    
    func signUp(username: String, password: String) {
        let apiService = APIService()
            
            apiService.signUp(username: signUpUsername, password: signUpPassword) { result in
                DispatchQueue.main.async {

                switch result {
                case .success(let response):
                    if response == "Success" {
                        self.isLoggedIn = true
                    } else {
                        self.loginError = true
                    }
                case .failure:
                    self.loginError = true
                }
            }
        }
    }
    
    func logIn(username: String, password: String) {
        let apiService = APIService()
        apiService.login(username: username, password: password) { result in
            DispatchQueue.main.async {
                
                switch result {
                case .success(let response):
                    print("Login Response: \(response)")
                    if response.contains("success"){
                        self.isLoggedIn = true
                        print("User logged in successfully")
                        print(self.isLoggedIn)
                    } else {
                        self.loginError = true
                        print("Login Error")
                        self.isShowingAlert = true
                    }
                case .failure(let error):
                    print("Login Error: \(error)")
                    self.loginError = true
                }
            }
        }
    }
    
}
