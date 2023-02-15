//
//  EditTableViewImageCell.swift
//  D-Day
//
//  Created by hana on 2023/02/01.
//

import UIKit
import RxSwift
import PhotosUI
import RxCocoa
import RealmSwift

class EditTableViewImageCell: UITableViewCell{
    let disposeBag = DisposeBag()
    
    let label = UILabel()
    let button = UIButton()
    var id = ""
//    let button = UIImagePickerController()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setAttribute()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setAttribute(){
        label.text = "배경이미지"
        
        button.imageView?.contentMode = .scaleAspectFill
        button.sizeToFit()
        button.rx.tap
            .subscribe{_ in
                self.buttonTap()
            }
            .disposed(by: disposeBag)
    }
    
    private func setLayout(){
        [label, button].forEach{
            contentView.addSubview($0)
        }
        
        label.snp.makeConstraints{
            $0.leading.equalToSuperview().inset(10)
            $0.centerY.equalToSuperview()
        }
        button.snp.makeConstraints{
            $0.trailing.equalToSuperview().inset(10)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(120)
        }
    }
    
    private func openLibrary(){
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .images
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.isEditing = true
        picker.delegate = self
        
        self.window?.rootViewController?.present(picker, animated: true)
    }
    private func openCamera(){
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.allowsEditing = true
        picker.cameraFlashMode = .off
        picker.delegate = self
        
        self.window?.rootViewController?.present(picker, animated: true)
    }
    
    private func setImage(image: UIImage){
        button.setImage(image, for: .normal)
    }
    
    private func buttonTap(){
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "사진 보관함에서 선택", style: .default, handler: {_ in
            self.openLibrary()
        }))
        alert.addAction(UIAlertAction(title: "카메라로 촬영", style: .default, handler: {_ in
            self.openCamera()
        }))
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        
        self.window?.rootViewController?.present(alert, animated: true)
    }

    func setLabelText(text: String){
        label.text = text
    }
    
    func setDate(id: String){
        self.id = id
        button.setImage(Repository().loadImageFromDocumentDirectory(imageName: id), for: .normal)
    }
    
}


extension EditTableViewImageCell: PHPickerViewControllerDelegate {
    //사진 선택
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
//        var selectedImage : UIImage?
        picker.dismiss(animated: true, completion: nil)
        
        let itemProvider = results.first?.itemProvider
        
        if let itemProvider = itemProvider, //UIImage로 값을 불러올 수 있을 경우에만 실행하도록 구현
           itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                DispatchQueue.main.async { //
                    guard let selectedImage = image as? UIImage else { return }
                    
                    Repository().saveImageToDocumentDirectory(imageName: self.id, image: selectedImage)
                    
                    self.setImage(image: selectedImage)
                }
            }
        }
        
    }
}

extension EditTableViewImageCell: UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        if let selectedImage = info[.editedImage] as? UIImage {
            DispatchQueue.main.async { //
                Repository().saveImageToDocumentDirectory(imageName: self.id, image: selectedImage)
                
                self.setImage(image: selectedImage)
            }
        }
    }
}
