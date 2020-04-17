//
//  PageDataViewController.swift
//  TechnicalTest
//
//  Created by Hai Le Thanh on 4/17/20.
//  Copyright © 2020 Hai Le Thanh. All rights reserved.
//

import UIKit

protocol PageDataViewProtocol: class {
    func configure(with viewModel: PageDataViewModelProtocol)
    func handleError(_ error: Error)
}

class PageDataViewController: BaseViewController {
    private let tableView = UITableView()
    private let viewModel: PageDataViewModelProtocol
    
    init(viewModel: PageDataViewModelProtocol) {
        self.viewModel = viewModel
        super.init()
        viewModel.bind(to: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureSubviews() {
        super.configureSubviews()
        
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.register(PageItemTableViewCell.self)
    }
    
    override func configureLayout() {
        super.configureLayout()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension PageDataViewController: PageDataViewProtocol {
    func configure(with viewModel: PageDataViewModelProtocol) {
        tableView.reloadData()
    }
    
    func handleError(_ error: Error) {
        
    }
}

extension PageDataViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PageItemTableViewCell = tableView.dequeueReuseableCell(indexPath: indexPath)
        cell.configure(with: viewModel.cellViewModel(at: indexPath.row))
        return cell
    }
}

