//
//  SearchVC.swift
//  GHFollowers
//
//  Created by GIBRAN I GAYTAN SILVA on 10/20/22.
//

import UIKit

class GHFSearchViewController: UIViewController {
    
    let logoImageView = UIImageView()
    let usernameTextField = GHFTextField ()
    let callToAcctionButton = GHFButton(backgroundColor: .systemGreen, title: "Get Followers")
    
    var isUserNameEnterred: Bool {
        return !usernameTextField.text!.isEmpty
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureLogoIV()
        configureUsernameTF()
        configureCallToAcctionB()
        createDismissKeyboardTapGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        usernameTextField.text = ""
    }
    
    func createDismissKeyboardTapGesture() {
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    @objc func pushFollowerListVC(){
        guard isUserNameEnterred else {
            presentGHFAlertOnMainThread(title: "Empty Unsername", message: "Please enter a unsername, we need to look who to look for 🙂.", buttonTittle: "Ok")
            return
        }
        usernameTextField.resignFirstResponder()
        let followersListVC = GHFFollowersListViewController()
        followersListVC.username = usernameTextField.text
        followersListVC.title = usernameTextField.text
        navigationController?.pushViewController(followersListVC, animated: true)
    }
    
    func configureLogoIV() {
        view.addSubview(logoImageView)
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.image = Images.ghLogo
        
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 200),
            logoImageView.widthAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    func configureUsernameTF(){
        view.addSubview(usernameTextField)
        usernameTextField.delegate = self
        
        NSLayoutConstraint.activate([
            usernameTextField.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 48),
            usernameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            usernameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            usernameTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func configureCallToAcctionB(){
        view.addSubview(callToAcctionButton)
        callToAcctionButton.addTarget(self, action: #selector(pushFollowerListVC), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            callToAcctionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            callToAcctionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            callToAcctionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            callToAcctionButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}

extension GHFSearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        pushFollowerListVC()
        return true
    }
}
