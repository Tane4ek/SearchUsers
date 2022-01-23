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
    var pageNumber = Int()
    var isLoading = false
    var sortOption = String()
}

extension UserListPresenter: UserListViewOutput {
    func viewWillAppear() {
        view?.reloadUI()
    }
    
    func buttonSearchTapped(text: String) {
        pageNumber = 1
        sortOption = ""
        searchText = text
        models = []
        if searchText != "" {
            let urlString = "https://api.github.com/search/users?q=" + searchText + "&page=" + String(pageNumber)
            print("button tapped: \(urlString)", pageNumber)
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
            models = []
            view?.reloadUI()
        }
    }
    
    func segmentControledTapped(sort: String) {
        sortOption = "+sort:" + sort
        pageNumber = 1
        let urlString = "https://api.github.com/search/users?q=" + searchText + sortOption + "&page=" + String(pageNumber)
        print("sermentControl: \(urlString)", pageNumber)
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
        if !isLoading {
            isLoading = true
            pageNumber += 1
            let urlString = "https://api.github.com/search/users?q=" + searchText + sortOption + "&page=" + String(pageNumber)
            print("load next page: \(urlString)", pageNumber)
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
                    self?.isLoading = false
                case .failure(let error):
                    print(error)
                }
            }
        } else {
            print("загрузка не завершена")
        }
    }
}
