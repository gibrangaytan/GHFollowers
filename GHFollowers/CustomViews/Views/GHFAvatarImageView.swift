//
//  GHFAvatarImageView.swift
//  GHFollowers
//
//  Created by GIBRAN I GAYTAN SILVA on 11/1/22.
//

import UIKit

class GHFAvatarImageView: UIImageView {
    
    let placeholderImage = UIImage(named: "avatar-placeholder")!

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        layer.cornerRadius = 10
        clipsToBounds = true
        image = placeholderImage
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    func downloadImage(from urlString: String){
        GHFNetworkManager.shared.downloadImage(from: urlString) { [weak self ]result in
            guard let self = self else { return }
            switch result {
            case.success(let image):
                DispatchQueue.main.async {
                    self.image = image
                }
            case .failure( _):
                self.image = self.placeholderImage
            }
        }
    }
}
