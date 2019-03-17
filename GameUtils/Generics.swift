//
//  Generics.swift
//  fighter
//
//  Created by 石宇涵 on 2018/11/18.
//  Copyright © 2018 石宇涵. All rights reserved.
//

import Foundation

public func arc4random <T: ExpressibleByIntegerLiteral> (_ type: T.Type) -> T {
  var r: T = 0
  arc4random_buf(&r, Int(MemoryLayout<T>.size))
  return r
}
