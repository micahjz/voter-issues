//
//  ViewController.swift
//  Voter Issue
//
//  Created by Micah Zirn on 5/7/16.
//  Copyright (c) 2016 Micah Zirn. All rights reserved.
//

import UIKit
import AVFoundation

var labelToFix : UILabel = UILabel()
var imageToFix : UIImageView = UIImageView()
var left = true
var leftCaption = ""
var rightCaption = ""
var issueCaption = ""
var imgleft = UIImage(named: "Screen Shot 2016-05-10 at 9.39.34 PM.png")
var imgright = UIImage(named: "Screen Shot 2016-05-10 at 9.39.51 PM.png")
var bern = UIImage(named: "Screen Shot 2016-05-10 at 9.39.34 PM.png")
var clint = UIImage(named: "Screen Shot 2016-05-10 at 9.39.51 PM.png")


class ViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, AVCaptureVideoDataOutputSampleBufferDelegate{
    
    var enterField = UITextField()
    
    
    @IBAction func xLeft(sender: AnyObject) {
        leftImage.image = UIImage()    }

    @IBAction func xRight(sender: AnyObject) {
        rightImage.image = UIImage()
    }
  
    @IBAction func clintPressed(sender: AnyObject) {
        rightImage.image = clint
    }
    @IBAction func bernPressed(sender: AnyObject) {
        leftImage.image = bern
    }
    @IBAction func rightSnap(sender: AnyObject) {
        left = false
        performSegueWithIdentifier("screenTo", sender: nil)
    }
    @IBAction func rightDownload(sender: AnyObject) {
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        image.allowsEditing = false
        self.presentViewController(image, animated: true, completion: nil)
        imageToFix = rightImage
    }
    @IBAction func leftSnap(sender: AnyObject) {
        left = true
        performSegueWithIdentifier("screenTo", sender: nil)
    }
    @IBAction func leftDownload(sender: AnyObject) {
        
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        image.allowsEditing = false
        self.presentViewController(image, animated: true, completion: nil)
        imageToFix = leftImage
        
    }
    @IBOutlet var leftLabel: UILabel!
    @IBOutlet var rightLabel: UILabel!
    @IBOutlet var rightImage: UIImageView!
    @IBOutlet var leftImage: UIImageView!
    @IBOutlet var rightI: UIView!
    @IBOutlet var leftI: UIView!
    @IBOutlet var issueLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if takenImage.size.width > 0
        {
            print(takenImage)
            if left{
                leftImage.image = takenImage
                rightImage.image = imgright
            }else{
                rightImage.image = takenImage
                leftImage.image = imgleft
            }
        }
        labelTouchable()
        enterField.frame = CGRectMake(0, self.view.frame.height, self.view.frame.width, 30)
        enterField.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        enterField.delegate = self
        enterField.textColor = UIColor.whiteColor()
        enterField.addTarget(self, action: "updateLabel", forControlEvents: UIControlEvents.EditingChanged)
        self.view.addSubview(enterField)
        leftLabel.text = leftCaption
        rightLabel.text = rightCaption
        issueLabel.text = issueCaption
        
        
        leftImage.layer.borderColor = UIColor.blackColor().CGColor
        leftImage.layer.borderWidth = 1
        rightImage.layer.borderColor = UIColor.blackColor().CGColor
        rightImage.layer.borderWidth = 1
        issueLabel.layer.borderColor = UIColor.blackColor().CGColor
        issueLabel.layer.borderWidth = 1
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateLabel()
    {
        labelToFix.text = enterField.text!
        leftCaption = leftLabel.text!
        rightCaption = rightLabel.text!
        issueCaption = issueLabel.text!
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        textField.frame = CGRectMake(0, self.view.frame.height, self.view.frame.width, 30)
        return true
    }
    
    func labelTouchable(){
        let tgr = UITapGestureRecognizer(target: self, action: "textf")
        tgr.numberOfTapsRequired = 1
        issueLabel.addGestureRecognizer(tgr)
        
        let tgr2 = UITapGestureRecognizer(target: self, action: "textf2")
        tgr2.numberOfTapsRequired = 1
        leftLabel.addGestureRecognizer(tgr2)
        
        let tgr3 = UITapGestureRecognizer(target: self, action: "textf3")
        tgr3.numberOfTapsRequired = 1
        rightLabel.addGestureRecognizer(tgr3)
        
    }
    func textf()
    {
        labelToFix = issueLabel
        enterField.frame = CGRectMake(self.view.frame.minX, self.view.center.y-10, self.view.frame.width, 30)
        enterField.becomeFirstResponder()
        enterField.text = labelToFix.text!
    }
    func textf2()
    {
        labelToFix = leftLabel
        enterField.frame = CGRectMake(self.view.frame.minX, self.view.center.y-10, self.view.frame.width, 30)
        enterField.becomeFirstResponder()
        enterField.text = labelToFix.text!
    }
    func textf3()
    {
        labelToFix = rightLabel
        enterField.frame = CGRectMake(self.view.frame.minX, self.view.center.y-10, self.view.frame.width, 30)
        enterField.becomeFirstResponder()
        enterField.text = labelToFix.text!
    }
    
    override func viewWillAppear(animated: Bool) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
            
            enterField.frame = CGRectMake(0, self.view.frame.maxY-keyboardSize.height-35, self.view.frame.width, 35)
            
            
            
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        //
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        self.dismissViewControllerAnimated(true, completion: nil)
        

        imageToFix.image = image
    }
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        leftCaption = leftLabel.text!
        rightCaption = rightLabel.text!
        issueCaption = issueLabel.text!
        imgleft = leftImage.image!
        imgright = rightImage.image!
    }
    
    @IBOutlet var buttons: [UIButton]!
  
    @IBAction func screenShot(sender: AnyObject) {
        for button in buttons
        {
            button.hidden = true
        }
        let layer = UIApplication.sharedApplication().keyWindow!.layer
        let scale = UIScreen.mainScreen().scale
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale);
        
        layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        UIImageWriteToSavedPhotosAlbum(screenshot, nil, nil, nil)
        for button in buttons{
            button.hidden = false
        }
    }
    
}

