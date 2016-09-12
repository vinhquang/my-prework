//
//  ViewController.swift
//  TipCalculator
//
//  Created by Zen on 9/12/16.
//  Copyright © 2016 Zen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var tipSegmented: UISegmentedControl!
    
    let defaults = NSUserDefaults.standardUserDefaults()
    var tipPercentages = [15.00, 20.00, 30.00]
    var isPresenting: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        defaults.removeObjectForKey("tip_percent_1")
        defaults.removeObjectForKey("tip_percent_2")
        defaults.removeObjectForKey("tip_percent_3")
        
        if ((defaults.objectForKey("tip_percent_1") == nil)) {
            defaults.setObject(String(tipPercentages[0]), forKey: "tip_percent_1")
            defaults.setObject(String(tipPercentages[1]), forKey: "tip_percent_2")
            defaults.setObject(String(tipPercentages[2]), forKey: "tip_percent_3")
        
            defaults.synchronize()
        }
        
        reloadTipPercentages()
    }
    
    override func viewWillAppear(animated: Bool) {
        reloadTipPercentages()
        calculateTip(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func reloadTipPercentages() {
        tipPercentages[0] = defaults.doubleForKey("tip_percent_1")
        tipPercentages[1] = defaults.doubleForKey("tip_percent_2")
        tipPercentages[2] = defaults.doubleForKey("tip_percent_3")
        
        let tipPercent1 = String(format: "%.0f", tipPercentages[0]) + "%"
        let tipPercent2 = String(format: "%.0f", tipPercentages[1]) + "%"
        let tipPercent3 = String(format: "%.0f", tipPercentages[2]) + "%"
        
        tipSegmented.setTitle(tipPercent1, forSegmentAtIndex: 0)
        tipSegmented.setTitle(tipPercent2, forSegmentAtIndex: 1)
        tipSegmented.setTitle(tipPercent3, forSegmentAtIndex: 2)
    }

    @IBAction func onTap(sender: AnyObject) {
        view.endEditing(true)
    }

    @IBAction func calculateTip(sender: AnyObject) {
        let bill = Double(billField.text!) ?? 0
        let tip = bill * tipPercentages[tipSegmented.selectedSegmentIndex] / 100
        let total = bill + tip
        
        tipLabel.text = String(format: "$%.2f", tip)
        totalLabel.text = String(format: "$%.2f", total)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let vc = segue.destinationViewController as UIViewController
        vc.modalPresentationStyle = UIModalPresentationStyle.Custom
        vc.transitioningDelegate = self
    }
}

extension ViewController: UIViewControllerTransitioningDelegate {
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresenting = true
        return self
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresenting = false
        return self
    }
    /*
    func interactionControllerForPresentation(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning?
    
    func interactionControllerForDismissal(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning?
    
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController?
 */
}

extension ViewController: UIViewControllerAnimatedTransitioning {
    
    // This is used for percent driven interactive transitions, as well as for container controllers that have companion animations that might need to
    // synchronize with the main animation.
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 1
    }
    // This method can only  be a nop if the transition is interactive and not a percentDriven interactive transition.
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView()
        let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        
        if isPresenting! {
            toVC.view.alpha = 0
            
            containerView?.addSubview(toVC.view)
            UIView.animateWithDuration(1, animations: {
                toVC.view.alpha = 1
            }) { (finished) -> Void in
                transitionContext.completeTransition(finished)
            }
        } else {
            fromVC.view.alpha = 1
            
            UIView.animateWithDuration(1, animations: {
                fromVC.view.alpha = 0
                fromVC.view.transform = CGAffineTransformMakeScale(0.01, 0.01)
                }, completion: { (finished) -> Void in
                    transitionContext.completeTransition(finished)
                    fromVC.view.removeFromSuperview()
            })
        }
    }
    
    // This is a convenience and if implemented will be invoked by the system when the transition context's completeTransition: method is invoked.
    func animationEnded(transitionCompleted: Bool) {        reloadTipPercentages()
        calculateTip(self)
    }
}