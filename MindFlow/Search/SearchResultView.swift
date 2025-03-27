//
//  SearchResultView.swift
//  MindFlow
//
//  Created by ne on 2025/3/27.
//

import UIKit
import SnapKit

class SearchResultView: UIView {
    
    // MARK: - UI Components
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let titleLabel = UILabel()
    private let resultTextView = UITextView()
    private let sourcesLabel = UILabel()
    private let sourcesList = UIStackView()
    
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
        backgroundColor = theme.background
        
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(resultTextView)
        contentView.addSubview(sourcesLabel)
        contentView.addSubview(sourcesList)
        
        setupConstraints()
        setupContent()
    }
    
    private func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }
        
        resultTextView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }
        
        sourcesLabel.snp.makeConstraints { make in
            make.top.equalTo(resultTextView.snp.bottom).offset(24)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }
        
        sourcesList.snp.makeConstraints { make in
            make.top.equalTo(sourcesLabel.snp.bottom).offset(12)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-24)
        }
    }
    
    private func setupContent() {
        // 标题
        titleLabel.text = "AI Search Results"
        titleLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        titleLabel.textColor = theme.text
        titleLabel.numberOfLines = 0
        
        // 结果文本
        resultTextView.text = "AI search works by combining natural language processing (NLP) with machine learning algorithms to understand user queries and retrieve relevant information. Unlike traditional search engines that match keywords, AI search understands context, intent, and can even interpret ambiguous queries.\n\nModern AI search systems use transformer models like BERT and GPT to process text and understand semantic relationships between words. These models are trained on vast amounts of data to recognize patterns and generate responses that are contextually appropriate."
        resultTextView.font = UIFont.systemFont(ofSize: 16)
        resultTextView.textColor = theme.text
        resultTextView.backgroundColor = .clear
        resultTextView.isEditable = false
        resultTextView.isScrollEnabled = false
        
        // 来源标签
        sourcesLabel.text = "Sources"
        sourcesLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        sourcesLabel.textColor = theme.text
        
        // 来源列表
        sourcesList.axis = .vertical
        sourcesList.spacing = 12
        sourcesList.distribution = .fillProportionally
        
        // 添加示例来源
        let sources = [
            "OpenAI Research Papers",
            "Google AI Blog",
            "MIT Technology Review"
        ]
        
        for source in sources {
            let sourceView = createSourceItem(text: source)
            sourcesList.addArrangedSubview(sourceView)
        }
    }
    
    private func createSourceItem(text: String) -> UIView {
        let sourceView = UIView()
        
        let linkIcon = UIImageView()
        linkIcon.image = UIImage(systemName: "link")
        linkIcon.tintColor = theme.primary
        
        let sourceLabel = UILabel()
        sourceLabel.text = text
        sourceLabel.textColor = theme.primary
        sourceLabel.font = UIFont.systemFont(ofSize: 14)
        
        sourceView.addSubview(linkIcon)
        sourceView.addSubview(sourceLabel)
        
        linkIcon.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.height.equalTo(16)
        }
        
        sourceLabel.snp.makeConstraints { make in
            make.left.equalTo(linkIcon.snp.right).offset(8)
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        // 添加点击效果
        sourceView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(sourceTapped))
        sourceView.addGestureRecognizer(tapGesture)
        
        return sourceView
    }
    
    @objc private func sourceTapped() {
        // 处理来源点击事件
        print("Source tapped")
    }
}