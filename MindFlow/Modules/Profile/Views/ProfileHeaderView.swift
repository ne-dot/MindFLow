import UIKit
import SnapKit

class ProfileHeaderView: UIView {
    // MARK: - UI Components
    lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 40
        imageView.backgroundColor = .systemGray5
        imageView.image = UIImage(named: "profile_placeholder")
        return imageView
    }()
    
    lazy var editProfileImageButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = theme.primaryColor
        button.tintColor = .white
        button.layer.cornerRadius = 15
        button.setImage(UIImage(systemName: "camera.fill"), for: .normal)
        return button
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.textColor = theme.textColor
        label.textAlignment = .center
        label.text = "not_logged_in".localized
        return label
    }()
    
    lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .systemGray
        label.textAlignment = .center
        label.text = "tap_to_login".localized
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
        addSubview(profileImageView)
        addSubview(editProfileImageButton)
        addSubview(nameLabel)
        addSubview(emailLabel)
        
        profileImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(20)
            make.width.height.equalTo(80)
        }
        
        editProfileImageButton.snp.makeConstraints { make in
            make.bottom.equalTo(profileImageView.snp.bottom).offset(4)
            make.trailing.equalTo(profileImageView.snp.trailing).offset(4)
            make.width.height.equalTo(30)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().offset(-20)
        }
    }
    
    // MARK: - Public Methods
    func updateProfile(name: String, email: String, image: UIImage?) {
        nameLabel.text = name
        emailLabel.text = email
        if let image = image {
            profileImageView.image = image
        }
    }
    
    // 在 resetToDefault 方法中
    func resetToDefault() {
        nameLabel.text = "not_logged_in".localized
        emailLabel.text = "tap_to_login".localized
        profileImageView.image = UIImage(named: "profile_placeholder")
    }
}
