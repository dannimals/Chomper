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
    
    fileprivate var labelTitles: [NSAttributedString]!
    fileprivate var labels: [UILabel]!
    fileprivate var underlineView: UIView!
    fileprivate var buttonWidth: CGFloat {
        if labels.count == 0 {
            return 0.0
        }
        return bounds.width / CGFloat(labels.count)
    }
    private var showUnderlineView: Bool!
    fileprivate var startCenter: CGFloat = -1
    
    @IBInspectable var selectedIndex: Int = 0 {
        didSet {
            setSelectedIndex(selectedIndex)
        }
    }
    
    @IBInspectable var selectedColor: UIColor = UIColor.orange {
        didSet {
            setSelectedColors()
        }
    }
    
    @IBInspectable var unselectedColor: UIColor = UIColor.lightGray {
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
    
    required init(titles: [NSAttributedString], showUnderlineView show: Bool = true) {
        showUnderlineView = show
        labelTitles = titles
        super.init(frame: CGRect.zero)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        var frame: CGRect

        for (index, label) in labels.enumerated() {
            frame = label.frame
            frame = CGRect(x: CGFloat(index) * buttonWidth, y: 0, width: buttonWidth , height: bounds.height)
            label.frame = frame
        }
        frame = CGRect(x: CGFloat(selectedIndex) * buttonWidth, y: bounds.height - 2.5, width: buttonWidth, height: 2.5)
        underlineView.frame = frame
        underlineView.isHidden = !showUnderlineView
        startCenter = underlineView.center.x
    }
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let location = touch.location(in: self)
        var calcIndex: Int?
        for (index, item) in labels.enumerated() {
            if item.frame.contains(location) {
                calcIndex = index
            }
        }
        if let calcIndex = calcIndex {
            selectedIndex = calcIndex
            sendActions(for: .touchUpInside)
        }
        return false
    }
    
    // MARK: - Handlers 
    
    fileprivate func setup() {
        addTarget(self, action: #selector(labelTapped), for: .touchUpInside)
        labels = [UILabel]()
        underlineView = UIView()
        underlineView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(underlineView)
        
        for title in labelTitles {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textAlignment = .center
            label.attributedText = title
            addSubview(label)
            labels.append(label)
        }
        setSelectedColors()
        setFonts()
        setSelectedIndex(selectedIndex, animated: false)
        
        backgroundColor = UIColor.white
    }
    
    final func setSelectedIndex(_ index: Int, animated: Bool = false, completionHandler: ((_ completed: Bool) -> Void)? = nil) {
        guard index < labels.count else { fatalError("index out of bounds") }
        for (i, label) in labels.enumerated() {
            label.textColor = i == index ? selectedColor : unselectedColor
        }
        
        if animated {
            UIView.animate(withDuration: 0.4, delay: 0.2, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.8, options: [], animations: { [unowned self] in
                var frame = self.underlineView.frame 
                frame.origin.x = self.labels[index].frame.minX 
                self.underlineView.frame = frame }, completion: { (bool) in
                    completionHandler?(bool)
            })
        }
        
    }
    
    final func scrollOffSetX(_ offsetX: CGFloat) {
        let center = startCenter + offsetX / CGFloat(labels.count)
        UIView.animate(withDuration: 0.4, delay: 0.2, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.8, options: [], animations: { [unowned self] in
            self.underlineView.center = CGPoint(x: center, y: self.underlineView.center.y)
        }, completion: nil)
    }
    
    fileprivate func setSelectedColors() {
        for (index, label) in labels.enumerated() {
            label.textColor = index == selectedIndex ? selectedColor : unselectedColor
        }
        underlineView.backgroundColor = selectedColor
    }
    
    fileprivate func setFonts() {
        for label in labels {
            label.font = font
        }
    }
    
    final func labelTapped() {
        labelTappedWithIndex(selectedIndex )
    }
    
    // MARK: - Override points
    
    func labelTappedWithIndex(_ index: Int) {}
    
}
