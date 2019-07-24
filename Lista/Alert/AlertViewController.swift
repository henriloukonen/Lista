//
//  AlertViewController.swift
//  ListaV3
//
//  Created by Henri Loukonen on 02/07/2019.
//  Copyright © 2019 Henri Loukonen. All rights reserved.
//

import UIKit

class AlertViewController: UIViewController {
    @IBOutlet var actionButton: UIButton!
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var alertMsg: UILabel!
    @IBOutlet var alertTitle: UILabel!
    @IBOutlet var backgroundView: UIView!
    @IBOutlet var titleBG: UIView!
    
    var actionButtonTitle = String()
    var titleForAlert = String()
    var body = String()
    var amount = Int()
    var itemName = String()
    var tag = Int()
    var buttonAction: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        actionButton.layer.cornerRadius = 4
        cancelButton.layer.cornerRadius = 4
        backgroundView.layer.cornerRadius = 7
    
        
//        backgroundView.layer.masksToBounds = false
//        backgroundView.layer.shadowColor = UIColor.black.cgColor
//        backgroundView.layer.shadowOpacity = 0.7
//        backgroundView.layer.shadowOffset = CGSize(width: -1, height: 1)
//        backgroundView.layer.shadowRadius = 5
//        backgroundView.layer.shadowPath = UIBezierPath(rect: backgroundView.bounds).cgPath
//        backgroundView.layer.shouldRasterize = true
//        backgroundView.layer.rasterizationScale = UIScreen.main.scale
        
        actionButton.setTitle(actionButtonTitle, for: .normal)
        alertTitle?.text = titleForAlert
        alertMsg?.text = body
        
        
        //        bgView.layer.borderWidth = 1
        //        bgView.layer.borderColor = Style.CategoryColors.darkGray.cgColor
        
    }
    
    static func newAlert(buttonTitle: String, title: String, message: String, completion: @escaping () -> Void) -> AlertViewController {
        let storyboard = UIStoryboard(name: "Alert", bundle: nil)
        let alertVC = storyboard.instantiateViewController(withIdentifier: "AlertVC") as! AlertViewController
        
        //        alertVC.titleLabel.text = title
        
        alertVC.actionButtonTitle = buttonTitle
        alertVC.buttonAction = completion
        alertVC.titleForAlert = title
        alertVC.body = message
        
        return alertVC
    }
    static func editItem(title: String, amount: Int, tag: Int) {
        
    }

    
    //    @IBAction func taptoClose(_ gestureRecognizer : UITapGestureRecognizer ) {
    //        guard gestureRecognizer.view != nil else { return }
    //
    //        if gestureRecognizer.state == .ended {
    //            dismiss(animated: true, completion: nil)
    //            itemTextField.resignFirstResponder()
    //        }
    //    }
    
    @IBAction func addAction(_ sender: UIButton) {
        buttonAction?()
    }
    
    @IBAction func cancel(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
