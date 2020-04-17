//
//  PageItemTableViewCell.swift
//  TechnicalTest
//
//  Created by Hai Le Thanh on 4/17/20.
//  Copyright © 2020 Hai Le Thanh. All rights reserved.
//

import UIKit

struct PageItemCellViewModel: BaseViewModel {
    let title: String?
    let description: String?
    let image: Observable<UIImage?>
}

class PageItemTableViewCell: BaseTableViewCell {
    
    private let mainStackView = UIStackView()
    
    private let imageContainer = UIView()
    private let avatarView = UIImageView()
    
    private let textStackView = UIStackView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private var viewModel: PageItemCellViewModel?
    
    override func configureSubviews() {
        super.configureSubviews()
        
        contentView.addSubview(mainStackView)
        
        mainStackView.addArrangedSubview(imageContainer)
        imageContainer.addSubview(avatarView)
        
        mainStackView.addArrangedSubview(textStackView)
        textStackView.addArrangedSubview(titleLabel)
        textStackView.addArrangedSubview(descriptionLabel)
    }
    
    override func configureLayout() {
        super.configureLayout()
        [mainStackView, imageContainer, avatarView,
         textStackView, titleLabel, descriptionLabel].forEach { disableTranslatesAutoResizing($0) }
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
        
        NSLayoutConstraint.activate([
            avatarView.topAnchor.constraint(equalTo: titleLabel.topAnchor),
            avatarView.bottomAnchor.constraint(lessThanOrEqualTo: imageContainer.bottomAnchor, constant: -10),
            avatarView.leadingAnchor.constraint(equalTo: imageContainer.leadingAnchor),
            avatarView.trailingAnchor.constraint(equalTo: imageContainer.trailingAnchor),
            avatarView.widthAnchor.constraint(equalToConstant: 44),
            avatarView.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    override func configureContent() {
        super.configureContent()
        mainStackView.axis = .horizontal
        mainStackView.spacing = 10
        
        textStackView.axis = .vertical
        textStackView.spacing = 8
        titleLabel.numberOfLines = 0
        descriptionLabel.numberOfLines = 0
    }
    
    private func disableTranslatesAutoResizing(_ view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        viewModel?.image.valueChanged = nil
        viewModel = nil
    }
 
    override func configure(with viewModel: BaseViewModel) {
        guard let viewModel = viewModel as? PageItemCellViewModel else { return }
        self.viewModel = viewModel
        titleLabel.text = viewModel.title
        descriptionLabel.text = viewModel.description
        avatarView.image = viewModel.image.value
        
        viewModel.image.valueChanged = { image in
            self.avatarView.image = image
        }
    }
}
