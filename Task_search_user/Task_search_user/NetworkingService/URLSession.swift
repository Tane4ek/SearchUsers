//
//  URLSession.swift
//  Task_search_user
//
//  Created by Татьяна Лузанова on 05.02.2022.
//

//import Foundation
//
//class UrlSession {
//
//    func request<ElementType: Codable>(urlString: String, completion: @escaping (Result<ElementType, Error>) -> Void) {
//        guard let url = URL(string: urlString) else { return }
//        let session = URLSession.shared
//        session.dataTask(with: url) { data, response, error in
//            DispatchQueue.main.async {
//                if let error = error {
//                    print("some error")
//                    completion(.failure(error))
//                    return
//                }
//
//        guard let data = data else { return }
//
//                do {
//                    let users = try JSONDecoder().decode(ElementType.self, from: data)
//                    completion(.success(users))
//                } catch let jsonError {
//                    print("Failer to decode JSON", jsonError)
//                    completion(.failure(jsonError))
//                }
//            }
//        }.resume()
//    }
//}
