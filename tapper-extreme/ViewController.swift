//
//  ViewController.swift
//  tapper-extreme
//
//  Created by Jay Chhaidan on 2016-05-10.
//  Copyright © 2016 Jay Chhaidan. All rights reserved.
//

import UIKit


class ViewController: UIViewController, UITextFieldDelegate {
    
    //variables-properties
    var maxTaps: Int = 0
    var currentTaps: Int = 0
    
    
    //outlets
    @IBOutlet weak var logoImg: UIImageView! //unwrapped
    @IBOutlet weak var howManyTapsTxt: UITextField!
    @IBOutlet weak var playBtn: UIButton!
    
    @IBOutlet weak var tapBtn: UIButton!
    @IBOutlet weak var tapsLbl: UILabel!
    
    // for keyboard dismissing & UIView
    override func viewDidLoad() {
        super.viewDidLoad()
        howManyTapsTxt.delegate = self
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    override func viewWillAppear(animated:Bool) {
        super.viewWillAppear(animated)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    var kbHeight: CGFloat!
    
    func keyboardWillShow(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            if let keyboardSize =  (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
                kbHeight = keyboardSize.height
                self.animateTextField(true)
                logoImg.hidden = true
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        self.animateTextField(false)
        logoImg.hidden = false
    }
    
    func animateTextField(up: Bool) {
        let movement = (up ? -kbHeight : kbHeight)
        
        UIView.animateWithDuration(0.3, animations: {
            self.view.frame = CGRectOffset(self.view.frame, 0, movement)
        })
    }
    
    @IBAction func onCoinTapped(sender: UIButton!) { //sender uibutton calls is
        //currentTaps = currentTaps+1
        //currentTaps++
        currentTaps += 1
        
        updateTapsLbl()
        
        if isGameOver() {
            restartGame()
        }
    }
    
    @IBAction func onPlayBtnPressed(sender: UIButton!) { //pass in object that was tapped by UIButton
        
        //validation
        if howManyTapsTxt.text != nil && howManyTapsTxt.text != "" {
            
            self.howManyTapsTxt.resignFirstResponder()
            
            logoImg.hidden = true
            playBtn.hidden = true
            howManyTapsTxt.hidden = true
            
            tapBtn.hidden = false
            tapsLbl.hidden = false
            
            maxTaps = Int(howManyTapsTxt.text!)! //grabbing text field, converting to int
            currentTaps = 0 //start over
            
            updateTapsLbl() //convert to string, inject into lavel
        }
    }//grabs text from textfield, nil means nothing
    
    func restartGame() { //functions should be considered for every action
        maxTaps = 0 //reset
        howManyTapsTxt.text = "" //empty text field
        
        logoImg.hidden = false
        playBtn.hidden = false
        howManyTapsTxt.hidden = false
        
        tapBtn.hidden = true
        tapsLbl.hidden = true
    }
    
    func isGameOver() -> Bool {
        if currentTaps >= maxTaps {
            return true
        } else {
            return false
        }
    }
    
    func updateTapsLbl() {
        tapsLbl.text = "\(currentTaps) Taps"
    }
}