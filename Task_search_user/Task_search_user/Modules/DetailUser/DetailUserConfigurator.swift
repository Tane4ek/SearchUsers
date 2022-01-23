//
//  DetailUserConfigurator.swift
//  Task_search_user
//
//  Created by Татьяна Лузанова on 21.01.2022.
//

import Foundation

final class DetailUserModuleConfigurator {
    
    func configure(name: String) -> DetailUserViewController {
        let presenter = DetailUserPresenter(user: name)
        let view =  DetailUserViewController(presenter: presenter)
        let router = DetailUserRouter()
        
        presenter.view = view
        presenter.router = router
        router.view = view
        
        return view
    }
}
