//
//  CardView.swift
//  Mure
//
//  Created by JimmGrown on 15.12.2019.
//  Copyright © 2019 JimmGrown. All rights reserved.
//

import UIKit

class XibInitializableView: UIView {
    class func instanceFromNib() -> Self {
        return UINib(nibName: String(describing: self), bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! Self
    }
}

class CardView: XibInitializableView {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var likesLabel: UILabel!
    
    func setup(_ card: Card) {
        likesLabel.text = String(card.likes)
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
                self?.imageView.image = UIImage(data: data)
            }
        }
    }

    
}
