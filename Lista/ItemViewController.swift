//
//  ItemViewController.swift
//  ListaV3
//
//  Created by Henri Loukonen on 02/07/2019.
//  Copyright © 2019 Henri Loukonen. All rights reserved.
//

import UIKit
import CoreData

class ItemViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var newItemTextField: UITextField!
    @IBOutlet var amountTextField: UITextField!
    
    var oldName: String!
    var newName: String!
    var amountOfItems: Int64!
    var selectedTag: Int64!
    var passedItem: List! { //values that were passed from "edit" swipe action
        didSet {
            self.oldName = passedItem.item
            self.amountOfItems = passedItem.amount
            self.selectedTag = passedItem.tag
        }
    }
    
    let tags = TagControl()
    let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonAction))
    let amount: UIBarButtonItem = UIBarButtonItem(title: "Amount", style: .plain, target: self, action: #selector(amountActionButton))
    let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
    
    
    override func viewDidLoad() {
        title = "Add Item"
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationItem.largeTitleDisplayMode = .never
        
        done.isEnabled = false
        
        let items = [amount, flexSpace, done]
        doneToolbar.barStyle = .default
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        newItemTextField.becomeFirstResponder()
        
        if let oldItem = passedItem { //if user pressed "edit", set these values
            done.isEnabled = true
            title = oldItem.item
            newItemTextField.text = oldName
            amountTextField.text = String(amountOfItems)
        }
        newItemTextField.inputAccessoryView = doneToolbar
        amountTextField.inputAccessoryView = doneToolbar
    }

    
    //MARK: - Textfield handling
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
        guard let oldText = newItemTextField.text, let stringRange = Range(range, in: oldText) else { return false }
        
        let newText = oldText.replacingCharacters(in: stringRange, with: string)
        if newText.isEmpty {
            done.isEnabled = false
        } else {
            done.isEnabled = true
        }
        return true
    }
 
    
    @IBAction func closeVC(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
        dismiss(animated: true, completion: nil)
        newItemTextField.resignFirstResponder()
        amountTextField.resignFirstResponder()
    }
    
    @objc func amountActionButton() {
        amountTextField.becomeFirstResponder()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let text = newItemTextField.text, !text.isEmpty else { return }
        guard let amount = amountTextField.text, !text.isEmpty else { return }
        newName = text
        _ = oldName
        amountOfItems = Int64(amount) ?? 0
        
        
        if let tag = tags.currentlySelectedTag {
            selectedTag = Int64(tag)
        }
    }
    @objc func doneButtonAction() {
        performSegue(withIdentifier: "unwindAddItemVC", sender: nil)
        newItemTextField.resignFirstResponder()
        amountTextField.resignFirstResponder()
    }
}
