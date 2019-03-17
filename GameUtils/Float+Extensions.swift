//
//  Float+Extensions.swift
//  fighter
//
//  Created by 石宇涵 on 2018/11/18.
//  Copyright © 2018 石宇涵. All rights reserved.
//


import Foundation

public extension Float {
  public static func random(min: Float, max: Float) -> Float {
    let r32 = Float(arc4random(UInt32.self)) / Float(UInt32.max)
    return (r32 * (max - min)) + min
  }
}
