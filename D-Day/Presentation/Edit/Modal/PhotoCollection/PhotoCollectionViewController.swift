//
//  PhotoCollectionViewController.swift
//  D-Day
//
//  Created by hana on 2023/06/13.
//

import UIKit
import CropViewController

protocol PhotoCollectionDelegate{
    func setBackgroundImage(_ image: UIImage)
}

class PhotoCollectionViewController: UIViewController{
    private lazy var presenter = PhotoCollectionPresenter(viewController: self)
    private let delegate: PhotoCollectionDelegate
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: "PhotoCollectionViewCell")
        collectionView.dataSource = dataSource
        collectionView.delegate = self
        
        let layout = CustomLayout()
        layout.delegate = self
        collectionView.collectionViewLayout = layout
        
        return collectionView
    }()
    
    private var dataSource: UICollectionViewDiffableDataSource<Int, Photo>?
    
    init(delegate: PhotoCollectionDelegate){
        self.delegate = delegate
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.viewDidLoad()
        presenter.nextPageFetchPhotos()
    }
    
    private func presentToEditViewController(image: UIImage) {
        let cropViewController = CustomCropViewController(image: image)
        cropViewController.delegate = self
        
        present(cropViewController, animated: true, completion: nil)
    }
}

// MARK: - UISearchBarDelegate
extension PhotoCollectionViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else {
            print("검색어를 입력해주세요.")
            return
        }
        searchBar.resignFirstResponder()
        if let cancelButton = searchBar.value(forKey: "cancelButton") as? UIButton {
            cancelButton.isEnabled = true
        }
        
        presenter.searchBarSearchButtonClicked(text)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        searchBar.resignFirstResponder()
        
        presenter.searchBarCancelButtonClicked()
    }
}

// MARK: - PhotoCollectionProtocol
extension PhotoCollectionViewController: PhotoCollectionProtocol{
    func setLayout(){
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
    }
    
    func setNavigation(){
        let searchBar = UISearchBar()
        searchBar.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 30, height: 0)
        searchBar.placeholder = NSLocalizedString("검색어 입력", comment: "")
        searchBar.showsCancelButton = true
        searchBar.delegate = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: searchBar)
    }
    
    func setDataSource() {
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath) as? PhotoCollectionViewCell
            cell?.photo = item
            
            return cell
        })
    }
    
    func applySnapshot(with photos: [Photo]) {
        var snapShot = NSDiffableDataSourceSnapshot<Int, Photo>()
        snapShot.appendSections([0]) // 주의: section하나를 안넣어주면 에러
        snapShot.appendItems(photos)
        dataSource?.apply(snapShot)
    }
    
    func resetCollectionViewContentOffset(){
        DispatchQueue.main.async {
            let topPoint = CGPoint(x: 0, y: -self.view.safeAreaInsets.top)
            self.collectionView.setContentOffset(topPoint, animated: false)
        }
    }
}


// MARK: - UICollectionViewDelegate
extension PhotoCollectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == presenter.getPhotosCount() - 1 {
            presenter.nextPageFetchPhotos()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let image = UIImage(data: presenter.getImageData(indexPath.row)) else { return }
        
        presentToEditViewController(image: image)
    }
}

// MARK: - CustomLayoutDelegate
extension PhotoCollectionViewController: CustomLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForImageAtIndexPath indexPath: IndexPath) -> CGFloat {
        let cellWidth = UIScreen.main.bounds.width / 2
        let imageWidth = presenter.getPhotoWidth(indexPath.row)
        let imageHeight = presenter.getPhotoHeight(indexPath.row)
        let imageRatio = imageHeight / imageWidth
        
        return CGFloat(imageRatio) * cellWidth
    }
    
    func numberOfItemsInCollectionView() -> Int {
        return dataSource?.snapshot().numberOfItems ?? 0
    }
}

// MARK: - CropViewControllerDelegate
extension PhotoCollectionViewController: CropViewControllerDelegate{
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        delegate.setBackgroundImage(image)

        cropViewController.dismiss(animated: true)
        dismiss(animated: true, completion: nil)

    }

    func cropViewController(_ cropViewController: CropViewController, didFinishCancelled cancelled: Bool) {
        cropViewController.dismiss(animated: true)
    }
}
