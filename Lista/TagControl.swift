//
//  TagControl.swift
//  Lista
//
//  Created by Henri Loukonen on 19/07/2019.
//  Copyright © 2019 Henri Loukonen. All rights reserved.
//

import UIKit

class TagControl: UIStackView {

    var lastSelectedTag: UIButton?
    var currentlySelectedTag: UIButton?
//    lazy var tagColors: [UIColor] = [Color.clear, Color.blue, Color.cyan, Color.purple, Color.lime, Color.orange]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTags()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupTags()
    }
    
    private func setupTags() {
       
        for i in 0..<Color.tagColors.count {
            
            let tag = UIButton()
            if i == 0 {
                tag.backgroundColor = Color.tagColors[0]
                tag.layer.borderColor = Color.lightGray.cgColor
                tag.layer.borderWidth = 1
                tag.setTitle("X", for: .normal)
                tag.setTitleColor(UIColor.black, for: .normal)
            } else {
                tag.backgroundColor = Color.tagColors[i]
            }
            tag.tag = i
            tag.layer.cornerRadius = 7
            tag.alpha = 0.7
            tag.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
//            tag.translatesAutoresizingMaskIntoConstraints = false
//            tag.widthAnchor.constraint(equalToConstant: 24.0).isActive = true
            tag.addTarget(self, action: #selector(TagControl.tagButtonTapped(button:)), for: .touchUpInside)
            
            addArrangedSubview(tag)
        }
        
    }

    
    @objc func tagButtonTapped(button: UIButton) {
        currentlySelectedTag = button
        
        let hapticFeedback = UIImpactFeedbackGenerator(style: .light)
        hapticFeedback.impactOccurred()
        
        if currentlySelectedTag?.tag == 0 {
            lastSelectedTag?.isSelected = false
        }
        
        if let selectedTag = lastSelectedTag { // if lastSelectedTag contains a button,
            selectedTag.isSelected = false     // set it to false
            
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 3, options: [.curveEaseOut], animations: {
                selectedTag.alpha = 0.7
                selectedTag.transform = CGAffineTransform(translationX: 1, y: 1)
                selectedTag.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            })
        }
            
            lastSelectedTag = button //set the button that was pressed as the lastSelectedTag
            
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 3, options: [.curveEaseOut], animations: {
                button.alpha = 1
                button.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
        currentlySelectedTag?.isSelected = true
    }
}
