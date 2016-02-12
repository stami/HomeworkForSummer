//
//  NewBuddyViewController.swift
//  HomeworkForSummer
//
//  Created by Samuli Tamminen on 11.2.2016.
//  Copyright © 2016 Samuli Tamminen. All rights reserved.
//

import UIKit

class NewBuddyViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var accountTextField: UITextField!
    
    var buddy: Buddy?

    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    @IBAction func cancel(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
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
