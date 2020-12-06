//
//  Regexp.swift
//  
//
//  Created by hoshiro ando on 2020/10/24.
//

import Foundation
extension String {
    func match(_ pattern: String, options: NSRegularExpression.Options = []) -> String? {
        return Regexp(pattern, options: options).match(self, at: 1)
    }
    func matches(_ pattern: String, options: NSRegularExpression.Options = []) -> [[String]]? {
        return Regexp(pattern, options: options).matches(self, start: 1)
    }
    func match0(_ pattern: String, options: NSRegularExpression.Options = []) -> String? {
        return Regexp(pattern, options: options).match(self, at: 0)
    }
    func matches0(_ pattern: String, options: NSRegularExpression.Options = []) -> [[String]]? {
        return Regexp(pattern, options: options).matches(self, start: 0)
    }
}
struct Regexp {
    let pattern: String
    var options: NSRegularExpression.Options
    init(_ pattern: String, options: NSRegularExpression.Options = []) {
        self.pattern = pattern
        self.options = options
    }
    func matches(_ string: String, start: Int) -> [[String]]? {
        do {
            let results = try NSRegularExpression(pattern: pattern, options: options).matches(in: string, options: .reportProgress, range: NSRange(location: 0, length: string.count))
            var dats: [[String]] = []
            for result in results {
                var datss = [String]()
                for j in start ..< result.numberOfRanges {
                    if result.range(at: j).length == 0 {
                        continue
                    }
                    datss += [(string as NSString).substring(with: result.range(at: j))]
                }
                dats += [datss]
            }
            return dats
        } catch {
            return nil
        }
    }
    func match(_ string: String, at: Int) -> String? {
        do {
            let dat = try NSRegularExpression(pattern: pattern, options: options).matches(in: string, options: .reportProgress, range: NSRange(location: 0, length: string.count))
            if dat.isEmpty {
                return nil
            }
            if dat[0].range(at: at).length == 0 {
                return nil
            }
            return (string as NSString).substring(with: dat[0].range(at: at))
        } catch {
            return nil
        }
    }
}
