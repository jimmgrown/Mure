import Foundation

typealias JSON = [String : Any]

enum API {
    
    static var identifier: String { return "mure-test02"}
    static var baseURL: String { return "https://ios-napoleonit.firebaseio.com/data/\(identifier)/" }
    
    static func editCard(id: String, likes: Int, dislikes: Int, completion: @escaping (Bool) -> Void) {
        let params = [
            "likes": likes,
            "dislikes": dislikes
        ]
        
        let url = URL(string: baseURL + "/notes/\(id)/.json")!
        var request = URLRequest(url: url)
        
        request.httpMethod = "PATCH"
        request.httpBody = try? JSONSerialization.data(withJSONObject: params)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            completion(error == nil)
        }
        task.resume()
    }
    
    static func loadCards(completion: @escaping ([Card]) -> Void) {
        let url = URL(string: baseURL + ".json")!
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error
            in
            guard
                let data = data,
                let json = try? JSONSerialization.jsonObject(with: data, options: [])
                    as? JSON
            else {
                DispatchQueue.main.async {
                    completion(Card.allObject())
                }
                return
            }
            
            DispatchQueue.main.async {
                let cardsJSON = json!["notes"] as! JSON
                var cards = [Card]()
                
                for card in cardsJSON {
                    cards.append(Card(data: card.value as! JSON, id: card.key))
                }
                
                let selectedGenres = UserDefaults.standard.value(forKey: "SelectedGenreArray") as! Array<String>
                
                cards.sort { $0.id < $1.id }
                cards = cards.filter { selectedGenres.index(of: $0.genre) != nil }
            
                completion(cards)
            }
            
        }
        task.resume()
    }
    
}
