//
//  Constants.swift
//  Lista
//
//  Created by Henri Loukonen on 12/07/2019.
//  Copyright © 2019 Henri Loukonen. All rights reserved.
//

import UIKit

enum Entity {
    enum Name {
        static let list = "List"
        static let tag  = "Tag"
    }
    enum Attribute {
        static let itemName   = "item"
        static let date       = "dateAdded"
        static let tag        = "tag"
        static let amount     = "amount"
        static let isDone     = "isDone"
    }
}

enum Color {
    static var tagColors: [UIColor] = [Color.clear, Color.blue, Color.cyan, Color.purple, Color.lime, Color.orange]
    static let clear     = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
    static let lime      = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
    static let blue      = #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)
    static let purple    = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
    static let orange    = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
    static let cyan      = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
    static let gray      = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
    static let lightGray = #colorLiteral(red: 0.4779320108, green: 0.5174674322, blue: 0.5749025791, alpha: 1)
}

enum PreferDarkmode {
    
}
