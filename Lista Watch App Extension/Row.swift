//
//  Row.swift
//  Lista Watch App Extension
//
//  Created by Henri Loukonen on 31/07/2019.
//  Copyright © 2019 Henri Loukonen. All rights reserved.
//

import WatchKit

class Row: NSObject {

    @IBOutlet var tag: WKInterfaceSeparator!
    @IBOutlet var rowGroup: WKInterfaceGroup!
    @IBOutlet var amount: WKInterfaceLabel!
    @IBOutlet var item: WKInterfaceLabel!
}
