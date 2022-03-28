//
//  Extensions.swift
//  Utility
//
//  Created by 廖力頡 on 2022/3/28.
//

import Foundation

extension Array {
    subscript (safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
