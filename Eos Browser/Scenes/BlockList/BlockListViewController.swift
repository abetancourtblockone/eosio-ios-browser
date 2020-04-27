//
//  BlockListViewController.swift
//  Eos Browser
//
//  Created by Angel Betancourt on 24/04/20.
//  Copyright © 2020 EOSIOS. All rights reserved.
//

import UIKit

final class BlockListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshButtonTouchedUp), for: .valueChanged)
        return refreshControl
    }()
    
    private lazy var viewModel = BlockListMVVMViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        tableView.refreshControl = refreshControl
        viewModel.sceneDidLoad()
    }
    
    @IBAction func refreshButtonTouchedUp(_ sender: UIBarButtonItem) {
        viewModel.handleRefresh()
    }
}

extension BlockListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.blocks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableViewCell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell")
        
        let block = viewModel.blocks[indexPath.row]
        tableViewCell?.textLabel?.text = block.producer
        tableViewCell?.detailTextLabel?.text = block.id
        return tableViewCell ?? UITableViewCell()
    }
}

extension BlockListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.handleSelectedBlock(at: indexPath)
    }
}

private extension BlockListViewController {
    func bind() {
        viewModel.blocks.observe { [weak self] blocks in
            self?.tableView.reloadData()
        }
        
        viewModel.titleLabel.observe { [weak self] title in
            self?.title = title
        }
        
        viewModel.state.observe { [weak self] state in
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
        }
    }
}


