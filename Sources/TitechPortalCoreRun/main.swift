//
//  File.swift
//  
//
//  Created by hoshiro ando on 2020/10/24.
//

import Foundation
import TitechPortalCore

let s = makeAccount()

TitechPortalLoginScrapingTask.login(userName: s.userName, password: s.password, matrix: s.MATRIX) {result in
    switch result {
    case .success(let cookies):
        print(cookies)
    case .failure(let err):
        print(err)
    }
}

dispatchMain()
