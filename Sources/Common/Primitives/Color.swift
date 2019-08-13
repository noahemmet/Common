//
//  Color.swift
//  FingerPaint
//
//  Created by Noah Emmet on 5/7/18.
//  Copyright © 2018 Sticks. All rights reserved.
//

import Foundation
#if canImport(UIKit)
import UIKit
#endif

public struct Color: Codable, Hashable {
    
    public var red: Double
    public var green: Double
    public var blue: Double
    public var alpha: Double

    public init(red: Double, green: Double, blue: Double, alpha: Double = 1.0) {
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = alpha
    }
    
    public enum HexError: Error {
        case unknown(Any)
        case invalidHex(String)
    }
    
    public var hexRGB: String {
        let rgb: Int = (Int)(red * 255) << 16 | (Int)(green * 255) << 8 | (Int)(blue * 255) << 0
        return String(format: "#%06x", rgb)
    }
    
    public var hexRGBA: String {
        let rgb: Int = (Int)(red * 255) << 16 | (Int)(green * 255) << 8 | (Int)(blue * 255) << 0
        return String(format: "#%06x", rgb)
    }
    
    public init(hex unknownHex: String) throws {
        let hexString = unknownHex.trimmingCharacters(in: .whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        
        if hexString.hasPrefix("#") {
            scanner.scanLocation = 1
        }
        
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        
        let red   = Double(r) / 255.0
        let green = Double(g) / 255.0
        let blue  = Double(b) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: 1)
    }

    public static func random(includeAlpha: Bool = false) -> Color {
        let red = Double.random(in: 0..<1)
        let green = Double.random(in: 0..<1)
        let blue = Double.random(in: 0..<1)
        let alpha: Double = includeAlpha ? Double.random(in: 0..<1) : 1
        let color = Color(red: red, green: green, blue: blue, alpha: alpha)
        return color
    }
    
    public mutating func randomize(within delta: Double, includeAlpha: Bool = false) {
        red.randomize(within: delta, clipTo: 0..<1)
        green.randomize(within: delta, clipTo: 0..<1)
        blue.randomize(within: delta, clipTo: 0..<1)
        if includeAlpha {
            alpha.randomize(within: delta, clipTo: 0..<1)
        }
    }
    
    public mutating func randomize(within range: Range<Double>, includeAlpha: Bool = false) {
        red.randomize(within: range)
        green.randomize(within: range)
        blue.randomize(within: range)
        if includeAlpha { 
            alpha.randomize(within: range)
        }
    }
    
    public mutating func darken(by delta: Double) {
        red *= delta
        green *= delta
        blue *= delta
    }
    
    public func darkened(by delta: Double) -> Color {
        var new = self
        new.darken(by: delta)
        return new
    }
    
    public mutating func lighten(by delta: Double) {
        red *= -delta
        green *= -delta
        blue *= -delta
    }
    
    public func lightened(by delta: Double) -> Color {
        var new = self
        new.lighten(by: delta)
        return new
    }
    
//    #if canImport(UIKit)
//    public init(_ uiColor: UIColor) {
//        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
//        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
//        self.init(red: Double(red), green: Double(green), blue: Double(blue), alpha: Double(alpha))
//    }
//
//    public var uiColor: UIColor {
//        let r = CGFloat(red)
//        let g = CGFloat(green)
//        let b = CGFloat(blue)
//        let a = CGFloat(alpha)
//        return UIColor(red: r, green: g, blue: b, alpha: a)
//    }
//
//    public var cgColor: CGColor {
//        return uiColor.cgColor
//    }
//    #endif
}

public extension Color {
    static let black = try! Color(hex: "#000000")
    static let gray = try! Color(hex: "#6F6F6F")
    static let darkGray = try! Color(hex: "#585858")
    static let white = try! Color(hex: "#ffffff")
    static let red = try! Color(hex: "#DD4949")
    
    static let border = try! Color(hex: "#6F6F6F")
}

extension Color: ExpressibleByStringLiteral {
    public init(stringLiteral: String) {
        try! self.init(hex: stringLiteral)
    }
}

extension Color: CustomStringConvertible {
	public var description: String { 
		return hexRGB
	}
}
