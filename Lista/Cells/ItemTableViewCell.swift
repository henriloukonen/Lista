//
//  ItemTableViewCell.swift
//  Lista
//
//  Created by Henri Loukonen on 12/07/2019.
//  Copyright © 2019 Henri Loukonen. All rights reserved.
//

import UIKit

class ItemTableViewCell: UITableViewCell {

    @IBOutlet var itemLabel: UILabel!
    @IBOutlet var categoryView: UIView!
    var color: UIColor!
    
    
    func configureCell(from list: List, with categoryColor: String) {
        itemLabel?.text = list.item
        
        switch categoryColor {
        case ColorTag.cyan:
            color = Color.cyan
        case ColorTag.lime:
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


