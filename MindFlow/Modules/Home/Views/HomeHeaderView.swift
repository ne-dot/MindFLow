//
//  HomeHeaderView.swift
//  MindFlow
//
//  Created by ne on 2025/3/27.
//

import UIKit
import SnapKit

class HomeHeaderView: UIView {
    
    // MARK: - UI Components
    private let searchContainer = UIView()
    private let searchIcon = UIImageView()
    private let searchLabel = UILabel()  
    private let micButton = UIButton(type: .system)
    
    // MARK: - Properties
    var onSearchTextChanged: ((String) -> Void)?
    var onMicButtonTapped: (() -> Void)?
    var onSearchTap: (() -> Void)?  // Add this property
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        backgroundColor = theme.backgroundColor
        layer.shadowColor = theme.borderColor.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 2
        
        addSubview(searchContainer)
        searchContainer.addSubview(searchIcon)
        searchContainer.addSubview(searchLabel)
        searchContainer.addSubview(micButton)
        
        setupSearchContainer()
        setupConstraints()
        setupActions()
    }
    
    private func setupSearchContainer() {
        // 搜索容器样式
        searchContainer.backgroundColor = theme.searchBackgroundColor
        searchContainer.layer.cornerRadius = 25
        
        // 搜索图标样式
        searchIcon.image = UIImage(systemName: "magnifyingglass")
        searchIcon.tintColor = theme.primaryColor
        
        // 搜索标签样式
        searchLabel.text = "search_placeholder".localized
        searchLabel.textColor = theme.searchPlaceholderColor
        searchLabel.font = UIFont.systemFont(ofSize: 14)
        
        // 麦克风按钮样式
        micButton.setImage(UIImage(systemName: "mic"), for: .normal)
        micButton.tintColor = theme.primaryColor
    }
    
    private func setupConstraints() {
        // 搜索容器约束
        searchContainer.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.height.equalTo(50)
        }
        
        // 搜索图标约束
        searchIcon.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(20)
        }
        
        // 麦克风按钮约束
        micButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(32)
        }
        
        // 搜索标签约束
        searchLabel.snp.makeConstraints { make in
            make.left.equalTo(searchIcon.snp.right).offset(8)
            make.right.equalTo(micButton.snp.left).offset(-8)
            make.centerY.equalToSuperview()
        }
    }
    
    private func setupActions() {
        // 移除文本字段相关的动作
        micButton.addTarget(self, action: #selector(micButtonTapped), for: .touchUpInside)
        
        // 添加搜索容器点击手势
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(searchContainerTapped))
        searchContainer.addGestureRecognizer(tapGesture)
        searchContainer.isUserInteractionEnabled = true
    }
    
    // MARK: - Actions
    // 移除 textFieldDidChange 方法
    
    @objc private func micButtonTapped() {
        onMicButtonTapped?()
    }
    
    @objc private func searchContainerTapped() {
        onSearchTap?()
    }
    
    // MARK: - Public Methods
    func getSearchText() -> String {
        return searchLabel.text ?? ""
    }
    
    func setSearchText(_ text: String) {
        searchLabel.text = text
        // 如果设置了实际搜索文本，更改颜色为正常文本颜色
        if text != "search_placeholder".localized {
            searchLabel.textColor = theme.textColor
        } else {
            searchLabel.textColor = theme.searchPlaceholderColor
        }
    }
}
