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
        
        _ = SeparatorStyle.none
        _ = layer.borderWidth = 2
        _ = layer.borderColor = UIColor.white.cgColor
    }
    func configureSelectedCell() {
        itemLabel?.alpha = 0.6
        UIView.animate(withDuration: 2, delay: 1, usingSpringWithDamping: 0.4, initialSpringVelocity: 2, options: [], animations: {
            self.itemLabel?.transform =  CGAffineTransform(translationX: 20, y: 0)
            })
    }
}


