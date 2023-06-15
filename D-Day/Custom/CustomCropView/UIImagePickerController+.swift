//
//  UIImagePickerController+.swift
//  D-Day
//
//  Created by hana on 2023/06/15.
//

import UIKit
import CropViewController
import AVFoundation


// MARK: Permission
extension UIImagePickerController {
    var checkCameraPermission: Bool {
        let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        
        switch status {
        case .notDetermined:
            // 권한 요청
            AVCaptureDevice.requestAccess(for: .video) { grated in
                if grated == true { return }
                // 거절
                OperationQueue.main.schedule {
                    self.dismiss(animated: true)
                }
            }
            return true
        case .authorized:
            return true
        default:
            return false
        }
    }

    public func showCamaraPermissionAlertController(view: UIViewController?) {
        let alertController = UIAlertController(
            title: NSLocalizedString("카메라 권한이 없습니다.", comment: ""),
            message: NSLocalizedString("설정앱에서 카메라 접근을 허용해주세요.\n권한 설정이 변경되면 앱이 다시 실행됩니다.", comment: ""),
            preferredStyle: .alert)
        
        let moveAction = UIAlertAction(title: NSLocalizedString("이동", comment: ""), style: .default){ _ in
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        }
        let cancelAction = UIAlertAction(title: NSLocalizedString("취소", comment: ""), style: .cancel)
        
        [moveAction, cancelAction].forEach{action in
            alertController.addAction(action)
        }
        
        view?.present(alertController, animated: true)
    }
}

// MARK: CropViewControllerDelegate
extension UIImagePickerController: CropViewControllerDelegate{
    public func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        self.delegate?.imagePickerController?(self, didFinishPickingMediaWithInfo: [InfoKey.editedImage: image])
        
        cropViewController.dismiss(animated: true)
        if self.sourceType == .photoLibrary {
            self.dismiss(animated: false)
        }
    }
    
    public func cropViewController(_ cropViewController: CropViewController, didFinishCancelled cancelled: Bool) {
        cropViewController.dismiss(animated: true)
    }
}
