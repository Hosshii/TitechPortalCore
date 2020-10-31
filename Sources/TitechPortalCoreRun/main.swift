//
//  File.swift
//  
//
//  Created by hoshiro ando on 2020/10/24.
//

import Foundation
import TitechPortalCore

let s = Auth()
TitechPortalLoginScrapingTask.login(userName: s.userName, password: s.password, matrix: s.MATRIX)

dispatchMain()
