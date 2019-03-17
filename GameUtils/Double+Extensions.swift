//
//  Double+Extensions.swift
//  fighter
//
//  Created by 石宇涵 on 2018/11/18.
//  Copyright © 2018 石宇涵. All rights reserved.
//


import Foundation

public extension Double {
  public static func random(min: Double, max: Double) -> Double {
    let r64 = Double(arc4random(UInt64.self)) / Double(UInt64.max)
    return (r64 * (max - min)) + min
  }
}

