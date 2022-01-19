//
//  UserListProtocol.swift
//  Task_search_user
//
//  Created by Поздняков Игорь Николаевич on 19.01.2022.
//

import UIKit

protocol UserListViewInput: AnyObject {
    
    func reloadUI()
    
    func success()
    
    func failure(error: Error)
}

protocol UserListViewOutput: AnyObject {
    
    func viewWillAppear()
    
    func buttonSearchTapped()
    
    func addData(data: String)
    
    func didSelectRowAt(index: Int)
    
    func numberOfItems() -> Int
    
    func currentModel() -> [UsersModel]
    
    func modelOfIndex(index: Int) -> UsersModel
    
    func getImage(from string: String, completion:@escaping ((UIImage?) -> Void))
}
