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
    
    public init(){
        print("init")
        
        let userName = readLine()!
        let password = readLine()!
        self.userName = userName
        self.password = password
        
        for _ in 0...6 {
            let s = readLine()!
            self.MATRIX.append(s.components(separatedBy: ","))
            
        }
    }
}
