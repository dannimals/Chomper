//
//  ToggleControl.swift
//  Chomper
//
//  Created by Danning Ge on 7/21/16.
//  Copyright © 2016 Danning Ge. All rights reserved.
//

import Common

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
            frame = CGRectMake(CGFloat(index) * buttonWidth, frame.minY, buttonWidth , bounds.height)
            label.frame = frame
        }
        
        frame = CGRectMake(CGFloat(selectedIndex) * bounds.width, self.bounds.height, buttonWidth, 5.0)
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
            label.textAlignment = .Center
            label.text = title
            label.translatesAutoresizingMaskIntoConstraints = false
            addSubview(label)
            labels.append(label)
        }
        setSelectedColors()
        setFonts()
        setSelectedIndex(selectedIndex, animated: false)
        
        underlineView = UIView()
        addSubview(underlineView)
        
        backgroundColor = UIColor.whiteColor()
    }
    
    func setSelectedIndex(index: Int, animated: Bool, completionHandler: ((completed: Bool) -> Void)? = nil) {
        guard index < labels.count else { fatalError("index out of bounds") }
        for (index, label) in labels.enumerate() {
            label.textColor = index == selectedIndex ? selectedColor : unselectedColor
        }
        
        UIView.animateWithDuration(0.5) { [weak self] in
            self?.underlineView.frame = self?.labels[index].frame ?? CGRectZero
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
    
}
