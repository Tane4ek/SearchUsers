//
//  TableViewCell.swift
//  Task_search_user
//
//  Created by Татьяна Лузанова on 17.01.2022.
//

import UIKit

class UserCollectionViewCell: UICollectionViewCell {
    
    private enum Layout {
    
        enum Avatar {
            static let positionInset: CGFloat = 10
            static let size: CGFloat = 50
        }
        enum Labels {
            static let leftInset: CGFloat = 30
            static let rightInset: CGFloat = 10
            static let verticalInset: CGFloat = 10
        }
        enum Chevron {
            static let horizontalInset: CGFloat = 10
            static let size: CGFloat = 10
        }
    }

    static let reusedId = "UserCollectionViewCell"
    
    private var containerView = UIView(frame: .zero)
    var avatar = UIImageView(frame: .zero)
    private var id = UILabel(frame: .zero)
    private var login = UILabel()
    private var chevron = UIImageView(frame: .zero)

//    MARK: -Setup
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUIElements()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUIElements() {
        setupContainerView()
        setupAvatar()
        setupLoginLabel()
        setupIdLabel()
        setupChevron()
        setupLayoutUserCell()
    }
    
    func setupContainerView() {
        containerView.layer.borderColor = UIColor.black.cgColor
        containerView.layer.borderWidth = 1
        containerView.layer.cornerRadius = 20
        containerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(containerView)
    }
    
    func setupAvatar() {
        avatar.layer.borderColor = UIColor.black.cgColor
        avatar.layer.borderWidth = 1
        avatar.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(avatar)
    }
    
    func setupLoginLabel() {
        login.font = UIFont.systemFont(ofSize: 24)
        login.tintColor = UIColor.black
        login.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(login)
    }
    
    func setupIdLabel() {
        id.font = UIFont.systemFont(ofSize: 20)
        id.tintColor = UIColor.black
        id.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(id)
    }
    
    func setupChevron() {
        chevron.image = UIImage(named: "chevron")
        chevron.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(chevron)
    }
    
    func setupLayoutUserCell() {
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            avatar.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Layout.Avatar.positionInset),
            avatar.topAnchor.constraint(equalTo: containerView.topAnchor, constant: Layout.Avatar.positionInset),
            avatar.heightAnchor.constraint(equalToConstant: Layout.Avatar.size),
            avatar.widthAnchor.constraint(equalToConstant: Layout.Avatar.size),
            
            login.leadingAnchor.constraint(equalTo: avatar.trailingAnchor, constant: Layout.Labels.leftInset),
            login.topAnchor.constraint(equalTo: containerView.topAnchor, constant: Layout.Labels.verticalInset),
            login.trailingAnchor.constraint(equalTo: chevron.leadingAnchor, constant: -Layout.Labels.rightInset),
            
            id.leadingAnchor.constraint(equalTo: avatar.trailingAnchor, constant: Layout.Labels.leftInset),
            id.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -Layout.Labels.verticalInset),
            id.trailingAnchor.constraint(equalTo: chevron.leadingAnchor, constant: -Layout.Labels.rightInset),
            
            chevron.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            chevron.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -Layout.Chevron.horizontalInset),
            chevron.widthAnchor.constraint(equalToConstant: Layout.Chevron.size)
        ])
    }
    
//    MARK: -Configure
    
    func configure(model: User) {
        login.text = model.login
        id.text = String(model.id)
    }
}
