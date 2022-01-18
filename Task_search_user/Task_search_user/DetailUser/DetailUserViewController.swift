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
    
    let networkService = NetworkService()
    var searcResponce: SearchResponse? = nil
    var array: [UsersModel] = []
//    var userResponce: String = ""
    
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
        //                updateDataFromServer(request: "")
    }
    
    func updateDataFromServer(request: String) {
        let urlString = "https://api.github.com/search/users/" + userName
        networkService.request(urlString: urlString) { [weak self] (result) in
            switch result {
            case .success(let searchResponse):
                self?.searcResponce = searchResponse
                self?.collectionView.reloadData()
                
                self?.array = searchResponse.items.map{
                    UsersModel(login: $0.login, id: $0.id, avatar: $0.avatar, followers: $0.followers)
                }
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
//        collectionView.register(DetailUserCollectionViewCell.self, forCellWithReuseIdentifier: DetailUserCollectionViewCell.reusedId)
        layout.scrollDirection = .vertical
        collectionView.setCollectionViewLayout(layout, animated: true)
        collectionView.delegate = self
        collectionView.dataSource = self
        layout.minimumLineSpacing = 10
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

// MARK: - UICollectionViewDelegate
extension DetailUserViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailUserVC = DetailUserViewController(userName: array[indexPath.row].login)
        
        navigationController?.pushViewController(detailUserVC, animated: true)
    }
}

// MARK: - UICollectionViewDataSource
extension DetailUserViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return array.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.reusedId, for: indexPath) as! CollectionViewCell
        cell.layer.cornerRadius = 20
        cell.login.text = array[indexPath.row].login
        cell.id.text = String(array[indexPath.row].id)
        let string = array[indexPath.row].avatar
        let image = getImage(from: string, completion: { (image: UIImage?) in
            cell.avatar.image = image
        })
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension DetailUserViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width - 30, height: 70)
    }
}
