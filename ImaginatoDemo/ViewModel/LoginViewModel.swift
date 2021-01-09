//
//  LoginViewModel.swift
//  ImaginatoDemo
//
//  Created by iMac on 08/01/21.
//

import UIKit
import RxSwift

struct LoginViewModel {
    let email = Variable<String>("")
    let password = Variable<String>("")
    var objUserData = LoginUserData()
    
    var userData = User()
}

struct LoginRequest: Encodable {
    var email: String?
    var password: String?
}


//user model
struct User: Codable {
    var user: LoginUserData?
}

struct LoginUserData: Codable {
    var created_at: String?
    var userId: Int?
    var userName: String?
}

extension LoginViewModel{
    func isFieldValidation() -> Bool {
        if email.value.isEmpty {
            SnackBar.show(strMessage: ErrorMesssages.EmptyEmail, type: .negative)
            return false
        } else if !email.value.isValidEmail {
            SnackBar.show(strMessage: ErrorMesssages.ValidEmail, type: .negative)
            return false
        }
        else if password.value.isEmpty {
            SnackBar.show(strMessage: ErrorMesssages.EmptyPassword, type: .negative)
            return false
        } else if !password.value.isValidPassword {
            SnackBar.show(strMessage: ErrorMesssages.ValidPassword, type: .negative)
            return false
        } else {
            return true
        }
    }
        
    func apiLogin(dicParam: [String: Any], completion :@escaping (_ isSucess : Bool?,_ receivedData: User?) -> Void) {
        ServiceManager.sharedInstance.postRequest(parameterDict: dicParam, URL: API.signin.URL) { (dicResponse, error) in
            do {
                if dicResponse != nil {
                    completion(true,try JSONDecoder().decode(User.self, from: (dicResponse!.dataReturn(isParseDirect: false))!))
                } else {
                    completion(false, nil)
                }
            }
            catch let err {
                print("Err", err)
                completion(false,nil)
            }
        }
    }
}
