//
//  DividerView.swift
//  MindFlow
//
//  Created by ne on 2025/3/28.
//

import UIKit
import SnapKit

class DividerView: UIView {
    
    // MARK: - 初始化方法
    init(text: String) {
        super.init(frame: .zero)
        setupView(text: text)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - 私有方法
    private func setupView(text: String) {
        let line = UIView()
        line.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
        addSubview(line)
        
        let label = UILabel()
        label.text = text
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.gray
        label.backgroundColor = .white
        label.textAlignment = .center
        addSubview(label)
        
        line.snp.makeConstraints { make in
            make.leading.trailing.equalTo(self)
            make.centerY.equalTo(self)
            make.height.equalTo(1)
        }
        
        label.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(self)
            make.width.equalTo(40)
        }
    }
}