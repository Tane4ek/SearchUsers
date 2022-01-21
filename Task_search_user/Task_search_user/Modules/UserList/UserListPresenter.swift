//
//  UserListPresenter.swift
//  Task_search_user
//
//  Created by Татьяна Лузанова on 19.01.2022.
//

import Foundation
import UIKit

class UserListPresenter {
    
    weak var view: UserListViewInput?
    var router: UserListRouter?
    var userNetworkingServise = UserNetworkService()
    var userSearchResponce: UserSearchResponse?
    var models: [User] = []
}

extension UserListPresenter: UserListViewOutput {
    func viewWillAppear() {
        view?.reloadUI()
    }
    
    func buttonSearchTapped(text: String) {
        if text != "" {
            let urlString = "https://api.github.com/search/users?q=" + text
            userNetworkingServise.request(urlString: urlString) { [weak self] (result) in
                switch result {
                case .success(let searchResponse):
                    self?.userSearchResponce = searchResponse
                    self?.models = searchResponse.items.map{
                        User(login: $0.login, id: $0.id, avatar: $0.avatar)
                    }
                    self?.view?.reloadUI()
                case .failure(let error):
                    print(error)
                }
            }
        } else {
            router?.showAlert()
        }
    }
    
    func segmentControledTapped(text: String, sort: String) {
        let urlString = "https://api.github.com/search/users?q=" + text + "sort:" + sort
        userNetworkingServise.request(urlString: urlString) { [weak self] (result) in
            switch result {
            case .success(let searchResponse):
                self?.userSearchResponce = searchResponse
                self?.models = searchResponse.items.map{
                    User(login: $0.login, id: $0.id, avatar: $0.avatar)
                }
                self?.view?.reloadUI()
            case .failure(let error):
                print(error)
            }
        }
    }

    func didSelectRowAt(index: Int) {
        let currentUser = models[index].login
        router?.showDetailUserModule(name: currentUser)
    }
    
    func numberOfItems() -> Int {
        return models.count
    }
    
    func currentModel() -> [User] {
        return models
    }
    
    func modelOfIndex(index: Int) -> User {
        return models[index]
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
}
