//
//  ProfileViewController.swift
//  MindFlow
//
//  Created by ne on 2025/3/27.
//

import UIKit
import SnapKit

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
    }
    
    private func setupUI() {
        // 创建个人资料标签
        let label = UILabel()
        label.text = "个人资料"
        label.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        label.textAlignment = .center
        view.addSubview(label)
        
        
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
