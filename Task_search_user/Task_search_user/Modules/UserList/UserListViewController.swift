//
//  ViewController.swift
//  Task_search_user
//
//  Created by Татьяна Лузанова on 17.01.2022.
//

import UIKit

class UserListViewController: UIViewController {
    
    private enum Paddings {
        
        enum TextField {
            static let horizontalInset: CGFloat = 10
        }
        enum ButtonSearch {
            static let verticalInset: CGFloat = 20
            static let horizontalInset: CGFloat = 10
            static let width: CGFloat = 100
        }
        enum SegmentControl {
            static let verticalInset: CGFloat = 30
        }
        enum CollectionView {
            static let topInset: CGFloat = 30
        }
    }
    
    private let presenter: UserListViewOutput
    
    init(presenter: UserListViewOutput) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var textField = UITextField(frame: .zero)
    var buttonSearch = UIButton(frame: .zero)
    
    var segmentedControl = UISegmentedControl()
    
    var noUsersLabel = UILabel(frame: .zero)
    
    var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
    
    let refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(pullToRefresh(sender:)), for: .valueChanged)
        return refreshControl
    }()
    
    let networkService = UserNetworkService()
    var searcResponce: UserSearchResponse? = nil
    var array: [UsersModel] = []
    var userRequest: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //                updateDataFromServer(request: "")
    }
    
    func updateDataFromServer(request: String) {
        let urlString = "https://api.github.com/search/users?q=" + request
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
        setupTextField()
        setupButtonSearch()
        setupSegmentControl()
        setupNoUsersLabel()
        setupCollectionView()
        setupLayout()
    }
    
    func setupNavigationBar() {
        navigationController?.navigationBar.tintColor = UIColor.black
        title = "Search users"
        
    }
    
    func setupTextField() {
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.borderWidth = 1
        textField.placeholder = "Type here..."
        textField.textAlignment = .left
        textField.layer.cornerRadius = 5
        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 20))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textField)
    }
    
    func setupButtonSearch() {
        buttonSearch.setTitle("Search", for: .normal)
        buttonSearch.titleLabel?.font = UIFont(name: "Helvetica", size: 24)
        buttonSearch.setTitleColor(UIColor.black, for: .normal)
        buttonSearch.layer.borderColor = UIColor.black.cgColor
        buttonSearch.layer.borderWidth = 1
        buttonSearch.layer.cornerRadius = 5
        buttonSearch.addTarget(self, action: #selector(buttonSearchTapped(_:)), for: .touchUpInside)
        buttonSearch.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonSearch)
    }
    
    func setupSegmentControl() {
        segmentedControl = UISegmentedControl(items: ["Followers", "Repositories", "Joined"])
        segmentedControl.layer.cornerRadius = 10
        segmentedControl.setWidth(80, forSegmentAt: 0)
        segmentedControl.setWidth(90, forSegmentAt: 1)
        segmentedControl.setWidth(80, forSegmentAt: 2)
        segmentedControl.addTarget(self, action: #selector(selectedValue), for: .valueChanged)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(segmentedControl)
    }
    
    func setupNoUsersLabel() {
        noUsersLabel.text = "No users"
        noUsersLabel.font = UIFont(name: "Helvetica", size: 24)
        noUsersLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(noUsersLabel)
    }
    
    func setupCollectionView() {
        collectionView.isHidden = true
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.reusedId)
        layout.scrollDirection = .vertical
        collectionView.setCollectionViewLayout(layout, animated: true)
        collectionView.refreshControl = refreshControl
        collectionView.delegate = self
        collectionView.dataSource = self
        layout.minimumLineSpacing = 10
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 30, right: 0)
        collectionView.keyboardDismissMode = .interactive
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
    }
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            buttonSearch.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Paddings.ButtonSearch.verticalInset),
            buttonSearch.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Paddings.ButtonSearch.horizontalInset),
            buttonSearch.widthAnchor.constraint(equalToConstant: Paddings.ButtonSearch.width),
            
            textField.centerYAnchor.constraint(equalTo: buttonSearch.centerYAnchor),
            textField.heightAnchor.constraint(equalTo: buttonSearch.heightAnchor),
            textField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Paddings.TextField.horizontalInset),
            textField.trailingAnchor.constraint(equalTo: buttonSearch.leadingAnchor, constant: -Paddings.TextField.horizontalInset),
            
            segmentedControl.topAnchor.constraint(equalTo: buttonSearch.bottomAnchor, constant: Paddings.SegmentControl.verticalInset),
            segmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            noUsersLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            noUsersLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            collectionView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: Paddings.CollectionView.topInset),
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
    
    @objc func selectedValue(target: UISegmentedControl) {
        
        if target == self.segmentedControl {
            if target.selectedSegmentIndex == 0 {
                let requestForSorted = userRequest + "sort:followers"
                updateDataFromServer(request: requestForSorted)
            } else if target.selectedSegmentIndex == 1 {
                let requestForSorted = userRequest + "sort:repo"
                updateDataFromServer(request: requestForSorted)
            } else {
                let requestForSorted = userRequest + "sort:joned"
                updateDataFromServer(request: requestForSorted)
            }
        }
    }
    
    @objc func pullToRefresh(sender: UIRefreshControl) {
        if userRequest == "" {
            collectionView.isHidden = true
            noUsersLabel.isHidden = false
        } else {
            updateDataFromServer(request: userRequest)
            noUsersLabel.isHidden = true
        }
        sender.endRefreshing()
    }
    
    @objc func buttonSearchTapped(_ sender: UIButton) {
        //        print("запрос который попадает на кнопку\(userResponce)")
        view.endEditing(true)
        if userRequest == "" {
            showAlert()
        } else {
            collectionView.isHidden = false
            noUsersLabel.isHidden = true
            updateDataFromServer(request: userRequest)
        }
        print("button tapped")
        //        presenter.buttonSearchTapped()
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Attention", message: "Requesr must contain at least one character", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    private func registerForKeyboardNotification() {
        self.registerForKeyboardWillShowNotification(self.collectionView)
        self.registerForKeyboardWillHideNotification(self.collectionView)
    }
}

