//
//  String+Extensions.swift
//  Common
//
//  Created by Noah Emmet on 8/11/18.
//  Copyright © 2018 Sticks. All rights reserved.
//

import Foundation

public extension String {
    func droppingPrefix(_ prefix: String) -> String {
        guard hasPrefix(prefix) else { return self }
        let newString = self.dropFirst(prefix.count)
        return String(newString)
    }
    
    func droppingUntil(_ match: String) -> String {
        guard let range = self.range(of: match) else { return self }
        var newString = self
        newString.removeSubrange(self.startIndex..<range.lowerBound)
        return newString
    }
    
    func prepending(_ prefix: String) -> String {
        return prefix + self
    }
    
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + dropFirst()
    }
    
    var camelCased: String {
        return self.components(separatedBy: " ")
            .map { return $0.lowercased().capitalizingFirstLetter() }
            .joined()
    }
    
    /// Downcases the string and replaces whitespace with a `_`. Useful for keys.
    var normalized: String {
        return self.lowercased().replacingOccurrences(of: " ", with: "_")
    }
    
    func words() -> [String] {
        let range = startIndex..<endIndex
        var words: [String] = []
        self.enumerateSubstrings(in: range, options: .byWords) { (substring, _, _, _) in
            words.append(substring ?? "")
        }
        return words
    }

    
    enum WordSplitResult {
        case match(String)
        case between(String)
    }
    func words(splitBy delimiter: String) -> [WordSplitResult] {
        let regex = try! NSRegularExpression(pattern: "#[a-z0-9]+", options: .caseInsensitive)
        
        let string = self as NSString
        let matchResults: [(match: String, result: NSTextCheckingResult)] = regex.matches(in: self, options: [], range: NSRange(location: 0, length: string.length)).map { result in
            let match = string.substring(with: result.range)
            return (match: match, result: result)
        }
        
        var wordSplitResults: [WordSplitResult] = []
        for (index, matchResult) in matchResults.enumerated() {
            // append the previous inbetween text
            if index == 0 {
                let firstBetween = string.substring(to: matchResult.result.range.location)
                wordSplitResults.append(.between(firstBetween))
            } else if let previousElement = matchResults.element(at: index-1) {
                let range = NSRange(location: previousElement.result.range.upperBound, length: matchResult.result.range.location - previousElement.result.range.upperBound)
                let previousBetween = string.substring(with: range)
                wordSplitResults.append(.between(previousBetween))
            }
            // append the match
            wordSplitResults.append(.match(matchResult.match))
            
            // append the last inbetween, if any
            let isLast = (matchResults.count == index+1)
            if isLast {
                let lastMatchIndex = matchResult.result.range.location + matchResult.result.range.length
                let endText = string.substring(from: lastMatchIndex)
                wordSplitResults.append(.between(endText))
            }
        }
        return wordSplitResults
    }
}