//
//  PlaceholderTextView.swift
//  MindFlow
//
//  Created by ne on 2025/3/28.
//

import UIKit

class PlaceholderTextView: UITextView {
    
    // MARK: - Properties
    private let placeholderLabel = UILabel()
    
    var placeholder: String = "" {
        didSet {
            placeholderLabel.text = placeholder
            setNeedsLayout()
        }
    }
    
    var placeholderColor: UIColor = .lightGray {
        didSet {
            placeholderLabel.textColor = placeholderColor
        }
    }
    
    // MARK: - Initialization
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setupPlaceholder()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupPlaceholder()
    }
    
    // MARK: - Setup
    private func setupPlaceholder() {
        // 配置占位符标签
        placeholderLabel.font = font
        placeholderLabel.textColor = placeholderColor
        placeholderLabel.numberOfLines = 0
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // 添加到视图层次结构
        addSubview(placeholderLabel)
        
        // 设置约束
        placeholderLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: textContainerInset.left + 5).isActive = true
        placeholderLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -textContainerInset.right).isActive = true
        placeholderLabel.topAnchor.constraint(equalTo: topAnchor, constant: textContainerInset.top).isActive = true
        
        // 添加通知监听文本变化
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange), name: UITextView.textDidChangeNotification, object: self)
    }
    
    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        updatePlaceholderVisibility()
    }
    
    // MARK: - Text Change Handling
    @objc private func textDidChange() {
        updatePlaceholderVisibility()
    }
    
    private func updatePlaceholderVisibility() {
        placeholderLabel.isHidden = !text.isEmpty
    }
    
    // MARK: - Cleanup
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}