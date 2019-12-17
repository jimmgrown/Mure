import UIKit
import Koloda
import CoreData
import Foundation
import AVFoundation
import SwiftSpinner

var loadedCards = [Card]()

class ViewController: UIViewController {
    
    enum Action {
        case like
        case dislike
    }
    
    @IBOutlet weak var kolodaView: KolodaView!

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dislike: UILabel!
    @IBOutlet weak var like: UILabel!
    @IBOutlet weak var playStopButton: UIButton!

    var songPlayer: AVAudioPlayer?
    var likedSongs: [String] = []
    
    var dataIsLoad: Bool = false

    private var allCards = [Card]() {
        didSet {
            loadedCards = allCards
            kolodaView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        kolodaView.layer.cornerRadius = 20

        kolodaView.dataSource = self
        kolodaView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard !dataIsLoad else { return }
        
        SwiftSpinner.show("")
        API.loadCards { [weak self] cardsArray in
            SwiftSpinner.hide()
            self?.dataIsLoad = true
            self?.allCards = cardsArray
        }
        
        kolodaView.reloadData()
    }
    
    @IBAction func playStopAction(_ sender: Any) {
        guard let player = songPlayer else {
            return
        }
        
        if player.isPlaying {
            playStopButton.setImage(UIImage(named: "ic_play"), for: .normal)
            player.stop()
        } else {
            playStopButton.setImage(UIImage(named: "ic_pause"), for: .normal)
            player.play()
        }
    }
    
    @IBAction func likeAction(_ sender: Any) {
        songAction(.like, index: nil)
        kolodaView.swipe(.right)
    }
    
    @IBAction func dislikeAction(_ sender: Any) {
        songAction(.dislike, index: nil)
        kolodaView.swipe(.left)
    }

    func randomInt(min: Int, max: Int) -> Int {
        return min + Int(arc4random_uniform(UInt32(max - min + 1)))
    }
    
    func songAction(_ action: Action, index: Int?) {
        let currentIndex = index ?? kolodaView.currentCardIndex
        guard currentIndex < allCards.count else {
            return
        }
        
        let card = allCards[currentIndex]
        var likes = card.likes!
        var dislikes = card.dislikes!
        
        switch action {
        case .dislike:
            dislikes += 1
            card.isLiked = false
        case .like:
            likes += 1
            card.isLiked = true
        }
        
        let ids = allCards.filter { $0.isLiked }.map { $0.id }
        UserDefaults.standard.set(ids, forKey: "LikedCards")
        
        API.editCard(id: card.id, likes: likes, dislikes: dislikes) { result in
            if result {
                print("success!")
            } else {
                print("failed!")
            }
        }
    }
    
}

extension ViewController: KolodaViewDelegate {
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        koloda.reloadData()
    }

    func koloda(_ koloda: KolodaView, didSelectCardAt index: Int) {
        //    let alert = UIAlertController(title: "Congratulation!", message: "Now you're \(cards[index])", preferredStyle: .alert)
        //    alert.addAction(UIAlertAction(title: "OK", style: .default))
        //    self.present(alert, animated: true)
    }
}

extension ViewController: KolodaViewDataSource {

    func kolodaNumberOfCards(_ koloda:KolodaView) -> Int {
        return allCards.count
    }

    func koloda(_ koloda: KolodaView, didSwipeCardAt index: Int, in direction: SwipeResultDirection) {
        switch direction {
        case .left, .topLeft, .up, .bottomLeft:
            songAction(.dislike, index: index)
        case .right, .down, .topRight, .bottomRight:
            songAction(.like, index: index)
        }
    }


    func koloda(_ koloda: KolodaView, didShowCardAt index: Int) {
        self.songPlayer?.stop()
        
        let card = allCards[index]
        nameLabel.text = allCards[index].name
        descriptionLabel.text = allCards[index].desc
        let url = URL(string: card.audioString)!
        downloadFileFromURL(url: url)
    }

    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        let cardView = CardView.instanceFromNib()
        cardView.setup(allCards[index])
        return cardView
    }
}

extension ViewController {
    
    func downloadFileFromURL(url: URL) {
        let downloadTask = URLSession.shared.downloadTask(with: url) { [weak self] url, response, error -> Void in
            guard let self = self, let url = url else {
                return
            }
            self.play(url: url)
        }

        downloadTask.resume()
    }
    
    func play(url: URL) {
        print("playing \(url)")

        do {
            self.songPlayer = try AVAudioPlayer(contentsOf: url)
            self.songPlayer?.prepareToPlay()
            self.songPlayer?.volume = 1.0
            self.songPlayer?.play()
        } catch let error {
            print(error.localizedDescription)
        }
        
    }
    
}

