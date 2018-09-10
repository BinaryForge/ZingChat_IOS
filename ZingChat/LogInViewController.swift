/*
Alexey Cain
 
LogInViewController Class
Class allows user to log in via Firebase
*/

import UIKit
import FirebaseDatabase
import Firebase
import SVProgressHUD


class LogInViewController: UIViewController {
    
    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var passwordTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func logInPressed(_ sender: AnyObject) {
        SVProgressHUD.show()
        if emailTextfield.text!.isEmpty &&  passwordTextfield.text!.isEmpty{
            let alert = UIAlertController(title: "Missing Credentials", message: "Please enter email & password.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                NSLog("The \"Missing Credentials\" alert occured.")
            }))
            self.present(alert, animated: true, completion: nil)
            SVProgressHUD.dismiss()
        }
        
        
        Auth.auth().signIn(withEmail: emailTextfield.text!, password: passwordTextfield.text!) { (user, error) in
            if error != nil{
                if let errCode = AuthErrorCode(rawValue: error!._code) {
                    switch errCode {
                    case .userNotFound:
                        SVProgressHUD.dismiss()
                        print("User not found")
                        let alert = UIAlertController(title: "User not found.", message: "Please re-enter credentials", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                            NSLog("The \"User not Found\" alert occured.")
                        }))
                        self.present(alert, animated: true, completion: nil)
                        self.emailTextfield.text = ""
                        self.passwordTextfield.text = ""
                        
                    case .invalidEmail:
                        SVProgressHUD.dismiss()
                        print("User not found")
                        let alert = UIAlertController(title: "Invalid Email", message: "Please re-enter email", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                            NSLog("The \"invalidEmail\" alert occured.")
                        }))
                        self.present(alert, animated: true, completion: nil)
                        self.emailTextfield.text = ""
                        self.passwordTextfield.text = ""
                        
                    case .wrongPassword:
                        SVProgressHUD.dismiss()
                        print("Wrong Password")
                        let alert = UIAlertController(title: "Wrong Password", message: "Password does not match email. Try again.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                            NSLog("The \"Wrong Password\" alert occured.")
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
