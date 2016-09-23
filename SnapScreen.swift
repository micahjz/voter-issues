//
//  SnapScreen.swift
//  Voter Issue
//
//  Created by Micah Zirn on 5/9/16.
//  Copyright (c) 2016 Micah Zirn. All rights reserved.
//

import UIKit
import AVFoundation
import CoreGraphics

var takenImage : UIImage = UIImage()

class SnapScreen: UIViewController,UINavigationControllerDelegate, UIImagePickerControllerDelegate, UINavigationBarDelegate, UITextFieldDelegate, AVCaptureVideoDataOutputSampleBufferDelegate {

    var isBack = true
    var taken = false
    
    //for camera access
    var captureSession: AVCaptureSession?
    var stillImageOutput: AVCaptureStillImageOutput?
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    ///
    
    @IBAction func switchPressed(sender: AnyObject) {
        var backCamera = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        let array = AVCaptureDevice.devicesWithMediaType(AVMediaTypeVideo)
        var frontCamera : AVCaptureDevice? = nil
        for  device in array
        {
            if device.position == AVCaptureDevicePosition.Front
            {
                frontCamera = device as! AVCaptureDevice
            }
        }
        
        captureSession = AVCaptureSession()
        captureSession!.sessionPreset = AVCaptureSessionPresetPhoto
        
        isBack = !isBack
        
        if isBack
        {
            do {
                let input = try AVCaptureDeviceInput(device: backCamera) as AVCaptureDeviceInput
                if  captureSession!.canAddInput(input)
                {
                    captureSession!.addInput(input)
                    
                }
            }catch let error as NSError {
                print(error)
            }
            
        }else
        {
            do {
                let input = try AVCaptureDeviceInput(device: frontCamera) as AVCaptureDeviceInput
                if  captureSession!.canAddInput(input)
                {
                    captureSession!.addInput(input)
                    
                }
            }catch let error as NSError {
                print(error)
            }
        }
        
        stillImageOutput = AVCaptureStillImageOutput()
        stillImageOutput!.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
        
        captureSession!.addOutput(stillImageOutput)
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        self.view.layer.addSublayer(previewLayer!)
        previewLayer!.frame = self.view.frame
        previewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        print(self.view.frame)
        
        for sv in self.view.subviews
        {
            self.view.bringSubviewToFront(sv)
        }
        
        captureSession?.startRunning()

    }
    @IBOutlet var switchButton: UIBarButtonItem!
    @IBOutlet var snapNavBar: UINavigationBar!
    @IBOutlet var snapToolBar: UIToolbar!
    @IBOutlet var cameraButton: UIBarButtonItem!
    
    @IBAction func cameraButtonPressed(sender: AnyObject) {
        taken = !taken
        if let videoConnection = stillImageOutput!.connectionWithMediaType(AVMediaTypeVideo) {
            stillImageOutput?.captureStillImageAsynchronouslyFromConnection(videoConnection, completionHandler: {(sampleBuffer, error) in
                
                
                
                var imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer)
                var dataProvider = CGDataProviderCreateWithCFData(imageData)
                var cgImageRef = CGImageCreateWithJPEGDataProvider(dataProvider, nil, true, CGColorRenderingIntent.RenderingIntentDefault)
                var image = UIImage(CGImage: cgImageRef!, scale: 1.0, orientation: UIImageOrientation.Right)
                
                
                
                
                self.previewLayer?.connection.enabled = false
                self.switchButton.enabled = false
                
                
                self.topLeftButton.title = "Cancel"
                
                takenImage = image
            })
            
        }
        if !taken{
            performSegueWithIdentifier("snapTo", sender: self)
        }
        

    }
    @IBOutlet var imageScreen: UIImageView!
    
    @IBAction func topLeftButtonPressed(sender: AnyObject) {
        
        if topLeftButton.title == "Back"
        {
            takenImage = UIImage()
            previewLayer?.connection.enabled = false
            performSegueWithIdentifier("snapTo", sender: nil)
        }else
        {
            imageScreen.image = UIImage()
            topLeftButton.title = "Back"
            cameraButton.enabled = true
            switchButton.enabled = true
            previewLayer?.connection.enabled = true
        }

    }
    @IBOutlet var topLeftButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let colorImage = imageFromColor(UIColor.clearColor(), frame: CGRectMake(0, 0, 340, 64))
        snapNavBar.setBackgroundImage(colorImage, forBarMetrics: .Default)
        snapNavBar.tintColor = UIColor.clearColor()
        snapNavBar.shadowImage = colorImage
        snapNavBar.delegate = self
        
        
        snapToolBar.setBackgroundImage(colorImage, forToolbarPosition: UIBarPosition.Bottom, barMetrics: .Default)
        snapToolBar.tintColor = UIColor.clearColor()
        snapToolBar.setShadowImage(colorImage, forToolbarPosition: UIBarPosition.Bottom)
        switchButton.tintColor = UIColor.whiteColor()
        cameraButton.tintColor = UIColor.whiteColor()
        topLeftButton.tintColor = UIColor.whiteColor()

        taken = false
        
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func imageFromColor(color: UIColor, frame: CGRect) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(frame.size, false, 0)
        color.setFill()
        UIRectFill(frame)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    override func viewWillAppear(animated: Bool) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        
        
        captureSession = AVCaptureSession()
        captureSession!.sessionPreset = AVCaptureSessionPresetPhoto
        
        var backCamera = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        
        
        do {
            let input = try AVCaptureDeviceInput(device: backCamera) as AVCaptureDeviceInput
            if  captureSession!.canAddInput(input)
            {
                captureSession!.addInput(input)
                
            }
        }catch let error as NSError {
            print(error)
        }
        
        stillImageOutput = AVCaptureStillImageOutput()
        stillImageOutput!.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
        
        captureSession!.addOutput(stillImageOutput)
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        self.view.layer.addSublayer(previewLayer!)
        previewLayer!.frame = self.view.frame
        previewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        
        for sv in self.view.subviews
        {
            self.view.bringSubviewToFront(sv)
        }
        captureSession?.startRunning()
        
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
