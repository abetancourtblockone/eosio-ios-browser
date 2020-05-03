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
        viewModel?.titleLabel.assign(to: \.title, on: self).store(in: &subscriptions)
        viewModel?.producerLabel.assign(to: \.text, on: producerLabel).store(in: &subscriptions)
        viewModel?.producerSignatureLabel.assign(to: \.text, on: producerSignatureLabel).store(in: &subscriptions)
        viewModel?.numberOfTransactionsLabel.assign(to: \.text, on: numberOfTransactionsLabel).store(in: &subscriptions)
        viewModel?.jsonText.assign(to: \.text, on: jsonTextView).store(in: &subscriptions)
        viewModel?.jsonIsHidden.assign(to: \.isHidden, on: jsonTextView).store(in: &subscriptions)
        
        viewModel?.switchJsonVisibilityButtonTitle.sink { [weak self] label in
            self?.switchJsonVisibilityButton.setTitle(label, for: .normal)
        }.store(in: &subscriptions)
    }
}
