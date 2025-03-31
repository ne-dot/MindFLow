//
//  ExploreViewController.swift
//  MindFlow
//
//  Created by ne on 2025/3/28.
//

import UIKit

class ExploreViewController: UIViewController {
    
    // MARK: - UI组件
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        
        let screenWidth = UIScreen.main.bounds.width
        let itemWidth = (screenWidth - 48) / 2 // 两列布局，左右各16点间距，中间16点间距
        layout.itemSize = CGSize(width: itemWidth, height: 220)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.register(ExploreItemCell.self, forCellWithReuseIdentifier: "ExploreItemCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    // MARK: - 数据
    private var exploreItems: [ExploreItem] = []
    
    // MARK: - 生命周期方法
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadExploreItems()
    }
    
    // MARK: - UI设置
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "探索"
        
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    // MARK: - 数据加载
    private func loadExploreItems() {
        // 模拟数据，实际应用中可以从API获取
        exploreItems = [
            ExploreItem(id: "1", title: "人工智能的未来发展", description: "探索AI技术的最新进展和未来可能的发展方向", imageUrl: "https://picsum.photos/id/1/300/200", link: "https://example.com/ai-future", category: "技术"),
            ExploreItem(id: "2", title: "量子计算入门指南", description: "了解量子计算的基本原理和应用场景", imageUrl: "https://picsum.photos/id/2/300/200", link: "https://example.com/quantum-computing", category: "科学"),
            ExploreItem(id: "3", title: "可持续发展与环保科技", description: "探索环保科技如何帮助实现可持续发展目标", imageUrl: "https://picsum.photos/id/3/300/200", link: "https://example.com/sustainable-tech", category: "环保"),
            ExploreItem(id: "4", title: "区块链技术与应用", description: "了解区块链技术的工作原理和实际应用案例", imageUrl: "https://picsum.photos/id/4/300/200", link: "https://example.com/blockchain", category: "技术"),
            ExploreItem(id: "5", title: "脑科学研究最新进展", description: "探索人类大脑研究的前沿成果和未来方向", imageUrl: "https://picsum.photos/id/5/300/200", link: "https://example.com/neuroscience", category: "科学"),
            ExploreItem(id: "6", title: "太空探索的新时代", description: "了解当前太空探索任务和未来计划", imageUrl: "https://picsum.photos/id/6/300/200", link: "https://example.com/space-exploration", category: "科学")
        ]
        
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension ExploreViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return exploreItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExploreItemCell", for: indexPath) as? ExploreItemCell else {
            return UICollectionViewCell()
        }
        
        let item = exploreItems[indexPath.item]
        cell.configure(with: item)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = exploreItems[indexPath.item]
        // 处理点击事件，例如打开详情页
        print("选择了探索项目: \(item.title)")
    }
}