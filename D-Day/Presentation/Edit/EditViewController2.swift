//
//  EditViewController.swift
//  D-Day
//
//  Created by hana on 2023/01/30.
//

import UIKit
import PhotosUI

class EditViewController2: UIViewController{
    private lazy var presenter = EditPresenter(viewController: self, delegate: delegate, item: item)
    private let delegate: EditDelegate
    private let item: Item
        
    private let scrollView = UIScrollView()
    private let vStackView = UIStackView()
    
    private let topStackView = UIStackView()
    
    private let titleStackView = UIStackView()
    private let titleTextField = UITextField()
    private let titleColorWell = UIColorWell()
    
    private let dateStackView = UIStackView()
    private let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "ko")
        datePicker.preferredDatePickerStyle = .wheels

        return datePicker
    }()
    
    private let middleStackView = UIStackView()
    
    private let bgColorStackView = UIStackView()
    private let bgColorSwitch: UISwitch = {
        let toggle = UISwitch()
        toggle.addTarget(self, action: #selector(isSwitchChangedValue), for: .valueChanged)
        
        return toggle
    }()
    private let bgColorLabel = UILabel()
    private let bgColorWell = UIColorWell()
    
    private let bgImageStackView = UIStackView()
    private let bgImageSwitch: UISwitch = {
        let toggle = UISwitch()
        toggle.addTarget(self, action: #selector(isSwitchChangedValue), for: .valueChanged)
        
        return toggle
    }()
    private let bgImageLabel = UILabel()
    private lazy var bgImageButton: UIButton = {
        let button = UIButton()
        button.tintColor = .systemGray
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.imageView?.contentMode = .scaleAspectFill
        button.sizeToFit()
        
        button.addTarget(self, action: #selector(bgImageButtonTap), for: .touchUpInside)
        
        return button
    }()
    
    private let circleStackView = UIStackView()
    private let circleLabel = UILabel()
    private let circleSwitch = UISwitch()
    
    private let memoStackView = UIStackView()
    private lazy var memoTextView: UITextView = {
        let textView = UITextView()
        textView.layer.borderWidth = 1.0
        textView.layer.borderColor = UIColor.systemBackground.withAlphaComponent(0.7).cgColor
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        textView.font = .systemFont(ofSize: 17)
        textView.text = presenter.textViewPlaceHolder
        textView.textColor = .tertiaryLabel
        
        textView.delegate = self
        
        return textView
    }()
    
    init(delegate: EditDelegate = MainPresenter(viewController: MainViewController()), item: Item = Item()){
        self.delegate = delegate
        self.item = item
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.viewDidLoad()
    }
    
    private func openLibrary(){
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .images
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.isEditing = true
        picker.delegate = self
        
        self.present(picker, animated: true)
    }
    
    private func openCamera(){
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.allowsEditing = true
        picker.cameraFlashMode = .off
        picker.delegate = self
        
        self.present(picker, animated: true)
    }
}

extension EditViewController2: EditProtocol{
    func setAttribute(){
        scrollView.backgroundColor = .systemGray6
        
        vStackView.axis = .vertical
        vStackView.alignment = .center
        vStackView.distribution = .equalSpacing
        vStackView.spacing = 40
        
        [topStackView, middleStackView, memoStackView].forEach{
            $0.axis = .vertical
            $0.alignment = .fill
            //            $0.distribution = .fill
            $0.spacing = 0
            $0.layer.cornerRadius = 10
            $0.backgroundColor = .systemBackground
            $0.clipsToBounds = true
        }
        
        [titleStackView, dateStackView, bgColorStackView, bgImageStackView, circleStackView].forEach{
            $0.axis = .horizontal
            $0.alignment = .center
            $0.distribution = .fillEqually
            $0.layer.borderWidth = 0.5
            $0.layer.borderColor = UIColor.systemGray6.cgColor
            
        }
        
        titleTextField.placeholder = CellList.title.text
        bgColorLabel.text = CellList.backgroundColor.text
        bgImageLabel.text = CellList.backgroundImage.text
        circleLabel.text = CellList.isCircle.text
    }
    
    func setNavigation(){
        var leftCancelButton = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(leftCancelButtonTap))
        var rightSaveButton = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(rightSaveButtonTap))
        
        navigationItem.leftBarButtonItem = leftCancelButton
        navigationItem.rightBarButtonItem = rightSaveButton
        navigationController?.navigationBar.tintColor = .label
        navigationController?.navigationBar.backgroundColor = .systemGray6
    }
    
    func setLayout(){
        view.addSubview(scrollView)
        scrollView.addSubview(vStackView)
        [topStackView, middleStackView, memoStackView].forEach{
            vStackView.addArrangedSubview($0)
        }
        
        scrollView.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        vStackView.snp.makeConstraints{
            $0.top.bottom.leading.trailing.equalTo(scrollView).inset(10)
            $0.centerX.equalToSuperview()
        }
        [titleStackView, dateStackView].forEach{
            topStackView.addArrangedSubview($0)
        }
        [bgColorStackView, bgImageStackView, circleStackView].forEach{
            middleStackView.addArrangedSubview($0)
        }
        [memoTextView].forEach{
            memoStackView.addArrangedSubview($0)
        }
        topStackView.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview().inset(10)
        }
        middleStackView.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview().inset(10)
        }
        
        [titleStackView, bgColorStackView, circleStackView].forEach{
            $0.snp.makeConstraints{
                $0.leading.trailing.equalToSuperview().inset(10)
                $0.height.equalTo(80)
            }
        }
        [dateStackView, bgImageStackView, memoStackView].forEach{
            $0.snp.makeConstraints{
                $0.leading.trailing.equalToSuperview().inset(10)
                $0.height.equalTo(200)
            }
        }
        
        [titleTextField, titleColorWell].forEach{
            titleStackView.addArrangedSubview($0)
        }
        [datePicker].forEach{
            dateStackView.addArrangedSubview($0)
        }
        [bgColorLabel, bgColorSwitch, bgColorWell].forEach{
            bgColorStackView.addArrangedSubview($0)
        }
        [bgImageLabel, bgImageSwitch, bgImageButton].forEach{
            bgImageStackView.addArrangedSubview($0)
        }
        [circleLabel, circleSwitch].forEach{
            circleStackView.addArrangedSubview($0)
        }
        
        bgImageButton.snp.makeConstraints{
            //            $0.trailing.equalToSuperview().inset(10)
            //            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(120)
        }
    }
    func setData(_ item: Item) {
        titleTextField.text = item.title
        titleColorWell.selectedColor = UIColor(hexCode: item.titleColor)
        datePicker.date = item.date
        bgColorSwitch.isOn = item.isBackgroundColor
        bgColorWell.selectedColor = UIColor(hexCode: item.backgroundColor)
        bgImageSwitch.isOn = item.isBackgroundImage
        circleSwitch.isOn = item.isCircle
        memoTextView.text = item.memo == "" ? presenter.textViewPlaceHolder : item.memo
        memoTextView.textColor =  item.memo == "" ? .tertiaryLabel : .label
    }
    
    func setImage( _ image: UIImage!){
        bgImageButton.setImage(image, for: .normal)
    }
    
    func showCloseAlertController(){
        let alertController = UIAlertController(title: "작성중인 내용이 있습니다. 닫으시겠습니까?", message: nil, preferredStyle: .alert)
        
        let closeAction = UIAlertAction(title: "닫기", style: .destructive){ [weak self] _ in
            self?.dismiss(animated: true)
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        
        [closeAction, cancelAction].forEach{action in
            alertController.addAction(action)
        }
        
        present(alertController, animated: true)
    }
    
    func showImageSelectAlertController(){
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "사진 보관함에서 선택", style: .default, handler: {_ in
            self.openLibrary()
        }))
        alert.addAction(UIAlertAction(title: "카메라로 촬영", style: .default, handler: {_ in
            self.openCamera()
        }))
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        
        self.present(alert, animated: true)
    }
    
    func showToast(message: String) {
        Util.showToast(view: self.view, message: message)
    }
    
    func dismiss() {
        self.dismiss(animated: true)
    }
}

