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
    guard self.hasPrefix(prefix) else { return self }
    return String(self.dropFirst(prefix.count))
  }
  
  func droppingSuffix(_ suffix: String) -> String {
    guard hasSuffix(suffix) else { return self }
    return String(self.dropLast(suffix.count))
  }
  
  func droppingIfPrefixed(by prefix: String) -> String? {
    guard self.hasPrefix(prefix) else { return nil }
    return String(self.dropFirst(prefix.count))
  }
  
  func droppingIfSuffixed(by suffix: String) -> String? {
    guard hasSuffix(suffix) else { return nil }
    return String(self.dropLast(suffix.count))
  }
  
  mutating func dropPrefix(_ prefix: String) {
    self = self.droppingPrefix(prefix)
  }
  
  mutating func dropSuffix(_ suffix: String) {
    self = self.droppingSuffix(suffix)
  }
  
  func droppingUntil(_ match: String) -> String {
    guard let range = self.range(of: match) else { return self }
    var newString = self
    newString.removeSubrange(self.startIndex..<range.lowerBound)
    return newString
  }
  
  func droppingAfter(_ match: String) -> String {
    guard let index = range(of: match)?.upperBound else {
      return self
    }
    return String(prefix(upTo: index))
  }
  
  // https://stackoverflow.com/a/47220964
  func ranges(of substring: String, options: CompareOptions = [], locale: Locale? = nil) -> [Range<
    Index
  >] {
    var ranges: [Range<Index>] = []
    while ranges.last.map({ $0.upperBound < self.endIndex }) ?? true,
      let range = self.range(
        of: substring,
        options: options,
        range: (ranges.last?.upperBound ?? self.startIndex)..<self.endIndex,
        locale: locale
      )
    {
      ranges.append(range)
    }
    return ranges
  }
  
  func strings(for ranges: [Range<Index>]) -> [(String, Range<Index>)] {
    var allRanges = ranges
    if let firstRange = ranges.first, firstRange.lowerBound != self.startIndex {
      // The ranges do not include the first index; add a new range
      let startRange: Range<Index> = self.startIndex ..< firstRange.lowerBound
      allRanges.insert(startRange, at: 0)
    }
    if let lastRange = ranges.last, lastRange.upperBound != self.endIndex {
      // The ranges do not include the last index; add a new range
      let endRange: Range<Index> = lastRange.upperBound ..< self.endIndex
      allRanges.append(endRange)
    }
    let stringsByRange: [(String, Range<Index>)] = allRanges.map { range in
      let string = self[range]
      return (String(string), range)
    }
    return stringsByRange
  }
  
  // https://stackoverflow.com/a/47220964
  func replacing<Result>(
    _ strings: [String],
    options: CompareOptions = [],
    locale: Locale? = nil,
    with handler: (String, [Range<Index>]) throws -> Result
  ) rethrows -> [Result] {
    let rangesBySubstring = strings.flatMap { [$0: self.ranges(of: $0)] }
    let results: [Result] = try rangesBySubstring.map { (arg) -> Result in
      let (match, ranges) = arg
      return try handler(match, ranges)
    }
    return results
  }
  
  func prepending(_ prefix: String) -> String {
    return prefix + self
  }
  
  func capitalizingFirstLetter() -> String {
    return prefix(1).uppercased() + dropFirst()
  }
  
  var uppercasingFirst: String {
    return prefix(1).uppercased() + dropFirst()
  }
  
  var lowercasingFirst: String {
    return prefix(1).lowercased() + dropFirst()
  }
  
  var upperCamelCased: String {
    return lowerCamelCased.uppercasingFirst
  }
  
  var lowerCamelCased: String {
    guard !isEmpty else {
      return ""
    }
    let parts = self.components(separatedBy: CharacterSet.alphanumerics.inverted)
    let first = String(describing: parts.first!).lowercasingFirst
    let rest = parts.dropFirst().map({String($0).uppercasingFirst})
    return ([first] + rest).joined(separator: "")
  }
  
  var lowerSnakeCased: String {
    guard !isEmpty else {
      return ""
    }
    let components = self.components(separatedBy: CharacterSet.alphanumerics.inverted)
    let rest = components.map { String($0).lowercased() }
    return rest.joined(separator: "_")
  }
  
  /// Downcases the string and replaces whitespace with a `_`. Useful for keys.
  var normalized: String {
    return self.lowercased().replacingOccurrences(of: " ", with: "_")
  }
  
  /// Replaces line breaks with extra spaces
  var singleLine: String {
    return replacingOccurrences(of: "\n", with: "   ")
  }
  
  static func random(
    length: Int,
    allowedChars: String = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
  ) -> String {
    let string = String((0..<length).map { _ in allowedChars.randomElement()! })
    return string
  }
}

// MARK: - Splitting

