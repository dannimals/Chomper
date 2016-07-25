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
    private var startCenter: CGFloat = -1
    
    @IBInspectable var selectedIndex: Int = 0 {
        didSet {
            setSelectedIndex(selectedIndex)
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
        startCenter = underlineView.center.x
    }
    
    override func beginTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
        let location = touch.locationInView(self)
        var calcIndex: Int?
        for (index, item) in labels.enumerate() {
            if item.frame.contains(location) {
                calcIndex = index
            }
        }
        if let calcIndex = calcIndex {
            selectedIndex = calcIndex
            sendActionsForControlEvents(.TouchUpInside)
        }
        return false
    }
    
    // MARK: - Handlers 
    
    private func setup() {
        addTarget(self, action: #selector(labelTapped), forControlEvents: .TouchUpInside)
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
            labels.append(label)
        }
        setSelectedColors()
        setFonts()
        setSelectedIndex(selectedIndex, animated: false)
        
        backgroundColor = UIColor.whiteColor()
    }
    
    final func setSelectedIndex(index: Int, animated: Bool = false, completionHandler: ((completed: Bool) -> Void)? = nil) {
        guard index < labels.count else { fatalError("index out of bounds") }
        for (i, label) in labels.enumerate() {
            label.textColor = i == index ? selectedColor : unselectedColor
        }
        
        if animated {
            UIView.animateWithDuration(0.4, delay: 0.2, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.8, options: [], animations: { [unowned self] in
                var frame = self.underlineView.frame ?? CGRectZero
                frame.origin.x = self.labels[index].frame.minX ?? 0.0
                self.underlineView.frame = frame }, completion: { (bool) in
                    completionHandler?(completed: bool)
            })
        }
        
    }
    
    final func scrollOffSetX(offsetX: CGFloat) {
        let center = startCenter + offsetX / CGFloat(labels.count)
        UIView.animateWithDuration(0.4, delay: 0.2, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.8, options: [], animations: { [unowned self] in
            self.underlineView.center = CGPoint(x: center, y: self.underlineView.center.y)
        }, completion: nil)
    }
    
    private func setSelectedColors() {
        for (index, label) in labels.enumerate() {
            label.textColor = index == selectedIndex ? selectedColor : unselectedColor
        }
        underlineView.backgroundColor = selectedColor
    }
    
    private func setFonts() {
        for label in labels {
            label.font = font
        }
    }
    
    final func labelTapped() {
        labelTappedWithIndex(selectedIndex ?? 0)
    }
    
    // MARK: - Override points
    
    func labelTappedWithIndex(index: Int) {}
    
}
