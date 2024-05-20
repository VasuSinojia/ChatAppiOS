//
//  NewLoginViewController.swift
//  ChatAppiOS
//
//  Created by Vasu-MacMini-M1 on 09/11/23.
//

import UIKit
import FirebaseAuth
import GoogleSignIn
import FirebaseCore
import NVActivityIndicatorView

class NewLoginViewController: UIViewController {
    
    @IBOutlet weak var googleBtn: UIView!
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    let indicatorFrame = CGRect(x: 0, y: 0, width: 50, height: 50)
    var indicatorView: NVActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataForTesting()
        self.navigationController?.navigationBar.isHidden = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(googleSignInBtnAction))
        googleBtn.addGestureRecognizer(gesture)
        indicatorView = NVActivityIndicatorView(frame: indicatorFrame)
//        let gesture2 = UITapGestureRecognizer(target: self, action: #selector(registerNowAction))
    }
    
    private func dataForTesting() {
        txtEmail.text = "azhar@gmail.com"
        txtPassword.text = "123456789"
    }
    
    @IBAction func btnLoginAction(_ sender: Any) {
        
        if let email = txtEmail.text, let password = txtPassword.text {
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let error = error {
                    Config.showAlert(with: "\(error.localizedDescription)", vc: self)
                    return
                }
                
                if let authResult = authResult {
                    DatabaseManager.sharedInstance.getUser(uid: authResult.user.uid) { user in
                        print("user id while login \(user.userId)")
                        let chatStoryBoard  = UIStoryboard(name: "Chat", bundle: nil)
                        let vc = chatStoryBoard.instantiateViewController(identifier: "ChatListViewController") as! ChatListViewController
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            }
        }
        

    }
    
    @objc private func registerNowAction() {
        
    }
    
    @IBAction func registerBtnAction(_ sender: Any) {
        
    }
    
    @IBAction func loginBtnAction(_ sender: Any) {
        
    }
    
    
    @objc private func googleSignInBtnAction() {
        guard let clientId = FirebaseApp.app()!.options.clientID else { return }
        
        let config = GIDConfiguration(clientID: clientId)
        GIDSignIn.sharedInstance.configuration = config
        
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { result , error in
            guard error == nil else {
                // ...
                return
            }
            
            guard let user = result?.user, let idToken = user.idToken?.tokenString else {
                return
            }
            
            let credentials = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)
            
            print("user name \(user.profile?.name)")
            print("credentials \(credentials)")
//            Auth.auth().signIn(with: credentials) { authResult, error in
//                guard error == nil else {
//                    print("Error while signing in\(String(describing: error))")
//                    return
//                }
//                
////                if let user = authResult?.user {
////                    DatabaseManager.sharedInstance.userExist(with: user.uid) { exist in
////                        if exist {
////                            return
////                        } else {
////                            DatabaseManager.sharedInstance.insertUser(with: ChatAppUser(firstName: user.displayName ?? "", lastName: "", email: user.email ?? "", userId: user.uid)) { success in
////                                UserDefaults.standard.setValue(user.email, forKey: "email")
////                            }
////                        }
////                    }
////                    UserDefaults.standard.set(true, forKey: Constants.sharedInstance.isLoggedIn)
////                    NavigationManager.sharedInstance.changeRootNavController(storyboard: "Conversation", viewController: "tabBarController")
////                }
//            }
        }
    }
    let textView = UITextView(frame: CGRect.zero)
    let label = UITextView(frame: CGRect.zero)

    @IBAction func forgotEmailTapped(_ sender : UIButton) {
        let alertController = UIAlertController(title: "\n\n\n\n\n", message: nil, preferredStyle: .alert)

           textView.textContainerInset = UIEdgeInsets.init(top: 8, left: 5, bottom: 8, right: 5)

           let saveAction = UIAlertAction(title: "OK", style: .default) { (action) in
               self.label.text = self.textView.text
               alertController.view.removeObserver(self, forKeyPath: "bounds")
           }

           saveAction.isEnabled = false

           let cancelAction = UIAlertAction.init(title: "Cancel", style: .default) { (action) in
               alertController.view.removeObserver(self, forKeyPath: "bounds")
           }

           alertController.view.addObserver(self, forKeyPath: "bounds", options: NSKeyValueObservingOptions.new, context: nil)

           NotificationCenter.default.addObserver(forName: UITextView.textDidChangeNotification, object: textView, queue: OperationQueue.main) { (notification) in
               saveAction.isEnabled = self.textView.text != ""
           }

           textView.backgroundColor = UIColor.white
           alertController.view.addSubview(self.textView)

           alertController.addAction(saveAction)
           alertController.addAction(cancelAction)

           self.present(alertController, animated: true, completion: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "bounds"{
            if let rect = (change?[NSKeyValueChangeKey.newKey] as? NSValue)?.cgRectValue {
                let margin:CGFloat = 8.0
                textView.frame = CGRect.init(x: rect.origin.x + margin, y: rect.origin.y + margin, width: rect.width - 2*margin, height: rect.height / 2)
                textView.bounds = CGRect.init(x: rect.origin.x + margin, y: rect.origin.y + margin, width: rect.width - 2*margin, height: rect.height / 2)
            }
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
