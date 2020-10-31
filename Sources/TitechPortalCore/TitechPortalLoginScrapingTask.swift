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
    public static func login(userName: String, password: String, matrix: [[String]]) {
        print("login")
        URLSession
            .shared
            .dataTask(with: URL(string:"https://portal.nap.gsic.titech.ac.jp/GetAccess/Login?Template=userpass_key&AUTHMETHOD=UserPassword")!)
            { data, res, err in
                let parsed = HTMLInputParser.parse(data!)
                let inputed = parsed.map { data -> HTMLInput in
                    if data.name == USER_NAME_IDE {
                        return HTMLInput(name: data.name, value: userName.urlEncoded, type: data.type)
                    }
                    else if data.name == USER_PASSWORD_IDE {
                        return HTMLInput(name: data.name, value: password.urlEncoded, type: data.type)
                    }else {
                        return HTMLInput(name: data.name, value: data.value, type: data.type)
                    }
                }
                
                var urlRequest = URLRequest(url: URL(string: "https://portal.nap.gsic.titech.ac.jp/GetAccess/Login")!)
                urlRequest.httpMethod = "POST"
                urlRequest.addValue("https://portal.nap.gsic.titech.ac.jp/GetAccess/Login", forHTTPHeaderField: "Referer")
                urlRequest.httpBody = inputed.map{data in
                    data.join()
                }
                .joined(separator: "&")
                .data(using: .utf8)
                
                let task = URLSession
                    .shared
                    .dataTask(with: urlRequest) { data, res, err in
                        guard let dataString = String(data: data!, encoding: .utf8) else {
                            print("parse password login request occurs error")
                            return
                        }
                        guard let selected_matrix = dataString.matches("([A-J]),(\\d+)") else {
                            print("read matrix in html error")
                            return
                        }
                        
                        if selected_matrix.count < 3 {
                            return
                        }
                        
                        let parsed = HTMLInputParser.parse(data!)
                        
                        // matrixコードを入力したHTMLInputを返す。最後にcompactMapでnilをのぞいているので[HTMLInput]型
                        let inputed = parsed.map{ data -> HTMLInput? in
                            var row: String
                            var column: String
                            if data.name == MATRIX_1_IDE {
                                row = selected_matrix[0][1]
                                column = selected_matrix[0][0]
                            }else if data.name == MATRIX_2_IDE {
                                row = selected_matrix[1][1]
                                column = selected_matrix[1][0]
                            }else if data.name == MATRIX_3_IDE {
                                row = selected_matrix[2][1]
                                column = selected_matrix[2][0]
                                
                            }else {
                                return HTMLInput(name: data.name, value: data.value, type: data.type)
                            }
                            guard let rowNum = Int(row) else {
                                print("read row error")
                                return nil
                            }
                            // アルファベットを数字に変えてるだけ
                            guard let columnNum = (column
                                                    .unicodeScalars
                                                    .first
                                                    .flatMap{ a in
                                                        "A"
                                                            .unicodeScalars
                                                            .first
                                                            .map{b in
                                                                a.value - b.value
                                                            }
                                                    }) else {
                                print("read column error")
                                return nil
                            }
                            // rowNumは1始まりになってる(matrix[[0] は []になってる)
                            return HTMLInput(name: data.name, value: String(matrix[rowNum][Int(columnNum)]), type: data.type)
                        }
                        .compactMap{$0}
                        
                        
                        var urlRequest = URLRequest(url: URL(string: "https://portal.nap.gsic.titech.ac.jp/GetAccess/Login")!)
                        urlRequest.httpMethod = "POST"
                        urlRequest.addValue("https://portal.nap.gsic.titech.ac.jp/GetAccess/Login", forHTTPHeaderField: "Referer")
                        urlRequest.httpBody = inputed.map{data in
                            data.join()
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
