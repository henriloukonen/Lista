//
//  AddItemViewController.swift
//  ListaV3
//
//  Created by Henri Loukonen on 02/07/2019.
//  Copyright © 2019 Henri Loukonen. All rights reserved.
//

import UIKit

class AddItemViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var newItemTextField: UITextField!
    @IBOutlet var amountTextField: UITextField!
    
    
    var itemName: String!
    var category: String!
    var amountOfItems: Int!
    
    let done: UIBarButtonItem = UIBarButtonItem(title: "Add", style: .done, target: self, action: #selector(doneButtonAction))
    let amount: UIBarButtonItem = UIBarButtonItem(title: "Amount", style: .plain, target: self, action: #selector(addAmount))
    let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    
    let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
    
    
    override func viewDidLoad() {
        title = "Add Item"
        navigationController?.navigationItem.largeTitleDisplayMode = .never
        
        let items = [amount, flexSpace, done]
        
//        newItemTextField.layer.cornerRadius = 10
//        amountTextField.layer.cornerRadius = 10
        
        
        newItemTextField.becomeFirstResponder()
        
        done.isEnabled = false
        
        doneToolbar.barStyle = .default
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        newItemTextField.inputAccessoryView = doneToolbar
        amountTextField.inputAccessoryView = doneToolbar
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        doneButtonAction()
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        newItemTextField.text = ""
        done.isEnabled = false
        return false
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let oldText = newItemTextField.text,
            let stringRange = Range(range, in: oldText) else {
                return false
        }
        let newText = oldText.replacingCharacters(in: stringRange, with: string)
        if newText.isEmpty {
            done.isEnabled = false
        } else {
            done.isEnabled = true
        }
        return true
    }

    
    @IBAction func closeVC(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        newItemTextField.resignFirstResponder()
        amountTextField.resignFirstResponder()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let text = newItemTextField.text, !text.isEmpty else {
            return
        }
        itemName = text
        category = "limeGreen"
    }
    
    @objc func addAmount() {
        amountTextField.becomeFirstResponder()
    }
    @objc func doneButtonAction() {
        performSegue(withIdentifier: "unwindAddItemVC", sender: nil)
        newItemTextField.resignFirstResponder()
        amountTextField.resignFirstResponder()
    }
}
