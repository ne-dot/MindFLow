//
//  ImagePickerManager.swift
//  MindFlow
//
//  Created by ne on 2025/3/28.
//

import UIKit

protocol ImagePickerManagerDelegate: AnyObject {
    func didSelectImage(_ image: UIImage)
    func didCancelImageSelection()
}

class ImagePickerManager: NSObject {
    
    weak var delegate: ImagePickerManagerDelegate?
    weak var viewController: UIViewController?
    
    init(viewController: UIViewController, delegate: ImagePickerManagerDelegate) {
        self.viewController = viewController
        self.delegate = delegate
        super.init()
    }
    
    // 显示选择图片的选项
    func showImagePickerOptions() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "拍照", style: .default) { [weak self] _ in
            self?.presentImagePicker(sourceType: .camera)
        }
        
        let libraryAction = UIAlertAction(title: "从相册选择", style: .default) { [weak self] _ in
            self?.presentImagePicker(sourceType: .photoLibrary)
        }
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel)
        
        actionSheet.addAction(cameraAction)
        actionSheet.addAction(libraryAction)
        actionSheet.addAction(cancelAction)
        
        viewController?.present(actionSheet, animated: true)
    }
    
    // 打开图片选择器
    private func presentImagePicker(sourceType: UIImagePickerController.SourceType) {
        guard UIImagePickerController.isSourceTypeAvailable(sourceType) else {
            print("图片源类型不可用: \(sourceType)")
            return
        }
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        viewController?.present(imagePicker, animated: true)
    }
}

// MARK: - UIImagePickerControllerDelegate
extension ImagePickerManager: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[.editedImage] as? UIImage {
            delegate?.didSelectImage(editedImage)
        } else if let originalImage = info[.originalImage] as? UIImage {
            delegate?.didSelectImage(originalImage)
        }
        
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        delegate?.didCancelImageSelection()
        picker.dismiss(animated: true)
    }
}