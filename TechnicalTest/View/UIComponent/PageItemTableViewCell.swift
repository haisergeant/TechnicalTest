//
//  PageItemTableViewCell.swift
//  TechnicalTest
//
//  Created by Hai Le Thanh on 4/17/20.
//  Copyright © 2020 Hai Le Thanh. All rights reserved.
//

import UIKit

enum ImageState: Equatable {
    case loading
    case fail
    case loadedImage(image: UIImage)
}

struct PageItemCellViewModel: BaseViewModel {
    let title: String?
    let description: String?
    let image: Observable<ImageState>
}

class PageItemTableViewCell: BaseTableViewCell {
    
    private let mainStackView = UIStackView()
    
    private let imageContainer = UIView()
    private let loadingIndicator = UIActivityIndicatorView(style: .gray)
    private let avatarView = UIImageView()
    
    private let textContainer = UIView()
    private let textStackView = UIStackView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private var viewModel: PageItemCellViewModel?
    
    override func configureSubviews() {
        super.configureSubviews()
        
        contentView.addSubview(mainStackView)
        
        mainStackView.addArrangedSubview(imageContainer)
        imageContainer.addSubview(avatarView)
        imageContainer.addSubview(loadingIndicator)
        
        mainStackView.addArrangedSubview(textContainer)
        textContainer.addSubview(textStackView)
        textStackView.addArrangedSubview(titleLabel)
        textStackView.addArrangedSubview(descriptionLabel)
    }
    
    override func configureLayout() {
        super.configureLayout()
        [mainStackView, imageContainer, avatarView, textContainer, loadingIndicator,
         textStackView, titleLabel, descriptionLabel].forEach { disableTranslatesAutoResizing($0) }
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
        
        NSLayoutConstraint.activate([
            avatarView.topAnchor.constraint(equalTo: imageContainer.topAnchor),
            avatarView.bottomAnchor.constraint(lessThanOrEqualTo: imageContainer.bottomAnchor, constant: 0),
            avatarView.leadingAnchor.constraint(equalTo: imageContainer.leadingAnchor),
            avatarView.trailingAnchor.constraint(equalTo: imageContainer.trailingAnchor),
            avatarView.widthAnchor.constraint(equalToConstant: 44),
            avatarView.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: avatarView.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(lessThanOrEqualTo: avatarView.centerYAnchor),
        ])
        
        NSLayoutConstraint.activate([
            textStackView.topAnchor.constraint(equalTo: textContainer.topAnchor),
            textStackView.bottomAnchor.constraint(lessThanOrEqualTo: textContainer.bottomAnchor, constant: 0),
            textStackView.leadingAnchor.constraint(equalTo: textContainer.leadingAnchor),
            textStackView.trailingAnchor.constraint(equalTo: textContainer.trailingAnchor),
        ])
        textStackView.setContentCompressionResistancePriority(.required, for: .vertical)
    }
    
    override func configureContent() {
        super.configureContent()
        mainStackView.axis = .horizontal
        mainStackView.spacing = 10
        
        textStackView.axis = .vertical
        textStackView.spacing = 8
        
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        titleLabel.textColor = .brown
        
        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        descriptionLabel.textColor = .lightGray
        
        avatarView.contentMode = .scaleAspectFit
        avatarView.layer.cornerRadius = 5
        avatarView.clipsToBounds = true
        loadingIndicator.hidesWhenStopped = true
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
        configureImage(with: viewModel.image.value)
        
        viewModel.image.valueChanged = { [weak self] state in
            self?.configureImage(with: state)
        }
    }
    
    private func configureImage(with state: ImageState) {
        switch state {
        case .loading:
            self.loadingIndicator.startAnimating()
            self.avatarView.image = nil
        case .fail:
            self.loadingIndicator.stopAnimating()
            self.avatarView.image = nil
        case .loadedImage(let image):
            self.loadingIndicator.stopAnimating()
            self.avatarView.image = image
        }
    }
}
