//
//  Ratio.swift
//  Common
//
//  Created by Noah Emmet on 11/11/18.
//  Copyright © 2018 Sticks. All rights reserved.
//

import Foundation

public struct Ratio: Codable, Hashable {
    
    public static let oneToOne = Ratio(1, by: 1)
    public static let portrait = Ratio(3, by: 2)
    public static let landscape = Ratio(2, by: 3)
    
    public var term1: CGFloat
    public var term2: CGFloat

    public init(_ term1: CGFloat, by term2: CGFloat) {
        self.term1 = term1
        self.term2 = term2
    }
}
