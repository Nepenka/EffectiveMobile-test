//
//  API Service.swift
//  EffectiveMobile-test
//
//  Created by Владислав Перелыгин on 30/09/2025.
//


import UIKit
import Foundation


class APIService {
    static let shared = APIService()
    
    private init() {}
        
    func fetchTodo(completion: @escaping (Result<[Task], Error>) -> Void) {
        let urlString = "https://dummyjson.com/todos"
        guard let url = URL(string: urlString) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        DispatchQueue.global(qos: .background).async {
            URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
                if let error = error {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                    return
                }
            
                guard let data = data else {
                    DispatchQueue.main.async {
                        completion(.failure(NSError(domain: "No data", code: -1)))
                    }
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(Todo.self, from: data)
                    DispatchQueue.main.async {
                        completion(.success(response.todos))
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            }.resume()
        }
    }
}
