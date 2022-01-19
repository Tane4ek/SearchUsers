//
//  NetworkingService.swift
//  Task_search_user
//
//  Created by Татьяна Лузанова  on 17.01.2022.
//

import UIKit

class UserNetworkService {
    
    func request(urlString: String, completion: @escaping (Result<UserSearchResponse, Error>) -> Void) {
        guard let url = URL(string: urlString) else { return }
        let session = URLSession.shared
        session.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("some error")
                    completion(.failure(error))
                    return
                }
            
        guard let data = data else { return }
                
                do {
                    let users = try JSONDecoder().decode(UserSearchResponse.self, from: data)
                    completion(.success(users))
                } catch let jsonError {
                    print("Failer to decode JSON", jsonError)
                    completion(.failure(jsonError))
                }
            }
        }.resume()
    }
    
    func getImage(from string: String) -> UIImage? {
        guard let url = URL(string: string)
        else {
            print("Unable to create URL")
            return nil
        }
        var image: UIImage? = nil
        do {
            let data = try Data(contentsOf: url, options: [])
            image = UIImage(data: data)
        }
        catch {
            print(error.localizedDescription)
        }
        return image
    }
}
