//
//  UILabel+NSMutableAttributedString.swift
//  MyHabits
//
//  Created by Andrey Antipov on 28.11.2020.
//  Copyright © 2020 Andrey Antipov. All rights reserved.
//
import UIKit

extension NSMutableAttributedString{
    // If no text is send, then the style will be applied to full text
    func setColorForPart(_ textToFind: String?, with color: UIColor) {

        let range:NSRange?
        if let text = textToFind{
            range = self.mutableString.range(of: text, options: .caseInsensitive)
        }else{
            range = NSMakeRange(0, self.length)
        }
        if range!.location != NSNotFound {
            addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range!)
        }
    }
}

extension UILabel {
    func setColorForPart(wholeText: String?, coloredPartText: String?, colorOfPart: UIColor) {
        if let wholeText = wholeText {
            let string: NSMutableAttributedString = NSMutableAttributedString(string: wholeText)
            string.setColorForPart(coloredPartText, with: colorOfPart)
            attributedText = string
        } else {
            attributedText = nil
        }
        
    }
}
