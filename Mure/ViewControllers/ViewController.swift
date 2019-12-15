import UIKit
import Koloda
import CoreData
import Foundation
import AVFoundation

class ViewController: UIViewController {

  @IBOutlet weak var kolodaView: KolodaView!

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dislike: UILabel!
    @IBOutlet weak var like: UILabel!
    
    var songPlaying: AVAudioPlayer?
    private var cards = [Card]() {
        didSet {
            kolodaView.reloadData()
        }
    }
    
    
    @IBAction func resetCards(_ sender: Any) {
            kolodaView.revertAction()
        
    }

    func randomInt(min: Int, max: Int) -> Int {
        return min + Int(arc4random_uniform(UInt32(max - min + 1)))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        API.loadCards { cardsArray in
            self.cards = cardsArray}
        kolodaView.reloadData()
    }
    
  override func viewDidLoad() {
    super.viewDidLoad()
    kolodaView.layer.cornerRadius = 20
    kolodaView.clipsToBounds = true
    kolodaView.dataSource = self
    kolodaView.delegate = self
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
    return cards.count
  }
  
    func koloda(_ koloda: KolodaView, didSwipeCardAt index: Int, in direction: SwipeResultDirection) {
//        switch(direction.rawValue)
//        {
//        case "right":
            let likes = cards[index].likes
            let likesInc = Int(likes!)!+1
            API.editCard(idCard: String(index),name: cards[index].name!, description:cards[index].description!,imageString: cards[index].imageString!,likes: String(likesInc), dislikes: cards[index].dislikes!, audioString:cards[index].audioString!){
                result in
                guard result else{return}
            }
//            break;
//        case "left":
//            let dislikes = cards[index].dislikes
//            let dislikesInc = Int(dislikes!)!+1
//            API.editCard(idCard: String(index),name: cards[index].name!, description:cards[index].description!,imageString: cards[index].imageString!,likes: cards[index].likes!, dislikes: String(dislikesInc), audioString:cards[index].audioString!){
//                result in
//                guard result else{return}
//            }
//            break;
//        default:break;
//        }
    }
        
        
    func koloda(_ koloda: KolodaView, didShowCardAt index: Int) {
        let card = cards[index]
        nameLabel.text = card.name
        descriptionLabel.text = card.description
        like.text = card.likes
        dislike.text = card.dislikes
        print(index)
        
        let url = URL(fileURLWithPath:card.audioString! )
        DispatchQueue.main.async{
            do {
                self.songPlaying = try AVAudioPlayer(contentsOf: url)
                self.songPlaying?.play()
            } catch {
                // couldn't load file :(
            }
        }
    }
  func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
    let card = cards[index]
    let imageString = card.imageString
    let imageData = NSData(base64Encoded: imageString!, options: Data.Base64DecodingOptions.ignoreUnknownCharacters)! as Data
    let imageCell: UIImage = UIImage(data: imageData)!
    let view = UIImageView(image: imageCell)
    view.layer.cornerRadius = 20
    view.contentMode = .scaleAspectFill
    view.clipsToBounds = true
    return view
  }
}

