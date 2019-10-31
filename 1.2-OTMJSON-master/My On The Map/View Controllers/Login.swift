//
//  Login.swift
//  On The Map
//
//  Created by Brittany Mason on 10/2/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation
import UIKit

class login: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate {
    
    // MARK: Setting Outlets
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var facebookButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //        unsubscribeFromKeyboardNotifications()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* Textfield Delegates */
        userNameTextField.delegate = self
        passwordTextField.delegate = self
        
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        
        print("tapped")
        
        if userNameTextField.text!.isEmpty || passwordTextField.text!.isEmpty {
            displayAlert(title: "Login Unsuccessful", message: "Username and/or Password is empty")
            
            } else {
            taskPostASessionAuth(username: userNameTextField.text!, password: passwordTextField.text!) { (success, errorString) in performUIUpdatesOnMain {
                if success{
                    performUIUpdatesOnMain {
                        self.userNameTextField.text = ""
                        self.passwordTextField.text = ""
                        
                        print("Successfully logged in!")
                        let storyboard = UIStoryboard(name: "Storyboard", bundle: nil)
                        let controller = storyboard.instantiateViewController(withIdentifier: "mapView")
                        self.present(controller, animated: true, completion: nil)
                }
                    
                } else if errorString != nil {
                        performUIUpdatesOnMain {
                            self.displayAlert(title: "Login Unsuccessful", message: errorString)
                        }
                    } else {
                        performUIUpdatesOnMain {
                            self.displayAlert(title: "Login Unsuccessful", message: "Invalid Username and/or Password")
                    
                }
            }
            
            func enableControllers(_ enable: Bool) {
                self.userNameTextField? .isEnabled = false
                self.passwordTextField.isEnabled = false
                self.loginButton.isEnabled = false
                self.facebookButton.isEnabled = false
                
            }
            
        }
        
        
    }
    
    
    
    
    
    
    
    
    
        }
}
}
