//
//  DetailUserViewController.swift
//  Task_search_user
//
//  Created by Татьяна Лузанова on 18.01.2022.
//

import UIKit

class DetailUserViewController: UIViewController {
    
    private enum Paddings {
        
        enum CollectionView {
            static let topInset: CGFloat = 30
        }
    }
    
    private enum DetailUserSection: Int {
        case avatar = 0, otherInformation
    }
    
    private enum OtherInformationSection: Int {
        case name = 0, email, company, followers
    }
    
    var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
    
    let networkService = DetailUserNetworkService()
    var detailsearcResponce: DetailUserSearchResponse? = nil
    var model: DetailUserModel = DetailUserModel(avatar: "", name: "", company: "", email: "", followers: 0)
    
    
    let userName: String
    
    init(userName: String) {
        self.userName = userName
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateDataFromServer(request: userName)
    }
    
    func updateDataFromServer(request: String) {
        let urlString = "https://api.github.com/users/" + request
        networkService.request(urlString: urlString) { [weak self] (result) in
            switch result {
            case .success(let searchResponse):
                self?.detailsearcResponce = searchResponse
                self?.collectionView.reloadData()
                self?.model.avatar = searchResponse.avatar
                self?.model.name = searchResponse.name
                self?.model.company = searchResponse.company
                self?.model.email = searchResponse.email
                self?.model.followers = searchResponse.followers
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func setupUI() {
        view.backgroundColor = UIColor.white
        setupNavigationBar()
        setupCollectionView()
        setupLayout()
    }
    
    func setupNavigationBar() {
        navigationController?.navigationBar.tintColor = UIColor.black
    }
    
    func setupCollectionView() {
        collectionView.register(DetailUserImageCollectionViewCell.self, forCellWithReuseIdentifier: DetailUserImageCollectionViewCell.reusedId)
        collectionView.register(DetailUserCollectionViewCell.self, forCellWithReuseIdentifier: DetailUserCollectionViewCell.reusedId)
        layout.scrollDirection = .vertical
        collectionView.setCollectionViewLayout(layout, animated: true)
        collectionView.delegate = self
        collectionView.dataSource = self
        //        layout.minimumLineSpacing = 10
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 30, right: 0)
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
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

// MARK: - UICollectionViewDataSource
extension DetailUserViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var items = 0
        if let currentNumberOfSection = DetailUserSection(rawValue: section) {
            switch currentNumberOfSection {
                
            case .avatar:
                items = 1
            case .otherInformation:
                items = OtherInformationSection.followers.rawValue + 1
            }
        }
        return items
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return DetailUserSection.otherInformation.rawValue + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //        cell.login.text = array[indexPath.row].login
        //        cell.id.text = String(array[indexPath.row].id)
        //        let string = array[indexPath.row].avatar
        //        let image = getImage(from: string, completion: { (image: UIImage?) in
        //            cell.avatar.image = image
        //        })
        
        if indexPath.section == DetailUserSection.avatar.rawValue {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailUserImageCollectionViewCell.reusedId, for: indexPath) as! DetailUserImageCollectionViewCell
            let string = model.avatar
            let image = getImage(from: string, completion: { (image: UIImage?) in
                cell.avatar.image = image
            })
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailUserCollectionViewCell.reusedId, for: indexPath) as! DetailUserCollectionViewCell
            if let currentCell = OtherInformationSection(rawValue: indexPath.row) {
                switch currentCell {
                    
                case .name:
                    cell.labelData.text = "name:"
                    cell.labelValue.text = model.name
                case .company:
                    cell.labelData.text = "company:"
                    cell.labelValue.text = model.company ?? ""
                case .email:
                    cell.labelData.text = "email:"
                    cell.labelValue.text = model.email ?? ""
                case .followers:
                    cell.labelData.text = "followers:"
                    cell.labelValue.text = String(model.followers)
                }
            }
            return cell
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension DetailUserViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var heightOfRow = CGSize(width: 0, height: 0)
        if let currentNumberOfSection = DetailUserSection(rawValue: indexPath.section) {
            switch currentNumberOfSection {
                
            case .avatar:
                heightOfRow = CGSize(width: view.frame.width, height: 300)
            case .otherInformation:
                
                heightOfRow = CGSize(width: view.frame.width, height: 50)
            }
        }
        return heightOfRow
    }
}