extension EditViewController2{
    @objc func leftCancelButtonTap(){
        presenter.leftCancelButtonTap()
    }
    
    @objc func rightSaveButtonTap(){
        presenter.rightSaveButtonTap(
            title: titleTextField.text,
            titleColor: titleColorWell.selectedColor,
            date: datePicker.date,
            isBgColor: bgColorSwitch.isOn,
            bgColor: bgColorWell.selectedColor,
            isBgImage: bgImageSwitch.isOn,
            bgImage: bgImageButton.imageView?.image,
            isCircle: circleSwitch.isOn,
            memo: memoTextView.text)
    }
    
    @objc func bgImageButtonTap(){
        presenter.bgImageButtonTap()
    }
    
    @objc func isSwitchChangedValue(_ sender: UISwitch){
        if sender == bgColorSwitch{
            bgImageSwitch.isOn = !sender.isOn
        }
        if sender == bgImageSwitch{
            bgColorSwitch.isOn = !sender.isOn
        }
        
        
//        presenter.isSwitchChangedValue()
    }
}


extension EditViewController2: PHPickerViewControllerDelegate {
    //사진 선택
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
//        var selectedImage : UIImage?
        picker.dismiss(animated: true, completion: nil)
        
        let itemProvider = results.first?.itemProvider
        
        if let itemProvider = itemProvider, //UIImage로 값을 불러올 수 있을 경우에만 실행하도록 구현
           itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                guard let selectedImage = image as? UIImage else {
                    print(error?.localizedDescription)
                    return
                }
                
                self.presenter.saveImage(selectedImage: selectedImage)
                DispatchQueue.main.async {
                    self.setImage(selectedImage)
                }
            }
        }
    }
}

extension EditViewController2: UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        if let selectedImage = info[.editedImage] as? UIImage {
            self.presenter.saveImage(selectedImage: selectedImage)
            DispatchQueue.main.async { //
                self.setImage(selectedImage)
            }
        }
    }
}

extension EditViewController2: UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        guard textView.textColor == .tertiaryLabel else{
            return
        }
        
        textView.text = nil
        textView.textColor = .label
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty{
            textView.text = presenter.textViewPlaceHolder
            textView.textColor = .tertiaryLabel
        }
    }
}


extension EditViewController2{
    enum CellType: Int, CaseIterable{
        case main = 0
        case view = 1
        case ext = 2
    }
    
    enum CellList: CaseIterable{
        case title, date, backgroundColor, backgroundImage, isCircle, memo

        var section: CellType{
            switch self{
            case.title, .date://, .isStartCount, .repeatCode:
                return .main
            case .backgroundColor, .backgroundImage, .isCircle:
                return .view
            case .memo:
                return .ext
            }
        }
        
        var text: String{
            switch self{
            case .title:
                return "제목을 입력해주세요"
            case .date:
                return "날짜"
//            case .isStartCount:
//                return "시작일"
//            case .repeatCode:
//                return "반복"
            case .backgroundColor:
                return "배경색"
            case .backgroundImage:
                return "배경이미지"
            case .isCircle:
                return "동그랗게"
            case .memo:
                return "메모"
            }
        }
    }
}
