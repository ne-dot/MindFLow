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
    
    // MARK: - UI Components
    private let backgroundImageView = UIImageView()
    private let pulseContainerView = UIView()
    private let outerPulseView = UIView()
    private let middlePulseView = UIView()
    private let innerPulseView = UIView()
    
    private let thinkingTextContainer = UIView()
    private let thinkingText = UILabel()
    private let dotsContainer = UIView()
    private let dot1 = UIView()
    private let dot2 = UIView()
    private let dot3 = UIView()
    let breathingView = UIView()
    var innerLayer = UIView()
    var middleLayer = UIView()
    var outerLayer = UIView()
    
    private let thinkingSubtext = UILabel()
    private let cancelButton = UIButton(type: .system)
    
    // MARK: - Properties
    var onCancelTapped: (() -> Void)?
    
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
        backgroundColor = .white
        
        setupBackgroundImage()
        setupPulseCircles()
        setupThinkingText()
        setupSubtext()
        setupCancelButton()
        
//        innerLayer = createBreathingLayer(size: 150, color: UIColor(red: 0.39, green: 0.4, blue: 0.95, alpha: 1), scale: 1.0)
//        middleLayer = createBreathingLayer(size: 170, color: UIColor(red: 0.39, green: 0.4, blue: 0.95, alpha: 0.7), scale: 1.1)
//        outerLayer = createBreathingLayer(size: 190, color: UIColor(red: 0.39, green: 0.4, blue: 0.95, alpha: 0.5), scale: 1.2)
        // 创建内层、外层视图，增加了三层之间的大小差距
        innerLayer = createBreathingLayer(size: 100, color: UIColor(red: 0.39, green: 0.4, blue: 0.95, alpha: 1), scale: 1.0)
        middleLayer = createBreathingLayer(size: 150, color: UIColor(red: 0.39, green: 0.4, blue: 0.95, alpha: 0.7), scale: 1.1)
        outerLayer = createBreathingLayer(size: 200, color: UIColor(red: 0.39, green: 0.4, blue: 0.95, alpha: 0.5), scale: 1.2)
              
               
        
        // 创建一个视图来表现呼吸动画
               
               breathingView.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
