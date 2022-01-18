//
//  TableViewCell.swift
//  Task_search_user
//
//  Created by Татьяна Лузанова on 17.01.2022.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    private enum Paddings {
    
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

    static let reusedId = "CollectionViewCell"
    
    var containerView = UIView(frame: .zero)
    var avatar = UIImageView(frame: .zero)
    var id = UILabel(frame: .zero)
    var login = UILabel()
    var chevron = UIImageView(frame: .zero)

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUIElements()
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
        containerView.backgroundColor = UIColor.white
        containerView.layer.borderColor = UIColor.gray.cgColor
        containerView.layer.borderWidth = 1
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.5
        containerView.layer.shadowOffset = CGSize.zero
        containerView.layer.shadowRadius = 5
        containerView.layer.cornerRadius = 20
        containerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(containerView)
    }
    
    func setupAvatar() {
        avatar.image = UIImage(named: "Placeholder")
        //        rocketImage.image = SearchResponse.image ? user.image : UIImage(named: "Placeholder")
        avatar.backgroundColor = UIColor.blue
        avatar.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(avatar)
    }
    
    func setupLoginLabel() {
        login.text = "Login"
        login.font = UIFont(name: "Helvetica", size: 24)
        login.tintColor = UIColor.black
        login.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(login)
    }
    
    func setupIdLabel() {
        id.text = "ID"
        id.font = UIFont(name: "Helvetica", size: 20)
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
            
            avatar.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Paddings.Avatar.positionInset),
            avatar.topAnchor.constraint(equalTo: containerView.topAnchor, constant: Paddings.Avatar.positionInset),
            avatar.heightAnchor.constraint(equalToConstant: Paddings.Avatar.size),
            avatar.widthAnchor.constraint(equalToConstant: Paddings.Avatar.size),
            
            login.leadingAnchor.constraint(equalTo: avatar.trailingAnchor, constant: Paddings.Labels.leftInset),
            login.topAnchor.constraint(equalTo: containerView.topAnchor, constant: Paddings.Labels.verticalInset),
            login.trailingAnchor.constraint(equalTo: chevron.leadingAnchor, constant: -Paddings.Labels.rightInset),
            
            id.leadingAnchor.constraint(equalTo: avatar.trailingAnchor, constant: Paddings.Labels.leftInset),
            id.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -Paddings.Labels.verticalInset),
            id.trailingAnchor.constraint(equalTo: chevron.leadingAnchor, constant: -Paddings.Labels.rightInset),
            
            chevron.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            chevron.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -Paddings.Chevron.horizontalInset),
            chevron.widthAnchor.constraint(equalToConstant: Paddings.Chevron.size)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
