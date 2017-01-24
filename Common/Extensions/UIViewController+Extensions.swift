//
//  UIViewController+Extensions.swift
//  Chomper
//
//  Created by Danning Ge on 6/20/16.
//  Copyright © 2016 Danning Ge. All rights reserved.
//

public typealias DismissAlertBlock = (_ confirmed: Bool) -> Void

extension UIViewController {
    
    public func alertWithButton(_ confirmButton: String = NSLocalizedString("OK", comment: "OK alert button"), title: String? = nil, message: String? = nil, style: UIAlertControllerStyle = .alert, dismissBlock: DismissAlertBlock? = nil) {
        
        let alert = UIAlertController(title: (style == .alert && title == nil) ? "" : title, message: message, preferredStyle: style)
        
        let confirmAction = UIAlertAction(title: confirmButton, style: .cancel, handler: { (action) in
            if let dismissBlockRef = dismissBlock {
                dismissBlockRef(false)
            }
        })
        
        alert.addAction(confirmAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    public func alertWithCancelButton(_ cancelButton: String = NSLocalizedString("Cancel", comment: "Cancel alert button"), confirmButton: String, title: String? = nil, message: String? = nil, destructiveStyle: Bool = false, confirmBold: Bool = true, style: UIAlertControllerStyle = .alert, dismissBlock: DismissAlertBlock? = nil) {
        
        let alert = UIAlertController(title: (style == .alert && title == nil) ? "" : title, message: message, preferredStyle: style)
        
        let cancelAction = UIAlertAction(title: cancelButton, style: .cancel, handler: { (action) in
            if let dismissBlockRef = dismissBlock {
                dismissBlockRef(false)
            }
        })
        
        alert.addAction(cancelAction)
        
        let confirmAction = UIAlertAction(title: confirmButton, style: destructiveStyle ? .destructive : .default, handler: { (action) in
            if let dismissBlockRef = dismissBlock {
                dismissBlockRef(true)
            }
        })
        
        alert.addAction(confirmAction)
        
        if confirmBold == true {
            alert.preferredAction = confirmAction
        }
        
        self.present(alert, animated: true, completion: nil)
    }
}
