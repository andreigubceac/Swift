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
        title = "Console"
        textView.text = storage.internSelf.rest.logString()
        let clearItem = UIBarButtonItem(title: "Clear", style: UIBarButtonItemStyle.plain, target: self, action: #selector(clearAction(_:)))
        if let count = navigationController?.viewControllers.count, count > 1 {
            navigationItem.rightBarButtonItem = clearItem
        }
        else {
            navigationItem.leftBarButtonItem = clearItem
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textView.scrollRangeToVisible(NSMakeRange(textView.text.count-1, 0))
    }
    
    var textView : UITextView {
        return view as! UITextView
    }
    
    @objc func clearAction(_ sender : AnyObject?) {
        storage.internSelf.rest.logClear()
        textView.text = nil
    }
    
    func syncCalendarWillStart(_ n : Notification?) {
        textView.text.append(NSLocalizedString("Fetching...", comment: "Fetching..."))
    }
    
    func syncCalendarDidFinish(_ n : Notification?) {
        textView.text = storage.internSelf.rest.logString()
        textView.scrollRangeToVisible(NSMakeRange(textView.text.count-1, 0))
    }
}
