//
//  WebViewController.swift
//
//  Created by Andrei Gubceac.
//  Copyright © 2016. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {
    var webView : UIWebView {
        get {
            return self.view as! UIWebView
        }
    }
    
    var url : URL? {
        didSet {
            if url != nil {
                self.webView.loadRequest(URLRequest(url: url!))
            }
        }
    }
    
    init(url : URL? = nil) {
        super.init(nibName: nil, bundle: nil)
        defer {
            self.url = url
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        let webView = UIWebView(frame: UIScreen.main.bounds)
        webView.scrollView.showsVerticalScrollIndicator = false
        webView.scrollView.showsHorizontalScrollIndicator = false
        webView.backgroundColor = UIColor.clear
        webView.isOpaque = true
        self.view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
    }
}
