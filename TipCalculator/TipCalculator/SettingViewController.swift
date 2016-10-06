//
//  SettingViewController.swift
//  TipCalculator
//
//  Created by Zen on 9/12/16.
//  Copyright © 2016 Zen. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var option1Field: UITextField!
    @IBOutlet weak var option2Field: UITextField!
    @IBOutlet weak var option3Field: UITextField!
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    @IBAction func onDismiss(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.option1Field.delegate = self
        self.option2Field.delegate = self
        self.option3Field.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        option1Field.text = defaults.objectForKey("tip_percent_1") as? String
        option2Field.text = defaults.objectForKey("tip_percent_2") as? String
        option3Field.text = defaults.objectForKey("tip_percent_3") as? String
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        defaults.setObject(option1Field.text!, forKey: "tip_percent_1")
        defaults.setObject(option2Field.text!, forKey: "tip_percent_2")
        defaults.setObject(option3Field.text!, forKey: "tip_percent_3")
        
        defaults.synchronize()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func onTap(sender: AnyObject) {
        view.endEditing(true)
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        var currentString = ""
        switch textField {
        case option1Field:
            currentString = option1Field.text!
        case option2Field:
            currentString = option2Field.text!
        case option3Field:
            currentString = option3Field.text!
        default:
            currentString = ""
        }
        
        switch string {
        case "0","1","2","3","4","5","6","7","8","9":
            currentString += string
        case ".":
            let array = currentString.characters.map {String($0)}
            var decimalCount = 0
            
            for character in array {
                if character == "." {
                    decimalCount+=1
                }
            }
            
            if decimalCount == 0 {
                currentString += string
            }
        default:
            let array = string.characters.map {String($0)}
            var currentStringArray = currentString.characters.map {String($0)}
            
            if array.count == 0 && currentStringArray.count != 0 {
                currentStringArray.removeLast()
                currentString = ""
                
                for character in currentStringArray {
                    currentString += String(character)
                }
            }
        }
        
        textField.text = currentString
        
        return false
    }
}
