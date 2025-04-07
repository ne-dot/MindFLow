//
//  FavoritesViewController.swift
//  MindFlow
//
//  Created by ne on 2025/3/27.
//

import UIKit
import SnapKit

class FavoritesViewController: UIViewController {
    
    // MARK: - Models
    struct FavoriteItem {
        let title: String
        let description: String
        let imageUrl: String?
        let tags: [String]
    }
    
    // MARK: - Properties
    private var favorites: [FavoriteItem] = [
        FavoriteItem(
            title: "AI Research Findings 2024",
            description: "Latest developments in machine learning and neural networks, with focus on natural language processing improvements.",
            imageUrl: "https://ai-public.mastergo.com/ai/img_res/73d13b9458b49d84c6c140632bc213bd.jpg",
            tags: ["Research", "AI"]
        ),
        FavoriteItem(
            title: "Meeting Notes - Product Review",
            description: "Key discussion points from the weekly product review meeting including feature prioritization and upcoming releases.",
            imageUrl: nil,
            tags: ["Work", "Meeting"]
        ),
        FavoriteItem(
            title: "Wellness Program Notes",
            description: "Monthly fitness goals and nutrition plan tracking for personal health improvement.",
            imageUrl: "https://ai-public.mastergo.com/ai/img_res/be96604894eb4c6b0c27c52a875e9d0e.jpg",
            tags: ["Health", "Personal"]
        ),
        FavoriteItem(
            title: "Budget Planning 2024",
            description: "Financial goals and monthly budget allocation for personal expenses and savings targets.",
            imageUrl: nil,
            tags: ["Finance", "Planning"]
        )
    ]
    
    // MARK: - UI Components
    private lazy var navigationBar: NavigationBar = {
        let nav = NavigationBar()
        nav.title = "Saved"
        nav.hideLeftButton()
        nav.hideSeparator()
        
        // 设置右侧魔法按钮
        let magicImage = UIImage(systemName: "wand.and.stars")
        nav.setRightButton(image: magicImage)
        nav.onRightButtonTapped = { [weak self] in
            self?.magicButtonTapped()
        }
        
        return nav
    }()
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = .clear
        table.separatorStyle = .none
        table.register(FavoriteItemCell.self, forCellReuseIdentifier: "FavoriteItemCell")
        table.delegate = self
        table.dataSource = self
        table.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
              
        return table
    }()
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .white
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        view.addSubview(navigationBar)
        navigationBar.snp.makeConstraints { make in
            make.top.equalTo(0)
            make.left.right.equalToSuperview()
            make.height.equalTo(navigationBar.totalHeight)
        }
        
        view.addSubview(tableView)
        setupConstraints()
    }
    
    private func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    
    private func createTabBarButton(icon: String, title: String, isSelected: Bool) -> UIView {
        let container = UIView()
        
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 20)
        let image = UIImage(systemName: icon, withConfiguration: config)
        button.setImage(image, for: .normal)
        button.tintColor = isSelected ? theme.primaryColor : .systemGray3
        
        let label = UILabel()
        label.text = title
        label.font = .systemFont(ofSize: 12)
        label.textColor = isSelected ? theme.primaryColor : .systemGray3
        
        container.addSubview(button)
        container.addSubview(label)
        
        button.snp.makeConstraints { make in
            make.top.centerX.equalToSuperview()
            make.size.equalTo(24)
        }
        
        label.snp.makeConstraints { make in
            make.top.equalTo(button.snp.bottom).offset(2)
            make.centerX.bottom.equalToSuperview()
        }
        
        return container
    }
    
    private func magicButtonTapped() {
        // 处理魔法按钮点击事件
    }
}

// MARK: - UITableViewDelegate & DataSource
extension FavoritesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteItemCell", for: indexPath) as! FavoriteItemCell
        cell.configure(with: favorites[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
