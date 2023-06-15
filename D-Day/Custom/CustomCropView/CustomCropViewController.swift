//
//  CustomCropViewController.swift
//  D-Day
//
//  Created by hana on 2023/06/15.
//

import CropViewController
import UIKit

class CustomCropViewController: CropViewController{
    override init(image: UIImage) {
        super.init(image: image)
        aspectRatioLockEnabled = true
        resetAspectRatioEnabled = false
        aspectRatioPickerButtonHidden = true
        aspectRatioPreset = .presetSquare
        transitioningDelegate = nil
        modalTransitionStyle = .crossDissolve
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
