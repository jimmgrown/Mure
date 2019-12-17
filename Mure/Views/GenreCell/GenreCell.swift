//
//  Genre.swift
//  Mure
//
//  Created by JimmGrown on 15.12.2019.
//  Copyright © 2019 JimmGrown. All rights reserved.
//

import UIKit

class GenreCell: UICollectionViewCell {
    
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var genreBackground: UIView!
    @IBOutlet weak var genreImage: UIImageView!
    
    @IBOutlet weak var imageWidth: NSLayoutConstraint!
    @IBOutlet weak var imageHeight: NSLayoutConstraint!
    
    private var genre: Genre!
    
    func setup(_ genre: Genre) {
        self.genre = genre
        
        genreLabel.text = genre.name
        
        if genre.isSelected {
            genreLabel.textColor = .systemYellow
        }
        
        let side = (UIScreen.main.bounds.size.width - 80) / 2
        imageWidth.constant = side
        imageHeight.constant = side
        
        genreImage.image = UIImage.gradientImageWithBounds(bounds: CGRect(x: 0, y: 0, width: side, height: side), colors: UIColor.gradients.randomElement()!)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(genreSelected))
        self.addGestureRecognizer(tap)
    }
    
    @objc func genreSelected() {
        genre.isSelected = !genre.isSelected
        
        UIView.animate(withDuration: 0.3) {
            self.genreLabel.textColor = self.genre.isSelected ? .systemYellow : .white
        }
    }
    
}
