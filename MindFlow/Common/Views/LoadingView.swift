//
//  LoadingView.swift
//  MindFlow
//
//  Created by ne on 2025/3/28.
//

import UIKit
import SnapKit

class LoadingView: UIView {
    
    // MARK: - 静态属性和方法
    private static var currentLoadingView: LoadingView?
    
    static func show(in view: UIView, message: String? = nil) {
        // 如果已经有加载视图，先移除
        hide()
        
        // 创建加载视图
        let loadingView = LoadingView(frame: view.bounds)
        loadingView.startAnimating(withMessage: message)
        
        // 添加到视图层次结构
        view.addSubview(loadingView)
        
        // 设置约束
        loadingView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        // 保存引用
        currentLoadingView = loadingView
    }
    
    static func hide() {
        currentLoadingView?.stopAnimating()
        currentLoadingView?.removeFromSuperview()
        currentLoadingView = nil
    }
    
    // MARK: - UI Components
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        view.layer.cornerRadius = 12
        return view
    }()
    
    private lazy var spinnerView: SpinnerView = {
        let view = SpinnerView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        view.color = .white
        return view
    }()
    
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
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
        backgroundColor = UIColor.black.withAlphaComponent(0.2)
        
        addSubview(containerView)
        containerView.addSubview(spinnerView)
        containerView.addSubview(messageLabel)
        
        containerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(120)
            make.height.greaterThanOrEqualTo(120)
        }
        
        spinnerView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(24)
            make.width.height.equalTo(40)
        }
        
        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(spinnerView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(12)
            make.bottom.equalToSuperview().offset(-16)
        }
    }
    
    // MARK: - Public Methods
    func startAnimating(withMessage message: String? = nil) {
        messageLabel.text = message
        messageLabel.isHidden = message == nil
        
        spinnerView.startAnimating()
    }
    
    func stopAnimating() {
        spinnerView.stopAnimating()
    }
}

// 自定义旋转动画视图
class SpinnerView: UIView {
    
    var color: UIColor = .white {
        didSet {
            shapeLayer.strokeColor = color.cgColor
        }
    }
    
    private let shapeLayer = CAShapeLayer()
    private var isAnimating = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupShapeLayer()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupShapeLayer()
    }
    
    private func setupShapeLayer() {
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = min(bounds.width, bounds.height) / 2 - 2
        let startAngle = -CGFloat.pi / 2
        let endAngle = startAngle + 2 * CGFloat.pi
        
        let path = UIBezierPath(arcCenter: center,
                                radius: radius,
                                startAngle: startAngle,
                                endAngle: endAngle,
                                clockwise: true)
        
        shapeLayer.path = path.cgPath
        shapeLayer.lineWidth = 3
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineCap = .round
        shapeLayer.strokeStart = 0
        shapeLayer.strokeEnd = 0.75
        
        layer.addSublayer(shapeLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = min(bounds.width, bounds.height) / 2 - 2
        let startAngle = -CGFloat.pi / 2
        let endAngle = startAngle + 2 * CGFloat.pi
        
        let path = UIBezierPath(arcCenter: center,
                                radius: radius,
                                startAngle: startAngle,
                                endAngle: endAngle,
                                clockwise: true)
        
        shapeLayer.path = path.cgPath
    }
    
    func startAnimating() {
        if isAnimating { return }
        isAnimating = true
        
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotationAnimation.fromValue = 0
        rotationAnimation.toValue = 2 * Double.pi
        rotationAnimation.duration = 1
        rotationAnimation.repeatCount = .infinity
        rotationAnimation.isRemovedOnCompletion = false
        
        layer.add(rotationAnimation, forKey: "rotation")
    }
    
    func stopAnimating() {
        if !isAnimating { return }
        isAnimating = false
        
        layer.removeAnimation(forKey: "rotation")
    }
}
