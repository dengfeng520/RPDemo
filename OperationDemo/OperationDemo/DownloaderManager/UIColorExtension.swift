//
//  UIColorExtension.swift
//  OperationDemo
//
//  Created by rp.wang on 2021/2/19.
//

import UIKit

/// 屏幕宽
public var __screenWidth: CGFloat {
    return UIScreen.main.bounds.size.width
}
/// 屏幕高
 public var __screenHeight: CGFloat {
    return UIScreen.main.bounds.size.height
}

extension UIColor {
    public class func hexStringToColor(_ hexadecimal: String, _ alpha: CGFloat? = 1) -> UIColor {
        var cstr = hexadecimal.trimmingCharacters(in:  CharacterSet.whitespacesAndNewlines).uppercased() as NSString;
        if cstr.length < 6 {
            return .clear
        }
        if cstr.hasPrefix("0X") {
            cstr = cstr.substring(from: 2) as NSString
        }
        if cstr.hasPrefix("#") {
            cstr = cstr.substring(from: 1) as NSString
        }
        if cstr.length != 6 {
            return .clear
        }
        var range = NSRange()
        range.location = 0
        range.length = 2
        let rStr = cstr.substring(with: range)
        range.location = 2
        let gStr = cstr.substring(with: range)
        range.location = 4
        let bStr = cstr.substring(with: range)
        var r :UInt32 = 0x0
        var g :UInt32 = 0x0
        var b :UInt32 = 0x0
        Scanner(string: rStr).scanHexInt32(&r)
        Scanner(string: gStr).scanHexInt32(&g)
        Scanner(string: bStr).scanHexInt32(&b)
        return UIColor(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: alpha ?? 1)
    }
}


