//
//  TBCaptureMaskView.swift
//  ZxingDemo-Swift
//
//  Created by Jarvis on 14-8-7.
//  Copyright (c) 2014年 com.thongbin. All rights reserved.
//

import UIKit

@objc protocol TBCaptureMaskViewDelegate : NSObjectProtocol{
    func cancelScan(sender: AnyObject)
    
    optional func pickImageFromPhotoLibrary(sender: AnyObject)
}

class TBCaptureMaskView: UIView{
    
    var _scan_icon_00 : UIImageView? = UIImageView()
    var _scan_icon_01 : UIImageView?  = UIImageView()
    var _maskImageView : UIImageView? = UIImageView()
    var _barcode_scan_box_top : UIImageView? = UIImageView()
    var _barcode_scan_box_mid : UIImageView? = UIImageView()
    var _barcode_scan_box_bottom : UIImageView? = UIImageView()
    var _barcode_effect_line1 : UIImageView? = UIImageView()
    var _barcode_effect_line2 : UIImageView? = UIImageView()
    
    var _cancelButton : UIButton?
    var _pickImageButton : UIButton!
    
    weak var delegate : TBCaptureMaskViewDelegate?
    
    
    required init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor.clearColor()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clearColor()
        
        _scan_icon_00?.frame = CGRectMake(frame.size.width/4 - 28, 40, 56.0, 46)
        _scan_icon_00?.image = UIImage(named: "scan_icon0")
        self.addSubview(_scan_icon_00!)
        
        _scan_icon_01?.frame = CGRectMake(frame.size.width/4*3 - 28, 40, 56.0, 46)
        _scan_icon_01?.image = UIImage(named: "scan_icon1")
        self.addSubview(_scan_icon_01!)
        
        _maskImageView?.frame = frame
        _maskImageView?.image = UIImage(named: "barcode_scan_back")
        self.addSubview(_maskImageView!)
        
        _barcode_scan_box_top?.frame = CGRect(x: 0.0, y: 0.0, width: 226.0, height: 23.5)
        _barcode_scan_box_top?.center = CGPoint(x: frame.size.width/2, y: 150.0)
        _barcode_scan_box_top?.image = UIImage(named: "barcode_scan_box_top")
        self.addSubview(_barcode_scan_box_top!)
        
        _barcode_scan_box_mid?.frame = CGRect(x: 0.0, y: 0.0, width: 226.0, height: 176.5)
        _barcode_scan_box_mid?.center = CGPoint(x: frame.size.width/2, y: 250.0)
        _barcode_scan_box_mid?.image = UIImage(named: "barcode_scan_box_mid").stretchableImageWithLeftCapWidth(1, topCapHeight: 0)
        self.addSubview(_barcode_scan_box_mid!)
        
        _barcode_scan_box_bottom?.frame = CGRect(x: 0.0, y: 0.0, width: 226.0, height: 23.5)
        _barcode_scan_box_bottom?.center = CGPoint(x: frame.size.width/2, y: 350.0)
        _barcode_scan_box_bottom?.image = UIImage(named: "barcode_scan_box_bottom")
        self.addSubview(_barcode_scan_box_bottom!)
        
        _cancelButton = UIButton.buttonWithType(.Custom) as? UIButton
        _cancelButton?.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
        _cancelButton?.center = CGPoint(x: 30, y: frame.size.height/25*24 - _cancelButton!.frame.size.height/2)
        _cancelButton?.setBackgroundImage(UIImage(named: "barcode_close_btn"), forState: .Normal)
        _cancelButton?.addTarget(self, action: "cancelScanAction:", forControlEvents: .TouchUpInside)
        self.addSubview(_cancelButton!)
        
