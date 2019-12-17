//
//  LikedViewController.swift
//  
//
//  Created by JimmGrown on 16.12.2019.
//

import UIKit

class LikedViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private var cards: [Card] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let ids = UserDefaults.standard.value(forKey: "LikedCards") as! [String]
        cards = loadedCards.filter { ids.firstIndex(of: $0.id) != nil }
    }
    
}

extension LikedViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LikedCell") as! LikedCell
        cell.setup(cards[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let card = cards[indexPath.row]
        let name = card.name!.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        if let url = URL(string: "https://www.google.com/search?q=\(name)") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
}
