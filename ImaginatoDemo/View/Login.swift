//
//  ViewController.swift
//  ImaginatoDemo
//
//  Created by iMac on 08/01/21.
//

import UIKit
import RxSwift

class LoginVC: BaseVC {
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!

    var viewModel: LoginViewModel = LoginViewModel()
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        Binding values
        self.txtEmail.rx.text
        .orEmpty
        .bind(to: viewModel.email)
        .disposed(by: disposeBag)
        
        self.txtPassword.rx.text
        .orEmpty
        .bind(to: viewModel.password)
        .disposed(by: disposeBag)
    }
    
    @IBAction func btnLoginClick(_ sender: UIButton) {
//        check internet connection
        if NetworkManager.sharedInstance.reachability.connection == .unavailable {
            let alertController = UIAlertController(title: GlobalConstants.APPNAME, message: "Please check your internet connection...!", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alertController, animated: true) {
            }
        } else {
            if self.viewModel.isFieldValidation() {
                var objLoginRequest: LoginRequest = LoginRequest()
                objLoginRequest.email = self.viewModel.email.value
                objLoginRequest.password = self.viewModel.password.value
                
//                call login api
                self.viewModel.apiLogin(dicParam: objLoginRequest.dictionary) { (isSuccess, response) in
                    if isSuccess! {
                        self.viewModel.userData = response!
                        let userData = UserInfo(context: CoredataService.context)
                        userData.email = self.viewModel.email.value
                        userData.password = self.viewModel.password.value
                        userData.userId = "\(self.viewModel.userData.user?.userId ?? 0)"
                        userData.userName = self.viewModel.userData.user?.userName
                        let date = self.getDate(strDate: (self.viewModel.userData.user?.created_at)!)
                        userData.created_at = date
                        CoredataService.saveContext()
                    }
                }
            }
        }
    }
}

