//
//  TBCaptureViewController.swift
//  ZxingDemo-Swift
//
//  Created by Jarvis on 14-8-7.
//  Copyright (c) 2014年 com.thongbin. All rights reserved.
//

import UIKit

@objc protocol TBCaptureViewControllerDelegate: NSObjectProtocol
{
    func captureResult(capture: ZXCapture, result: ZXResult, barcodeFormat: String?)
}

class TBCaptureViewController: UIViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate,ZXCaptureDelegate,
TBCaptureMaskViewDelegate
{

    var _capture: ZXCapture? = ZXCapture()
    var _captureMaskView: TBCaptureMaskView?
    
    weak var _delegate: TBCaptureViewControllerDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.blackColor()
        
        _capture?.camera = _capture!.back()
        _capture?.focusMode = AVCaptureFocusMode.ContinuousAutoFocus
        _capture?.rotation = 90.0
        
        _capture?.layer.frame = self.view.bounds
        _capture?.scanRect = CGRect(x: 0.0, y: 0.0, width: 320, height: 586)
        self.view.layer .addSublayer(_capture!.layer)
        _capture?.delegate = self
        
        _captureMaskView = TBCaptureMaskView(frame: self.view.frame)
        _captureMaskView?.delegate = self;
        self.view.addSubview(_captureMaskView!)
        self.view .bringSubviewToFront(_captureMaskView!)

    }
    
    override func viewDidAppear(animated: Bool) {
        if _capture!.running
        {
            _captureMaskView?.startScanEffectAnimation()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    //ZXCaptureDelegate
    func captureResult(capture: ZXCapture!, result: ZXResult!) {
        
        if result.isEqual(nil)
        {
            return
        }
        
        if let isTrue = _delegate?.respondsToSelector("captureResult:result:barcodeFormat:")
        {
            if isTrue
            {
                _delegate?.captureResult(capture, result: result, barcodeFormat: nil)
            }
        }
        
        //Vibrate
        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        cancelScan("")
        
    }
    
    //TBCaputureMaskViewDelegate
    func cancelScan(sender: AnyObject) {
        _capture?.stop()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func pickImageFromPhotoLibrary(sender: AnyObject) {
        var _pickerController: UIImagePickerController = UIImagePickerController()
        _pickerController.allowsEditing = true
        _pickerController.delegate = self
        _pickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        presentViewController(_pickerController, animated: true, completion: {(finished) -> Void in
            self._capture!.stop()
        })
    }
    
    //UIImagePickerControllerDelegate
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]!) {
        
        var image = info["UIImagePickerControllerEditedImage"] as UIImage
        dismissViewControllerAnimated(true, completion: {
            var imageToDecode = image.CGImage
            var source = ZXCGImageLuminanceSource(CGImage: imageToDecode)
            var bitmap = ZXBinaryBitmap(binarizer: ZXHybridBinarizer(source: source))

            var error: NSError?
            var result = self._capture!.reader.decode(bitmap, hints: self._capture!.hints, error: &error)
            if !result.isEqual(nil)
            {
                self._capture!.delegate.captureResult(self._capture, result: result)
                
            } else {
                
            }
        })
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController!) {
        dismissViewControllerAnimated(true, completion: {
            self._capture!.start()
        })
    }
    
//    func barcodeFormatToString(format: ZXBarcodeFormat!) -> String {
//        var formatVar = format
//        switch formatVar {
//        case .kBarcodeFormatAztec:
//            return "Aztec";
//            
//        case kBarcodeFormatCodabar:
//            return "CODABAR";
//            
//        case kBarcodeFormatCode39:
//            return "Code 39";
//            
//        case kBarcodeFormatCode93:
//            return "Code 93";
//            
//        case kBarcodeFormatCode128:
//            return "Code 128";
//            
//        case kBarcodeFormatDataMatrix:
//            return "Data Matrix";
//            
//        case kBarcodeFormatEan8:
//            return "EAN-8";
//            
//        case kBarcodeFormatEan13:
//            return "EAN-13";
//            
//        case kBarcodeFormatITF:
//            return "ITF";
//            
//        case kBarcodeFormatPDF417:
//            return "PDF417";
//            
//        case kBarcodeFormatQRCode:
//            return "QR Code";
//            
//        case kBarcodeFormatRSS14:
//            return "RSS 14";
//            
//        case kBarcodeFormatRSSExpanded:
//            return "RSS Expanded";
//            
//        case kBarcodeFormatUPCA:
//            return "UPCA";
//            
//        case kBarcodeFormatUPCE:
//            return "UPCE";
//            
//        case kBarcodeFormatUPCEANExtension:
//            return "UPC/EAN extension";
//            
//        default:
//            return "Unknown";
//        }
//    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
