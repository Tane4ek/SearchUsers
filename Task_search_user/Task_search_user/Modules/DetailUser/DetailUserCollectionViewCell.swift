//
//  DetailUserCollectionViewCell.swift
//  Task_search_user
//
//  Created by Поздняков Игорь Николаевич on 18.01.2022.
//

import UIKit

class DetailUserCollectionViewCell: UICollectionViewCell {
    
    private enum Paddings {
    
        enum Labels {
            static let leftInset: CGFloat = 30
            static let rightInset: CGFloat = 10
            static let verticalInset: CGFloat = 10
        }
    }

    static let reusedId = "CollectionViewCell"
    
    var containerView = UIView(frame: .zero)
    var labelValue = UILabel(frame: .zero)
    var labelData = UILabel(frame: .zero)
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUIElements()
    }
    
    func setupUIElements() {
        setupContainerView()
        setupLabelValue()
        setupLabelData()
        setupLayoutUserCell()
    }
    
    func setupContainerView() {
        containerView.backgroundColor = UIColor.white
//        containerView.layer.borderColor = UIColor.gray.cgColor
//        containerView.layer.borderWidth = 1
//        containerView.layer.shadowColor = UIColor.black.cgColor
//        containerView.layer.cornerRadius = 20
        containerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(containerView)
    }
    
    func setupLabelValue() {
        labelValue.text = "name:"
        labelValue.font = UIFont(name: "Helvetica", size: 24)
        labelValue.tintColor = UIColor.black
        labelValue.numberOfLines = 0
        labelValue.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(labelValue)
    }
    
    func setupLabelData() {
        labelData.text = "Vasya Pupkin"
        labelData.font = UIFont(name: "Helvetica", size: 24)
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
            
            labelData.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Paddings.Labels.leftInset),
            labelData.topAnchor.constraint(equalTo: containerView.topAnchor, constant: Paddings.Labels.verticalInset),
            
            labelValue.leadingAnchor.constraint(equalTo: labelData.trailingAnchor, constant: Paddings.Labels.rightInset),
            labelValue.topAnchor.constraint(equalTo: containerView.topAnchor, constant: Paddings.Labels.verticalInset),
            labelValue.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -Paddings.Labels.leftInset)
            
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
