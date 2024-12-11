//
//  NewRegisterViewController.swift
//  ChatAppiOS
//
//  Created by Vasu-MacMini-M1 on 09/11/23.
//

import UIKit
import FirebaseAuth

class NewRegisterViewController: UIViewController {
    
    @IBOutlet weak var txtFirstName: UITextField!
    
    @IBOutlet weak var txtLastName: UITextField!
    
    @IBOutlet weak var txtEmail: UITextField!
    
    @IBOutlet weak var txtPassword: UITextField!
    
    @IBOutlet weak var txtRePassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        txtPassword.textContentType = .oneTimeCode
        txtRePassword.textContentType = .oneTimeCode
        // Do any additional setup after loading the view.
    }
    @IBAction func btnBackTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func btnRegisterAction(_ sender: Any) {
        
        if let firstName = txtFirstName.text, let lastName = txtLastName.text, let email = txtEmail.text, let password = txtPassword.text, let _ = txtRePassword.text {
            
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let error = error {
                    print("error while creating the user \(error)")
                    Config.showAlert(with: "\(error.localizedDescription)", vc: self)
                    return
                }
                
                if let authResult = authResult {
                    var user = UserModel(userId: authResult.user.uid, firstName: firstName, lastName: lastName, email: email, password: password)
                    
                    DatabaseManager.sharedInstance.insertUser(user: user) { success in
                        if success {
                            print("Successfully Added the user")
                            Config.showAlert(with: "Registration Successful", vc: self)
                            self.navigationController?.popViewController(animated: true)
                        } else {
                            print("Error adding the user")
                        }
                    }
                    
                }
            }
            
        } else {
            
        }
        
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
