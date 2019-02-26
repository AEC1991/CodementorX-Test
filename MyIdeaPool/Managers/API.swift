//
//  API.swift
//  MyIdeaPool
//
//  Created by Star on 2/25/19.
//  Copyright © 2019 TopStar. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD

class API: NSObject {

    enum StateCode : Int{
        case success = 200
        case login = 201
        case logout = 204
        case unauthorized = 401
    }
    
    static let shared = API()
    var jwt : String?
    var refresh_token : String? {
        get {
            return UserManager.shared.refresh_token
        }
        set {
            UserManager.shared.refresh_token = newValue
        }
    }
    
    func signUp(user : User, complete : @escaping ((_ success : Bool, _ error : String?)-> Void)) {
        
        SVProgressHUD.show()

        let parmas = [
            "email": user.email!,
            "name": user.name!,
            "password": user.password!,
        ]
        let headers = [
            "Content-Type": "application/json",
            ]
        let url = Constants.API.baseUrl + Constants.API.users
        
        Alamofire.request(url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!,
                          method: .post,
                          parameters: parmas,
                          encoding: JSONEncoding.default,
                          headers:headers).responseJSON { (dataResponse) in

                            SVProgressHUD.dismiss()
                            let error = dataResponse.error
                            if error  == nil {
                                if dataResponse.response?.statusCode == StateCode.login.rawValue {
                                    if let json = dataResponse.value as? [String : Any] {
                                        self.jwt = json["jwt"] as? String
                                        self.refresh_token = json["refresh_token"] as? String
                                        complete(true, nil)
                                    }else {
                                        complete(false, "Parsing error")
                                    }
                                }else {
                                    complete(false, "Server error")
                                }
                            }else {
                                complete(false, error?.localizedDescription)
                            }
                            
        }
        
    }

    func login(user : User, complete : @escaping ((_ success : Bool, _ error : String?)-> Void)) {
        
        SVProgressHUD.show()
        
        let parmas = [
            "email": user.email!,
            "password": user.password!,
            ]
        let headers = [
            "Content-Type": "application/json",
            ]
        let url = Constants.API.baseUrl + Constants.API.access_tokens
        
        Alamofire.request(url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!,
                          method: .post,
                          parameters: parmas,
                          encoding: JSONEncoding.default,
                          headers:headers).responseJSON { (dataResponse) in
                            
                            SVProgressHUD.dismiss()
                            let error = dataResponse.error
                            if error  == nil {
                                if dataResponse.response?.statusCode == StateCode.login.rawValue {
                                    if let json = dataResponse.value as? [String : Any] {
                                        self.jwt = json["jwt"] as? String
                                        self.refresh_token = json["refresh_token"] as? String
                                        complete(true, nil)
                                    }else {
                                        complete(false, "Parsing error")
                                    }
                                }else {
                                    complete(false, "Server error")
                                }
                            }else {
                                complete(false, error?.localizedDescription)
                            }
                            
        }
        
    }

    func logout(complete : @escaping ((_ error : String?)-> Void)) {
        
        guard let accessToken = jwt, let refreshToken = refresh_token  else {
            complete ("Invalid Access Token")
            return
        }
        
        SVProgressHUD.show()
        
        let headers = [
            "Content-Type": "application/json",
            "X-Access-Token" : accessToken,
            ]
        let parmas = [
            "refresh_token" : refreshToken,
        ]
        
        let url = Constants.API.baseUrl + Constants.API.access_tokens
        
        Alamofire.request(url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!,
                          method: .delete,
                          parameters: parmas,
                          encoding: JSONEncoding.default,
                          headers:headers).responseJSON { (dataResponse) in
                            
                            SVProgressHUD.dismiss()
                            let statusCode = dataResponse.response?.statusCode
                            if statusCode == StateCode.logout.rawValue {
                                complete(nil)
                            }else if statusCode == StateCode.unauthorized.rawValue {
                                self.refreshToken(complete: { (err) in
                                    if err == nil {
                                        self.logout(complete: complete)
                                    }else {
                                        complete(err)
                                    }
                                })
                            }else {
                                complete(dataResponse.error?.localizedDescription)
                            }

        }
        
    }

