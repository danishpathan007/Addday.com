//
//  CommonUtilities.swift
//  Allday.com
//
//  Created by Danish Khan on 27/04/20.
//  Copyright © 2020 Danish Khan. All rights reserved.
//

import Foundation
import UIKit

class AlertUtility {
    
    static let CancelButtonIndex = -1;
    
    class func showAlert(_ onController:UIViewController!, title:String?,message:String? ) {
        showAlert(onController, title: title, message: message, cancelButton: "OK", buttons: nil, actions: nil)
    }
    
    /**
     - parameter title:        title for the alert
     - parameter message:      message for alert
     - parameter cancelButton: title for cancel button
     - parameter buttons:      array of string for title for other buttons
     - parameter actions:      action is the callback which return the action and index of the button which was pressed
     */
    
    
    class func showAlert(_ onController:UIViewController!, type:UIAlertController.Style! = .alert, title:String?,message:String? = nil ,cancelButton:String = "OK",buttons:[String]? = nil,actions:((_ alertAction:UIAlertAction,_ index:Int)->())? = nil) {
        // make sure it would be run on  main queue
        let alertController = UIAlertController(title: title, message: message, preferredStyle: type)
        
        let action = UIAlertAction(title: cancelButton, style: UIAlertAction.Style.cancel) { (action) in
            alertController.dismiss(animated: true, completion: nil)
            actions?(action,CancelButtonIndex)
        }
        alertController.addAction(action)
        if let _buttons = buttons {
            for button in _buttons {
                let action = UIAlertAction(title: button, style: .default) { (action) in
                    let index = _buttons.firstIndex(of: action.title!)
                    actions?(action,index!)
                }
                alertController.addAction(action)
            }
        }
        onController.present(alertController, animated: true, completion: nil)
    }
    
    class func showDeleteAlert(_ onController:UIViewController!, type:UIAlertController.Style! = .alert, title:String?,message:String? = nil ,cancelButton:String = "OK",buttons:[String]? = nil,actions:((_ alertAction:UIAlertAction,_ index:Int)->())? = nil) {
        // make sure it would be run on  main queue
        let alertController = UIAlertController(title: title, message: message, preferredStyle: type)
        
        let action = UIAlertAction(title: cancelButton, style: .default) { (action) in
            alertController.dismiss(animated: true, completion: nil)
            actions?(action,CancelButtonIndex)
        }
        alertController.addAction(action)
        if let _buttons = buttons {
            for button in _buttons {
                let action = UIAlertAction(title: button, style: .destructive) { (action) in
                    let index = _buttons.firstIndex(of: action.title!)
                    actions?(action,index!)
                }
                alertController.addAction(action)
            }
        }
        onController.present(alertController, animated: true, completion: nil)
    }
    
    
    
    
    class func showAlertWithTextField(_ onController: UIViewController!, title: String? = nil, message: String? = nil, placeholder: String? = nil, completion: @escaping ((String) -> Void) = { _ in }) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addTextField() { newTextField in
            newTextField.placeholder = placeholder
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in completion("") })
        alert.addAction(UIAlertAction(title: "Ok", style: .default) { action in
            if
                let textFields = alert.textFields,
                let tf = textFields.first,
                let result = tf.text
            { completion(result) }
            else
            { completion("") }
        })
        onController.present(alert, animated: true, completion: nil)
    }
    
    
    
    
}
