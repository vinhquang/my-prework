//
//  SettingViewController.swift
//  TipCalculator
//
//  Created by Zen on 9/12/16.
//  Copyright © 2016 Zen. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {

    @IBOutlet weak var option1Field: UITextField!
    @IBOutlet weak var option2Field: UITextField!
    @IBOutlet weak var option3Field: UITextField!
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    @IBAction func onDismiss(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
}
