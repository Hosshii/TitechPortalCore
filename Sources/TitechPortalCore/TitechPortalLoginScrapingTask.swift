//
//  File.swift
//  
//
//  Created by hoshiro ando on 2020/10/24.
//

import Foundation

let USER_NAME_IDE = "usr_name"
let USER_PASSWORD_IDE = "usr_password"


public struct TitechPortalLoginScrapingTask {
    public static func login(){
        print("login")
        URLSession
            .shared
            .dataTask(with: URL(string:"https://portal.nap.gsic.titech.ac.jp/GetAccess/Login?Template=userpass_key&AUTHMETHOD=UserPassword")!)
            { data, res, err in
                //            print(res ?? "no res")
                print(String(data: data!, encoding: .utf8) ?? "no data")
                
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
                        print(String(data: data!, encoding: .utf8) ?? "no data" )
                        //                        print(err)
                        //                        print(res)
                        HTMLInputParser.parse(data!)
                            .map {data in
                                print(data)
                            }
                        
                    }
                    .resume()
            }
            .resume()
    }
}
