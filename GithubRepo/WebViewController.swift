//
//  WebViewController.swift
//  GithubRepo
//
//  Created by Gilang Persada on 14/01/2022.
//

import UIKit
import WebKit

class WebViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    var urlString:String
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = false
        webView.navigationDelegate = self
        startLoading()
        navigationButton()
        let url = URL(string: urlString)!
        let urlRequest = URLRequest(url: url)
        webView.load(urlRequest)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { (dataRecords) in
            print("count: \(dataRecords.count)")
            WKWebsiteDataStore.default().removeData(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes(), for: dataRecords, completionHandler: {})
        }
        
    }
    
    init(url:String){
        self.urlString = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startLoading(){
        loadingIndicator.isHidden = false
        loadingIndicator.startAnimating()
        webView.isHidden = true
    }
    
    func stopLoading(){
        loadingIndicator.stopAnimating()
        loadingIndicator.isHidden = true
        webView.isHidden = false
    }
    
    func navigationButton(){
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backNavPressed))
        let nextButton = UIBarButtonItem(image: UIImage(systemName: "chevron.right"), style: .plain, target: self, action: #selector(nextNavPressed))
        self.navigationItem.leftBarButtonItems = [backButton,nextButton]
    }
    
//    override func loadView() {
//        super.loadView()
//        webView.uiDelegate = self
//    }
    
    func checkCanNavigation(canGoForward:Bool){
        let barButton = self.navigationItem.leftBarButtonItems?.first(where: { (barButtonItem) -> Bool in
            barButtonItem.action == #selector(nextNavPressed(_:))
        })
        if !canGoForward{
            barButton?.isEnabled = false
        } else {
            barButton?.isEnabled = true
        }
    }
    
    @objc func backNavPressed(_ sender:UIBarButtonItem){
        if webView.canGoBack{
            webView.goBack()
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func nextNavPressed(_ sender:UIBarButtonItem){
        if webView.canGoForward{
            webView.goForward()
        } else {
//            sender.isEnabled = false
        }
    }

}

extension WebViewController:WKNavigationDelegate{
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        stopLoading()
        checkCanNavigation(canGoForward: webView.canGoForward)
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        startLoading()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        webView.reload()
    }
    
    
    
}
