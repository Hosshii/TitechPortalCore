//
//  File.swift
//  
//
//  Created by hoshiro ando on 2020/10/24.
//

import Foundation


public struct Account {
    var MATRIX:[[String]] = [[]]
    var userName: String
    var password: String
}

func makeAccount()->Account{
    let userName = readLine()!
    let password = readLine()!
    var MATRIX:[[String]] = [[]]
    
    for _ in 0...6 {
        let s = readLine()!
       MATRIX.append(s.components(separatedBy: ","))
        
    }
    
    return Account(MATRIX: MATRIX, userName: userName, password: password)
}
