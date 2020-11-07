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
    public static func login(userName: String, password: String, matrix: [[String]], complethionHandler: @escaping (Result<[HTTPCookie],TitechPortalError>) -> Void) {
        print("login")
        URLSession
            .shared
            .dataTask(with: URL(string:"https://portal.nap.gsic.titech.ac.jp/GetAccess/Login?Template=userpass_key&AUTHMETHOD=UserPassword")!)
            { _data, _res, err in
                guard let data = _data else {
                    print("response data is nil")
                    complethionHandler(.failure(TitechPortalError.passwordPageScrapingError))
                    return
                }
                
                if TitechPortalErrorHandling.JudgePage(data: data) != TitechPortalErrorHandling.PageType.password {
                    print("Cannot scraping password authenticate page")
                    complethionHandler(.failure(TitechPortalError.passwordPageScrapingError))
                    return
                }
                
                let parsed = HTMLInputParser.parse(data)
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
                
                guard let res = _res else {
                    return
                }
                var cookieURL: URL?
                
                if let res = res as? HTTPURLResponse {
                    if let fields = res.allHeaderFields as? [String: String], let url = res.url {
                        cookieURL = url
                        for cookie in HTTPCookie.cookies(withResponseHeaderFields: fields, for: url) {
                            HTTPCookieStorage.shared.setCookie(cookie)
                        }
                    }
                }
                
                let task = URLSession
                    .shared
                    .dataTask(with: urlRequest) { _data, res, err in
                        guard let data = _data else {
                            print("response data is nil")
                            complethionHandler(.failure(TitechPortalError.matrixPageScrapingError))
                            return
                        }
                        
                        if TitechPortalErrorHandling.JudgePage(data: data) != TitechPortalErrorHandling.PageType.matrix {
                            print("password authentication failed")
                            complethionHandler(.failure(TitechPortalError.passwordAuthError))
                            return
                        }
                        
                        guard let dataString = String(data: data, encoding: .utf8) else {
                            print("parse password login request occurs error")
                            complethionHandler(.failure(TitechPortalError.matrixPageScrapingError))
                            return
                        }
                        guard let selected_matrix = dataString.matches("([A-J]),(\\d+)") else {
                            print("read matrix in html error")
                            complethionHandler(.failure(TitechPortalError.matrixPageScrapingError))
                            return
                        }
                        
                        if selected_matrix.count < 3 {
                            complethionHandler(.failure(TitechPortalError.matrixPageScrapingError))
                            return
                        }
                        
                        let parsed = HTMLInputParser.parse(data)
                        
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
                            .dataTask(with: urlRequest) { _data, res, err in
                                guard let data = _data else {
                                    print("response data is nil")
                                    complethionHandler(.failure(TitechPortalError.loggedinPageError))
                                    return
                                }
                                if TitechPortalErrorHandling.JudgePage(data: data) != TitechPortalErrorHandling.PageType.loggedin {
                                    print("matrix authentication failed")
                                    complethionHandler(.failure(TitechPortalError.matrixAuthError))
                                    return
                                }

                                print("login success")
                                if let cookies = HTTPCookieStorage.shared.cookies(for: cookieURL!) {
                                
                                complethionHandler(.success(cookies))
                                
                            }
                            }
                            .resume()
                    }
                    .resume()
            }
            .resume()
    }
}
