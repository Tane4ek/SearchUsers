//
//  UserListConfigurator.swift
//  Task_search_user
//
//  Created by Поздняков Игорь Николаевич on 19.01.2022.
//

import UIKit


final class UserListModuleConfigurator {
    
//    var userNetworkingServise: UserNetworkService
//
//    init(userNetworkingServise: UserNetworkService) {
//        self.userNetworkingServise = userNetworkingServise
//    }
    
    func configure() -> UserListViewController {
        let presenter = UserListPresenter()
        let view = UserListViewController(presenter: presenter)
        let router = UserListRouter()
        
        presenter.view = view
        presenter.router = router
//        presenter.userNetworkingServise = userNetworkingServise
//        router.serviceContainer = serviceContainer
        router.view = view
        
        return view
    }
}
