//
//  ContentView.swift
//  Gap_International
//
//  Created by Vaibhav Rajani on 10/13/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject var loginController = LoginController()
    @State private var username = ""
    @State private var password = ""
    @ObservedObject var apiService = APIService()
    
    var body: some View {
        if loginController.isLoggedIn {
            MainContentView(isLoggedIn: $loginController.isLoggedIn, username: username)
                } else {
                    LoginView(controller: loginController, username: $username, password: $password)
        }
    }
}

#Preview {
    ContentView()
}
