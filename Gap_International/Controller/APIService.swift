//
//  APIService.swift
//  Gap_International
//
//  Created by Vaibhav Rajani on 10/17/23.
//

import Foundation

class APIService: ObservableObject {
    private let baseURL = "https://gapinternationalwebapi20200521010239.azurewebsites.net/api"
    
    private func makeRequest<T: Encodable>(urlString: String, httpMethod: String, body: T, completion: @escaping (Result<String, Error>) -> Void) {
        if let url = URL(string: urlString) {
            var request = URLRequest(url: url)
            request.httpMethod = httpMethod
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let encoder = JSONEncoder()
            if let jsonData = try? encoder.encode(body) {
                request.httpBody = jsonData
            }
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error: \(error)")
                    completion(.failure(error))
                    return
                }
                
                if let data = data, let response = String(data: data, encoding: .utf8) {
                    print("Response: \(response)")
                    completion(.success(response))
                }
            }.resume()
        } else {
            // Handle invalid URL
            completion(.failure(NSError(domain: "InvalidURL", code: 0, userInfo: nil)))
        }
    }
    
    func login(username: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {
        let loginURL = "\(baseURL)/User/UserLogin"
        let request = LoginRequest(userName: username, password: password)
        
        makeRequest(urlString: loginURL, httpMethod: "POST", body: request, completion: completion)
    }
    
    func signUp(username: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {
        let signUpURL = "\(baseURL)/User/CreateUserAccount"
        let request = SignUpRequest(userName: username, password: password)
        
        makeRequest(urlString: signUpURL, httpMethod: "POST", body: request, completion: completion)
    }
    
    func saveComment(username: String, chapterName: String, comment: String, level: Int, completion: @escaping (Result<String, Error>) -> Void) {
        let saveCommentURL = "\(baseURL)/User/SaveJournal"
        let request = SaveCommentRequest(userName: username, chapterName: chapterName, comment: comment, level: level)
        
        makeRequest(urlString: saveCommentURL, httpMethod: "POST", body: request, completion: completion)
    }
    
    func fetchData<T: Decodable>(from urlString: String, responseType: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let decodedData = try decoder.decode(T.self, from: data)
                    completion(.success(decodedData))
                } catch {
                    completion(.failure(error))
                }
            }
        }.resume()
    }

    func getUserComments(username: String, completion: @escaping (Result<[Comment], Error>) -> Void) {
        let urlString = "\(baseURL)/User/GetJournal?UserName=\(username)"

        fetchData(from: urlString, responseType: [Comment].self, completion: completion)
    }

    
}
