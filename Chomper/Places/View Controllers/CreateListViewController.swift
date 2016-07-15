//
//  CreatePlaceViewController.swift
//  Chomper
//
//  Created by Danning Ge on 7/13/16.
//  Copyright © 2016 Danning Ge. All rights reserved.
//

import Common

class CreateListViewController: UIViewController, BaseViewControllerProtocol, UITextFieldDelegate {
    var textField: UITextField!
    var cancelButton: UIButton!
    var saveButton: UIButton!
    var containerView: UIView!
    var containerBottomLayout: NSLayoutConstraint!
    var titleTopLayout: NSLayoutConstraint!
    
    var saveAction: (() -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //
        // Set up view
        
        view.backgroundColor = UIColor.whiteColor()
        let effect = UIBlurEffect(style: .ExtraLight)
        let blurView = UIVisualEffectView(effect: effect)
        blurView.frame = view.frame
        view.frame = view.frame
        view.insertSubview(blurView, atIndex: 0)
        
        //
        // Set up buttons
        
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
        
        textField = UITextField()
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textField)
        textField.returnKeyType = .Done
        textField.textColor = UIColor.lightGrayColor()
        textField.tintColor = UIColor.orangeColor()
        textField.font = UIFont.chomperFontForTextStyle("h2")
        textField.placeholder = NSLocalizedString("Create a new list", comment: "list name")
        titleTopLayout = NSLayoutConstraint(item: textField, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1, constant: 0)
        view.addConstraint(titleTopLayout)
        textField.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor, constant: 50.0).active = true
        textField.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor, constant: -50.0).active = true
        
        let lineView = UIView()
        lineView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(lineView)
        lineView.heightAnchor.constraintEqualToConstant(0.75).active = true
        lineView.backgroundColor = UIColor.lightGrayColor()
        lineView.topAnchor.constraintEqualToAnchor(textField.bottomAnchor, constant: 5.0).active = true
        lineView.leadingAnchor.constraintEqualToAnchor(textField.leadingAnchor, constant: -2.5).active = true
        lineView.trailingAnchor.constraintEqualToAnchor(textField.trailingAnchor, constant: 2.5).active = true

        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillAppear(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        textField.becomeFirstResponder()
    }
    
    
    // MARK: - Handlers
    
    func keyboardWillAppear(notif: NSNotification) {
        if let userInfo = notif.userInfo, keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue() {
            let keyboardHeight = keyboardFrame.size.height
            titleTopLayout.constant = (view.bounds.height - keyboardHeight - containerView.bounds.height - textField.bounds.height) / 2
            containerBottomLayout.constant = -keyboardHeight
        }
    }
    
    func keyboardWillHide(notif: NSNotification) {
        containerBottomLayout.constant = -(tabBarController?.view.frame.height ?? 0)
    }
    
    func textIsValid(textField: UITextField) -> Bool {
        let trimmedText = textField.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) ?? ""
        return !(textField.text?.isEmpty ?? false) && (trimmedText.characters.count > 0)

    }
    
    
    @IBAction
    func cancelTapped(sender: UIButton) {
        textField.resignFirstResponder()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction
    func saveTapped(sender: UIButton) {
        guard textIsValid(textField) else { return }
        saveAction?()
        textField.resignFirstResponder()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - UITextField delegate methods
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        guard textIsValid(textField) else { return false }
        textField.resignFirstResponder()
        dismissViewControllerAnimated(true, completion: nil)
        return true
    
    }


}
