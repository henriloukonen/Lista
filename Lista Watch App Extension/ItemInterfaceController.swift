//
//  ItemInterfaceController.swift
//  Lista Watch App Extension
//
//  Created by Henri Loukonen on 30/07/2019.
//  Copyright © 2019 Henri Loukonen. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class ItemInterfaceController: WKInterfaceController, WCSessionDelegate {
    @IBOutlet var label: WKInterfaceLabel!
    @IBOutlet var table: WKInterfaceTable!
    
    let session = WCSession.default
    var itemDict = [String : [Int64]]()
    
    override init() {
        super.init()
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
        
    }
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        // Configure interface objects here.
    }
  
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {}

    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
        if let receivedItems = userInfo["items"] as? [String : [Int64]] {
            itemDict = receivedItems
        }
        
        DispatchQueue.main.async {
            self.table.setNumberOfRows(self.itemDict.count, withRowType: "itemRow")
            var i = 0
            for (key, value) in self.itemDict {
                let row = self.table.rowController(at: i) as! Row
                row.item.setText(key)
                if value[0] < 1 { row.amount.setHidden(true) } else { row.amount.setText(String(value[0])) }
                row.rowGroup.setBackgroundColor(Color.tagColors[Int(value[1])])
                
                i += 1
            }
        }
    }
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        let row = table.rowController(at: rowIndex) as! Row
        row.item.setTextColor(Color.lightGray)
        row.rowGroup.setBackgroundColor(UIColor.black)
        
        print("tapped row \(rowIndex)")
    }
}
