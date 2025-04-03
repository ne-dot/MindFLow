//
//  ToastView.swift
//  MindFlow
//
//  Created by ne on 2025/3/28.
//

import UIKit
import SnapKit

class ToastView: UIView {
    
    // MARK: - 静态属性和方法
    private static var currentToastView: ToastView?
    
    enum ToastType {
        case success
        case error
        case info
        
        var color: UIColor {
            switch self {
            case .success:
                return theme.toastSuccessColor
            case .error:
                return theme.toastErrorColor
            case .info:
                return theme.toastInfoColor
            }
        }
        
        var icon: UIImage? {
            switch self {
            case .success:
                return UIImage(systemName: "checkmark.circle.fill")
            case .error:
                return UIImage(systemName: "xmark.circle.fill")
            case .info:
                return UIImage(systemName: "info.circle.fill")
            }
        }
    }
    
    static func show(message: String, type: ToastType = .info, duration: TimeInterval = 2.0, in view: UIView? = nil) {
        // 如果已经有Toast视图，先移除
        hide()
        
        // 获取要显示Toast的视图
        let targetView: UIView
        if let providedView = view {
            targetView = providedView
        } else {
            guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let window = scene.windows.first(where: { $0.isKeyWindow }) else {
                return
            }
            targetView = window
        }
        
        // 创建Toast视图
        let toastView = ToastView(message: message, type: type)
        
        // 添加到视图层次结构
        targetView.addSubview(toastView)
        
        // 设置约束 - 居中显示
        toastView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.lessThanOrEqualTo(targetView.frame.width - 64)
        }
        
        // 保存引用
        currentToastView = toastView
        
        // 显示动画
        toastView.alpha = 0
        UIView.animate(withDuration: 0.3, animations: {
            toastView.alpha = 1
        })
        
        // 自动隐藏
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            hide()
        }
    }
    
    static func showSuccess(message: String, duration: TimeInterval = 2.0, in view: UIView? = nil) {
        show(message: message, type: .success, duration: duration, in: view)
    }
    
    static func showError(message: String, duration: TimeInterval = 2.0, in view: UIView? = nil) {
        show(message: message, type: .error, duration: duration, in: view)
    }
    
    static func hide() {
        guard let toastView = currentToastView else { return }
        
        UIView.animate(withDuration: 0.3, animations: {
            toastView.alpha = 0
        }, completion: { _ in
            toastView.removeFromSuperview()
            currentToastView = nil
        })
    }
    
    // MARK: - UI Components
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        view.layer.cornerRadius = 8
        return view
    }()
    
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        return imageView
    }()
    
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: - Initialization
    init(message: String, type: ToastType) {
        super.init(frame: .zero)
        
        iconImageView.image = type.icon
        iconImageView.tintColor = type.color
        messageLabel.text = message
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        addSubview(containerView)
        containerView.addSubview(iconImageView)
        containerView.addSubview(messageLabel)
        
        // 设置容器视图的背景色为半透明黑色
        containerView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        iconImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
        }
        
        messageLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconImageView.snp.trailing).offset(12)
            make.trailing.equalToSuperview().offset(-16)
            make.top.bottom.equalToSuperview().inset(12)
        }
    }
}
