//
//  Extensions.swift
//  Mure
//
//  Created by JimmGrown on 17.12.2019.
//  Copyright © 2019 JimmGrown. All rights reserved.
//

import UIKit
import RealmSwift

extension UIColor {
    static func random() -> UIColor {
        return UIColor(red:   .random(),
                       green: .random(),
                       blue:  .random(),
                       alpha: 1.0)
    }
    
    static var gradients: [[CGColor]] = [
        [UIColor(hex: "#FE8C00")!.cgColor, UIColor(hex: "#F83600")!.cgColor],
        [UIColor(hex: "#00c6ff")!.cgColor, UIColor(hex: "#0072ff")!.cgColor],
        [UIColor(hex: "#70e1f5")!.cgColor, UIColor(hex: "#ffd194")!.cgColor],
        [UIColor(hex: "#556270")!.cgColor, UIColor(hex: "#FF6B6B")!.cgColor],
        [UIColor(hex: "#9D50BB")!.cgColor, UIColor(hex: "#6E48AA")!.cgColor],
        [UIColor(hex: "#000000")!.cgColor, UIColor(hex: "#e74c3c")!.cgColor],
        [UIColor(hex: "#F0C27B")!.cgColor, UIColor(hex: "#4B1248")!.cgColor],
        [UIColor(hex: "#FF4E50")!.cgColor, UIColor(hex: "#F9D423")!.cgColor],
        [UIColor(hex: "#F0C27B")!.cgColor, UIColor(hex: "#4B1248")!.cgColor],
        [UIColor(hex: "#ADD100")!.cgColor, UIColor(hex: "#7B920A")!.cgColor],
        [UIColor(hex: "#FBD3E9")!.cgColor, UIColor(hex: "#FBD3E9")!.cgColor],
        [UIColor(hex: "#606c88")!.cgColor, UIColor(hex: "#3f4c6b")!.cgColor],
        [UIColor(hex: "#C9FFBF")!.cgColor, UIColor(hex: "#FFAFBD")!.cgColor],
        [UIColor(hex: "#649173")!.cgColor, UIColor(hex: "#DBD5A4")!.cgColor],
        [UIColor(hex: "#B993D6")!.cgColor, UIColor(hex: "#8CA6DB")!.cgColor],
    ]
}

extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

extension UIImage {
    static func gradientImageWithBounds(bounds: CGRect, colors: [CGColor]) -> UIImage {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = colors
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        
        UIGraphicsBeginImageContext(gradientLayer.bounds.size)
        gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}

extension UIColor {
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            if hexColor.count == 6 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = 1

                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }

        return nil
    }
}

protocol RealmObjectExtensible where Self: Object {}
extension RealmObjectExtensible {
    
    static func byPrimaryKey(_ id: String) -> Self? {
        let realm = try! Realm()
        return realm.object(ofType: Self.self, forPrimaryKey: id)
    }
    
}
extension Object: RealmObjectExtensible {}
