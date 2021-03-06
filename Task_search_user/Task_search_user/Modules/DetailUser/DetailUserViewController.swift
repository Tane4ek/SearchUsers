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
            static let insideInset: CGFloat = 10
        }
    }
    
    private enum DetailUserSection: Int {
        case avatar = 0, otherInformation
    }
    
    private enum OtherInformationSection: Int {
        case name = 0, email, company, followers
    }
    
    private enum Titles {
        static let name = "name:"
        static let email = "email:"
        static let company = "company:"
        static let followers = "followers:"
    }
    
    private let presenter: DetailUserViewOutput
    
    private var activityIndicator = UIActivityIndicatorView()
    
    private var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()

    
//    MARK: - Init
    init(presenter: DetailUserViewOutput) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    MARK: - Life circle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.viewWillAppear()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter.updateDataFromServer()
        activityIndicator.stopAnimating()
    }
    
//    MARK: - Setup UI
    private func setupUI() {
        view.backgroundColor = UIColor.white
        setupNavigationBar()
        setupActivityIndicator()
        setupCollectionView()
        setupLayout()
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.tintColor = UIColor.black
    }
    
    private func setupCollectionView() {
        collectionView.register(DetailUserImageCollectionViewCell.self, forCellWithReuseIdentifier: DetailUserImageCollectionViewCell.reusedId)
        collectionView.register(DetailUserCollectionViewCell.self, forCellWithReuseIdentifier: DetailUserCollectionViewCell.reusedId)
        layout.scrollDirection = .vertical
        collectionView.setCollectionViewLayout(layout, animated: true)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset = UIEdgeInsets(top: Paddings.CollectionView.insideInset, left: 0, bottom: Paddings.CollectionView.insideInset, right: 0)
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupActivityIndicator() {
        activityIndicator.startAnimating()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        collectionView.addSubview(activityIndicator)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

// MARK: - DetailUserViewInput
extension DetailUserViewController: DetailUserViewInput {
    func reloadUI() {
        collectionView.reloadData()
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
    
        if indexPath.section == DetailUserSection.avatar.rawValue {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailUserImageCollectionViewCell.reusedId, for: indexPath) as! DetailUserImageCollectionViewCell
            let string = presenter.getUserDetail().avatar
            _ = presenter.getImage(from: string, completion: { (image: UIImage?) in
                cell.avatar.image = image
            })
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailUserCollectionViewCell.reusedId, for: indexPath) as! DetailUserCollectionViewCell
            if let currentCell = OtherInformationSection(rawValue: indexPath.row) {
                switch currentCell {
                    
                case .name:
                    cell.labelData.text = Titles.name
                    cell.labelValue.text = presenter.getUserDetail().name
                case .company:
                    cell.labelData.text = Titles.company
                    cell.labelValue.text = presenter.getUserDetail().company
                case .email:
                    cell.labelData.text = Titles.email
                    cell.labelValue.text = presenter.getUserDetail().email
                case .followers:
                    cell.labelData.text = Titles.followers
                    cell.labelValue.text = String(presenter.getUserDetail().followers ?? 0)
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
                        heightOfRow = CGSize(width: view.frame.width, height: 60)
            }
        }
        return heightOfRow
    }
}
