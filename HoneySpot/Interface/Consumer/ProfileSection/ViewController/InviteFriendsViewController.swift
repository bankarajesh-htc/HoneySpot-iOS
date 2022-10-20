//
//  InviteFriendsViewController.swift
//  HoneySpot
//
//  Created by Max on 3/8/19.
//  Copyright © 2019 HoneySpot. All rights reserved.
//

import UIKit
import Contacts
import MessageUI
import FacebookShare
import TwitterKit

class InviteFriendsViewController: UIViewController,MFMessageComposeViewControllerDelegate,MFMailComposeViewControllerDelegate {

    static let STORYBOARD_IDENTIFIER = "InviteFriendsViewController"
    
    @IBOutlet weak var invitationMethodsCollectionView: UICollectionView!
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    
    let shareViaArray = [
        ShareVia(image: UIImage(named: "FB")!, name: "Facebook"),
        //ShareVia(image: UIImage(named: "Twitter")!, name: "Twitter"),
        ShareVia(image: UIImage(named: "SMS")!, name: "SMS"),
        ShareVia(image: UIImage(named: "Mail")!, name: "Mail"),
        ShareVia(image: UIImage(named: "Whatsapp")!, name: "Whatsapp"),
        ShareVia(image: UIImage(named: "Link")!, name: "Link"),
        ShareVia(image: UIImage(named: "More")!, name: "More")
    ]
    
    var contactUsers = [ContactUser]()
    var filteredContacts = [ContactUser]()
    var shareText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        
        shareText = "I am on HoneySpot as " + (UserDefaults.standard.string(forKey: "username") ?? "") + ". Install the app to follow my favorite restaurants. -> https://honeyspotapp.app.link/download"

