//
//  CustomToggleControl.swift
//  Chomper
//
//  Created by Danning Ge on 1/5/17.
//  Copyright © 2017 Danning Ge. All rights reserved.
//

import Common

class CustomToggleControl: UIControl {
   
    let defaultColor = UIColor(red: 1, green: 140/255, blue: 0, alpha: 1)
    var selectedIndex: ((_ index: Int) -> Void)?
    private var labelTitles: [NSAttributedString]!
    private var labels =  [UILabel]()

    required init(titles: [NSAttributedString]) {
        labelTitles = titles
        super.init(frame: CGRect.zero)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let width = bounds.width / CGFloat(labels.count)
        let shadowRect = CGRect(x: 3, y: bounds.height - 3, width: bounds.width - 5, height: 8.0)
        let shadowColor = UIColor(red: 224/255, green: 224/255, blue: 224/255, alpha: 1).cgColor
        var frame: CGRect
        
        layer.cornerRadius = bounds.height / 2
        setShadow(shadowColor, opacity: 0.9, height: 8.0, shadowRect: shadowRect)

        for (index, label) in labels.enumerated() {
            frame = label.frame
            frame = CGRect(x: CGFloat(index) * width, y: 0, width: width, height: bounds.height)
            label.frame = frame
            label.clipsToBounds = true

            if index == 0 {
                label.layer.roundCorners(corners: [.topLeft, .bottomLeft], radius: label.bounds.height / 2)
            } else {
                label.layer.roundCorners(corners: [.topRight, .bottomRight], radius: label.bounds.height / 2)
            }
            
            if index != labels.count - 1 {
                let separator = UIView()
                addSubview(separator)
                separator.backgroundColor = UIColor(red: 168/255, green: 168/255, blue: 168/255, alpha: 1)
                frame = CGRect(x: label.frame.maxX, y: 0, width: 1, height: bounds.height)
                separator.frame = frame
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let location = touches.first?.location(in: self) {
            for (_, item) in labels.enumerated() {
                if item.frame.contains(location) {
                    item.layer.backgroundColor = UIColor.orange.cgColor
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        var calcIndex: Int?

        if let location = touches.first?.location(in: self) {
            for (index, item) in labels.enumerated() {
                if item.frame.contains(location) {
                    calcIndex = index
                    item.layer.backgroundColor = defaultColor.cgColor
                }
            }
            if let calcIndex = calcIndex {
                actionForSelectedIndex(index: calcIndex)
                sendActions(for: .touchUpInside)
            }
        }
    }
    
    // MARK: - Helpers
    
    private func actionForSelectedIndex(index: Int) {
        selectedIndex?(index)
    }
    
    private func setup() {
        backgroundColor = defaultColor
        
        for title in labelTitles {
            let label = UILabel()
            addSubview(label)
            label.font = UIFont.chomperFontForTextStyle("p small")
            label.textAlignment = .center
            label.attributedText = title
            label.textColor = UIColor.white
            labels.append(label)
        }
    }
}
