//
//  UserListConfigurator.swift
//  Task_search_user
//
//  Created by Татьяна Лузанова on 19.01.2022.
//

import UIKit


final class UserListModuleConfigurator {
    
    func configure() -> UserListViewController {
        let presenter = UserListPresenter()
        let view = UserListViewController(presenter: presenter)
        let router = UserListRouter()
        
        presenter.view = view
        presenter.router = router
        router.view = view
        
        return view
    }
}