        _pickImageButton = UIButton.buttonWithType(.Custom) as UIButton
        _pickImageButton.frame = CGRect(x: 0, y: 0, width: 89, height: 30)
        _pickImageButton.center = CGPoint(x: 320/2, y: self.frame.size.height/25*24 - _pickImageButton.frame.size.height/2)
        _pickImageButton.setTitle("从相册选", forState: .Normal)
        _pickImageButton.setTitleColor(UIColor(red: 0.53, green: 0.53, blue: 0.53, alpha: 1), forState: .Normal)
        _pickImageButton.setTitleColor(.whiteColor(), forState: .Highlighted)
        _pickImageButton.titleEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        _pickImageButton.titleLabel.font = .systemFontOfSize(13.0)
        _pickImageButton.setBackgroundImage(UIImage(named: "barcode_btn"), forState: .Normal)
        _pickImageButton.addTarget(self, action: "pickImageFromPhotoLibraryAction:", forControlEvents: .TouchUpInside)
        self.addSubview(_pickImageButton)
        
    }
    
    //button action
    func cancelScanAction(sender: AnyObject)
    {
        _scan_icon_00?.removeFromSuperview()
        _scan_icon_00 = nil
        _scan_icon_01?.removeFromSuperview()
        _scan_icon_01 = nil
        _barcode_scan_box_top?.removeFromSuperview()
        _barcode_scan_box_top = nil
        _barcode_scan_box_mid?.removeFromSuperview()
        _barcode_scan_box_mid = nil
        _barcode_scan_box_bottom?.removeFromSuperview()
        _barcode_scan_box_bottom = nil
        _maskImageView?.removeFromSuperview()
        _maskImageView = nil
        _barcode_effect_line1?.removeFromSuperview()
        _barcode_effect_line1 = nil
        _barcode_effect_line2?.removeFromSuperview()
        _barcode_effect_line2 = nil
        
        _cancelButton = nil
        _pickImageButton = nil
        
        if let isTrue = delegate?.respondsToSelector("cancelScan:")
        {
            if isTrue
            {
                delegate?.cancelScan(sender)
            }
        }
    }
    
    func pickImageFromPhotoLibraryAction(sender: AnyObject)
    {
        if let isTrue = delegate?.respondsToSelector("pickImageFromPhotoLibrary:")
        {
            if isTrue
            {
                delegate?.pickImageFromPhotoLibrary!(sender)
            }
        }
    }
    
    func startScanEffectAnimation()
    {
        if _barcode_effect_line2 != nil
        {
            _barcode_effect_line2?.removeFromSuperview()
            _barcode_effect_line2 = nil
        }
        
        _barcode_effect_line1 = UIImageView()
        _barcode_effect_line1?.frame = CGRect(x: 0.0, y: 0.0, width: 214, height: 55);
        _barcode_effect_line1?.image = UIImage(named:"barcode_effect_line1");
        _barcode_effect_line1?.center = CGPoint(x: self.frame.size.width/2, y: 130.0);
        self.addSubview(_barcode_effect_line1!);
        
        UIView.animateWithDuration(0.6, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut,
            animations: {
                self._barcode_effect_line1!.transform = CGAffineTransformMakeTranslation(0.0, 205)
            }, completion: {(finished) -> Void in
                self._barcode_effect_line1!.removeFromSuperview()
                self._barcode_effect_line1 = nil
                self.startRoundScanEffect()
        })
    }
    
    func startRoundScanEffect()
    {
        _barcode_effect_line2 = UIImageView()
        _barcode_effect_line2?.frame = CGRect(x: 0.0, y: 0.0, width: 214, height: 10)
        _barcode_effect_line2?.image = UIImage(named: "barcode_effect_line2")
        _barcode_effect_line2?.center = CGPoint(x:self.frame.size.width/2, y:355.0)
        self.addSubview(_barcode_effect_line2!)
        
        startRoundScanEffectAnimation()
    }
    
    func startRoundScanEffectAnimation()
    {
        UIView.animateWithDuration(1.5, delay: 0.0, options: UIViewAnimationOptions.Repeat|UIViewAnimationOptions.Autoreverse|UIViewAnimationOptions.CurveEaseInOut, animations: {
            self._barcode_effect_line2!.transform = CGAffineTransformMakeTranslation(0.0, -210.0)
            self._barcode_effect_line2!.transform = CGAffineTransformIdentity
            self._barcode_effect_line2!.transform = CGAffineTransformMakeTranslation(0.0, -210.0)
            }, completion: {(finished) -> Void in
                
        })
    }
    
    
    
    
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect)
    {
        // Drawing code
    }
    */

}
