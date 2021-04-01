//
//  ImagePickerManager.swift
//  ColetteAppiOS
//
//  Created by Abdulrahman A. Hashmi on 31/03/2021.
//

import Foundation
import Foundation
import UIKit
import CropViewController
import Photos

class ImagePickerManager: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CropViewControllerDelegate {

    let vc: UIViewController
    private var image: UIImage?
    var onSelectImage: ((_ image: UIImage) -> Void)?

    init(vc: UIViewController) {
        self.vc = vc
    }

    func showActionSheet(
        title: String,
        message: String?,
        txtCancel: String,
        txtCamera: String,
        txtGallery: String,
        _ button: UIButton?) {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)

            alertController.addAction(UIAlertAction(title: txtCancel, style: .cancel, handler: nil))
            alertController.addAction(UIAlertAction(title: txtCamera, style: .default, handler: { [weak self](_) in
                if let this = self {
                    this.importImageFrom(sourceType: .camera)
                }
            }))
            alertController.addAction(UIAlertAction(title: txtGallery, style: .default, handler: { [weak self](_) in
                if let this = self {
                    this.importImageFrom(sourceType: .photoLibrary)
                }
            }))
            alertController.view.backgroundColor = .white
            alertController.view.layer.cornerRadius = 25
            vc.present(alertController, animated: true, completion: nil)
    }

    private func importImageFrom(sourceType type: UIImagePickerController.SourceType) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = type
        vc.present(picker, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            picker.dismiss(animated: true, completion: {
                self.onSelectImage?(image)
            })
        }
    }

    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        // 'image' is the newly cropped version of the original image
        cropViewController.dismiss(animated: true) {
            self.onSelectImage?(image)
        }
    }

}
