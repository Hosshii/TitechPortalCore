//
//  File.swift
//  
//
//  Created by hoshiro ando on 2020/10/24.
//

import Foundation
import Kanna

enum HTMLInputType: String {
    case text
    case password
    case checkbox
    case radio
    case file
    case hidden
    case submit
    case reset
    case button
    case image
}

struct HTMLInput {
    let name: String
    let value: String
    let type: HTMLInputType
    
    func encode() -> String {
        self.name + "=" + self.value
    }
}

struct HTMLInputParser {
    static func parse(_ input: Data) -> [HTMLInput] {
        do {
            let doc = try HTML(html: input, encoding: .utf8)
            return doc
                .css("input")
                .map {
                    HTMLInput(
                        name:
                            $0["name"] ?? "",
                        value: $0["value"] ?? "",
                        type: HTMLInputType(rawValue: $0["type"] ?? "") ?? .text
                    )
            }
        } catch {
            print(error)
            return []
        }
    }
}
