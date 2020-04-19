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
        tableView.estimatedRowHeight = 120
        tableView.rowHeight = UITableView.automaticDimension
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(reloadView), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
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
    
    override func configureContents() {
        super.configureContents()
        showLoadinng()
        viewModel.requestData()
    }
}

private extension PageDataViewController {
    @objc func reloadView() {
        viewModel.requestData()
    }
}

extension PageDataViewController: PageDataViewProtocol {
    func configure(with viewModel: PageDataViewModelProtocol) {
        title = viewModel.pageTitle()
        hideLoadingAndRefreshControl()
        tableView.reloadData()
    }
    
    func handleError(_ error: Error) {
        hideLoadingAndRefreshControl()
        showError(error)
    }
    
    private func hideLoadingAndRefreshControl() {
        hideLoading()
        tableView.refreshControl?.endRefreshing()
    }
}

extension PageDataViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PageItemTableViewCell = tableView.dequeueReuseableCell(indexPath: indexPath)
        cell.configure(with: viewModel.cellViewModel(at: indexPath.row))
        viewModel.requestDataForCellIfNeeded(at: indexPath.row)
        return cell
    }
}

extension PageDataViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        viewModel.stopRequestDataForCell(at: indexPath.row)
    }
}

