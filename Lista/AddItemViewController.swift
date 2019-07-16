//
//  AddItemViewController.swift
//  ListaV3
//
//  Created by Henri Loukonen on 02/07/2019.
//  Copyright © 2019 Henri Loukonen. All rights reserved.
//

import UIKit

class AddItemViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var addButton: UIBarButtonItem!
    @IBOutlet var newItemTextField: UITextField!
    @IBOutlet var categoryTableView: UITableView!
    var itemName: String!
    
    override func viewDidLoad() {
        title = "Add Item"
        navigationController?.navigationItem.largeTitleDisplayMode = .never
        newItemTextField.becomeFirstResponder()
    }
    
    @IBAction func closeVC(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        newItemTextField.resignFirstResponder()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let text = newItemTextField.text, !text.isEmpty else {
            return
        }
        itemName = text
        newItemTextField.resignFirstResponder()
    }
    
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        newItemTextField.text = ""
        addButton.isEnabled = false
        return false
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let oldText = newItemTextField.text,
            let stringRange = Range(range, in: oldText) else {
                return false
        }
        let newText = oldText.replacingCharacters(in: stringRange, with: string)
        if newText.isEmpty {
            addButton.isEnabled = false
        } else {
            addButton.isEnabled = true
        }
        return true
    }
}
