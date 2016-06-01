//
//  ViewController.swift
//  MozAnalytics
//
//  Created by Andrews Jr, George on 9/15/15.
//  Copyright (c) 2015 Andrews Jr, George. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITextFieldDelegate {
    
    let keychainWrapper = KeychainWrapper()

    @IBOutlet weak var accessIDTextField: UITextField!
    @IBOutlet weak var secretKeyTextField: UITextField!
    
    @IBOutlet weak var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.restorationIdentifier = K.RestoreID.settings
        
        accessIDTextField.delegate = self
        secretKeyTextField.delegate = self
        
        if NSUserDefaults.standardUserDefaults().boolForKey(K.defaultsKey.hasCredentials) {
            accessIDTextField.text = NSUserDefaults.standardUserDefaults().valueForKey(K.accessID) as? String
            secretKeyTextField.text = keychainWrapper.myObjectForKey(K.secretKey) as? String
            saveButton.setTitle("Update Settings", forState: .Normal)
        }
    }
    
    @IBAction func saveSettings(sender: AnyObject) {
        
        if (accessIDTextField.hasText() && secretKeyTextField.hasText()) {
            
            accessIDTextField.resignFirstResponder()
            secretKeyTextField.resignFirstResponder()
            
            // Save secretKey to keychain
            keychainWrapper.mySetObject(secretKeyTextField.text, forKey:kSecValueData)
            keychainWrapper.writeToKeychain()
            
            // Save accessID to defaults
            NSUserDefaults.standardUserDefaults().setValue(accessIDTextField.text, forKey: K.accessID)
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: K.defaultsKey.hasCredentials)
            NSUserDefaults.standardUserDefaults().synchronize()
            
            
            saveButton.setTitle("Update Settings", forState: .Normal)
            
        } else {
            presentAlert(title: "Notification", message: "You must enter both an Access ID and a Secret Key!")
        }
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func encodeRestorableStateWithCoder(coder: NSCoder) {
        coder.encodeObject(accessIDTextField.text, forKey: K.accessID)
        coder.encodeObject(secretKeyTextField.text, forKey: K.secretKey)
        super.encodeRestorableStateWithCoder(coder)
    }
    
    override func decodeRestorableStateWithCoder(coder: NSCoder) {
        if let accessID = coder.decodeObjectForKey(K.accessID) as? String {
            accessIDTextField.text = accessID
        }
        if let secretKey = coder.decodeObjectForKey(K.secretKey) as? String {
            secretKeyTextField.text = secretKey
        }
        super.decodeRestorableStateWithCoder(coder)
    }

}

