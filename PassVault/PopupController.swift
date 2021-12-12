//
//  PopupController.swift
//  PassVault
//
//  Created by Kly Yee on 11/4/21.
//

import UIKit
import CryptoSwift

class PopupController: UIViewController {


    @IBOutlet weak var addError: UILabel!
    
    @IBOutlet weak var websiteText: UITextField!
    
    @IBOutlet weak var userText: UITextField!
    
    @IBOutlet weak var pwText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func generateHandle(_ sender: Any) {
    
        pwText.text = random_generator()
        
    }
    
    func random_generator() -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*_+-()~"
        return String((0..<15).map{ _ in letters.randomElement()! })
    }
    
    @IBAction func addOkHandle(_ sender: Any) {
        
        if (websiteText.text == "" || userText.text == "" || pwText.text == "") {
            addError.text = "Please fill in all the boxes"
        } else {
            let encrypted = encrypt(text: pwText.text!)
            add_password(web: websiteText.text!, user: userText.text!, pw: encrypted!)
            viewWillDisappear(true)

            self.dismiss(animated: true, completion: nil)
        }

    }
    
    func encrypt(text: String) -> String?  {
        if let aes = try? AES(key: "ij9VQe2aTDX-7S~d", iv: ")T--oWKx@zEhN(oo"),
           let encrypted = try? aes.encrypt(Array(text.utf8)) {
            return encrypted.toHexString()
        }
        return nil
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if let firstVC = presentingViewController as? PasswordTableViewController {
            DispatchQueue.main.async {
                firstVC.parse_file()
                firstVC.tableView.reloadData()
            }
        }
    }
    
    @IBAction func cancelHandle(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func add_password(web: String, user: String, pw: String) {
        let file = "passwordList.txt"
        let entry = web + " " + user + " " + pw + " "
        
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {

            let fileURL = dir.appendingPathComponent(file)

            //reading
            do {
                var content = try String(contentsOf: fileURL, encoding: .utf8)
                
                content = content + "\n" + entry
                try content.write(to: fileURL, atomically: false, encoding: .utf8)

            }
            catch {
                do {
                    try entry.write(to: fileURL, atomically: false, encoding: .utf8)
                } catch {
                    print("Cannot write to file")
                }
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
