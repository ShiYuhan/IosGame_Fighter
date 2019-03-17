//
//  UIColor+Extensions.swift
//  fighter
//
//  Created by 石宇涵 on 2018/11/18.
//  Copyright © 2018 石宇涵. All rights reserved.
//


import UIKit
import SceneKit

let UIColorList:[UIColor] = [
  UIColor.black,
  UIColor.lime,
  UIColor.Gainsboro,
  UIColor.Honeydew,
  UIColor.cyan,
  UIColor.silver,
  UIColor.MistyRose,
  UIColor.maroon,
  UIColor.olive,
  UIColor.LightSteelBlue,
  UIColor.RosyBrown,
  UIColor.Thistle,
  UIColor.magenta,
  UIColor.DarkSeaGreen,
  UIColor.LightSteelBlue,
  UIColor.teal,
  UIColor.MistyRose,
  UIColor.AliceBlue,

]

extension UIColor {
  
  public static func random() -> UIColor {
    let maxValue = UIColorList.count
    let rand = Int(arc4random_uniform(UInt32(maxValue)))
    return UIColorList[rand]
  }
  
  public static var lime: UIColor {
    return UIColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 1.0)
  }
  
  public static var silver: UIColor {
    return UIColor(red: 192/255, green: 192/255, blue: 192/255, alpha: 1.0)
  }
  
  public static var maroon: UIColor {
    return UIColor(red: 0.5, green: 0.0, blue: 0.0, alpha: 1.0)
  }
  
  public static var olive: UIColor {
    return UIColor(red: 0.5, green: 0.5, blue: 0.0, alpha: 1.0)
  }
  
  public static var teal: UIColor {
    return UIColor(red: 0.0, green: 0.5, blue: 0.5, alpha: 1.0)
  }
  
  public static var navy: UIColor {
    return UIColor(red: 0.0, green: 0.0, blue: 128, alpha: 1.0)
  }
    public static var linen: UIColor {
        return UIColor(red: 250/255, green: 240/255, blue: 230/255, alpha: 1.0)
    }
    public static var Gainsboro: UIColor {
        return UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1.0)
    }
    public static var Honeydew: UIColor {
        return UIColor(red: 240/255, green: 255/255, blue: 240/255, alpha: 1.0)
    }
    public static var AliceBlue: UIColor {
        return UIColor(red: 240/255, green: 248/255, blue: 255/255, alpha: 1.0)
    }
    public static var MistyRose: UIColor {
        return UIColor(red: 255/255, green: 228/255, blue: 225/255, alpha: 1.0)
    }
    public static var LightSteelBlue: UIColor {
        return UIColor(red: 176/255, green: 196/255, blue: 222/255, alpha: 1.0)
    }
    public static var DarkSeaGreen: UIColor {
        return UIColor(red: 143/255, green: 188/255, blue: 143/255, alpha: 1.0)
    }
    public static var RosyBrown: UIColor {
        return UIColor(red: 188/255, green: 143/255, blue: 143/255, alpha: 1.0)
    }
    public static var Thistle: UIColor {
        return UIColor(red:216/255, green: 191/255, blue: 216/255, alpha: 1.0)
    }
    
}