    func getIdeas(page : Int, progressHUD : Bool? = true, complete : @escaping ((_ ideas : [Idea]?, _ error : String?)-> Void)) {
        
        guard let accessToken = jwt else {
            refreshToken { (err) in
                if err == nil {
                    self.getIdeas(page: page, progressHUD : progressHUD, complete: complete)
                }else {
                    complete (nil, err)
                }
            }
            return
        }
        if progressHUD == true {
            SVProgressHUD.show()
        }
        
        let headers = [
            "Content-Type": "application/json",
            "X-Access-Token" : accessToken,
            ]
        let parmas = [
            "page" : page,
            ]
        
        let url = Constants.API.baseUrl + Constants.API.ideas
        Alamofire.request(url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!,
                          method: .get,
                          parameters: parmas,
                          headers:headers).responseJSON { (dataResponse) in

                            if progressHUD == true {
                                SVProgressHUD.dismiss()
                            }
                            
                            if dataResponse.response?.statusCode == StateCode.success.rawValue {
                                var result = [Idea]()
                                if let array = dataResponse.value as? [[String:Any]] {
                                    result = array.map({ (item) -> Idea in
                                        return Idea(dic: item)
                                    })
                                }
                                complete(result, nil)
                            }else if dataResponse.response?.statusCode == StateCode.unauthorized.rawValue {
                                self.refreshToken(complete: { (err) in
                                    if err == nil {
                                        self.getIdeas(page: page, progressHUD : progressHUD, complete: complete)
                                    }else {
                                        complete(nil, err)
                                    }
                                })
                            }else {
                                complete(nil, dataResponse.error?.localizedDescription)
                            }

        }
        
    }

    
    func updateIdea(idea : Idea, complete : @escaping ((_ newIdea : Idea?, _ error : String?)-> Void)) {
        
        guard let accessToken = jwt else {
            complete (nil, "Invalid Access Token")
            return
        }
        
        let parmas = [
            "content": idea.content!,
            "impact": idea.impact!,
            "ease" : idea.ease!,
            "confidence" : idea.confidence!,
            ] as [String : Any]
        let headers = [
            "Content-Type": "application/json",
            "X-Access-Token" : accessToken,
            ]
        var url = Constants.API.baseUrl + Constants.API.ideas
        var method : HTTPMethod!
        var successCode : StateCode!
        if idea.id != nil {
            url = url + "/\(idea.id!)"
            method = .put
            successCode = StateCode.success
        }else {
            method = .post
            successCode = StateCode.login
        }
        
        SVProgressHUD.show()
        Alamofire.request(url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!,
                          method: method,
                          parameters: parmas,
                          encoding: JSONEncoding.default,
                          headers:headers).responseJSON { (dataResponse) in
                            
                            SVProgressHUD.dismiss()
                            
                            if dataResponse.response?.statusCode == successCode.rawValue {
                                var newIdea : Idea?
                                if let dic = dataResponse.value as? [String:Any] {
                                    newIdea = Idea(dic: dic)
                                }
                                complete(newIdea, nil)
                            }else if dataResponse.response?.statusCode == StateCode.unauthorized.rawValue {
                                self.refreshToken(complete: { (err) in
                                    if err == nil {
                                        self.updateIdea(idea: idea, complete: complete)
                                    }else {
                                        complete(nil, err)
                                    }
                                })
                            }else {
                                complete(nil, dataResponse.error?.localizedDescription)
                            }


        }
        
    }
    
    func deletIdea(idea : Idea, complete : @escaping ((_ error : String?)-> Void)) {
        
        guard let accessToken = jwt else {
            complete ("Invalid Access Token")
            return
        }
        
        SVProgressHUD.show()
        
        let headers = [
            "Content-Type": "application/json",
            "X-Access-Token" : accessToken,
            ]
        
        let url = Constants.API.baseUrl + Constants.API.ideas + "/\(idea.id!)"
        
        Alamofire.request(url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!,
                          method: .delete,
                          headers:headers).responseJSON { (dataResponse) in
                            
                            SVProgressHUD.dismiss()
                            
                            if dataResponse.response?.statusCode == StateCode.logout.rawValue {
                                complete(nil)
                            }else if dataResponse.response?.statusCode == StateCode.unauthorized.rawValue {
                                self.refreshToken(complete: { (err) in
                                    if err == nil {
                                        self.deletIdea(idea: idea, complete: complete)
                                    }else {
                                        complete(err)
                                    }
                                })
                            }else {
                                complete(dataResponse.error?.localizedDescription)
                            }
                            
        }
        
    }
    
    
    func refreshToken(complete : @escaping ((_ error : String?)-> Void)) {
        

        guard let refrshToken = refresh_token else {
            complete("Invalid Refresh Token")
            return
        }
        SVProgressHUD.show()
        
        let parmas = [
            "refresh_token": refrshToken,
            ]
        let headers = [
            "Content-Type": "application/json",
            ]
        let url = Constants.API.baseUrl + Constants.API.access_tokens + Constants.API.refresh
        
        Alamofire.request(url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!,
                          method: .post,
                          parameters: parmas,
                          encoding: JSONEncoding.default,
                          headers:headers).responseJSON { (dataResponse) in
                            
                            SVProgressHUD.dismiss()
                            if dataResponse.response?.statusCode == StateCode.success.rawValue {
                                if let json = dataResponse.value as? [String : Any] {
                                    self.jwt = json["jwt"] as? String
                                }
                                complete(nil)
                            }else {
                                complete(dataResponse.error?.localizedDescription)
                            }

        }
        
    }




}
