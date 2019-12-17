//
//  Genre.swift
//  Mure
//
//  Created by JimmGrown on 15.12.2019.
//  Copyright © 2019 JimmGrown. All rights reserved.
//

import UIKit

class Genre {
    
    let name: String
    var isSelected: Bool = false
    
    var image: UIImage? {
        return UIImage(named: name)
    }
    
    init(name: String) {
        self.name = name
    }
    
    static var all: [Genre] {
        return allNames.map { Genre(name: $0) }
    }
    
    private static var allNames: [String] {
        return ["Rock", "Pop", "Jazz", "Rap", "Alternative", "Indi", "Electronic", "Club"]
    }
    
}
