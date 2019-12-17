//
//  LikedCell.swift
//  Mure
//
//  Created by JimmGrown on 17.12.2019.
//  Copyright © 2019 JimmGrown. All rights reserved.
//

import UIKit

class LikedCell: UITableViewCell {
    
    @IBOutlet weak var songImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    
    func setup(_ card: Card) {
        nameLabel.text = String(card.name)
        descLabel.text = String(card.desc)
        downloadImage(from: URL(string: card.imageString)!)
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(from url: URL) {
        print("Download Started")
        getData(from: url) { [weak self] data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() {
                self?.songImage.image = UIImage(data: data)
            }
        }
    }
    
}
