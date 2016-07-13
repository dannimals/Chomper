//
//  CreatePlaceViewController.swift
//  Chomper
//
//  Created by Danning Ge on 7/13/16.
//  Copyright © 2016 Danning Ge. All rights reserved.
//

import Common

class CreateListViewController: UIViewController, UITextFieldDelegate {
    var titleView: UITextField!
    var cancelButton: UIButton!
    var saveButton: UIButton!
    var containerView: UIView!
    var containerBottomLayout: NSLayoutConstraint!

    var saveAction: (() -> ())?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //
        // Set up views
        
        view.backgroundColor = UIColor.whiteColor()
        
        containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        containerView.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor).active = true
        containerView.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor).active = true
        containerBottomLayout = NSLayoutConstraint(item: containerView, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1, constant: 0)
        view.addConstraint(containerBottomLayout)
        
        cancelButton = UIButton()
        cancelButton.titleLabel?.textAlignment = .Center
        cancelButton.addTarget(self, action: #selector(cancelTapped(_:)), forControlEvents: .TouchUpInside)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(cancelButton)
        cancelButton.setTitleColor(UIColor.grayColor(), forState: .Highlighted)
        cancelButton.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        cancelButton.titleLabel?.font = UIFont.chomperFontForTextStyle("p small")
        cancelButton.setTitle(NSLocalizedString("Cancel", comment: "cancelButton"), forState: .Normal)
        
        saveButton = UIButton()
        saveButton.titleLabel?.textAlignment = .Center
        saveButton.addTarget(self, action: #selector(saveTapped(_:)), forControlEvents: .TouchUpInside)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(saveButton)
        saveButton.setTitleColor(UIColor.lightGrayColor(), forState: .Highlighted)
        saveButton.setTitleColor(UIColor.orangeColor(), forState: .Normal)
        saveButton.titleLabel?.font = UIFont.chomperFontForTextStyle("h4")
        saveButton.setTitle(NSLocalizedString("Save", comment: "save"), forState: .Normal)
        
        let buttons: [String: AnyObject] = [
            "saveButton": saveButton,
            "cancelButton": cancelButton
        ]
        
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|[saveButton]|",
            options: [],
            metrics: nil,
            views: buttons)
        )
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|[cancelButton]|",
            options: [],
            metrics: nil,
            views: buttons)
        )
        
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "H:|[cancelButton][saveButton(==cancelButton)]|",
            options: [],
            metrics: nil,
            views: buttons)
        )

        //
        // Set up center UITextField
        
        titleView = UITextField()
        titleView.delegate = self
        titleView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleView)
        titleView.returnKeyType = .Done
        titleView.textColor = UIColor.lightGrayColor()
        titleView.tintColor = UIColor.orangeColor()
        titleView.font = UIFont.chomperFontForTextStyle("h2")
        titleView.placeholder = NSLocalizedString("Name", comment: "list name")
        titleView.topAnchor.constraintEqualToAnchor(topLayoutGuide.bottomAnchor, constant: 75.0).active = true
        titleView.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor, constant: 75.0).active = true
        titleView.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor, constant: -75.0).active = true
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillAppear(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIKeyboardWillShowNotification, object: nil)
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        titleView.becomeFirstResponder()
    }
    
    // MARK: - Handlers
    
    func keyboardWillAppear(notif: NSNotification) {
        if let userInfo = notif.userInfo, keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue() {
            let keyboardHeight = keyboardFrame.size.height
            containerBottomLayout.constant = -keyboardHeight
            view.layoutIfNeeded()
        }
    }
    
    func keyboardWillHide(notif: NSNotification) {
//        containerBottomLayout.constant = 0
//        view.layoutIfNeeded()
    }
    
    
    @IBAction
    func cancelTapped(sender: UIButton) {
        titleView.resignFirstResponder()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction
    func saveTapped(sender: UIButton) {
        saveAction?()
        titleView.resignFirstResponder()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - UITextField delegate methods
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if !(textField.text!.isEmpty) {
           textField.resignFirstResponder()
            dismissViewControllerAnimated(true, completion: nil)
            return true
        }
        return false
    }


}
