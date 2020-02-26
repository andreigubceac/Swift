//
//  ConsoleViewController.swift
//
//  Created by Andrei Gubceac on 12/3/15.
//  Copyright © 2015. All rights reserved.
//

import UIKit
import MessageUI

class ConsoleViewController: UIViewController {
    var toRecipients: [String]?
    
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
        let clearItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(clearAction(_:)))
        var items = [clearItem];
        if MFMailComposeViewController.canSendMail() {
            let shareItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareAction(_:)))
            items.append(shareItem)
        }
        if let count = navigationController?.viewControllers.count, count > 1 {
            navigationItem.rightBarButtonItems = items
        }
        else {
            navigationItem.leftBarButtonItems = items
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
        return view as? UITextView ?? UITextView()
    }
    
    @objc private func clearAction(_ sender : AnyObject?) {
        storage.internSelf.rest.logClear()
        textView.text = nil
    }
    
    @objc private func shareAction(_ sender: UIBarButtonItem) {
        let mailComposer = MFMailComposeViewController()
        mailComposer.mailComposeDelegate = self
        if let toRecipients = toRecipients {
            mailComposer.setToRecipients(toRecipients)
        }
        mailComposer.setSubject("Log - \(Date())")
        mailComposer.setMessageBody(storage.internSelf.rest.logString(), isHTML: false)
        present(mailComposer, animated: true, completion: nil)
    }
    
    func syncCalendarWillStart(_ n : Notification?) {
        textView.text.append(NSLocalizedString("Fetching...", comment: "Fetching..."))
    }
    
    func syncCalendarDidFinish(_ n : Notification?) {
        textView.text = storage.internSelf.rest.logString()
        textView.scrollRangeToVisible(NSMakeRange(textView.text.count-1, 0))
    }
}

extension UIViewController : MFMailComposeViewControllerDelegate {
    
    public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true) {
            if let error = error{
                debugPrint(error)
            }
        }
    }
}

extension UIViewController : MFMessageComposeViewControllerDelegate {
    
    public func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true) {
            if result == .failed {
                debugPrint(result)
            }
        }
    }
}
