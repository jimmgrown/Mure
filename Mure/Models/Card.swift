//
//  Card.swift
//  Business Cards List
//
//  Created by Ilya on 30.11.2019.
//  Copyright © 2019 Ilya. All rights reserved.
//

import RealmSwift

class Card: Object {
    
    static var shared = [Card]()
    
    var id: String!
    var genre: String!
    var name: String!
    var desc: String!
    var imageString: String!
    var likes: Int!
    var dislikes: Int!
    var audioString: String!
    var isLiked: Bool = false
    
    convenience init(data: JSON, id: String) {
        self.init()
        
        self.id = id
        self.genre = data["genre"] as? String
        self.name = data["name"] as? String
        self.desc = data["description"] as? String
        self.imageString = data["imageString"] as? String
        self.likes = (data["likes"] as? Int) ?? 0
        self.dislikes = (data["dislikes"] as? Int) ?? 0
        self.audioString = data["audioString"] as? String
        
        let savedCard = Card.byPrimaryKey(id)
        self.isLiked = savedCard?.isLiked ?? false
        
        let realm = try! Realm()
        try! realm.write() {
            realm.add(self, update: .all)
        }
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    static func allObject() -> [Card] {
        let realm = try! Realm()
        return realm.objects(Card.self).map { $0 }
    }
    
    func saveObject() {
        let realm = try! Realm()
        try! realm.write() {
            realm.add(self, update: .modified)
        }
    }
    
}
