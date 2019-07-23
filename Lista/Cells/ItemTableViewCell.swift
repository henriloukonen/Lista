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
    
    func configureCell(from entity: List) {
        itemLabel?.text = entity.item
        amountLabel?.text = (entity.amount<1) ? nil : String(entity.amount)

        //Style the cell
        if entity.isDone {
            itemLabel?.textColor = Color.lightGray
            itemLabel?.alpha = 0.4
            itemLabel?.transform = CGAffineTransform(translationX: 25, y: 0)
            itemLabel?.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        } else {
            itemLabel?.textColor = nil
            itemLabel?.alpha = 1
            itemLabel?.transform = .identity
            itemLabel?.transform = .identity
        }
        
        _ = SeparatorStyle.none
        _ = layer.borderWidth = 2
        _ = layer.borderColor = UIColor.white.cgColor
    }
//    func animateMarking() {
//        UIView.animate(withDuration: 1, delay: 0.3, options: [], animations: {
//            
//        })
//    }
}


