//
//  TagControl.swift
//  Lista
//
//  Created by Henri Loukonen on 19/07/2019.
//  Copyright © 2019 Henri Loukonen. All rights reserved.
//

import UIKit

class TagControl: UIStackView {

    var lastSelectedTag: UIButton!
//    lazy var tags: [UIColor] = [#colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1), #colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1), #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1), #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1), #colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1)]
    lazy var tags: [UIColor] = [#colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1), #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1), #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1), #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1), #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTags()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupTags()
    }
    
    private func setupTags() {
        
        for i in 0..<tags.count {
            let tag = UIButton()
            
            tag.backgroundColor = tags[i]
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
        print("button \(button.tag) is selected")
        
        if let selectedTag = lastSelectedTag { //if lastSelectedTag contains a button, set it to false
            selectedTag.isSelected = false
            
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 3, options: [.curveEaseOut], animations: {
                selectedTag.alpha = 0.7
                selectedTag.transform = CGAffineTransform(translationX: 1, y: 1)
                selectedTag.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            })
        }
            
            lastSelectedTag = button //set the button that was pressed as the lastSelectedTag
            
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 3, options: [.curveEaseOut], animations: {
                button.alpha = 1
//                button.transform = CGAffineTransform(translationX: 1, y: -7)
                button.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
            
            button.isSelected = true
        
    }
}
