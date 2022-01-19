//
//  UserListPresenter.swift
//  Task_search_user
//
//  Created by Поздняков Игорь Николаевич on 19.01.2022.
//

import Foundation
import UIKit

class UserListPresenter {
    
    weak var view: UserListViewInput?
    var router: UserListRouter?
    var userNetworkingServise: UserNetworkService?
    var userRequest: String = ""
    var userSearchResponce: UserSearchResponse?
    
    var models: [UsersModel] = []
}

extension UserListPresenter: UserListViewOutput {
    func viewWillAppear() {
        view?.reloadUI()
    }
    
    func buttonSearchTapped() {
//        print("метод в презентере")
//        print(userRequest)
//        let urlString = "https://api.github.com/search/users?q=" + userRequest
//        userNetworkingServise?.request(urlString: urlString) { [weak self] (result) in
//            switch result {
//            case .success(let searchResponse):
//                self?.userSearchResponce = searchResponse
//                
//                self?.models = searchResponse.items.map{
//                    UsersModel(login: $0.login, id: $0.id, avatar: $0.avatar, followers: $0.followers)
//                }
//                self?.view?.reloadUI()
//                print(self?.models.count)
//            case .failure(let error):
//                print(error)
//            }
//            
//        }
    }
    
    func addData(data: String) {
        userRequest = data
    }
    
    func didSelectRowAt(index: Int) {
        
    }
    
    func numberOfItems() -> Int {
        return models.count
    }
    
    func currentModel() -> [UsersModel] {
        return models
    }
    
    func modelOfIndex(index: Int) -> UsersModel {
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
