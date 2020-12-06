//
//  File.swift
//  
//
//  Created by hoshiro ando on 2020/10/24.
//

import Foundation
import TitechPortalCore

let userName = readLine()!
let password = readLine()!
var matrix:[[String]] = [[]]

for _ in 0...6 {
    let s = readLine()!
    matrix.append(s.components(separatedBy: ","))
    
}

TitechPortalLoginScrapingTask.login(userName: userName, password: password, matrix: matrix) {result in
    switch result {
    case .success(let cookies):
        print(cookies)
    case .failure(let err):
        print(err)
    }
}

dispatchMain()
