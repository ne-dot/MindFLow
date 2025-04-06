//
//  HomeViewController.swift
//  MindFlow
//
//  Created by ne on 2025/3/27.
//

import UIKit
import SnapKit

class HomeViewController: UIViewController {
    
    // MARK: - UI Components
    private let headerView = HomeHeaderView()
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let welcomeView = WelcomeView()
    private let tipView = TipView(iconName: "lightbulb", text: "search_hint".localized)
    private lazy var suggestionsStackView: SuggestionsStackView = {
        let view = SuggestionsStackView()
        view.delegate = self
        return view
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = theme.backgroundColor
        navigationController?.setNavigationBarHidden(true, animated: false)
        setupUI()
        setupActions()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        // 添加所有子视图
        addAllSubviews()
        
        // 设置所有约束
        setupAllConstraints()
        
    }
    
    private func addAllSubviews() {
        view.addSubview(headerView)
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(welcomeView)
        contentView.addSubview(suggestionsStackView)
        contentView.addSubview(tipView)
    }
    
    private func setupAllConstraints() {
        // 头部视图约束
        headerView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right)
            make.height.equalTo(80)
        }
        
        // 滚动视图约束
        scrollView.showsVerticalScrollIndicator = false
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(view.safeAreaLayoutGuide.snp.width)
        }
        
        // 欢迎视图约束
        welcomeView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.left.right.equalToSuperview()
        }
        
        // 建议栏约束
        suggestionsStackView.snp.makeConstraints { make in
            make.top.equalTo(welcomeView.snp.bottom).offset(32)
            make.left.right.equalToSuperview().inset(16)
        }
        
        // 提示视图约束
        tipView.snp.makeConstraints { make in
            make.top.equalTo(suggestionsStackView.snp.bottom).offset(32)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-80)
            make.height.equalTo(60)
        }
    }
    
    // 在setupActions方法中添加搜索框点击事件
    private func setupActions() {
        headerView.onSearchTextChanged = { [weak self] text in
            self?.handleSearchTextChanged(text)
        }
        
        headerView.onMicButtonTapped = { [weak self] in
            self?.handleMicButtonTapped()
        }
        
        // 添加搜索框点击事件
        headerView.onSearchTap = { [weak self] in
            self?.showSearchScreen()
        }
    }
    
    // 添加显示搜索页面的方法
    // 修改显示搜索页面的方法，添加渐入渐出动画
    private func showSearchScreen(query: String? = nil) {
        let searchVC = SearchViewController()
        if let q = query {
            searchVC.searchTextField.text = q
            searchVC.performSearch(query: q)
        }
        
        
        searchVC.configure(with: [
            "suggestion_ai_search".localized,
            "suggestion_productivity".localized,
            "suggestion_remote_work".localized
        ])
        
        let searchNav = UINavigationController(rootViewController: searchVC)
        searchNav.modalPresentationStyle = .overFullScreen
        searchNav.modalTransitionStyle = .crossDissolve
        searchNav.view.alpha = 0
        
        searchVC.onClose = { [weak self] in
            // 关闭时的渐出动画
            UIView.animate(withDuration: 0.25, animations: {
                searchNav.view.alpha = 0
            }, completion: { _ in
                self?.dismiss(animated: false)
            })
        }
        
        present(searchNav, animated: false) {
            // 呈现后的渐入动画
            UIView.animate(withDuration: 0.3) {
                searchNav.view.alpha = 1
            }
        }
    }
    
    // MARK: - Actions
    private func handleSearchTextChanged(_ text: String) {
        print("\("search_text_changed".localized)\(text)")
        // 处理搜索文本变化
    }
    
    private func handleMicButtonTapped() {
        print("mic_button_tapped".localized)
        // 处理麦克风按钮点击
    }
}

extension HomeViewController: SuggestionsStackViewDelegate {
    func suggestionsStackView(_ stackView: SuggestionsStackView, didSelectSuggestion suggestion: String) {
        // 处理建议选择，比如跳转到搜索页面
        showSearchScreen(query: suggestion)
    }
}
