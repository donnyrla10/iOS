//
//  EmailViewController.swift
//  Login
//
//  Created by 김영선 on 2022/07/23.
//

import UIKit
import FirebaseAuth

class EmailViewController: UIViewController {
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var errorMessageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nextButton.layer.cornerRadius = 10
        nextButton.isEnabled = false
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    @IBAction func tapNextButton(_ sender: UIButton) {
        let email = emailTextField.text ?? ""
        let pw = passwordTextField.text ?? ""
        
        //신규 사용자 생성
        Auth.auth().createUser(withEmail: email, password: pw){ [weak self] authResult, error in
            guard let self = self else {return}
            
            if let error = error{
                let code = (error as NSError).code
                switch code {
                case 1707: //이미 가입한 계정
                    //로그인하기
                    self.loginUser(withEmail: email, password: pw)
                default:
                    self.errorMessageLabel.text = error.localizedDescription
                }
            }else{
                self.showMainViewController()
            }
        }
    }
    
    private func loginUser(withEmail email: String, password: String){
        Auth.auth().signIn(withEmail: email, password: password){ [weak self] _, error in
            guard let self = self else {return}
            if let error = error {
                self.errorMessageLabel.text = error.localizedDescription
            }else{
                self.showMainViewController()
            }
        }
    }
    
    private func showMainViewController(){
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let mainViewController = storyboard.instantiateViewController(withIdentifier: "MainViewController")
        mainViewController.modalPresentationStyle = .fullScreen
        navigationController?.show(mainViewController, sender: nil)
    }
}

extension EmailViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let isEmailEmpty = emailTextField.text == ""
        let isPwEmpty = passwordTextField.text == ""
        
        nextButton.isEnabled = !isEmailEmpty && !isPwEmpty
    }
}
