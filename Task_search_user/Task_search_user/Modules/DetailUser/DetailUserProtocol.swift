//
//  File.swift
//  Task_search_user
//
//  Created by Татьяна Лузанова on 21.01.2022.
//

import UIKit

protocol DetailUserViewInput: AnyObject {
    
    func reloadUI()
    
}

protocol DetailUserViewOutput: AnyObject {
    
    func viewWillAppear()
    
    func updateDataFromServer()
    
    func getImage(from string: String, completion:@escaping ((UIImage?) -> Void))
    
    func getUserDetail() -> UserDetail
}
