//
//  DetailUserCollectionViewCell.swift
//  Task_search_user
//
//  Created by Татьяна Лузанова on 18.01.2022.
//

import UIKit

class DetailUserCollectionViewCell: UICollectionViewCell {
    
    private enum Layout {
        enum Labels {
            static let leftInset: CGFloat = 30
            static let rightInset: CGFloat = 10
            static let verticalInset: CGFloat = 10
            static let size: CGFloat = 130
        }
    }

    static let reusedId = "DetailUserCollectionViewCell"
    
    var containerView = UIView(frame: .zero)
    var labelValue = UILabel(frame: .zero)
    var labelData = UILabel(frame: .zero)
  
//       MARK: -Setup UI
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUIElements()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUIElements() {
        setupContainerView()
        setupLabelValue()
        setupLabelData()
        setupLayoutUserCell()
    }
    
    func setupContainerView() {
        containerView.backgroundColor = UIColor.white
        containerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(containerView)
    }
    
    func setupLabelValue() {
        labelValue.font = UIFont.systemFont(ofSize: 24)
        labelValue.tintColor = UIColor.black
        labelValue.numberOfLines = 0
        labelValue.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(labelValue)
    }
    
    func setupLabelData() {
        labelData.font = UIFont.systemFont(ofSize: 24)
        labelData.tintColor = UIColor.black
        labelData.textAlignment = .left
        labelData.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(labelData)
    }
    
    func setupLayoutUserCell() {
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            labelData.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Layout.Labels.leftInset),
            labelData.topAnchor.constraint(equalTo: containerView.topAnchor, constant: Layout.Labels.verticalInset),
            labelData.widthAnchor.constraint(equalToConstant: Layout.Labels.size),
            
            labelValue.leadingAnchor.constraint(equalTo: labelData.trailingAnchor, constant: Layout.Labels.rightInset),
            labelValue.topAnchor.constraint(equalTo: containerView.topAnchor, constant: Layout.Labels.verticalInset),
            labelValue.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -Layout.Labels.leftInset)
            
        ])
    }    
}
