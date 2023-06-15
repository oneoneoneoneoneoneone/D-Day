//
//  PhotoCollectionViewCell.swift
//  D-Day
//
//  Created by hana on 2023/06/13.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    static let identifier = String(describing: PhotoCollectionViewCell.self)
    
    var photo: Photo? {
        didSet {
            guard let url = URL(string: photo?.urls.regular ?? "") else { return }
            
            photoImageView.downloadPhoto(url)
        }
    }
    
    private let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private var imageDataTask: URLSessionDataTask?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout(){
        addSubview(photoImageView)
        photoImageView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
    }
}
