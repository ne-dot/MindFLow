//
//  ThinkingView.swift
//  MindFlow
//
//  Created by ne on 2025/3/27.
//

import UIKit
import SnapKit
import Kingfisher

class ThinkingView: UIView {
    
    private lazy var breathingView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var outerLayer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.39, green: 0.4, blue: 0.95, alpha: 0.3)
        view.layer.cornerRadius = 100 // 200/2
        view.layer.masksToBounds = true
        return view
    }()
    
    private lazy var middleLayer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.39, green: 0.4, blue: 0.95, alpha: 0.5)
        view.layer.cornerRadius = 75 // 150/2
        view.layer.masksToBounds = true
        return view
    }()
    
    private lazy var innerLayer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.39, green: 0.4, blue: 0.95, alpha: 0.7)
        view.layer.cornerRadius = 50 // 100/2
        view.layer.masksToBounds = true
        return view
    }()
    
    private lazy var thinkingTextContainer: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var thinkingText: UILabel = {
        let label = UILabel()
        label.text = "Thinking"
        label.textColor = theme.text
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        return label
    }()
    
    private lazy var thinkingSubtext: UILabel = {
        let label = UILabel()
        label.text = "Analyzing your query and gathering insights from multiple sources"
        label.textColor = theme.subText
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
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
        setupBreathingView()
        setupThinkingText()
        setupSubtext()
    }
    
    private func setupBreathingView() {
        addSubview(breathingView)
        breathingView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(100)
            make.width.height.equalTo(200)
        }
        
        // 添加三层呼吸动画视图
        breathingView.addSubview(outerLayer)
        outerLayer.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(200)
        }
        
        breathingView.addSubview(middleLayer)
        middleLayer.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(150)
        }
        
        breathingView.addSubview(innerLayer)
        innerLayer.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(100)
        }
    }
    
    private func setupThinkingText() {
        addSubview(thinkingTextContainer)
        thinkingTextContainer.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(breathingView.snp.bottom).offset(30)
        }
        
        thinkingTextContainer.addSubview(thinkingText)
        thinkingText.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupSubtext() {
        addSubview(thinkingSubtext)
        
        thinkingSubtext.snp.makeConstraints { make in
            make.top.equalTo(thinkingTextContainer.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(48)
            make.right.equalToSuperview().offset(-48)
        }
    }
    
    // MARK: - Animations
    private func startBreathingAnimation() {
        // 内层动画
        let innerScaleAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        innerScaleAnimation.values = [1.0, 0.9, 1.0]
        innerScaleAnimation.keyTimes = [0.0, 0.5, 1.0]
        innerScaleAnimation.duration = 3.0
        innerScaleAnimation.repeatCount = .infinity
        innerScaleAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        let innerOpacityAnimation = CAKeyframeAnimation(keyPath: "opacity")
        innerOpacityAnimation.values = [0.8, 1.0, 0.8]
        innerOpacityAnimation.keyTimes = [0.0, 0.5, 1.0]
        innerOpacityAnimation.duration = 3.0
        innerOpacityAnimation.repeatCount = .infinity
        innerOpacityAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        let innerAnimationGroup = CAAnimationGroup()
        innerAnimationGroup.animations = [innerScaleAnimation, innerOpacityAnimation]
        innerAnimationGroup.duration = 3.0
        innerAnimationGroup.repeatCount = .infinity
        innerAnimationGroup.isRemovedOnCompletion = false
        
        // 中层动画
        let middleScaleAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        middleScaleAnimation.values = [1.0, 1.1, 1.0]
        middleScaleAnimation.keyTimes = [0.0, 0.5, 1.0]
        middleScaleAnimation.duration = 4.0
        middleScaleAnimation.repeatCount = .infinity
        middleScaleAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        let middleOpacityAnimation = CAKeyframeAnimation(keyPath: "opacity")
        middleOpacityAnimation.values = [0.6, 0.8, 0.6]
        middleOpacityAnimation.keyTimes = [0.0, 0.5, 1.0]
        middleOpacityAnimation.duration = 4.0
        middleOpacityAnimation.repeatCount = .infinity
        middleOpacityAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        let middleAnimationGroup = CAAnimationGroup()
        middleAnimationGroup.animations = [middleScaleAnimation, middleOpacityAnimation]
        middleAnimationGroup.duration = 4.0
        middleAnimationGroup.repeatCount = .infinity
        middleAnimationGroup.isRemovedOnCompletion = false
        
        // 外层动画
        let outerScaleAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        outerScaleAnimation.values = [1.0, 1.1, 1.0]
        outerScaleAnimation.keyTimes = [0.0, 0.5, 1.0]
        outerScaleAnimation.duration = 5.0
        outerScaleAnimation.repeatCount = .infinity
        outerScaleAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        let outerOpacityAnimation = CAKeyframeAnimation(keyPath: "opacity")
        outerOpacityAnimation.values = [0.4, 0.6, 0.4]
        outerOpacityAnimation.keyTimes = [0.0, 0.5, 1.0]
        outerOpacityAnimation.duration = 5.0
        outerOpacityAnimation.repeatCount = .infinity
        outerOpacityAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        let outerAnimationGroup = CAAnimationGroup()
        outerAnimationGroup.animations = [outerScaleAnimation, outerOpacityAnimation]
        outerAnimationGroup.duration = 5.0
        outerAnimationGroup.repeatCount = .infinity
        outerAnimationGroup.isRemovedOnCompletion = false
        
        // 添加动画
        innerLayer.layer.add(innerAnimationGroup, forKey: "breathingAnimation")
        middleLayer.layer.add(middleAnimationGroup, forKey: "breathingAnimation")
        outerLayer.layer.add(outerAnimationGroup, forKey: "breathingAnimation")
    }
    
    // MARK: - Public Methods
    func startAnimating() {
        isHidden = false
        startBreathingAnimation()
    }
    
    func stopAnimating() {
        isHidden = true
        
        // 移除所有动画
        innerLayer.layer.removeAllAnimations()
        middleLayer.layer.removeAllAnimations()
        outerLayer.layer.removeAllAnimations()
    }
}
