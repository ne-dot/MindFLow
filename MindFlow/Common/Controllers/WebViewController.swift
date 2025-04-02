//
//  WebViewController.swift
//  MindFlow
//
//  Created by ne on 2025/3/27.
//

import UIKit
import WebKit
import SnapKit

class WebViewController: UIViewController {
    
    // MARK: - UI Components
    private lazy var webView: WKWebView = {
        let preferences = WKWebpagePreferences()
        preferences.allowsContentJavaScript = true
        
        let configuration = WKWebViewConfiguration()
        configuration.defaultWebpagePreferences = preferences
        
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        return webView
    }()
    
    private lazy var progressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.progressTintColor = UIColor(red: 0.31, green: 0.27, blue: 0.9, alpha: 1.0)
        return progressView
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        indicator.color = .gray
        return indicator
    }()
    
    // MARK: - Properties
    private let url: URL
    private var progressObservation: NSKeyValueObservation?
    
    // MARK: - Initialization
    init(url: URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: false)
        setupUI()
        setupNavigationBar()
        setupObservers()
        loadWebContent()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        progressObservation?.invalidate()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = theme.backgroundColor
        
        // 添加WebView
        view.addSubview(webView)
        webView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        // 添加进度条
        view.addSubview(progressView)
        progressView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
            make.height.equalTo(2)
        }
        
        // 添加加载指示器
        view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "网页浏览"
        
        // 添加刷新按钮
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshWebView))
        
        // 添加分享按钮
        let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareWebPage))
        
        navigationItem.rightBarButtonItems = [shareButton, refreshButton]
    }
    
    private func setupObservers() {
        // 监听进度变化
        progressObservation = webView.observe(\.estimatedProgress, options: [.new]) { [weak self] webView, change in
            guard let self = self, let newValue = change.newValue else { return }
            self.progressView.progress = Float(newValue)
            self.progressView.isHidden = newValue == 1
        }
    }
    
    private func loadWebContent() {
        let request = URLRequest(url: url)
        webView.load(request)
        activityIndicator.startAnimating()
    }
    
    // MARK: - Actions
    @objc private func refreshWebView() {
        webView.reload()
    }
    
    @objc private func shareWebPage() {
        guard let url = webView.url else { return }
        
        let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        present(activityVC, animated: true)
    }
}

// MARK: - WKNavigationDelegate
extension WebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
        navigationItem.title = webView.title
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        activityIndicator.stopAnimating()
        showErrorAlert(message: error.localizedDescription)
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        activityIndicator.stopAnimating()
        showErrorAlert(message: error.localizedDescription)
    }
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(
            title: "加载失败",
            message: message,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "确定", style: .default))
        present(alert, animated: true)
    }
}
