//
//  DetailUserImageCollectionViewCell.swift
//  Task_search_user
//
//  Created by Татьяна Лузанова on 18.01.2022.
//

import UIKit

class DetailUserImageCollectionViewCell: UICollectionViewCell {
    
    private enum Layout {
    
        enum Avatar {
            static let size: CGFloat = 200
        }
    }

    static let reusedId = "DetailUserImageCollectionViewCell"
    
    var containerView = UIView(frame: .zero)
    var avatar = UIImageView(frame: .zero)

//      MARK: -Setup 
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
        setupLayoutUserCell()
    }
    
    func setupContainerView() {
        containerView.backgroundColor = UIColor.white
        containerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(containerView)
    }
    
    func setupAvatar() {
        avatar.layer.borderColor = UIColor.black.cgColor
        avatar.layer.borderWidth = 1
        avatar.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(avatar)
    }
    
    func setupLayoutUserCell() {
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            avatar.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            avatar.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            avatar.heightAnchor.constraint(equalToConstant: Layout.Avatar.size),
            avatar.widthAnchor.constraint(equalToConstant: Layout.Avatar.size)
            
        ])
    }
}
