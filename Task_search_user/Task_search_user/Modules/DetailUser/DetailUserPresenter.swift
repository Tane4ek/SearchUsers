//
//  DetailUserPresenter.swift
//  Task_search_user
//
//  Created by Татьяна Лузанова on 21.01.2022.
//

import Foundation
import UIKit

class DetailUserPresenter {
    
    weak var view: DetailUserViewInput?
    var router: DetailUserRouter?
    var detailUserNetworkServise = DetailUserNetworkService()
    var detailUserSearchResponce: UserDetail?
    
    var user: String
    
    init(user: String) {
        self.user = user
    }
}

extension DetailUserPresenter: DetailUserViewOutput {
    func viewWillAppear() {
        view?.reloadUI()
    }
    
    func updateDataFromServer() {
        let urlString = "https://api.github.com/users/" + user
        detailUserNetworkServise.request(urlString: urlString) { [weak self] (result) in
            switch result {
            case .success(let searchResponse):
                self?.detailUserSearchResponce = searchResponse
                self?.view?.reloadUI()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getImage(from string: String, completion:@escaping ((UIImage?) -> Void)) {
        guard let url = URL(string: string)
        else {
            print("Unable to create URL")
            completion(nil)
            return
        }
        
        DispatchQueue.global().async {
            do {
                let data = try Data(contentsOf: url, options: [])
                DispatchQueue.main.async {
                    let image = UIImage(data: data)
                    completion(image)
                }
            }
            catch {
                print(error.localizedDescription)
                completion(nil)
            }
        }
    }
    
    func getUserDetail() -> UserDetail {
        let userDetails = detailUserSearchResponce ?? UserDetail(avatar: "", name: "", company: "", email: "", followers: 0)
        return userDetails
    }
}
