//
//  PrivacyViewController.swift
//  MyMusicDiary
//
//  Created by 임승섭 on 2023/10/19.
//

import UIKit
import WebKit


class PrivarcyViewController: BaseViewController, WKNavigationDelegate {
    
    var webView = WKWebView()
    
    lazy var activityIndicator = {
        let view = UIActivityIndicatorView()
        view.center = view.center
        view.hidesWhenStopped = true
        view.style = .medium
        view.stopAnimating()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        navigationItem.title = "개인정보 처리방침"
        
        webView.navigationDelegate = self
        
        
        view.addSubview(webView)
        view.addSubview(activityIndicator)
        webView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view)
        }
        activityIndicator.snp.makeConstraints { make in
            make.center.equalTo(view)
        }
        
        
        activityIndicator.startAnimating()
        loadWebView()
    }
    
    
    private func loadWebView() {
        guard let url = URL(string: "https://prairie-drill-e3a.notion.site/MULOG-3971812319844e4d9c5bdbdbdf848b03") else { return }
        let request = URLRequest(url: url)
        self.webView.load(request)
    }
    
    
    // 로드 성공
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
        print("로드 성공")
    }
}
