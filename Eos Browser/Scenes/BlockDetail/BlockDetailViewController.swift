//
//  BlockDetailViewController.swift
//  Eos Browser
//
//  Created by Angel Betancourt on 26/04/20.
//  Copyright © 2020 EOSIOS. All rights reserved.
//

import UIKit

final class BlockDetailViewController: UIViewController, MVVMView {
    @IBOutlet weak var producerLabel: UILabel!
    @IBOutlet weak var producerSignatureLabel: UILabel!
    @IBOutlet weak var numberOfTransactionsLabel: UILabel!
    @IBOutlet weak var switchJsonVisibilityButton: UIButton!
    @IBOutlet weak var jsonTextView: UITextView!
    
    var viewModel: BlockDetailMVVMViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        viewModel?.sceneDidLoad()
    }
    
    @IBAction func jsonButtonTouchedUp(_ sender: Any) {
        viewModel?.handleSwitchJsonVisibility()
    }
    
    func bind() {
        viewModel?.titleLabel.bind { [weak self] label in
            self?.title = label
        }
        
        viewModel?.producerLabel.bind { [weak self] label in
            self?.producerLabel.text = label
        }
        
        viewModel?.producerSignatureLabel.bind { [weak self] label in
            self?.producerSignatureLabel.text = label
        }
        
        viewModel?.numberOfTransactionsLabel.bind { [weak self] label in
            self?.numberOfTransactionsLabel.text = label
        }
        
        viewModel?.switchJsonVisibilityButtonTitle.bind { [weak self] label in
            self?.switchJsonVisibilityButton.setTitle(label, for: .normal)
        }
        
        viewModel?.jsonText.bind { [weak self] text in
            self?.jsonTextView.text = text
        }
        
        viewModel?.jsonIsVisible.bind { [weak self] isVisible in
            self?.jsonTextView.isHidden = !isVisible
        }
    }
}