public extension String {
  /// https://stackoverflow.com/a/31727051
  func slice(from: String, to: String) -> String? {
    return (range(of: from)?.upperBound).flatMap { substringFrom in
      (range(of: to, range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
        String(self[substringFrom..<substringTo])
      }
    }
  }
  
  func sliceAll(from: String, to: String) -> [String] {
    var copy = self
    var slices: [String] = []
    while let sliced = copy.slice(from: from, to: to) {
      slices.append(sliced)
      copy = copy.droppingPrefix(sliced)
    }
    return slices
  }
  
  func words() -> [String] {
    let range = startIndex..<endIndex
    var words: [String] = []
    self.enumerateSubstrings(in: range, options: .byWords) { substring, _, _, _ in
      words.append(substring ?? "")
    }
    return words
  }
  
  enum WordSplitResult {
    case match(String)
    case between(String)
    
    public var asMatch: String? {
      if case .match(let match) = self {
        return match
      } else {
        return nil
      }
    }
    
    public var asBetween: String? {
      if case .between(let between) = self {
        return between
      } else {
        return nil
      }
    }
  }
  
  func words(splitBy delimiter: String) -> [WordSplitResult] {
    let regex = try! NSRegularExpression(pattern: "#[a-z0-9]+", options: .caseInsensitive)
    
    let string = self as NSString
    let matchResults: [(match: String, result: NSTextCheckingResult)] = regex.matches(
      in: self,
      options: [],
      range: NSRange(location: 0, length: string.length)
    ).map { result in
      let match = string.substring(with: result.range)
      return (match: match, result: result)
    }
    
    // If there are no matches, return self.
    guard matchResults.isEmpty == false else {
      return [.between(self)]
    }
    
    var wordSplitResults: [WordSplitResult] = []
    for (index, matchResult) in matchResults.enumerated() {
      // append the previous inbetween text
      if index == 0 {
        let firstBetween = string.substring(to: matchResult.result.range.location)
        wordSplitResults.append(.between(firstBetween))
      } else if let previousElement = matchResults.element(at: index - 1) {
        let range = NSRange(
          location: previousElement.result.range.upperBound,
          length: matchResult.result.range.location - previousElement.result.range.upperBound
        )
        let previousBetween = string.substring(with: range)
        wordSplitResults.append(.between(previousBetween))
      }
      // append the match
      wordSplitResults.append(.match(matchResult.match))
      
      // append the last inbetween, if any
      let isLast = (matchResults.count == index + 1)
      if isLast {
        let lastMatchIndex = matchResult.result.range.location + matchResult.result.range.length
        let endText = string.substring(from: lastMatchIndex)
        wordSplitResults.append(.between(endText))
      }
    }
    return wordSplitResults
  }
}

// https://stackoverflow.com/a/24144365

public extension String {
  subscript (i: Int) -> Character {
    return self[index(startIndex, offsetBy: i)]
  }
  
  subscript (bounds: CountableRange<Int>) -> Substring {
    let start = index(startIndex, offsetBy: bounds.lowerBound)
    let end = index(startIndex, offsetBy: bounds.upperBound)
    return self[start ..< end]
  }
  
  subscript (bounds: CountableClosedRange<Int>) -> Substring {
    let start = index(startIndex, offsetBy: bounds.lowerBound)
    let end = index(startIndex, offsetBy: bounds.upperBound)
    return self[start ... end]
  }
  
  subscript (bounds: CountablePartialRangeFrom<Int>) -> Substring {
    let start = index(startIndex, offsetBy: bounds.lowerBound)
    let end = index(endIndex, offsetBy: -1)
    return self[start ... end]
  }
  
  subscript (bounds: PartialRangeThrough<Int>) -> Substring {
    let end = index(startIndex, offsetBy: bounds.upperBound)
    return self[startIndex ... end]
  }
  
  subscript (bounds: PartialRangeUpTo<Int>) -> Substring {
    let end = index(startIndex, offsetBy: bounds.upperBound)
    return self[startIndex ..< end]
  }
}

public extension Substring {
  subscript (i: Int) -> Character {
    return self[index(startIndex, offsetBy: i)]
  }
  
  subscript (bounds: CountableRange<Int>) -> Substring {
    let start = index(startIndex, offsetBy: bounds.lowerBound)
    let end = index(startIndex, offsetBy: bounds.upperBound)
    return self[start ..< end]
  }
  
  subscript (bounds: CountableClosedRange<Int>) -> Substring {
    let start = index(startIndex, offsetBy: bounds.lowerBound)
    let end = index(startIndex, offsetBy: bounds.upperBound)
    return self[start ... end]
  }
  
  subscript (bounds: CountablePartialRangeFrom<Int>) -> Substring {
    let start = index(startIndex, offsetBy: bounds.lowerBound)
    let end = index(endIndex, offsetBy: -1)
    return self[start ... end]
  }
  
  subscript (bounds: PartialRangeThrough<Int>) -> Substring {
    let end = index(startIndex, offsetBy: bounds.upperBound)
    return self[startIndex ... end]
  }
  
  subscript (bounds: PartialRangeUpTo<Int>) -> Substring {
    let end = index(startIndex, offsetBy: bounds.upperBound)
    return self[startIndex ..< end]
  }
}