//               breathingView.layer.cornerRadius = breathingView.frame.size.width / 2 // 圆形视图
//               breathingView.layer.masksToBounds = true
               self.addSubview(breathingView)
        breathingView.addSubview(innerLayer)
        breathingView.addSubview(middleLayer)
        breathingView.addSubview(outerLayer)
               
              
    }
    
    func createBreathingLayer(size: CGFloat, color: UIColor, scale: CGFloat) -> UIView {
            let layer = UIView()
            layer.frame = CGRect(x: 0, y: 0, width: size, height: size)
            layer.center = CGPoint(x: 150, y: 150) // Centered in the breathing container
            layer.backgroundColor = color
            layer.layer.cornerRadius = size / 2
            layer.layer.masksToBounds = true
            return layer
        }

    func startBreathingAnimation(view: UIView, isInner: Bool) {
            // 内层和外层的缩放动画相反
            let scaleAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
            if isInner {
                scaleAnimation.values = [1.0, 0.9, 1.0] // 内层是缩小时变大，放大时变小
            } else {
                scaleAnimation.values = [1.0, 1.1, 1.0] // 外层是放大时变大，缩小时变小
            }
            scaleAnimation.keyTimes = [0.0, 0.5, 1.0]
            scaleAnimation.duration = 4.0
            scaleAnimation.repeatCount = .infinity
            
            // 透明度动画
            let opacityAnimation = CAKeyframeAnimation(keyPath: "opacity")
            opacityAnimation.values = [0.5, 1.0, 0.5]
            opacityAnimation.keyTimes = [0.0, 0.5, 1.0]
            opacityAnimation.duration = 4.0
            opacityAnimation.repeatCount = .infinity
            
            // 添加动画
            view.layer.add(scaleAnimation, forKey: "scaleAnimation")
            view.layer.add(opacityAnimation, forKey: "opacityAnimation")
        }
    
    private func setupBackgroundImage() {
        // 背景图片
        addSubview(backgroundImageView)
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.alpha = 0.1
        
        // 使用Kingfisher加载网络图片
        let imageUrl = URL(string: "https://ai-public.mastergo.com/ai/img_res/a9f71a0238d81cc77127afc56deb7493.jpg")
        backgroundImageView.kf.setImage(
            with: imageUrl,
            placeholder: nil,
            options: [
                .transition(.fade(0.3)),
                .cacheOriginalImage
            ]
        )
        
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupPulseCircles() {
        // 脉冲容器
//        addSubview(pulseContainerView)
//        pulseContainerView.snp.makeConstraints { make in
//            make.centerX.equalToSuperview()
//            make.centerY.equalToSuperview().offset(-60)
//            make.width.height.equalTo(192) // 48*4
//        }
//        
//        // 外层脉冲圆
//        pulseContainerView.addSubview(outerPulseView)
//        outerPulseView.layer.cornerRadius = 96 // 192/2
//        outerPulseView.backgroundColor = UIColor(red: 0.39, green: 0.4, blue: 0.95, alpha: 0.2)
//        outerPulseView.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//        }
//        
//        // 中层脉冲圆
//        pulseContainerView.addSubview(middlePulseView)
//        middlePulseView.layer.cornerRadius = 77 // 154/2
//        middlePulseView.backgroundColor = UIColor(red: 0.39, green: 0.4, blue: 0.95, alpha: 0.2)
//        middlePulseView.snp.makeConstraints { make in
//            make.center.equalToSuperview()
//            make.width.height.equalTo(154) // 192 * 0.8
//        }
//        
//        // 内层脉冲圆
//        pulseContainerView.addSubview(innerPulseView)
//        innerPulseView.layer.cornerRadius = 58 // 115/2
//        innerPulseView.backgroundColor = UIColor(red: 0.39, green: 0.4, blue: 0.95, alpha: 0.2)
//        innerPulseView.snp.makeConstraints { make in
//            make.center.equalToSuperview()
//            make.width.height.equalTo(115) // 192 * 0.6
//        }
        
        // 添加脉冲动画
//        addPulseAnimation(to: outerPulseView, delay: 0)
//        addPulseAnimation(to: middlePulseView, delay: 0.5)
//        addPulseAnimation(to: innerPulseView, delay: 1.0)
    }
    
    private func setupThinkingText() {
        // 添加"Thinking"文本容器
        addSubview(thinkingTextContainer)
        thinkingTextContainer.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.snp.bottom).offset(30)
        }
        
        // 添加"Thinking"文本
        thinkingText.text = "Thinking"
        thinkingText.textColor = UIColor(red: 0.33, green: 0.33, blue: 0.33, alpha: 1.0) // #545454
        thinkingText.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        thinkingTextContainer.addSubview(thinkingText)
        thinkingText.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview()
        }
        
        // 添加点容器
        thinkingTextContainer.addSubview(dotsContainer)
        dotsContainer.snp.makeConstraints { make in
            make.left.equalTo(thinkingText.snp.right).offset(8)
            make.centerY.equalTo(thinkingText)
            make.height.equalTo(20)
            make.width.equalTo(40)
            make.right.equalToSuperview()
        }
        
        // 添加三个点
        let dotSize: CGFloat = 6
        let dotSpacing: CGFloat = 6
        
        dotsContainer.addSubview(dot1)
        dot1.backgroundColor = UIColor(red: 0.39, green: 0.4, blue: 0.95, alpha: 1.0) // #6366F1
        dot1.layer.cornerRadius = dotSize / 2
        dot1.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.height.equalTo(dotSize)
        }
        
        dotsContainer.addSubview(dot2)
        dot2.backgroundColor = UIColor(red: 0.39, green: 0.4, blue: 0.95, alpha: 1.0) // #6366F1
        dot2.layer.cornerRadius = dotSize / 2
        dot2.snp.makeConstraints { make in
            make.left.equalTo(dot1.snp.right).offset(dotSpacing)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(dotSize)
        }
        
        dotsContainer.addSubview(dot3)
        dot3.backgroundColor = UIColor(red: 0.39, green: 0.4, blue: 0.95, alpha: 1.0) // #6366F1
        dot3.layer.cornerRadius = dotSize / 2
        dot3.snp.makeConstraints { make in
            make.left.equalTo(dot2.snp.right).offset(dotSpacing)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(dotSize)
        }
        
        // 添加波浪动画
