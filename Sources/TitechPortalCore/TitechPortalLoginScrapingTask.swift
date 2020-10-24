//
//  File.swift
//  
//
//  Created by hoshiro ando on 2020/10/24.
//

import Foundation

let USER_NAME_IDE = "usr_name"
let USER_PASSWORD_IDE = "usr_password"
let MATRIX_1_IDE = "message3"
let MATRIX_2_IDE = "message4"
let MATRIX_3_IDE = "message5"


public struct TitechPortalLoginScrapingTask {
    public static func login(){
        print("login")
        URLSession
            .shared
            .dataTask(with: URL(string:"https://portal.nap.gsic.titech.ac.jp/GetAccess/Login?Template=userpass_key&AUTHMETHOD=UserPassword")!)
            { data, res, err in
                //            print(res ?? "no res")
//                print(String(data: data!, encoding: .utf8) ?? "no data")
                
//                HTMLInputParser.parse(data!)
//                    .map {data in
//                        print(data)
//                    }
                let parsed = HTMLInputParser.parse(data!)
                let inputed = parsed.map { data -> HTMLInput in
                    if data.name == USER_NAME_IDE {
                        return HTMLInput(name: data.name, value: USER_NAME, type: data.type)
                    }
                    else if data.name == USER_PASSWORD_IDE {
                        return HTMLInput(name: data.name, value: PASSWORD, type: data.type)
                    }else {
                        return HTMLInput(name: data.name, value: data.value, type: data.type)
                    }
                }
//                print("================")
                
//                inputed.map{data in
//                    print(data)
//                }
                
                var urlRequest = URLRequest(url: URL(string: "https://portal.nap.gsic.titech.ac.jp/GetAccess/Login")!)
                urlRequest.httpMethod = "POST"
                urlRequest.addValue("https://portal.nap.gsic.titech.ac.jp/GetAccess/Login", forHTTPHeaderField: "Referer")
                urlRequest.httpBody = inputed.map{data in
                    data.encode()
                }
                .joined(separator: "&")
                .data(using: .utf8)
                
                //                print(String(data: urlRequest.httpBody!, encoding: .utf8))
                
//                print("============")
                
                let task = URLSession
                    .shared
                    .dataTask(with: urlRequest) { data, res, err in
//                        print(String(data: data!, encoding: .utf8) ?? "no data" )
                        //                        print(err)
                        //                        print(res)
                        let dataString = String(data: data!, encoding: .utf8)!
                        guard let matrix = dataString.matches("([A-J]),(\\d+)") else {
                            return
                        }
                        
                        if matrix.count < 3 {
                            return
                        }
                        
                        let m = Matrix()
                        let parsed = HTMLInputParser.parse(data!)
                        let inputed = parsed.map{ data -> HTMLInput in
                            if data.name == MATRIX_1_IDE {
                                let row = Int(matrix[0][1])!
//                                let column = first(matrix[0][0].utf8)!
                                let column = matrix[0][0].unicodeScalars.first!.value - "A".unicodeScalars.first!.value
                                return HTMLInput(name: data.name, value: String(m.MATRIX[row][Int(column)]), type: data.type)
                            }else if data.name == MATRIX_2_IDE {
                                let row = Int(matrix[1][1])!
//                                let column = first(matrix[0][0].utf8)!
                                let column = matrix[1][0].unicodeScalars.first!.value - "A".unicodeScalars.first!.value
                                return HTMLInput(name: data.name, value: String(m.MATRIX[row][Int(column)]), type: data.type)
                            }else if data.name == MATRIX_3_IDE {
                                let row = Int(matrix[2][1])!
//                                let column = first(matrix[0][0].utf8)!
                                let column = matrix[2][0].unicodeScalars.first!.value - "A".unicodeScalars.first!.value
                                return HTMLInput(name: data.name, value: String(m.MATRIX[row][Int(column)]), type: data.type)
                            }
                            return HTMLInput(name: data.name, value: data.value, type: data.type)
                        }
                        
                        var urlRequest = URLRequest(url: URL(string: "https://portal.nap.gsic.titech.ac.jp/GetAccess/Login")!)
                        urlRequest.httpMethod = "POST"
                        urlRequest.addValue("https://portal.nap.gsic.titech.ac.jp/GetAccess/Login", forHTTPHeaderField: "Referer")
                        urlRequest.httpBody = inputed.map{data in
                            data.encode()
                        }
                        .joined(separator: "&")
                        .data(using: .utf8)
                        
                        let task = URLSession
                            .shared
                            .dataTask(with: urlRequest) { data, res, err in
                                print(String(data: data!, encoding: .utf8) ?? "no data" )
                            }
                            .resume()
                        
                    }
                    .resume()
            }
            .resume()
    }
}
