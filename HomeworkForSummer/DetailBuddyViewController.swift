//
//  NewBuddyViewController.swift
//  HomeworkForSummer
//
//  Created by Samuli Tamminen on 11.2.2016.
//  Copyright © 2016 Samuli Tamminen. All rights reserved.
//

import UIKit

class DetailBuddyViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var accountTextField: UITextField!
    
    var buddy: Buddy?

    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Set up views if editing an existing Buddy
        if let buddy = buddy {
            navigationItem.title = buddy.name
            nameTextField.text = buddy.name
            accountTextField.text = buddy.account
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

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
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if saveButton === sender {
            let name = nameTextField.text ?? ""
            let account = accountTextField.text ?? ""
            
            buddy = Buddy(name: name, account: account)
            
        }
    }


}
