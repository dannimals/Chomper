//
//  UIViewController+Extensions.swift
//  Chomper
//
//  Created by Danning Ge on 6/20/16.
//  Copyright © 2016 Danning Ge. All rights reserved.
//

public typealias DismissAlertBlock = (confirmed: Bool) -> Void

extension UIViewController {
    
    public func alertWithButton(confirmButton: String = NSLocalizedString("OK", comment: "OK alert button"), title: String? = nil, message: String? = nil, style: UIAlertControllerStyle = .Alert, dismissBlock: DismissAlertBlock? = nil) {
        
        let alert = UIAlertController(title: (style == .Alert && title == nil) ? "" : title, message: message, preferredStyle: style)
        
        let confirmAction = UIAlertAction(title: confirmButton, style: .Cancel, handler: { (action) in
            if let dismissBlockRef = dismissBlock {
                dismissBlockRef(confirmed: false)
            }
        })
        
        alert.addAction(confirmAction)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    public func alertWithCancelButton(cancelButton: String = NSLocalizedString("Cancel", comment: "Cancel alert button"), confirmButton: String, title: String? = nil, message: String? = nil, destructiveStyle: Bool = false, confirmBold: Bool = true, style: UIAlertControllerStyle = .Alert, dismissBlock: DismissAlertBlock? = nil) {
        
        let alert = UIAlertController(title: (style == .Alert && title == nil) ? "" : title, message: message, preferredStyle: style)
        
        let cancelAction = UIAlertAction(title: cancelButton, style: .Cancel, handler: { (action) in
            if let dismissBlockRef = dismissBlock {
                dismissBlockRef(confirmed: false)
            }
        })
        
        alert.addAction(cancelAction)
        
        let confirmAction = UIAlertAction(title: confirmButton, style: destructiveStyle ? .Destructive : .Default, handler: { (action) in
            if let dismissBlockRef = dismissBlock {
                dismissBlockRef(confirmed: true)
            }
        })
        
        alert.addAction(confirmAction)
        
        if confirmBold == true {
            alert.preferredAction = confirmAction
        }
        
        self.presentViewController(alert, animated: true, completion: nil)
    }

}
