//
//  Int+Extensions.swift
//  fighter
//
//  Created by 石宇涵 on 2018/11/18.
//  Copyright © 2018 石宇涵. All rights reserved.
//

import Foundation

public extension Int {
  public static func random(min: Int , max: Int) -> Int {
    return Int(arc4random_uniform(UInt32(max - min + 1))) + min
  }
}
