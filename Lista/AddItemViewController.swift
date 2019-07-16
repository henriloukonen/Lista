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

    var itemName: String!

    
    override func viewDidLoad() {
        title = "Add Item"
        navigationController?.navigationItem.largeTitleDisplayMode = .never
        newItemTextField.becomeFirstResponder()
        addDoneButtonOnKeyboard()
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
    
    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Add", style: .done, target: self, action: #selector(doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        newItemTextField.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction() {
        performSegue(withIdentifier: "unwindAddItemVC", sender: nil)
    }
}
