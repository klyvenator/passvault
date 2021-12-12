//
//  PasswordController.swift
//  PassVault
//
//  Created by Kly Yee on 11/4/21.
//

import UIKit
import CryptoSwift

class PasswordController: UIViewController {

    @IBOutlet weak var passwordBox: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(PasswordTableViewController.login)
        passwordBox.text = get_password()
        print(get_password())
    }
    
    @IBAction func cancelHandle(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func copyButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func decrypt(hexString: String) -> String? {
        if let aes = try? AES(key: "ij9VQe2aTDX-7S~d", iv: ")T--oWKx@zEhN(oo"),
            let decrypted = try? aes.decrypt(Array<UInt8>(hex: hexString)) {
            return String(data: Data(bytes: decrypted), encoding: .utf8)
        }
        return nil
    }
    
    func get_password() -> String {
        
        let file = "passwordList.txt" //this is the file. we will write to and read from it

        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {

            let fileURL = dir.appendingPathComponent(file)

            //reading
            
            do {
                let entry = try String(contentsOf: fileURL, encoding: .utf8)
                let entryArray = entry.split(separator: "\n")
                
                for line in entryArray{
                    let singleEntry = line.split(separator: " ")
                    for word in singleEntry {
                        if (word == PasswordTableViewController.website) {
                            if (singleEntry[1] == PasswordTableViewController.login) {
                                return decrypt(hexString: String(singleEntry[2]))!
                            }
                        }
                    }
                }
                
                
            }
            catch {
                // do nothing
            }
        }
        
        return ""
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
