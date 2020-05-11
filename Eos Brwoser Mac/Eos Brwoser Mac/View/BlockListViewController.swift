//
//  BlockListViewController.swift
//  Eos Brwoser Mac
//
//  Created by Angel Betancourt on 9/05/20.
//  Copyright © 2020 EOSIOS. All rights reserved.
//

import Cocoa
import Combine
import EOSIOSDomainMac

@available(OSX 10.15.1, *)
final class BlockListTableViewDiffableDataSource: NSCollectionViewDiffableDataSource<BlockListViewModel.Section, BlockListViewModel.Item> {
    
}

final class BlockListViewController: NSViewController {
    
    @IBOutlet weak var tableView: NSTableView!
//    private diffable: BlockListTableViewDiffableDataSource?
    
    lazy var viewModel: BlockListMVVMViewModel = .init(configuration: (),
                                                         dependencies: self.blockListSceneDependencies)
    
    private lazy var stringsProvider = StringsProvider()
    private lazy var restBlocksService = RestBlocksService()
    private lazy var retrieveBlocks: RetrieveBlocksAdapter = .init(dependencies: .init(blocksService: restBlocksService))
    private lazy var blockListSceneDependencies: BlockListScene.ViewModel.Dependencies = .init(stringsProvider: stringsProvider,
                                                                                               retrieveBlocks: retrieveBlocks)
    private var subscriptions = [AnyCancellable]()
    private var blocks = [BlockListViewModel.Item]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        bind()
        viewModel.handleRefresh()
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

//    init?(coder: NSCoder, viewModel: BlockListMVVMViewModel) {
//        self.viewModel = viewModel
//        super.init(coder: coder)
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
}
extension BlockListViewController: NSTableViewDelegate {
    
}

extension BlockListViewController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        blocks.count
    }
//    func tableView(_ tableView: NSTableView, rowViewForRow row: Int) -> NSTableRowView? {
//        .init()
//    }
    func tableView(_ tableView: NSTableView, dataCellFor tableColumn: NSTableColumn?, row: Int) -> NSCell? {
        let block = blocks[row]
        return .init(textCell: block.producer)
    }
    
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        blocks[row].producer
    }
}

private extension BlockListViewController {
    func bind() {
        
        tableView.dataSource = self
        tableView.delegate = self
        
        viewModel.blocks.sink {[weak self] blocks in
            self?.blocks = blocks
            self?.tableView.reloadData()
        }.store(in: &subscriptions)
        
        viewModel.titleLabel.assign(to: \.title, on: self).store(in: &subscriptions)
        
        
        viewModel.state.sink { [weak self] state in
            //        guard let self = self else {
            //            return
            //        }
            switch state {
            case .refreshing:
                print("refreshing")
            case .idle:
                print("idle")
            }
        }.store(in: &subscriptions)
    }
}
