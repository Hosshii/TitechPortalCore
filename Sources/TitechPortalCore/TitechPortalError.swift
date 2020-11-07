//
//  File.swift
//  
//
//  Created by hoshiro ando on 2020/11/07.
//

import Foundation

public enum TitechPortalError:Error {
    case networkError
    case passwordPageScrapingError
    case passwordAuthError
    case matrixPageScrapingError
    case matrixAuthError
    case loggedinPageError
    case otherError
}
