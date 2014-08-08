//
//  TBMainViewController.swift
//  ZxingDemo-Swift
//
//  Created by Jarvis on 14-8-6.
//  Copyright (c) 2014年 com.thongbin. All rights reserved.
//

import UIKit

class TBMainViewController: UIViewController , TBCaptureViewControllerDelegate{

    @IBOutlet var _contentTextView: UITextView!
    @IBOutlet var _launchScanButton: UIButton!
    @IBOutlet var _generaterButton: UIButton!
    @IBOutlet var _codeImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func launchScanButtonAction(sender: AnyObject) {
        let _captureViewController: TBCaptureViewController = TBCaptureViewController()
        _captureViewController._delegate = self
        self.presentViewController(_captureViewController, animated: true, completion: nil)
    }
    
    @IBAction func genreateQRCode(sender: AnyObject) {
        
    }
    
//    TBCaptureViewControllerDelegate
    func captureResult(capture: ZXCapture, result: ZXResult, barcodeFormat: String?) {
        _contentTextView.text = result.text
        _codeImage.image = UIImage(CGImage: capture.lastScannedImage)
    }
}
