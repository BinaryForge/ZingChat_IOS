/*
Alexey Cain

ChatViewController Class
Handles the view for instant messaging via Firebase
*/

import UIKit
import FirebaseDatabase
import Firebase
import ChameleonFramework

class ChatViewController: UIViewController, UITableViewDelegate,UITableViewDataSource, UITextFieldDelegate{
    
    @IBOutlet var heightConstraint: NSLayoutConstraint!
    @IBOutlet var sendButton: UIButton!
    @IBOutlet var messageTextfield: UITextField!
    @IBOutlet var messageTableView: UITableView!
    
    var messageArray: [Message] = [Message]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messageTableView.delegate = self
        messageTableView.dataSource = self
        messageTextfield.delegate = self
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
        
        messageTableView.addGestureRecognizer(tapGesture)
        messageTableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "customMessageCell")
        
        configureTableView()
        retrieveMessages()
        
        messageTableView.separatorStyle = .none
        
    }
    
    ///////////////////////////////////////////
    
    //MARK: - TableView DataSource Methods
    
    /*
     Updates the cell with correct message from sender.
     
     Parameters: tableView, cellForRowAt indexPath
     Returns: cell with correct sender, messageBody
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customMessageCell", for: indexPath)
            as! CustomMessageCell
        
        cell.messageBody.text = messageArray[indexPath.row].messageBody
        cell.senderUsername.text = messageArray[indexPath.row].sender
        cell.avatarImageView.image = UIImage(named: "egg")
        
        if cell.senderUsername.text == Auth.auth().currentUser?.email as String?{
            
            cell.avatarImageView.backgroundColor =  UIColor.flatMint()
            cell.messageBackground.backgroundColor = UIColor.flatSkyBlue()
            
        }else{
            cell.avatarImageView.backgroundColor =  UIColor.flatWatermelon()
            cell.messageBackground.backgroundColor = UIColor.flatGray()
        }
        
        return cell
    }
    
    /*
     Set cell rows based on messageArray.count
     
     Parameters: tableView, numberOfRowsInSection
     Returns: number of cell rows for UI
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageArray.count
    }
    
    /*
     Notify tableview user finished message
     
     Parameters: N/A
     Returns: N/A
     */
    
    @objc func tableViewTapped(){
        messageTextfield.endEditing(true)
    }
    
    /*
     Adjust height based upond the user's message lenght.
     
     Parameters: N/A
     Returns: N/A
     */
    
    func configureTableView(){
        messageTableView.rowHeight = UITableViewAutomaticDimension
        messageTableView.estimatedRowHeight = 130.00
        
    }
    
    ///////////////////////////////////////////
    //MARK:- TextField Delegate Methods
    
    /*
     Move messageTextfield up for keyboard view
     when user wants to send message.
     
     Parameters: UITextField
     Returns: N/A
     */
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.6) {
            self.heightConstraint.constant = 308
            //view has changed, rewrite.
            self.view.layoutIfNeeded()
            
        }
    }
    
    /*
     Move messageTextfield down for keyboard view
     when user finishes sending message.
     
     Parameters: UITextField
     Returns: N/A
     */
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.6) {
            self.heightConstraint.constant = 50
            //view has changed, rewrite.
            self.view.layoutIfNeeded()
            
        }
    }
    
    ///////////////////////////////////////////
    //MARK: - Send & Recieve from Firebase
    
    /*
     Once user hits send, push  Sender and MessageBody to
     Firebase server
     
     Parameters: AnyObject
     Returns: N/A
     */
    @IBAction func sendPressed(_ sender: AnyObject) {
        messageTextfield.endEditing(true)
        messageTextfield.isEnabled = false
        
        sendButton.isEnabled = false
        
        let messageDB = Database.database().reference().child("Messages")
        
        let messagaDict = ["Sender":Auth.auth().currentUser?.email, "MessageBody" : messageTextfield.text!]
        
        messageDB.childByAutoId().setValue(messagaDict){
            (error, reference) in
            if error != nil{
                print(error)
                
            }else{
                print("msg saved")
                self.messageTextfield.isEnabled = true
                self.sendButton.isEnabled = true
                self.messageTextfield.text = ""
            }
        }
        
    }
    
    /*
     Gather messages from Firebase server
     
     Parameters: N/A
     Returns: N/A
     */
    func retrieveMessages(){
        let messageDB = Database.database().reference().child("Messages")
        messageDB.observe(.childAdded) { (snapshot) in
            let snapshotValue = snapshot.value as! Dictionary<String, String>
            let text = snapshotValue["MessageBody"]!
            let sender = snapshotValue["Sender"]!
            
            let message = Message()
            message.sender = sender
            message.messageBody = text
            
            self.messageArray.append(message)
            self.configureTableView()
            self.messageTableView.reloadData()
        }
    }
    
    /*
     Sign out the user if logOut button is pressed.
     
     Parameters: AnyObject
     Returns: N/A
     */
    @IBAction func logOutPressed(_ sender: AnyObject) {
        do{
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        }catch{
            print("Unsuccessfull logout")
        }
    }
    

}
