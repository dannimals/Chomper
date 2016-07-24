//
//  ToggleControl.swift
//  Chomper
//
//  Created by Danning Ge on 7/21/16.
//  Copyright © 2016 Danning Ge. All rights reserved.
//

import Common

//
// Subclass and override labelTappedWithIndex

@IBDesignable
class ToggleControl: UIControl {
    
    // MARK: - Properties 
    
    private var labelTitles: [String]!
    private var labels: [UILabel]!
    private var underlineView: UIView!
    private var buttonWidth: CGFloat {
        if labels.count == 0 {
            return 0.0
        }
        return bounds.width / CGFloat(labels.count)
    }
    
    @IBInspectable var selectedIndex: Int = 0 {
        didSet {
            setSelectedIndex(selectedIndex, animated: true)
        }
    }
    
    @IBInspectable var selectedColor: UIColor = UIColor.orangeColor() {
        didSet {
            setSelectedColors()
        }
    }
    
    @IBInspectable var unselectedColor: UIColor = UIColor.lightGrayColor() {
        didSet {
            setSelectedColors()
        }
    }
    
    @IBInspectable var font: UIFont = UIFont.chomperFontForTextStyle("h3") {
        didSet {
            setFonts()
        }
    }

    // MARK: - Initializers
    
    required init(titles: [String]) {
        labelTitles = titles
        super.init(frame: CGRectZero)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        var frame: CGRect

        for (index, label) in labels.enumerate() {
            frame = label.frame
            frame = CGRectMake(CGFloat(index) * buttonWidth, self.frame.minY, buttonWidth , bounds.height)
            label.frame = frame
        }
        frame = CGRectMake(CGFloat(selectedIndex) * buttonWidth, self.frame.maxY - 3.0, buttonWidth, 3.0)
        underlineView.frame = frame
    }
    
    // MARK: - Handlers 
    
    func setup() {
        labels = [UILabel]()
        underlineView = UIView()
        underlineView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(underlineView)
        
        for title in labelTitles {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textAlignment = .Center
            label.text = title
            addSubview(label)
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(labelTapped(_:)))
            label.userInteractionEnabled = true
            label.addGestureRecognizer(tap)
            labels.append(label)
        }
        setSelectedColors()
        setFonts()
        setSelectedIndex(selectedIndex, animated: false)
        
        backgroundColor = UIColor.whiteColor()
    }
    
    func setSelectedIndex(index: Int, animated: Bool, completionHandler: ((completed: Bool) -> Void)? = nil) {
        guard index < labels.count else { fatalError("index out of bounds") }
        for (i, label) in labels.enumerate() {
            label.textColor = i == index ? selectedColor : unselectedColor
        }
        
        if animated {
            UIView.animateWithDuration(0.4) { [weak self] in
                var frame = self?.underlineView.frame ?? CGRectZero
                frame.origin.x = self?.labels[index].frame.minX ?? 0.0
                self?.underlineView.frame = frame
            }
        }
    }
    
    func setSelectedColors() {
        for (index, label) in labels.enumerate() {
            label.textColor = index == selectedIndex ? selectedColor : unselectedColor
        }
        underlineView.backgroundColor = selectedColor
    }
    
    func setFonts() {
        for label in labels {
            label.font = font
        }
    }
    
    func labelTapped(sender: UITapGestureRecognizer) {
        guard let label = sender.view as? UILabel else { fatalError("label cannot be found from tap") }
        labelTappedWithIndex(labels.indexOf(label) ?? 0)
    }
    
    // MARK: - Override
    
    func labelTappedWithIndex(index: Int) {}
    
}
