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
            static let bottomInset: CGFloat = 10
            static let spacing: CGFloat = 10
        }
    }
    
    private enum Titles {
        static let navigationBarTitle = "Search users"
        static let textFieldPlaceholder = "Type here..."
        static let buttonSearchTitle = "Search"
        static let noUsersLabelTitle = "No users"
    }
    
    private let presenter: UserListViewOutput
    
    private var textField = UITextField(frame: .zero)
    private var buttonSearch = UIButton(frame: .zero)
    
    private var segmentedControl = UISegmentedControl()
    
    private var noUsersLabel = UILabel(frame: .zero)
    
    private var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
    
    let refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(pullToRefresh(sender:)), for: .valueChanged)
        return refreshControl
    }()
    
    private var userRequest: String = ""
    
    private var page = 2
    private var fetchingMoreUsers = false
    
//      MARK: -Init
    init(presenter: UserListViewOutput) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
//      MARK: -Life circle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.viewWillAppear()
    }
    
//      MARK: -Setup UI
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
        title = Titles.navigationBarTitle
    }
    
    func setupTextField() {
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.borderWidth = 1
        textField.placeholder = Titles.textFieldPlaceholder
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
        buttonSearch.setTitle(Titles.buttonSearchTitle, for: .normal)
        buttonSearch.titleLabel?.font = UIFont.systemFont(ofSize: 24)
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
        noUsersLabel.text = Titles.noUsersLabelTitle
        noUsersLabel.font = UIFont.systemFont(ofSize: 24)
        noUsersLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(noUsersLabel)
    }
    
    func setupCollectionView() {
        collectionView.isHidden = true
        collectionView.register(UserCollectionViewCell.self, forCellWithReuseIdentifier: UserCollectionViewCell.reusedId)
        layout.scrollDirection = .vertical
        collectionView.setCollectionViewLayout(layout, animated: true)
        collectionView.refreshControl = refreshControl
        collectionView.delegate = self
        collectionView.dataSource = self
        layout.minimumLineSpacing = Paddings.CollectionView.spacing
        collectionView.contentInset = UIEdgeInsets(top: Paddings.CollectionView.bottomInset, left: 0, bottom: Paddings.CollectionView.topInset, right: 0)
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.first != nil {
            view.endEditing(true)
        } else {
            super.touchesBegan(touches, with: event)
        }
    }
    
    @objc func selectedValue(target: UISegmentedControl) {
        if presenter.numberOfItems() != 0 {
            if target == self.segmentedControl {
                if target.selectedSegmentIndex == 0 {
                    presenter.segmentControledTapped(text: userRequest, sort: "followers")
                } else if target.selectedSegmentIndex == 1 {
                    presenter.segmentControledTapped(text: userRequest, sort: "repo")
                } else {
                    presenter.segmentControledTapped(text: userRequest, sort: "joned")
                }
            }
        } else {
            return
        }
    }
    
    @objc func pullToRefresh(sender: UIRefreshControl) {
        presenter.buttonSearchTapped(text: userRequest)
        sender.endRefreshing()
    }
    
    @objc func buttonSearchTapped(_ sender: UIButton) {
        view.endEditing(true)
        page = 2
        presenter.buttonSearchTapped(text: userRequest)
        segmentedControl.selectedSegmentIndex = UISegmentedControl.noSegment
    }
    
    private func registerForKeyboardNotification() {
        self.registerForKeyboardWillShowNotification(self.collectionView)
        self.registerForKeyboardWillHideNotification(self.collectionView)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        if collectionView.isHidden == false {
            let currentOffset = scrollView.contentOffset.y
        let maxOffset = scrollView.contentSize.height - scrollView.frame.size.height
        let detailOffset = maxOffset - currentOffset

        if detailOffset <= 0 {
                print("scroll to bottom")
                addMoreUsers()
            }
        }
    }
    
    func addMoreUsers() {
        if (!fetchingMoreUsers) {
            fetchingMoreUsers = true
            presenter.getMoreUsers(text: userRequest, index: page)
            page += 1
            fetchingMoreUsers = false
        }
        
    }
}

// MARK: -UserListViewInput
extension UserListViewController: UserListViewInput {
    
    func reloadUI() {
        self.collectionView.reloadData()
        if presenter.numberOfItems() == 0 {
            collectionView.isHidden = true
            noUsersLabel.isHidden = false
        } else {
            collectionView.isHidden = false
            noUsersLabel.isHidden = true
        }
    }
}

// MARK: - UICollectionViewDelegate
extension UserListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.didSelectRowAt(index: indexPath.row)
    }
}

// MARK: - UICollectionViewDataSource
extension UserListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.numberOfItems()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserCollectionViewCell.reusedId, for: indexPath) as! UserCollectionViewCell
        let modelOfIndex = presenter.modelOfIndex(index: indexPath.row)
        cell.configure(model: modelOfIndex)
        cell.prepareForReuse()
        let _ = presenter.getImage(from: indexPath.row, completion: { (image: UIImage?) in
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
        userRequest = updatedText
        
        return true
    }
}

//      MARK: - registerForKeyboardNotification
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

//      MARK: -ScrollView
extension UIScrollView {
    func setContentInsetAndScrollIndicatorInsets(_ edgeInsets: UIEdgeInsets) {
        self.contentInset = edgeInsets
        self.scrollIndicatorInsets = edgeInsets
    }
}
