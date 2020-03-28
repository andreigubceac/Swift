//
//  WebViewController.swift
//
//  Created by Andrei Gubceac.
//  Copyright © 2016. All rights reserved.
//

import WebKit

class WebViewController: UIViewController {
    var webView : WKWebView {
        return view as? WKWebView ?? WKWebView()
    }
    
    var url : URL? {
        didSet {
            guard let url = url else { return }
            webView.load(URLRequest(url: url))
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
        view = WKWebView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
    }
}