// MARK: -UserListViewInput
extension UserListViewController: UserListViewInput {
    func success() {
        
    }
    
    func failure(error: Error) {
        
    }
    
    func reloadUI() {
        self.collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDelegate
extension UserListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailUserVC = DetailUserViewController(userName: array[indexPath.row].login)
        
        navigationController?.pushViewController(detailUserVC, animated: true)
    }
}

// MARK: - UICollectionViewDataSource
extension UserListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return array.count
        //        return presenter.numberOfItems()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.reusedId, for: indexPath) as! CollectionViewCell
        cell.layer.cornerRadius = 20
        //        let modelOfIndex = presenter.modelOfIndex(index: indexPath.row)
        //        cell.configure(model: modelOfIndex)
        //        let string = presenter.modelOfIndex(index: indexPath.row).avatar
        //        let image = presenter.getImage(from: string, completion: { (image: UIImage?) in
        //                            cell.avatar.image = image })
        cell.login.text = array[indexPath.row].login
        cell.id.text = String(array[indexPath.row].id)
        let string = array[indexPath.row].avatar
        let image = getImage(from: string, completion: { (image: UIImage?) in
            cell.avatar.image = image })
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension UserListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width - 30, height: 70)
    }
}

// MARK: - TextFieldDelegate
extension UserListViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return false;
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        //        presenter.addData(data: updatedText)
        userRequest = updatedText
        
        return true
    }
}

//MARK: - registerForKeyboardNotification
extension UserListViewController {
    func registerForKeyboardWillShowNotification(_ scrollView: UIScrollView, usingBlock block: ((CGSize?) -> Void)? = nil) {
        _ = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: nil, using: { notification -> Void in
            let userInfo = notification.userInfo!
            let keyboardSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey]! as AnyObject).cgRectValue.size
            self.collectionView.setContentInsetAndScrollIndicatorInsets(UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height + 100, right: 0))
        })
    }
    
    func registerForKeyboardWillHideNotification(_ scrollView: UIScrollView, usingBlock block: ((CGSize?) -> Void)? = nil) {
        _ = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: nil, using: { notification -> Void in
            self.collectionView.setContentInsetAndScrollIndicatorInsets(UIEdgeInsets.zero)
        })
    }
}

extension UIScrollView {
    func setContentInsetAndScrollIndicatorInsets(_ edgeInsets: UIEdgeInsets) {
        self.contentInset = edgeInsets
        self.scrollIndicatorInsets = edgeInsets
    }
}
