//
//  EditTableViewImageCell.swift
//  D-Day
//
//  Created by hana on 2023/02/01.
//

import UIKit
import PhotosUI

class EditTableViewImageCell: UITableViewCell{
    private var delegate: EditCellDelegate?
    private var cell: EditViewController.CellList?
    var id = ""
    
    let label: UILabel = {
        let label = UILabel()
        label.text = "배경이미지"
        
        return label
    }()
    
    lazy var button: UIButton = {
        let button = UIButton()
        button.tintColor = .systemGray
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
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
        
    private func setLayout(){
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
    
    private func setImage(image: UIImage){
        button.setImage(image, for: .normal)
        
        delegate?.valueChanged(self.cell!, didChangeValue: image)
    }
    
    private func openLibrary(){
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        picker.delegate = self
        
        window?.rootViewController?.presentedViewController?.present(picker, animated: true)
    }
    private func openCamera(){
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.allowsEditing = true
        picker.cameraFlashMode = .off
        picker.delegate = self
        
        if checkCameraPermission(picker){
            window?.rootViewController?.presentedViewController?.present(picker, animated: true)
        }
    }
    
    private func checkCameraPermission(_ picker: UIImagePickerController) -> Bool{
        let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        
        switch status {
        case .notDetermined:
            // 권한 요청
            AVCaptureDevice.requestAccess(for: .video) { grated in
                if !grated {
                    OperationQueue.main.schedule {
                        picker.dismiss(animated: true)
                    }
                }
            }
            return true
        case .authorized:
            return true
        default:
            self.showCamaraPermissionAlertController()
            return false
        }
    }

    func showCamaraPermissionAlertController() {
        let alertController = UIAlertController(title: "카메라 권한이 없습니다.", message: "설정앱에서 카메라 접근을 허용해주세요.\n권한 설정이 변경되면 앱이 다시 실행됩니다.", preferredStyle: .alert)
        
        let moveAction = UIAlertAction(title: "이동", style: .default){ _ in
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        
        [moveAction, cancelAction].forEach{action in
            alertController.addAction(action)
        }
        
        window?.rootViewController?.presentedViewController?.present(alertController, animated: true)
    }
        
    func bind(delegate: EditCellDelegate, cell: EditViewController.CellList){
        self.delegate = delegate
        self.cell = cell
        label.text = cell.text
    }
    
    func setDate(isOn: Bool, id: String){
        toggle.isOn = isOn
        toggle.sendActions(for: .valueChanged)
        
        self.id = id
        
        guard let image = Repository().loadImageFromDocumentDirectory(imageName: id) else {
            button.setImage(UIImage(systemName: "photo"), for: .normal)
            delegate?.valueChanged(self.cell!, didChangeValue: button.image(for: .normal))
            return
        }
        button.setImage(image, for: .normal)
        delegate?.valueChanged(self.cell!, didChangeValue: button.image(for: .normal))
    }
    
    func setToggle(){
        toggle.isOn.toggle()
    }
    
    @objc func buttonTap(){
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.popoverPresentationController?.sourceView = button
        
        alert.addAction(UIAlertAction(title: "사진 보관함에서 선택", style: .default, handler: {_ in
            self.openLibrary()
        }))
        alert.addAction(UIAlertAction(title: "카메라로 촬영", style: .default, handler: {_ in
            self.openCamera()
        }))
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))

        window?.rootViewController?.presentedViewController?.present(alert, animated: true)
    }
    
    @objc func toggleValueChanged(_ sender: UISwitch){
        delegate?.valueChanged(self.cell!, didChangeValue: sender.isOn)
    }
}


extension EditTableViewImageCell: UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        if let selectedImage = info[.editedImage] as? UIImage {
            DispatchQueue.main.async {
                self.setImage(image: selectedImage)
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
