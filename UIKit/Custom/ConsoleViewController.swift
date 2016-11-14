//
//  ConsoleViewController.swift
//
//  Created by Andrei Gubceac on 12/3/15.
//  Copyright © 2015. All rights reserved.
//

import UIKit

class ConsoleViewController: ViewController {
    
    override func loadView() {
        let textView = UITextView();
        textView.isEditable = false;
        self.view = textView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Console"
        self.textView.text = self.storage?.rest.logString()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Clear", style: UIBarButtonItemStyle.plain, target: self, action: #selector(ConsoleViewController.clearAction(_:)))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.textView.scrollRangeToVisible(NSMakeRange(self.textView.text.characters.count-1, 0))
    }
    
    var textView : UITextView {
        get {
            return self.view as! UITextView
        }
    }
    
    func clearAction(_ sender : AnyObject?) {
        self.storage?.rest.logClear()
        self.textView.text = nil
    }
    
    func syncCalendarWillStart(_ n : Notification?) {
        self.textView.text.append(NSLocalizedString("Fetching...", comment: "Fetching..."))
    }
    
    func syncCalendarDidFinish(_ n : Notification?) {
        self.textView.text = self.storage?.rest.logString()
        self.textView.scrollRangeToVisible(NSMakeRange(self.textView.text.characters.count-1, 0))
    }
}
