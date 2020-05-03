//
//  BlockListViewController.swift
//  Eos Browser
//
//  Created by Angel Betancourt on 24/04/20.
//  Copyright © 2020 EOSIOS. All rights reserved.
//

import UIKit
import Combine

final class BlockListTableViewDiffableDataSource: UITableViewDiffableDataSource<BlockListViewModel.Section, BlockListViewModel.Item> {
    
}

final class BlockListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    private var diffableDataSource: BlockListTableViewDiffableDataSource?
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshButtonTouchedUp), for: .valueChanged)
        return refreshControl
    }()
    
    private lazy var viewModel = BlockListMVVMViewModel()
    private var subscriptions = [AnyCancellable]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        setupDiffable()
        tableView.refreshControl = refreshControl
        viewModel.sceneDidLoad()
    }
    
    @IBAction func refreshButtonTouchedUp(_ sender: UIBarButtonItem) {
        viewModel.handleRefresh()
    }
}

extension BlockListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.handleSelectedBlock(at: indexPath)
    }
}

private extension BlockListViewController {
    func bind() {
        viewModel.blocks.sink {[weak self] blocks in
            var snapshot = NSDiffableDataSourceSnapshot<BlockListViewModel.Section, BlockListViewModel.Item>()
            snapshot.appendSections(BlockListViewModel.Section.allCases)
            snapshot.appendItems(blocks)
            self?.diffableDataSource?.apply(snapshot,
                                            animatingDifferences: false,
                                            completion: nil)
        }.store(in: &subscriptions)
        
        viewModel.titleLabel.assign(to: \.title, on: self).store(in: &subscriptions)
        
        viewModel.state.sink { [weak self] state in
            guard let self = self else {
                return
            }
            switch state {
            case .refreshing:
                self.refreshControl.beginRefreshing()
            case .idle:
                self.refreshControl.endRefreshing()
            case .showing(let scene):
                self.show(scene: scene)
            }
        }.store(in: &subscriptions)
    }
    
    func setupDiffable() {
        diffableDataSource = .init(tableView: tableView, cellProvider: { (tableView, indexPath, blockListItem) -> UITableViewCell? in
            let tableViewCell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath)
            tableViewCell.textLabel?.text = blockListItem.producer
            tableViewCell.detailTextLabel?.text = blockListItem.id
            return tableViewCell
        })
    }
}


