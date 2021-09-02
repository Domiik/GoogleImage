//
//  ViewController.swift
//  GoogleImage
//
//  Created by Domiik on 23.08.2021.
//

import UIKit
import GoogleSignIn
import GoogleAPIClientForREST
import GTMSessionFetcher

class ViewController: UIViewController {
    
    
    @IBOutlet weak var fetchFilesButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialise()
        // Do any additional setup after loading the view.
    }
    
    
    private func initialise() {
        if GIDSignIn.sharedInstance()?.currentUser != nil {
            loginButton.setTitle("Logout", for: .normal)
            fetchFilesButton.isHidden = false
        } else {
            loginButton.setTitle("Login", for: .normal)
            fetchFilesButton.isHidden = true
        }
    }
    
    private func fetchFiles(_ user: GIDGoogleUser) {
        guard let vc = self.storyboard?.instantiateViewController(identifier: "CloudFilesVC") as? CloudFilesViewController else {
            return
        }
        vc.service.authorizer = user.authentication.fetcherAuthorizer()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }


    
    @IBAction func actionBtnLogin(_ sender: Any) {
        if GIDSignIn.sharedInstance()?.currentUser != nil {
            GIDSignIn.sharedInstance()?.signOut()
            initialise()
        } else {
            GIDSignIn.sharedInstance().delegate = self
            GIDSignIn.sharedInstance()?.presentingViewController = self
            GIDSignIn.sharedInstance().scopes = [kGTLRAuthScopeDriveReadonly]
            GIDSignIn.sharedInstance()?.signIn()
        }
    }
    
    @IBAction func actionBtnFetchFiles(_ sender: Any) {
        if let user = GIDSignIn.sharedInstance()?.currentUser {
            fetchFiles(user)
        }
    }
}


extension ViewController: GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let _ = error {
            Alert.show(message: error.localizedDescription)
        } else {
            fetchFiles(user)
            initialise()
        }
    }
}

