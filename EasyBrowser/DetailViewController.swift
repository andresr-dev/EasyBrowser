//
//  DetailViewController.swift
//  EasyBrowser
//
//  Created by Andres camilo Raigoza misas on 21/10/22.
//

import UIKit
import WebKit

class DetailViewController: UIViewController, WKNavigationDelegate {
    var webView: WKWebView!
    var website: String?
    
    var progressView: UIProgressView!
        
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        webView.scrollView.contentInsetAdjustmentBehavior = .always
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never

        let back = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: webView, action: #selector(webView.goBack))
        let forward = UIBarButtonItem(image: UIImage(systemName: "chevron.forward"), style: .plain, target: webView, action: #selector(webView.goForward))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
        let progressButton = UIBarButtonItem(customView: progressView)
        
        toolbarItems = [back, spacer, forward, spacer, progressButton, spacer, refresh]
        navigationController?.isToolbarHidden = false
        
        // .new: every new change
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        
        if let website {
            let url = URL(string: "https://" + website)!
            webView.load(URLRequest(url: url))
            webView.allowsBackForwardNavigationGestures = true
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction) async -> WKNavigationActionPolicy {
        let url = navigationAction.request.url
        
        if let urlString = url?.absoluteString {
            if urlString.contains("about:blank") {
                return .allow
            }
            if let website, urlString.contains(website) {
                return .allow
            }
        }
        showBlockAlert()
        return .cancel
    }
    
    func showBlockAlert() {
        let ac = UIAlertController(title: "This website is blocked", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .cancel))
        present(ac, animated: true)
    }

}
