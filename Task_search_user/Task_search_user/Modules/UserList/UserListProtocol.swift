//
//  UserListProtocol.swift
//  Task_search_user
//
//  Created by Татьяна Лузанова on 19.01.2022.
//

import UIKit

protocol UserListViewInput: AnyObject {
    
    func reloadUI()
}

protocol UserListViewOutput: AnyObject {
    
    func viewWillAppear()
    
    func buttonSearchTapped(text: String)
    
    func segmentControledTapped(text: String, sort: String)
    
    func didSelectRowAt(index: Int)
    
    func numberOfItems() -> Int
    
    func currentModel() -> [User]
    
    func modelOfIndex(index: Int) -> User
    
    func getImage(from string: String, completion:@escaping ((UIImage?) -> Void))
}
