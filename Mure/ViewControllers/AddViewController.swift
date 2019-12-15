//
//  AddViewController.swift
//  Business Cards List
//
//  Created by MacBook Pro on 02.12.2019.
//  Copyright © 2019 Ilya. All rights reserved.
//
import Foundation
import UIKit
import CoreData

class AddViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//
    private var cards = [Card]()
//
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionText: UITextField!
    @IBOutlet weak var name: UITextField!

    var titleText = "Добавить Mure"
    var addPhotoText = "Добавить Фото"
    var card: NSManagedObject? = nil
    var indexPathForCard: IndexPath? = nil
    var imageStringData: String = ""

    @IBOutlet weak var addPhotoLabel: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        API.loadCards { cardsArray in
            self.cards = cardsArray}
        titleLabel.text = titleText
        addPhotoLabel.setTitle(addPhotoText, for: .normal)
        if let card = self.card {
            let imageString = card.value(forKey: "imageString") as! String
            let imageData = NSData(base64Encoded: imageString, options: Data.Base64DecodingOptions.ignoreUnknownCharacters)! as Data
            let imageCell: UIImage = UIImage(data: imageData)!
            imageView.image = imageCell
            imageView.contentMode = .scaleAspectFill
            name.text = card.value(forKey: "name") as? String
            descriptionText.text = card.value(forKey: "descriptionText") as? String
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func saveAndClose(_ sender: Any) {
//        performSegue(withIdentifier: "unwindToCardList", sender: self)
        let name = self.name.text!
        let descriptionText = self.descriptionText.text!
        let imageString = self.imageStringData
        let testUrlMusic = "https://yadi.sk/d/svBVKVGaZ8PfaA"
        let id = String(cards.count)
        API.createCard(idCard: id, name: name, description: descriptionText, imageString: imageString, likes: "0", dislikes: "0",audioString:testUrlMusic ){
                        result in
                        guard result else{return}
                    }
    }

    @IBAction func close(_ sender: Any) {
        name.text = nil
        descriptionText.text = nil
    }

//-------> AddPhoto


    @IBOutlet weak var imageView: UIImageView!
    @IBAction func addPhoto(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        let actionPhoto = UIAlertController(title: "Источник фото", message: "Выберите источник", preferredStyle: .actionSheet)
        actionPhoto.addAction(UIAlertAction(title: "Камера", style: .default, handler: { (action: UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
            } else {
                print("Камера недоступна")
            }

        }))
        actionPhoto.addAction(UIAlertAction(title: "Библиотека", style: .default, handler: {(action: UIAlertAction) in
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        actionPhoto.addAction(UIAlertAction(title: "Отменить", style: .cancel, handler: nil))
        self.present(actionPhoto, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        imageView.image = image

        let imageData: Data? = image.jpegData(compressionQuality: 0.4)
        let imageStr = imageData?.base64EncodedString(options: .lineLength64Characters) ?? ""
        imageStringData = imageStr
//        print(imageStr,"imageString")

        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }





    
//------> End AddPhoto
    

    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
