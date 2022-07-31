//
//  String+heightExt.swift
//  TodoAppUnderdogFantasy
//
//  Created by Usman Ahmed on 31/07/2022.
//

import Foundation
import UIKit

extension String {
    func height(_ width: CGFloat, minHeight: CGFloat, font: UIFont) -> CGFloat {
        let constrainedSize = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingRect = self.boundingRect(with: constrainedSize, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        return max(minHeight, boundingRect.height)
    }
}
