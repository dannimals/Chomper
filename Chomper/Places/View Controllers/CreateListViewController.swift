//
//  CreatePlaceViewController.swift
//  Chomper
//
//  Created by Danning Ge on 7/13/16.
//  Copyright © 2016 Danning Ge. All rights reserved.
//

import Common
import Models

class CreateListViewController: BaseViewController, UITextFieldDelegate {
    fileprivate var backgroundContext: NSManagedObjectContext!
    fileprivate var cancelButton: UIButton!
    fileprivate var containerView: UIView!
    fileprivate var containerBottomLayout: NSLayoutConstraint!
    fileprivate var errorLabel: UILabel!
    fileprivate var saveButton: UIButton!
    fileprivate var textField: UITextField!
    fileprivate var titleTopLayout: NSLayoutConstraint!
    
    var saveAction: (() -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //
        // Set up background context and observers
        
        backgroundContext = mainContext.createBackgroundContext()
        backgroundContext.addNSManagedObjectContextDidSaveNotificationObserver(mainContext)
        
        //
        // Set up view
        
        view.backgroundColor = UIColor.softWhite()
        let effect = UIBlurEffect(style: .extraLight)
        let blurView = UIVisualEffectView(effect: effect)
        blurView.frame = view.frame
        view.frame = view.frame
        view.insertSubview(blurView, at: 0)
        
        //
        // Set up buttons
        
        containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        containerBottomLayout = NSLayoutConstraint(item: containerView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        view.addConstraint(containerBottomLayout)
        
        cancelButton = UIButton()
        cancelButton.titleLabel?.textAlignment = .center
        cancelButton.addTarget(self, action: #selector(cancelTapped(_:)), for: .touchUpInside)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(cancelButton)
        cancelButton.setTitleColor(UIColor.textColor(), for: .highlighted)
        cancelButton.setTitleColor(UIColor.darkGrey(), for: UIControlState())
        cancelButton.titleLabel?.font = UIFont.chomperFontForTextStyle("h4")
        cancelButton.setTitle(NSLocalizedString("Cancel", comment: "cancelButton"), for: UIControlState())
        
        saveButton = UIButton()
        saveButton.titleLabel?.textAlignment = .center
        saveButton.addTarget(self, action: #selector(saveTapped(_:)), for: .touchUpInside)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(saveButton)
        saveButton.setTitleColor(UIColor.darkGrey(), for: .highlighted)
        saveButton.setTitleColor(UIColor.darkOrange(), for: UIControlState())
        saveButton.titleLabel?.font = UIFont.chomperFontForTextStyle("h4")
        saveButton.setTitle(NSLocalizedString("Save", comment: "save"), for: UIControlState())
        
        let buttons: [String: AnyObject] = [
            "saveButton": saveButton,
            "cancelButton": cancelButton
        ]
        
        view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|[saveButton]|",
            options: [],
            metrics: nil,
            views: buttons)
        )
        view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|[cancelButton]|",
            options: [],
            metrics: nil,
            views: buttons)
        )
        
        view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|[cancelButton][saveButton(==cancelButton)]|",
            options: [],
            metrics: nil,
            views: buttons)
        )

        //
        // Set up center UITextField
        
        textField = UITextField()
        textField.delegate = self
        view.addSubview(textField)
        textField.autocorrectionType = .no
        textField.returnKeyType = .done
        textField.textColor = UIColor.textColor()
        textField.tintColor = UIColor.darkOrange()
        textField.font = UIFont.chomperFontForTextStyle("h2")
        textField.placeholder = NSLocalizedString("Create a new list", comment: "list name")
        titleTopLayout = NSLayoutConstraint(item: textField, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0)
        view.addConstraint(titleTopLayout)
      
        let lineView = UIView()
        view.addSubview(lineView)
        lineView.heightAnchor.constraint(equalToConstant: 0.75).isActive = true
        lineView.backgroundColor = UIColor.darkGrey()
        
        errorLabel = UILabel()
        view.addSubview(errorLabel)
        errorLabel.font = UIFont.chomperFontForTextStyle("p small")
        errorLabel.textColor = UIColor.darkOrange()
       
        NSLayoutConstraint.useAndActivateConstraints([
            errorLabel.leadingAnchor.constraint(equalTo: lineView.leadingAnchor),
            errorLabel.trailingAnchor.constraint(equalTo: lineView.trailingAnchor),
            errorLabel.topAnchor.constraint(equalTo: lineView.bottomAnchor, constant: 2.5),
            lineView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 5.0),
            lineView.leadingAnchor.constraint(equalTo: textField.leadingAnchor, constant: -2.5),
            lineView.trailingAnchor.constraint(equalTo: textField.trailingAnchor, constant: 2.5),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50.0),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50.0)
        ])
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }
    
    
    // MARK: - Handlers
    
    func keyboardWillAppear(_ notif: Notification) {
        if let userInfo = notif.userInfo, let keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardFrame.size.height
            titleTopLayout.constant = (view.bounds.height - keyboardHeight - containerView.bounds.height - textField.bounds.height) / 2
            containerBottomLayout.constant = -keyboardHeight
        }
    }
    
    func createNewList() {
        backgroundContext.performChanges { [unowned self] in
            let _ = List.insertIntoContext(self.backgroundContext, name: (self.textField.text)!, ownerEmail: AppData.sharedInstance.ownerUserEmail)
        }
        saveAction?()
        textField.resignFirstResponder()
        dismiss(animated: true, completion: nil)
    }
    
    // TODO: error handling
    func textIsValid(_ textField: UITextField) -> Bool {
        //
        // Check there is text and is not a duplicate
        
        let trimmedText = textField.text?.trimmingCharacters(in: CharacterSet.whitespaces) ?? ""
        return !(textField.text?.isEmpty ?? false) && (trimmedText.characters.count > 0)
        
    }
    
    func handleError(_ text: String? = nil) {
        // TODO:
        errorLabel.text = NSLocalizedString("Please enter a valid name", comment: "valid name")
    }
    
    @IBAction
    func cancelTapped(_ sender: UIButton) {
        textField.resignFirstResponder()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction
    func saveTapped(_ sender: UIButton) {
        guard textIsValid(textField) else {
            handleError()
            return
        }
        createNewList()
    }
    
    // MARK: - UITextField delegate methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard textIsValid(textField) else {
            handleError()
            return false
        }
        createNewList()
        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        errorLabel.text = ""
        return true
    }
}
