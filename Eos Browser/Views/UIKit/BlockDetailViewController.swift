//
//  BlockDetailViewController.swift
//  Eos Browser
//
//  Created by Angel Betancourt on 26/04/20.
//  Copyright © 2020 EOSIOS. All rights reserved.
//

import UIKit
import Combine

final class BlockDetailViewController: UIViewController, MVVMView {
    @IBOutlet weak var producerLabel: UILabel!
    @IBOutlet weak var producerSignatureLabel: UILabel!
    @IBOutlet weak var numberOfTransactionsLabel: UILabel!
    @IBOutlet weak var switchJsonVisibilityButton: UIButton!
    @IBOutlet weak var jsonTextView: UITextView!
    
    var viewModel: BlockDetailMVVMViewModel?
    private var subscriptions = [AnyCancellable]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        viewModel?.sceneDidLoad()
    }
    
    @IBAction func jsonButtonTouchedUp(_ sender: Any) {
        viewModel?.handleSwitchJsonVisibility()
    }
    
    func bind() {
        viewModel?.titleLabel.sink { [weak self] label in
            self?.title = label
        }.store(in: &subscriptions)
        
        viewModel?.producerLabel.sink { [weak self] label in
            self?.producerLabel.text = label
        }.store(in: &subscriptions)
        
        viewModel?.producerSignatureLabel.sink { [weak self] label in
            self?.producerSignatureLabel.text = label
        }.store(in: &subscriptions)
        
        viewModel?.numberOfTransactionsLabel.sink { [weak self] label in
            self?.numberOfTransactionsLabel.text = label
        }.store(in: &subscriptions)
        
        viewModel?.switchJsonVisibilityButtonTitle.sink { [weak self] label in
            self?.switchJsonVisibilityButton.setTitle(label, for: .normal)
        }.store(in: &subscriptions)
        
        viewModel?.jsonText.sink { [weak self] text in
            self?.jsonTextView.text = text
        }.store(in: &subscriptions)
        
        viewModel?.jsonIsVisible.sink { [weak self] isVisible in
            self?.jsonTextView.isHidden = !isVisible
        }.store(in: &subscriptions)
    }
}
