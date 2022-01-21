//
//  UserListRouter.swift
//  Task_search_user
//
//  Created by Татьяна Лузанова on 19.01.2022.
//

import UIKit

class UserListRouter {
    
    weak var view: UserListViewController?
    weak var alert: UIAlertController?
    
    
    func showAlert() {
        let alert = UIAlertController(title: "Attention", message: "Requesr must contain at least one character", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        view?.present(alert, animated: true, completion: nil)
    }
    
    func showNoResultsAlert() {
        let alert = UIAlertController(title: "Attention", message: "The search has not given any results. Try another query", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        view?.present(alert, animated: true, completion: nil)
    }
    
    func showDetailUserModule(name: String) {
        let configurator = DetailUserModuleConfigurator()
        let detailUserViewController = configurator.configure(name: name)
        
        view?.navigationController?.pushViewController(detailUserViewController, animated: true)
    }
}
