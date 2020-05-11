//
//  AppDelegate.swift
//  Eos Brwoser Mac
//
//  Created by Angel Betancourt on 8/05/20.
//  Copyright © 2020 EOSIOS. All rights reserved.
//

import Cocoa
import EOSIOSDomainMac

extension NSStoryboard {
    static let main = NSStoryboard.init(name: "Main", bundle: .main)
}

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}

