//
//  ColorObjects.swift
//  BackgroundColorChanger
//
//  Created by Nicole Chu on 11/6/20.
//

import Foundation
import UIKit

struct ColorManager: Codable {
    static var colorCollection: [Color] = []
}

struct Color: Codable {
    var red: Int = 255
    var green: Int = 255
    var blue: Int = 255
    var alpha: Int = 255
    
    func GetHex() -> String {
        return String(format: "%02lX%02lX%02lX%02lX",
                      self.red, self.green, self.blue, self.alpha)
    }
        
    func GetImage() -> UIImage {
        let inputRed = CGFloat(self.red)/255
        let inputGreen = CGFloat(self.green)/255
        let inputBlue = CGFloat(self.blue)/255
        let inputAlpha = CGFloat(self.alpha)/255
        
        let uiColor = UIColor(red: inputRed, green: inputGreen, blue: inputBlue, alpha: inputAlpha)
        
        return uiColor.imageWithColor(width: 20, height: 20)
    }
}

extension UIColor {
    func imageWithColor(width: Int, height: Int) -> UIImage {
        let size = CGSize(width: width, height: height)
        
        return UIGraphicsImageRenderer(size: size).image {
            rendererContext in
            self.setFill()
            rendererContext.fill(CGRect(origin: .zero, size: size))
        }
    }
}
