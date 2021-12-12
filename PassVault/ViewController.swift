//
//  ViewController.swift
//  PassVault
//
//  Created by Kly Yee on 1/4/21.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var loginBox: UITextField!
    
    @IBOutlet weak var loginStatus: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loginBox.delegate = self
        loginBox.attributedPlaceholder
            
            = NSAttributedString(string: "Input Password")
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        authenticate_password(pw: textField.text)
        textField.text = ""
    }
    
    func authenticate_password(pw: String?) {
        let storedpw = get_password();
        if (storedpw != "") {
            if (pw == storedpw) {
                let storyboard = UIStoryboard(name: "Index", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "TableViewBoard") as UIViewController
                vc.modalPresentationStyle = .fullScreen;
                show(vc, sender: nil)
            } else {
                loginStatus.text = "Incorrect password entered."
            }
        } else {
            create_password(pw: pw);
            loginStatus.text = "New password created."
        }
    }
    
    func get_password() -> String {
        let file = "loginhash.txt" //this is the file. we will write to and read from it

        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {

            let fileURL = dir.appendingPathComponent(file)

            //reading
            do {
                let password = try String(contentsOf: fileURL, encoding: .utf8)
                return password;
            }
            catch {
                // do nothing
            }
        }
        return ""
    }
    
    func create_password(pw : String?) {
        let file = "loginhash.txt" //this is the file. we will write to and read from it

        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {

            let fileURL = dir.appendingPathComponent(file)

            //writing
            do {
                try pw?.write(to: fileURL, atomically: false, encoding: .utf8)
            }
            catch {
                print("Unknown Error")
            }

        }
    }
    
}
    

