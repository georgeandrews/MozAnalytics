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
<<<<<<< HEAD
=======
        self.restorationIdentifier = K.RestoreID.settings
>>>>>>> bcb94d1ccb0c9baa6ed6da445d1295720734e259
        
        accessIDTextField.delegate = self
        secretKeyTextField.delegate = self
        
<<<<<<< HEAD
        if UserDefaults.standard.bool(forKey: "hasCredentials") {
            accessIDTextField.text = UserDefaults.standard.value(forKey: "accessID") as? String
            secretKeyTextField.text = keychainWrapper.myObject(forKey: kSecValueData) as? String
            saveButton.setTitle("Update Settings", for: UIControlState())
        }
    }
    
    @IBAction func saveSettings(_ sender: AnyObject) {
        
        if (accessIDTextField.hasText && secretKeyTextField.hasText) {
            
            // Save accessID and hasCredentials boolean to NSUserDefaults
            UserDefaults.standard.setValue(accessIDTextField.text, forKey: "accessID")
            UserDefaults.standard.set(true, forKey: "hasCredentials")
            UserDefaults.standard.synchronize()
            
            // Save secretKey to Keychain
            keychainWrapper.mySetObject(secretKeyTextField.text, forKey:kSecValueData)
            keychainWrapper.writeToKeychain()
            
            saveButton.setTitle("Update Settings", for: UIControlState())
            
            accessIDTextField.resignFirstResponder()
            secretKeyTextField.resignFirstResponder()
=======
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
>>>>>>> bcb94d1ccb0c9baa6ed6da445d1295720734e259
            
        } else {
            presentAlert(title: "Notification", message: "You must enter both an Access ID and a Secret Key!")
        }
        
    }
    
<<<<<<< HEAD
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
=======
    func textFieldShouldReturn(textField: UITextField) -> Bool {
>>>>>>> bcb94d1ccb0c9baa6ed6da445d1295720734e259
        textField.resignFirstResponder()
        return true
    }
    
<<<<<<< HEAD
    // MARK: - Application State
    override func encodeRestorableState(with coder: NSCoder) {
        coder.encode(accessIDTextField.text, forKey: "accessID")
        coder.encode(secretKeyTextField.text, forKey: "secretKey")
        super.encodeRestorableState(with: coder)
    }
    
    override func decodeRestorableState(with coder: NSCoder) {
        if let accessID = coder.decodeObject(forKey: "accessID") as? String {
            accessIDTextField.text = accessID
        }
        if let secretKey = coder.decodeObject(forKey: "secretKey") as? String {
            secretKeyTextField.text = secretKey
        }
        super.decodeRestorableState(with: coder)
=======
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
>>>>>>> bcb94d1ccb0c9baa6ed6da445d1295720734e259
    }

}

