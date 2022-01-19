//
//  DetailUserNetworkService.swift
//  Task_search_user
//
//  Created by Поздняков Игорь Николаевич on 19.01.2022.
//

import UIKit

class DetailUserNetworkService {
    
    func request(urlString: String, completion: @escaping (Result<DetailUserSearchResponse, Error>) -> Void) {
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
                    let users = try JSONDecoder().decode(DetailUserSearchResponse.self, from: data)
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
