//
//  EditTableViewImageCell.swift
//  D-Day
//
//  Created by hana on 2023/02/01.
//

import UIKit
import PhotosUI
import CropViewController

class EditTableViewImageCell: UIEditCell {
    let label: UILabel = {
        let label = UILabel()
        label.text = "배경이미지"
        
        return label
    }()
    
    lazy var button: UIButton = {
        let button = UIButton()
        button.tintColor = .systemGray
        button.contentVerticalAlignment = .center
        button.contentHorizontalAlignment = .center
        button.imageView?.contentMode = .scaleAspectFill
        button.sizeToFit()
        button.addTarget(self, action: #selector(buttonTap), for: .touchUpInside)
        
        return button
    }()
    
    lazy var toggle: UISwitch = {
        let toggle = UISwitch()
        toggle.addTarget(self, action: #selector(toggleValueChanged), for: .valueChanged)
        
        return toggle
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    override func setLayout(){
        [label, toggle, button].forEach{
            contentView.addSubview($0)
        }
        
        label.snp.makeConstraints{
            $0.leading.equalToSuperview().inset(10)
            $0.centerY.equalToSuperview()
        }
        toggle.snp.makeConstraints{
            $0.trailing.equalTo(button.snp.leading).offset(-10)
            $0.centerY.equalToSuperview()
        }
        button.snp.makeConstraints{
            $0.trailing.equalToSuperview().inset(10)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(120)
        }
    }
     
    override func bind(delegate: EditCellDelegate, cell: EditCell){
        self.delegate = delegate
        self.cell = cell
        label.text = cell.text
    }
    
    override func setData(backgroundIsImage: Bool?) {
        guard let backgroundIsImage = backgroundIsImage else { return }
        
        toggle.isOn = backgroundIsImage
    }
    
    override func setData(id: String?){
        guard let id = id else { return }
        guard let image = Repository().loadImageFromFileManager(imageName: id) else {
            button.setImage(UIImage(systemName: "photo", withConfiguration: UIImage.SymbolConfiguration(pointSize: 80, weight: .light)), for: .normal)
            return
        }
        
        setImage(image: image)
    }
    
    func setToggle(){
        toggle.isOn.toggle()
    }
    
    @objc func buttonTap(){
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.popoverPresentationController?.sourceView = button
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("사진 보관함에서 선택", comment: ""), style: .default, handler: { [unowned self] _ in
            self.presentLibrary()
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("카메라로 촬영", comment: ""), style: .default, handler: { [unowned self] _ in
            self.presentCamera()
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("이미지 검색", comment: ""), style: .default, handler: { [unowned self] _ in
            self.presentUnsplashPhotoPicker()
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("취소", comment: ""), style: .cancel))

        window?.rootViewController?.presentedViewController?.present(alert, animated: true)
    }
    
    @objc func toggleValueChanged(_ sender: UISwitch){
        delegate?.valueChanged(self.cell, didChangeValue: sender.isOn)
    }
}

// MARK: private Methode
extension EditTableViewImageCell{
    private func setImage(image: UIImage){
        button.setImage(image, for: .normal)
        
        setData(backgroundIsImage: true)
        delegate?.valueChanged(self.cell, didChangeValue: image)
    }
    
    private func presentLibrary(){
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.mediaTypes = [ UTType.image.identifier ]
        picker.delegate = self
        
        window?.rootViewController?.presentedViewController?.present(picker, animated: true)
    }
    
    private func presentCamera(){
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.mediaTypes = [ UTType.image.identifier ]
        picker.cameraFlashMode = .off
        picker.delegate = self
        
        if picker.checkCameraPermission == false {
            picker.showCamaraPermissionAlertController(view: window?.rootViewController?.presentedViewController)
            return
        }
        window?.rootViewController?.presentedViewController?.present(picker, animated: true)
    }
    
    private func presentUnsplashPhotoPicker(){
        let viewController = UINavigationController(rootViewController: PhotoCollectionViewController(delegate: self))

        window?.rootViewController?.presentedViewController?.present(viewController, animated: true)
    }
    
    private func presentToEditViewController(picker: UIImagePickerController, image: UIImage) {
        let cropViewController = CustomCropViewController(image: image)
        cropViewController.delegate = picker
        
        switch picker.sourceType{
        case .camera:
            picker.dismiss(animated: false, completion: {
                self.window?.rootViewController?.presentedViewController?.present(cropViewController, animated: true)
            })
        case .photoLibrary:
            picker.present(cropViewController, animated: false)
        default:
            break
        }
    }
}


// MARK: UIImagePickerControllerDelegate
extension EditTableViewImageCell: UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            presentToEditViewController(picker: picker, image: selectedImage)
            return
        }
        if let editImage = info[.editedImage] as? UIImage {
            DispatchQueue.main.async {
                self.setImage(image: editImage)
            }
            return
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

// MARK: PhotoCollectionDelegate
extension EditTableViewImageCell: PhotoCollectionDelegate{
    func setBackgroundImage(_ image: UIImage){
        self.setImage(image: image)
    }
}
