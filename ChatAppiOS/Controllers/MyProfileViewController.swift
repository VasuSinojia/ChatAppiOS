//
//  MyProfileViewController.swift
//  ChatAppiOS
//
//  Created by Vasu-MacMini-M1 on 20/11/23.
//

import UIKit
import FirebaseAuth

class MyProfileViewController: UIViewController {
    
    @IBOutlet weak var myImage: UIImageView!
    @IBOutlet weak var txtMyName: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.tintColor = .white
        loadData()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func logoutBtnAction(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
          } catch let error {
            print("Error while logging out")
          }
    }
    
    private func loadData() {
        var user = MyManager.getUserData()
        txtMyName.text = (user.firstName ?? "") + " " + (user.lastName ?? "")
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
