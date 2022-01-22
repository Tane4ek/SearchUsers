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
    var searchText = String()
    var pageNumber = 0
}

extension UserListPresenter: UserListViewOutput {
    func viewWillAppear() {
        view?.reloadUI()
    }
    
    func buttonSearchTapped(text: String) {
        pageNumber = 0
        self.searchText = text
        if searchText != "" {
            let urlString = "https://api.github.com/search/users?q=" + searchText + "&page=" + String(pageNumber)
            userNetworkingServise.request(urlString: urlString) { [weak self] (result) in
                switch result {
                case .success(let searchResponse):
                    self?.userSearchResponce = searchResponse
                    self?.models = []
                    self?.models = searchResponse.items.map{
                        User(login: $0.login, id: $0.id, avatar: $0.avatar)
                    }
                    self?.view?.reloadUI()
                    self?.pageNumber += 1
                case .failure(let error):
                    print(error)
                }
            }
        } else {
            router?.showAlert()
            models = []
            view?.reloadUI()
        }
    }
    
    func segmentControledTapped(sort: String) {
        let urlString = "https://api.github.com/search/users?q=" + searchText + "sort:" + sort
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
    
    func getImage(from index: Int, completion:@escaping ((UIImage?) -> Void)) {
        guard let url = URL(string: models[index].avatar)
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
    
    func loadNextPage() {
        print("loading more users")
        if models.count % 30 == 0 {
            let urlString = "https://api.github.com/search/users?q=" + searchText + "&page=" + String(pageNumber)
            userNetworkingServise.request(urlString: urlString) { [weak self] (result) in
                switch result {
                case .success(let searchResponse):
                    self?.userSearchResponce = searchResponse
                    var moreUsers = searchResponse.items.map{
                        User(login: $0.login, id: $0.id, avatar: $0.avatar)
                    }
                    self?.models += moreUsers
                    moreUsers = []
                    self?.pageNumber += 1
                    self?.view?.reloadUI()
                case .failure(let error):
                    print(error)
                }
            }
        } else {
            print("Больше пользователей нет")
            return
        }
    }
}
