//
//  ViewController.swift
//  SwiftySocialDemo
//
//  Created by Manish Kumar on 2023-03-10.
//

import UIKit
import SwiftySocial
import AuthenticationServices

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func loginWithGoogle() {
        SwiftySocial(for: .google).login { result in
            DispatchQueue.main.async {
                switch result {
                    case .success(let user):
                        self.showAlert(user: user)
                    case .failure(let error):
                        print(error.description)
                }
            }
        }
    }
    
    @IBAction func loginWithGithub() {
        SwiftySocial(for: .github).login { result in
            DispatchQueue.main.async {
                switch result {
                    case .success(let user):
                        self.showAlert(user: user)
                    case .failure(let error):
                        print(error.description)
                }
            }
        }
    }
    
    @IBAction func loginWithReddit() {
        SwiftySocial(for: .reddit).login { result in
            DispatchQueue.main.async {
                switch result {
                    case .success(let user):
                        self.showAlert(user: user)
                    case .failure(let error):
                        print(error.description)
                }
            }
        }
    }
    
    @IBAction func loginWithDropbox() {
        SwiftySocial(for: .dropbox).login { result in
            DispatchQueue.main.async {
                switch result {
                    case .success(let user):
                        self.showAlert(user: user)
                    case .failure(let error):
                        print(error.description)
                }
            }
        }
    }
    
    @IBAction func loginWithLinkedIn() {
        SwiftySocial(for: .linkedin).login { result in
            DispatchQueue.main.async {
                switch result {
                    case .success(let user):
                        self.showAlert(user: user)
                    case .failure(let error):
                        print(error.description)
                }
            }
        }
    }
    
    @IBAction func loginWithMicrosoft() {
        SwiftySocial(for: .microsoft).login { result in
            DispatchQueue.main.async {
                switch result {
                    case .success(let user):
                        self.showAlert(user: user)
                    case .failure(let error):
                        print(error.description)
                }
            }
        }
    }
    
    func showAlert(user: SwiftySocialUser) {
        let alertController = UIAlertController(title: "User", message: user.userName, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true)
    }
}
