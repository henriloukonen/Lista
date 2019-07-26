//
//  ItemTableViewCell.swift
//  Lista
//
//  Created by Henri Loukonen on 12/07/2019.
//  Copyright © 2019 Henri Loukonen. All rights reserved.
//

import UIKit

class ItemTableViewCell: UITableViewCell {
    @IBOutlet var amountLabel: UILabel!
    @IBOutlet var itemLabel: UILabel!
    @IBOutlet var tagView: UIView!
    let tags = TagControl()
    
    func configureCell(from entity: List) {
        itemLabel?.text = entity.item
        amountLabel?.text = (entity.amount<1) ? nil : String(entity.amount)
        tagView.backgroundColor = tags.tagsArray[Int(entity.tag)]
        
        //Style the cell
        if entity.isDone {
            itemLabel?.textColor = Color.lightGray
            amountLabel?.textColor = Color.lightGray
            itemLabel?.alpha = 0.4
            itemLabel?.transform = CGAffineTransform(translationX: 55, y: 0)
            itemLabel?.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            amountLabel?.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            tagView.alpha = 0.4
            _ = backgroundColor = #colorLiteral(red: 0.9780562804, green: 0.9780562804, blue: 0.9780562804, alpha: 1)
        } else {
            itemLabel?.textColor = nil
            amountLabel?.textColor = nil
            itemLabel?.alpha = 1
            tagView.alpha = 1
            itemLabel?.transform = .identity
            itemLabel?.transform = .identity
            amountLabel?.transform = .identity
            _ = backgroundColor = #colorLiteral(red: 0.8996073921, green: 0.8996073921, blue: 0.8996073921, alpha: 1)
        }
        
        _ = SeparatorStyle.none
//        _ = layer.borderWidth = 2
        _ = layer.cornerRadius = 1
//        _ = layer.borderColor = UIColor.white.cgColor
    }
//    func animateMarkAsDone(using item: Bool) {
//        if item {
//            DispatchQueue.main.async {
//                UIView.animate(withDuration: 0.3, delay: 0.7, usingSpringWithDamping: 0.4, initialSpringVelocity: 6, options: [.curveEaseInOut], animations: {
//                    self.itemLabel?.textColor = Color.lightGray
//                    self.amountLabel?.textColor = Color.lightGray
//                    self.itemLabel?.alpha = 0.4
//                    self.itemLabel?.transform = CGAffineTransform(translationX: 55, y: 0)
//                    self.itemLabel?.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
//                    self.amountLabel?.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
//                    self.backgroundColor = #colorLiteral(red: 0.9780562804, green: 0.9780562804, blue: 0.9780562804, alpha: 1)
//
//                })
//            }
//        } else {
//            DispatchQueue.main.async {
//                UIView.animate(withDuration: 0.3, delay: 0.7, usingSpringWithDamping: 0.4, initialSpringVelocity: 6, options: [.curveEaseInOut], animations: {
//                    self.itemLabel?.textColor = nil
//                    self.amountLabel?.textColor = nil
//                    self.itemLabel?.alpha = 1
//                    self.itemLabel?.transform = .identity
//                    self.amountLabel?.transform = .identity
//                    self.backgroundColor = #colorLiteral(red: 0.8996073921, green: 0.8996073921, blue: 0.8996073921, alpha: 1)
//                })
//            }
//        }
//    }
}


