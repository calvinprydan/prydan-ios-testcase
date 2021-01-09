
//  Created by Darshan Gajera on 03/26/20.
//  Copyright © 2020 Calendar. All rights reserved.
//

import UIKit
import RxAlamofire
import Alamofire
import RxSwift
import RxCocoa
import Reachability

struct ImageData {
    var name: String?
    var img: UIImage?
}

// swiftlint:disable all
enum API : String {
    static let BaseURL = "http://imaginato.mocklab.io/"
    case signin = "login"
    
    var URL : String {
        get{
            return API.BaseURL + self.rawValue
        }
    }
}

class ServiceManager: NSObject {
    let disposeBag = DisposeBag()
    static let sharedInstance : ServiceManager = {
        let instance = ServiceManager()
        return instance
    }()
    
    func postRequest(parameterDict: [String: Any], URL aUrl: String, isLoader: Bool = true, isSuccessAlert: Bool = true, isFailureAlert: Bool = true, block: @escaping (NSDictionary?, NSError?) -> Void) {
            print("URL: \(aUrl)")
            print("Param: \(parameterDict)")

            if Reachability.Connection.self != .none {
                if isLoader {
                    LoadingView.startLoading()
                }
                var header: [String: String]?
                header = ["Content-Type":"application/json"]
                RxAlamofire.requestJSON(.post,aUrl, parameters: parameterDict, encoding: JSONEncoding.default, headers: header)
                    .debug()
                    .subscribe(onNext: { (r, json) in
                        do {
                            if isLoader {
                                LoadingView.stopLoading()
                            }
                            if r.statusCode == 200 {
                                print("response:\(json)")
                                let dicData = json as! NSDictionary
                                print("response:\(dicData)")
                                if let error = dicData.value(forKey: "errors") as? NSArray {
                                    if error.count > 0 {
                                        let msg = (error.firstObject as! NSDictionary).value(forKey: "message") as! String
                                        SnackBar.show(strMessage: msg, type: .negative)
                                    }
                                } else {
                                    let status: Bool = dicData.value(forKey: "result") as! Bool
                                    if status {
                                        
//                                        success alert
                                        if isSuccessAlert {
                                            SnackBar.show(strMessage: "login Suceesfully", type: .positive)
                                        }
                                        block(dicData, nil)
                                    } else {
                                        if isFailureAlert {
//                                            failed alert
                                            SnackBar.show(strMessage: dicData.value(forKey: "error_message") as! String, type: .negative)
                                            block(nil, nil)
                                        } else {
                                            block(nil, nil)
                                        }
                                    }
                                }
                            } else if r.statusCode == 404 {
                                if isFailureAlert {
                                    let dicData = json as! NSDictionary
                                    SnackBar.show(strMessage: dicData.value(forKey: "message") as! String, type: .negative)
                                }
                            } else if r.statusCode == 403 || r.statusCode == 401 {
                                AppPrefsManager.sharedInstance.removeDataFromPreference(key: AppPrefsManager.sharedInstance.USER)
                            } else if r.statusCode == 500 {
                                SnackBar.show(strMessage: ErrorMesssages.wrong, type: .negative)
                            }
                        }
                    }, onError: {(error) in
                        LoadingView.stopLoading()
                    })
                    .disposed(by: disposeBag)
            }
        }
}

extension URL {
    /// Creates an NSURL with url-encoded parameters.
    init?(string : String, parameters : [String : String]) {
        guard var components = URLComponents(string: string) else { return nil }
        components.queryItems = parameters.map { return URLQueryItem(name: $0, value: $1) }
        guard let url = components.url else { return nil }
        // Kinda redundant, but we need to call init.
        self.init(string: url.absoluteString)
    }
}
