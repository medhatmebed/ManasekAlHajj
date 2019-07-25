//
//  StringExtension.swift
//  SelfServices
//
//  Created by Owen on 2018-06-11.
//  Copyright © 2018 Rent Centric. All rights reserved.
//

import Foundation

extension String {
    static func className(_ aClass: AnyClass) -> String {
        return NSStringFromClass(aClass).components(separatedBy: ".").last!
    }
    
    func substring(_ from: Int) -> String {
        return String(self[self.index(self.startIndex, offsetBy: from)..<self.endIndex])
    }
    
    var length: Int {
        return self.count
    }
    
    func range(from nsRange: NSRange) -> Range<String.Index>? {
        guard
            let from16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location, limitedBy: utf16.endIndex),
            let to16 = utf16.index(from16, offsetBy: nsRange.length, limitedBy: utf16.endIndex),
            let from = String.Index(from16, within: self),
            let to = String.Index(to16, within: self)
            else { return nil }
        return from ..< to
    }
    
    func trimTheEndSpace() -> String {
        return self.replacingOccurrences(of: "\\s+$", with: "", options: .regularExpression)
    }
    
    func trimTheStartpace() -> String {
        return self.trimmingCharacters(in: .whitespaces)
    }
}
