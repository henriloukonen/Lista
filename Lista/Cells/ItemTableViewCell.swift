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
    
    var color: UIColor!
  

    
    func configureCell(from entity: List) {
        itemLabel?.text = entity.item
        amountLabel?.text = (entity.amount<1) ? nil : String(entity.amount)
        
//        switch tagColor {
//        case Color.cyan:
//            color = Color.cyan
//        case Color.limeGreen:
//            color = Color.lime
//        case Color.blue:
//            color = Color.blue
//        case Color.purple:
//            color = Color.purple
//        default:
//            color = nil
//        }
        
        //Style the cell
        
        _ = SeparatorStyle.none
        _ = layer.borderWidth = 2
        _ = layer.borderColor = UIColor.white.cgColor
    }
}


