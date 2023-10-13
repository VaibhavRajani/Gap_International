//
//  LoginView.swift
//  Gap_International
//
//  Created by Vaibhav Rajani on 10/17/23.
//

import SwiftUI

struct LoginView: View {
    @Binding var username: String
    @Binding var password: String
    @Binding var isLoggedIn: Bool
    @Binding var loginError: Bool
    @ObservedObject var apiService: APIService
    @State private var isSignUp = false
    @State private var signUpUsername: String = ""
    @State private var signUpPassword: String = ""
    @State private var isShowingAlert = false
    
    var body: some View {
        NavigationLink("", destination: EmptyView())
        VStack {
            Image("gap") // Replace with your image name
                .resizable()
                .scaledToFit()
                .frame(width: 500, height: 200) // Adjust the size as needed
                .padding()
            
            if isSignUp {
                // Sign-up form
                TextField("Username", text: $signUpUsername)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                SecureField("Password", text: $signUpPassword)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button("Sign Up") {
                    apiService.signUp(username: signUpUsername, password: signUpPassword) { result in
                        switch result {
                        case .success(let response):
                            if response == "Success" {
                                isLoggedIn = true
                            } else {
                                loginError = true
                            }
                        case .failure:
                            loginError = true
                        }
                    }
                }
                .buttonStyle(DefaultButtonStyle(backgroundColor: Color.gray))
                
                Button("Back to Login") {
                    isSignUp = false
                }
                .buttonStyle(DefaultButtonStyle(backgroundColor: Color.gray))
            } else {
                // Login form
                TextField("Username", text: $username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                HStack {
                    Button("Login") {
                        apiService.login(username: username, password: password) { result in
                            switch result {
                            case .success(let response):
                                print("Login Response: \(response)")
                                if response.contains("success"){
                                    isLoggedIn = true
                                    print("User logged in successfully")
                                    print(isLoggedIn)
                                } else {
                                    loginError = true
                                    print("Login Error")
                                    isShowingAlert = true
                                }
                            case .failure(let error):
                                print("Login Error: \(error)")
                                loginError = true
                            }
                        }
                    }
                    .buttonStyle(DefaultButtonStyle(backgroundColor: Color.gray))
                    
                    Button("Sign Up") {
                        isSignUp.toggle()
                    }
                    .buttonStyle(DefaultButtonStyle(backgroundColor: Color.gray))
                }
            }
        }
        .navigationBarHidden(true)
        .alert(isPresented: $isShowingAlert) {
            Alert(
                title: Text("Login Error"),
                message: Text("Incorrect username or password. Please try again."),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

struct DefaultButtonStyle: ButtonStyle {
    var backgroundColor: Color
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .padding()
            .background(backgroundColor)
            .foregroundColor(.white)
            .cornerRadius(8)
            .padding(.horizontal)
            .opacity(configuration.isPressed ? 0.7 : 1.0)
    }
}

#Preview {
    ContentView()
}

