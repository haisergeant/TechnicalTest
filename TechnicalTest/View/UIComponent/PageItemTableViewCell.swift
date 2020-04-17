//
//  PageItemTableViewCell.swift
//  TechnicalTest
//
//  Created by Hai Le Thanh on 4/17/20.
//  Copyright © 2020 Hai Le Thanh. All rights reserved.
//

import UIKit

struct PageItemCellViewModel: BaseViewModel {
    let title: String
    let description: String
}

class PageItemTableViewCell: BaseTableViewCell {
    
    private let avatarView = UIImageView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    
    
    override func configureSubviews() {
        super.configureSubviews()
                
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
    }
    
    override func configureLayout() {
        super.configureLayout()
        
    }
 
    override func configure(with viewModel: BaseViewModel) {
        guard let viewModel = viewModel as? PageItemCellViewModel else { return }
        titleLabel.text = viewModel.title
        descriptionLabel.text = viewModel.description
    }
}
