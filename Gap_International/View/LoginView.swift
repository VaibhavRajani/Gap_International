//
//  LoginView.swift
//  Gap_International
//
//  Created by Vaibhav Rajani on 10/17/23.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var controller = LoginController()
    @Binding var username: String
    @Binding var password: String
    
    var body: some View {
        NavigationLink("", destination: EmptyView())
        VStack {
            Image("gap")
                .resizable()
                .scaledToFit()
                .frame(width: 500, height: 200)
                .padding()
            
            if controller.isSignUp {
                TextField("Username", text: $controller.signUpUsername)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                SecureField("Password", text: $controller.signUpPassword)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button("Sign Up") {
                    controller.signUp(username: username, password: password)
                }
                .buttonStyle(DefaultButtonStyle(backgroundColor: Color.gray))
                
                Button("Back to Login") {
                    controller.isSignUp = false
                }
                .buttonStyle(DefaultButtonStyle(backgroundColor: Color.gray))
            } else {
                TextField("Username", text: $username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                HStack {
                    Button("Login") {
                        controller.logIn(username: username, password: password)
                    }
                    .buttonStyle(DefaultButtonStyle(backgroundColor: Color.gray))
                    
                    Button("Sign Up") {
                        controller.isSignUp.toggle()
                    }
                    .buttonStyle(DefaultButtonStyle(backgroundColor: Color.gray))
                }
            }
        }
        .navigationBarHidden(true)
        .alert(isPresented: $controller.isShowingAlert) {
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

