//
//  Card.swift
//  Business Cards List
//
//  Created by Ilya on 30.11.2019.
//  Copyright © 2019 Ilya. All rights reserved.
//

class Card {
    
    static var shared = [Card]()
    
    var idCard: String?
    var name: String?
    var description: String?
    var imageString: String?
    var likes: String?
    var dislikes: String?
    var audioString: String?
//    var iconName: String?
    
    init(data: JSON) {
        self.idCard = data["idCard"] as! String?
        self.name = data["name"] as! String?
        self.description = data["description"] as! String?
        self.imageString = data["imageString"] as! String?
        self.likes = data["likes"] as! String?
        self.dislikes = data["dislikes"] as! String?
        self.audioString = data["audioString"] as! String?
//        self.iconName   = data["iconName"] as! String?
        
        // MARK: - Initialization
    
    }
}
