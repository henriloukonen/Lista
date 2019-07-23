//
//  SettingsTableViewController.swift
//  Lista
//
//  Created by Henri Loukonen on 22/07/2019.
//  Copyright © 2019 Henri Loukonen. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    @IBOutlet var darkmodeSwitch: UISwitch!
    @IBOutlet var currentSortSetting: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Settings"
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    @IBAction func closeButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}


extension SettingsTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
