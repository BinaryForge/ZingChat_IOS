/*
 Alexey Cain
 
 RegisterViewController Class
 Class allows user to register via Firebase
 */

import UIKit
import Firebase
import FirebaseDatabase
import SVProgressHUD

class RegisterViewController: UIViewController {
    
    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var passwordTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /*
     Register user to Firebase
     
     Parameters: AnyObject
     Returns: N/A
     */
    
    @IBAction func registerPressed(_ sender: AnyObject) {
        SVProgressHUD.show()
        if emailTextfield.text!.isEmpty &&  passwordTextfield.text!.isEmpty{
            let alert = UIAlertController(title: "Missing Credentials", message: "Please enter email & password.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                NSLog("The \"Missing Credentials\" alert occured.")
            }))
            self.present(alert, animated: true, completion: nil)
            SVProgressHUD.dismiss()
        }
        
        Auth.auth().createUser(withEmail: emailTextfield.text!, password: passwordTextfield.text!) { (user, error) in
            if error != nil{
                if let errCode = AuthErrorCode(rawValue: error!._code) {
                    switch errCode {
                    case .invalidEmail:
                        SVProgressHUD.dismiss()
                        print("User not found")
                        let alert = UIAlertController(title: "Invalid Email", message: "The email address is badly formatted.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                            NSLog("The \"Invalid Email\" alert occured.")
                        }))
                        self.present(alert, animated: true, completion: nil)
                        self.emailTextfield.text = ""
                        self.passwordTextfield.text = ""
                        
                    case .weakPassword:
                        SVProgressHUD.dismiss()
                        print("Wrong Password")
                        let alert = UIAlertController(title: "Weak Password", message: "The password must be 6 characters long or more.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                            NSLog("The \"Weak Password\" alert occured.")
                        }))
                        self.present(alert, animated: true, completion: nil)
                        self.emailTextfield.text = ""
                        self.passwordTextfield.text = ""
                        
                    default:
                        SVProgressHUD.dismiss()
                        print("Create User Error: \(error)")
                    }
                }
            }else{
                SVProgressHUD.dismiss()
                self.performSegue(withIdentifier: "goToChat", sender: self)
            }
        }
        
    }
}
