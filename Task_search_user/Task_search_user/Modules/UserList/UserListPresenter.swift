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
    var models: [User] = []
    var searchText = String()
    var pageNumber = Int()
    var isLoading = false
    var sortOption = String()
    var totalCount = Int()
    
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
            loadPage()
        } else {
            router?.showAlert()
            models = []
            view?.reloadUI()
        }
    }
    
    func segmentControledTapped(sort: String) {
        sortOption = "+sort:" + sort
        pageNumber = 1
        models = []
        loadPage()
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
            if totalCount > (models.count){
                isLoading = true
                pageNumber += 1
                loadPage()
            }
        } else {
            print("загрузка не завершена")
        }
    }
    
    private func loadPage() {
        let urlString = "https://api.github.com/search/users?q=" + searchText + sortOption + "&page=" + String(pageNumber)
        print("button tapped: \(urlString)", pageNumber)
        userNetworkingServise.request(urlString: urlString) { [weak self] (result) in
            switch result {
            case .success(let searchResponse):
                self?.totalCount = searchResponse.totalCount ?? 0
                self?.models += searchResponse.items
                self?.view?.reloadUI()
                self?.isLoading = false
            case .failure(let error):
                self?.isLoading = false
                print(error)
            }
            self?.isLoading = false
        }
    }
}
