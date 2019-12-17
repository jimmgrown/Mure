//
//  GenreViewController.swift
//  Mure
//
//  Created by JimmGrown on 15.12.2019.
//  Copyright © 2019 JimmGrown. All rights reserved.
//

import UIKit

class GenreViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let genres = Genre.all
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(UINib(nibName: "GenreCell", bundle: nil), forCellWithReuseIdentifier: "genreCell")
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.reloadData()
    }
    
    @IBAction func saveGenre(_ sender: UIButton) {
        var selectedGenreArray: [String] = []
        genres.forEach { genre in
            if genre.isSelected {
                selectedGenreArray.append(genre.name)
            }
        }
        
        if selectedGenreArray.count == 0 {
            selectedGenreArray.append(contentsOf: genres.map { $0.name })
        }
        
        UserDefaults.standard.set(selectedGenreArray, forKey: "SelectedGenreArray")
        
        guard let window = UIApplication.shared.keyWindow else {
            return
        }   
        
        let vc = RootViewController.instance()
        window.rootViewController = vc
        
        let options: UIView.AnimationOptions = .transitionCrossDissolve
        let duration: TimeInterval = 0.3
        UIView.transition(with: window, duration: duration, options: options, animations: {}, completion:
            nil)
    }
    
}

extension GenreViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return genres.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "genreCell", for: indexPath) as! GenreCell
        cell.setup(genres[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let side = (UIScreen.main.bounds.size.width - 80) / 2
        return CGSize(width: side, height: side)
    }
    
}
