//
//  TrailerViewController.swift
//  MovieTranslator
//
//  Created by Никита on 23.02.2018.
//  Copyright © 2018 Никита. All rights reserved.
//

import Foundation
import UIKit
import WebKit

class TrailerViewController : UIViewController , NSURLConnectionDataDelegate, WKNavigationDelegate {
    
    @IBOutlet weak var wkWebView: WKWebView!
    var videoKey : String?
    
    override func viewDidLoad() {
        showLoading()
        initialSetup(key: videoKey)
    }
    
    //MARK: - WKNavigationDelegate
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        hideLoading()
    }
    
    //MARK: - Private
    private func initialSetup(key : String?) {
        wkWebView = WKWebView()
        wkWebView.navigationDelegate = self
        view = wkWebView
        
        
        

        let url = URL(string: String(format:"\(youtoubeURLPrefix)%@", key!))!
        wkWebView.load(URLRequest(url: url))
    }
    
}

