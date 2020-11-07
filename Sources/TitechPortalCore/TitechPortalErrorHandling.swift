//
//  File.swift
//  
//
//  Created by hoshiro ando on 2020/11/07.
//

import Foundation

public struct TitechPortalErrorHandling {
    public enum PageType {
        case password
        case matrix
        case loggedin
        case error
    }
    
    public static func JudgePage(data: Data) -> PageType {
        let PASSWORD_PAGE_KEYWORD = ["Please input your account & password.", "Account name and password are case-sensitive."]
        let MATRIX_PAGE_KEYWORD = ["Matrix Authentication", "Matrix entries are NOT case-sensitive."]
        let LOGGEDIN_PAGE_KEYWORD = ["Tokyo Tech Mail", "TOKYO TECH OCW-i"]
        
        guard let dataString = String(data: data, encoding: .utf8) else {
            return PageType.error
        }
        if PASSWORD_PAGE_KEYWORD.allSatisfy({dataString.contains($0)}) {
            return PageType.password
        }else if MATRIX_PAGE_KEYWORD.allSatisfy({dataString.contains($0)}) {
            return PageType.matrix
        }else if LOGGEDIN_PAGE_KEYWORD.allSatisfy({dataString.contains($0)}) {
            return PageType.loggedin
        }
        
        return PageType.error
    }
}
