//
//  NewBuddyViewController.swift
//  HomeworkForSummer
//
//  Created by Samuli Tamminen on 11.2.2016.
//  Copyright © 2016 Samuli Tamminen. All rights reserved.
//

import UIKit

class DetailBuddyViewController: UIViewController, UITextFieldDelegate {

    // MARK: Properties
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var accountTextField: UITextField!
    
    var buddy: Buddy?
    var index: Int?
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Handle the text field’s user input through delegate callbacks.
        nameTextField.delegate = self
        accountTextField.delegate = self
        
        // Set up views if editing an existing Buddy
        if let buddy = buddy {
            navigationItem.title = buddy.name
            nameTextField.text = buddy.name
            accountTextField.text = buddy.account
        }
        
        // Disable save button if name is empty
        checkFields()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // Hide the keyboard when clicked out of textfield
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        checkFields()
    }
    
    func checkFields() {
        // Disable the Save button if the text field is empty.
        let name = nameTextField.text ?? ""
        let account = accountTextField.text ?? ""
        saveButton.enabled = !name.isEmpty && !account.isEmpty
    }
    
    // Dismiss keyboard when clicked out of textfield
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }

    
    // MARK: Navigation

    @IBAction func cancel(sender: UIBarButtonItem) {
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
        let isPresentingInAddMode = presentingViewController is UINavigationController
        
        if isPresentingInAddMode {
            // Dismiss modal
            dismissViewControllerAnimated(true, completion: nil)
        } else {
            // Go back in navigation controller
            navigationController!.popViewControllerAnimated(true)
        }
    }
    
    
    @IBAction func save(sender: UIBarButtonItem) {
        
        let name = nameTextField.text ?? ""
        let account = accountTextField.text ?? ""
        
        let status = IBAN.status(account)
        
        if status == .Valid {
            print("DetailBuddyViewController: \(status.description())")
            performSegueWithIdentifier("unwindToBuddyViewController", sender: saveButton)
        } else {
            
            print("DetailBuddyViewController: \(status.description())")
            
            func cancelHandler(action: UIAlertAction) {
                print("alert canceled")
            }
            
            func saveHandler(action: UIAlertAction) {
                print("save anyway")
                performSegueWithIdentifier("unwindToBuddyViewController", sender: saveButton)
            }
            
            let alert = UIAlertController(title: "Invalid IBAN account", message: status.description(), preferredStyle: .Alert)
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: cancelHandler))
            alert.addAction(UIAlertAction(title: "Save anyway", style: .Default, handler: saveHandler))
            
            // Show the alert
            presentViewController(alert, animated: true, completion: nil)
            
        }
        
    }
    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if saveButton === sender {
            print("prepareForSegue: saveButton")
            let name = nameTextField.text ?? ""
            let account = accountTextField.text ?? ""
            
            buddy = Buddy(name: name, account: account)
        }
    }


}
