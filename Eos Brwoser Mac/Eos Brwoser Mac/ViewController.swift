//
//  ViewController.swift
//  Eos Brwoser Mac
//
//  Created by Angel Betancourt on 8/05/20.
//  Copyright © 2020 EOSIOS. All rights reserved.
//

import Cocoa
import EOSIOSDomainMac
class ViewController: NSViewController {

    let viewModel: BlockDetailMVVMViewModel
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    init?(coder: NSCoder, viewModel: BlockDetailMVVMViewModel) {
        self.viewModel = viewModel
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

