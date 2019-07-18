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
    @IBOutlet var categoryView: UIView!
    var color: UIColor!
    
    
    func configureCell(from list: List, with colorTag: String) {
        itemLabel?.text = list.item
        amountLabel?.text = (list.amount<=1) ? nil : String(list.amount)
        
        switch colorTag {
        case ColorTag.cyan:
            color = Color.cyan
        case ColorTag.limeGreen:
            color = Color.limeGreen
        case ColorTag.blue:
            color = Color.blue
        case ColorTag.purple:
            color = Color.purple
        default:
            color = nil
        }
        categoryView.backgroundColor = color
    }
}