//        addDotAnimation(to: dot1, delay: 0)
//        addDotAnimation(to: dot2, delay: 0.3)
//        addDotAnimation(to: dot3, delay: 0.6)
    }
    
    private func setupSubtext() {
        // 添加副文本
        thinkingSubtext.text = "Analyzing your query and gathering insights from multiple sources"
        thinkingSubtext.textColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0) // #808080
        thinkingSubtext.font = UIFont.systemFont(ofSize: 14)
        thinkingSubtext.textAlignment = .center
        thinkingSubtext.numberOfLines = 0
        addSubview(thinkingSubtext)
        
        thinkingSubtext.snp.makeConstraints { make in
            make.top.equalTo(thinkingTextContainer.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(48)
            make.right.equalToSuperview().offset(-48)
        }
    }
    
    private func setupCancelButton() {
        // 添加取消按钮
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0), for: .normal)
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        cancelButton.layer.cornerRadius = 4
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        addSubview(cancelButton)
        
        cancelButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-48)
            make.height.equalTo(40)
            make.width.equalTo(100)
        }
    }
    
    
    // MARK: - Animations
    private func addPulseAnimation(to view: UIView, delay: TimeInterval) {
        // 缩放动画
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.duration = 4.0  // 增加动画时长
        scaleAnimation.fromValue = 0.9  // 减小缩放范围
        scaleAnimation.toValue = 1.1
        scaleAnimation.autoreverses = true
        scaleAnimation.repeatCount = .infinity
        scaleAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        // 透明度动画
        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.duration = 4.0  // 增加动画时长
        opacityAnimation.fromValue = 0.4  // 减小透明度变化范围
        opacityAnimation.toValue = 0.6
        opacityAnimation.autoreverses = true
        opacityAnimation.repeatCount = .infinity
        opacityAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        // 动画组
        let animationGroup = CAAnimationGroup()
        animationGroup.animations = [scaleAnimation, opacityAnimation]
        animationGroup.duration = 4.0  // 增加动画时长
        animationGroup.repeatCount = .infinity
        animationGroup.beginTime = CACurrentMediaTime() + delay
        animationGroup.isRemovedOnCompletion = false
        
        view.layer.add(animationGroup, forKey: "pulseAnimation")
    }
    
    private func addDotAnimation(to view: UIView, delay: TimeInterval) {
        // 点的上下移动动画
        let moveAnimation = CAKeyframeAnimation(keyPath: "transform.translation.y")
        moveAnimation.values = [0, -4, 0]  // 减小移动幅度
        moveAnimation.keyTimes = [0, 0.5, 1]
        moveAnimation.duration = 2.0  // 增加动画时长
        moveAnimation.beginTime = CACurrentMediaTime() + delay
        moveAnimation.repeatCount = .infinity
        moveAnimation.isRemovedOnCompletion = false
        moveAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        // 点的透明度变化
        let opacityAnimation = CAKeyframeAnimation(keyPath: "opacity")
        opacityAnimation.values = [0.5, 0.9, 0.5]  // 减小透明度变化范围
        opacityAnimation.keyTimes = [0, 0.5, 1]
        opacityAnimation.duration = 2.0  // 增加动画时长
        opacityAnimation.beginTime = CACurrentMediaTime() + delay
        opacityAnimation.repeatCount = .infinity
        opacityAnimation.isRemovedOnCompletion = false
        opacityAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        // 动画组
        let animationGroup = CAAnimationGroup()
        animationGroup.animations = [moveAnimation, opacityAnimation]
        animationGroup.duration = 2.0  // 增加动画时长
        animationGroup.repeatCount = .infinity
        animationGroup.beginTime = CACurrentMediaTime() + delay
        animationGroup.isRemovedOnCompletion = false
        
        view.layer.add(animationGroup, forKey: "dotAnimation")
    }
    
    // MARK: - Public Methods
    func startAnimating() {
        isHidden = false
        
        // 重新添加所有动画
//        addPulseAnimation(to: outerPulseView, delay: 0)
//        addPulseAnimation(to: middlePulseView, delay: 0.5)
//        addPulseAnimation(to: innerPulseView, delay: 1.0)
        // 调用方法开始动画
        // 开始动画
        startBreathingAnimation(view: innerLayer, isInner: true)
        startBreathingAnimation(view: middleLayer, isInner: false)
        startBreathingAnimation(view: outerLayer, isInner: false)
        addDotAnimation(to: dot1, delay: 0)
        addDotAnimation(to: dot2, delay: 0.3)
        addDotAnimation(to: dot3, delay: 0.6)
    }
    
    func stopAnimating() {
        isHidden = true
        
        // 移除所有动画
        outerPulseView.layer.removeAllAnimations()
        middlePulseView.layer.removeAllAnimations()
        innerPulseView.layer.removeAllAnimations()
        
        dot1.layer.removeAllAnimations()
        dot2.layer.removeAllAnimations()
        dot3.layer.removeAllAnimations()
    }
    
    // MARK: - Actions
    @objc private func cancelButtonTapped() {
        onCancelTapped?()
    }
}