        fetchContacts(completion: {contacts in
            contacts.forEach({
                var img = UIImage()
                if $0.thumbnailImageData != nil
                {
                    img = UIImage.init(data: $0.thumbnailImageData!)!
                    self.contactUsers.append(ContactUser(name: $0.givenName, number: $0.phoneNumbers.first?.value.stringValue ?? "",image: img))
                }
                else
                {
                    self.contactUsers.append(ContactUser(name: $0.givenName, number: $0.phoneNumbers.first?.value.stringValue ?? "",image: UIImage(named: "userEmptyImage")))
                }
            })
            self.filteredContacts = self.contactUsers
            DispatchQueue.main.async {
                self.searchTableView.reloadData()
            }
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func fetchContacts(completion: @escaping (_ result: [CNContact]) -> Void){
        DispatchQueue.main.async {
            var results = [CNContact]()
            let keys = [CNContactGivenNameKey,CNContactFamilyNameKey,CNContactMiddleNameKey,CNContactEmailAddressesKey,CNContactPhoneNumbersKey,CNContactThumbnailImageDataKey] as [CNKeyDescriptor]
            let fetchRequest = CNContactFetchRequest(keysToFetch: keys)
            fetchRequest.sortOrder = .userDefault
            let store = CNContactStore()
            store.requestAccess(for: .contacts, completionHandler: {(grant,error) in
                if grant{
                    do {
                        try store.enumerateContacts(with: fetchRequest, usingBlock: { (contact, stop) -> Void in
                            results.append(contact)
                        })
                    }
                    catch let error {
                        print(error.localizedDescription)
                    }
                    completion(results)
                }else{
                    print("Error \(error?.localizedDescription ?? "")")
                }
            })
        }
    }
    
    @IBAction func searchBarChanged(_ sender: Any) {
        let searchText = searchTextField.text ?? ""
        if(searchText == ""){
            self.filteredContacts = self.contactUsers
        }else{
            self.filteredContacts = self.contactUsers.filter({ (user) -> Bool in
                return user.name.lowercased().contains(searchText)
            })
        }
        self.searchTableView.reloadData()
    }
    
    func sendSms(number : String){
        if (MFMessageComposeViewController.canSendText()) {
            let controller = MFMessageComposeViewController()
            controller.body = shareText
            controller.recipients = [number]
            controller.messageComposeDelegate = self
            self.present(controller, animated: true, completion: nil)
        }else{
            self.showErrorHud(message: "We don't have any permission to send Sms")
        }
    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onBackButtonTap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension InviteFriendsViewController : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.filteredContacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! InviteFriendsTableViewCell
        cell.img.image = self.filteredContacts[indexPath.row].image ?? UIImage()
        cell.img.layer.cornerRadius = cell.img.frame.height / 2
        cell.img.contentMode = .scaleAspectFill
        cell.img.clipsToBounds = true
        cell.inviteButton.layer.cornerRadius = cell.inviteButton.frame.height / 2
        cell.inviteButton.clipsToBounds = true
        cell.name.text = self.filteredContacts[indexPath.row].name
        cell.number.text = self.filteredContacts[indexPath.row].number
        cell.superVc = self
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}

extension InviteFriendsViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shareViaArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! InviteFriendsCollectionViewCell
        cell.img.image = shareViaArray[indexPath.row].image
        cell.text.text = shareViaArray[indexPath.row].name
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
//        else if(indexPath.row == 1){
//            //Twitter
//            if (TWTRTwitter.sharedInstance().sessionStore.hasLoggedInUsers()) {
//                // App must have at least one logged-in user to compose a Tweet
//                let composer = TWTRComposerViewController.init(initialText: shareText, image: nil, videoData: nil)
//                present(composer, animated: true, completion: nil)
//            } else {
//                // Log in, and then check again
//                TWTRTwitter.sharedInstance().logIn { session, error in
//                    if session != nil { // Log in succeeded
//                        let composer = TWTRComposerViewController.init(initialText: self.shareText, image: nil, videoData: nil)
//                        self.present(composer, animated: true, completion: nil)
//                    } else {
//                        let alert = UIAlertController(title: "No Twitter Accounts Available", message: "You must log in before presenting a composer.", preferredStyle: .alert)
//                        self.present(alert, animated: false, completion: nil)
//                    }
//                }
//            }
//        }
        
        if(indexPath.row == 0){
            let content = ShareLinkContent()
            content.quote = "I'm on HoneySpot as " + (UserDefaults.standard.string(forKey: "username") ?? "") + ". Install the app to follow my favorite restaurants."
            content.contentURL = URL(string: "https://honeyspotapp.app.link/download")!
            let dialog = ShareDialog(fromViewController: self, content: content, delegate: self)
            dialog.mode = .native
            dialog.show()
            
        }else if(indexPath.row == 1){
            //SMS
            if (MFMessageComposeViewController.canSendText()) {
                let controller = MFMessageComposeViewController()
                controller.body = shareText
                controller.recipients = []
                controller.messageComposeDelegate = self
                self.present(controller, animated: true, completion: nil)
            }else{
                self.showErrorHud(message: "We don't have any permission to send Sms")
            }
        }else if(indexPath.row == 2){
            //Mail
            if MFMailComposeViewController.canSendMail() {
                let mail = MFMailComposeViewController()
                mail.mailComposeDelegate = self
                mail.setToRecipients([])
                mail.setMessageBody(shareText, isHTML: true)

                present(mail, animated: true)
            } else {
                self.showErrorHud(message: "Your mail app is not configured correctly")
            }
        }else if(indexPath.row == 3){
            //Whatsapp
            let excapedText = shareText.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
            let url = URL(string: "whatsapp://send?text="+excapedText)
            if(UIApplication.shared.canOpenURL(url!)){
                UIApplication.shared.open(url!, options: [:], completionHandler: nil)
            }else{
                sharePrompt()
            }
        }else if(indexPath.row == 4){
            //Link
            UIPasteboard.general.string = shareText
            self.showInformationHud(message: "Link Copied to Clipboard")
        }else if(indexPath.row == 5){
            //More
            sharePrompt()
        }
    }
    
    func sharePrompt(){
        let textShare = [ shareText ]
        let activityViewController = UIActivityViewController(activityItems: textShare , applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.height, height: collectionView.frame.height)
    }
    
}

extension InviteFriendsViewController : SharingDelegate {
    func sharer(_ sharer: Sharing, didCompleteWithResults results: [String : Any]) {
        
    }
    
    func sharer(_ sharer: Sharing, didFailWithError error: Error) {
        
    }
    
    func sharerDidCancel(_ sharer: Sharing) {
        
    }
    
    
}

struct ShareVia {
    let image : UIImage
    let name : String
}

struct ContactUser {
    let name : String
    let number : String
    let image : UIImage?
}
