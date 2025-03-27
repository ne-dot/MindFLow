//
//  FavoritesViewController.swift
//  MindFlow
//
//  Created by ne on 2025/3/27.
//

import UIKit

class FavoritesViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
    }
    
    private func setupUI() {
        let label = UILabel()
        label.text = "收藏内容"
        label.textAlignment = .center
        view.addSubview(label)
        // 使用SnapKit设置约束
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
