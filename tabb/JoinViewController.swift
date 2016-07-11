//
//  JoinViewController.swift
//  tabb
//
//  Created by LeeDongMin on 12/7/15.
//  Copyright © 2015 LeeDongMin. All rights reserved.
//

import UIKit
import MobileCoreServices

class JoinViewController: UIViewController, UIImagePickerControllerDelegate, UIAlertViewDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var joinBack: UIView!
    
    var profileImage : UIImageView!
    var userName : UITextField!

    let picker = UIImagePickerController()
    
    var cameraUI: UIImagePickerController! = UIImagePickerController()
    var popover:UIPopoverController?=nil
    var profileBtn = UIButton()
    
    var imageCheck = false
    
    var hideCheck : Bool = false
    var showCheck : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        profileImage = UIImageView()
        profileImage.frame = CGRectMake((screen.size.width * 161) / 414, (screen.size.height * 76) / 736, (screen.size.width * 92) / 414, (screen.size.height * 92) / 736)
        profileImage.layer.cornerRadius = profileImage.frame.width / 2
        profileImage.clipsToBounds = true
        profileImage.image = UIImage(named: "icon_nophoto")
        joinBack.addSubview(profileImage)
        
        profileBtn = UIButton()
        profileBtn.frame = CGRectMake((screen.size.width * 222) / 414, (screen.size.height * 130) / 736, (screen.size.width * 35) / 414, (screen.size.height * 35) / 736)
        profileBtn.setBackgroundImage(UIImage(named: "icon_add2"), forState: .Normal)
        profileBtn.addTarget(self, action: "btnImagePickerClicked:", forControlEvents: .TouchUpInside)
        joinBack.addSubview(profileBtn)
        
        userName = UITextField()
        userName.frame = CGRectMake((screen.size.width * 11) / 414, (screen.size.height * 225) / 736, (screen.size.width * 392) / 414, (screen.size.height * 30) / 736)
        userName.backgroundColor = UIColor.clearColor()
        userName.textAlignment = .Center
        userName.textColor = UIColor.whiteColor()
        userName.font = UIFont(name: lato, size: (screen.size.width * 15) / 414)
        userName.attributedPlaceholder = NSAttributedString(string:"Enter your Name",
            attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        userName.delegate = self
        joinBack.addSubview(userName)
        
        let userNameLine = UIView()
        userNameLine.frame = CGRectMake((screen.size.width * 11) / 414, (screen.size.height * 265) / 736, (screen.size.width * 392) / 414, (screen.size.height * 1) / 736)
        userNameLine.backgroundColor = UIColorFromHex(0x666666, alpha: 1.0)
        joinBack.addSubview(userNameLine)
        
        let nextView = UIView()
        nextView.frame = CGRect(x: (screen.size.width * 170 / 414), y: (screen.size.height * 520 / 736), width: (screen.size.width * 74 / 414), height: (screen.size.height * 74 / 736))
        nextView.backgroundColor = UIColorFromHex(0xc13939, alpha: 1.0)
        nextView.layer.cornerRadius = nextView.frame.size.width / 2
        joinBack.addSubview(nextView)
        
        let nextImage = UIImageView(image: UIImage(named: "btn_next"))
        nextImage.frame = CGRect(x: (screen.size.width * 22.5 / 414), y: (screen.size.height * 22.5 / 736), width: (screen.size.width * 29 / 414), height: (screen.size.height * 29 / 736))
        nextView.addSubview(nextImage)
        
        let nextBtn = UIButton()
        nextBtn.frame = CGRect(x: 0, y: 0, width: (screen.size.width * 74 / 414), height: (screen.size.height * 74 / 736))
        nextBtn.backgroundColor = UIColor.clearColor()
        nextBtn.layer.cornerRadius = nextBtn.frame.size.width / 2
        nextBtn.addTarget(self, action: "nextAction:", forControlEvents: .TouchUpInside)
        nextBtn.setBackgroundImage(UIImage.imageWithColor(UIColorFromHex(0xffffff, alpha: 0.0)), forState: .Normal)
        nextBtn.setBackgroundImage(UIImage.imageWithColor(UIColorFromHex(0xffffff, alpha: 0.3)), forState: .Highlighted)
        nextBtn.clipsToBounds = true
        nextView.addSubview(nextBtn)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        self.view.addGestureRecognizer(tap)
        
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil);
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil);
        
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        self.nextAction(nil)
        
        return true
    }
    
    func keyboardWillShow(sender: NSNotification) {
        
        if(showCheck == true) {
            return;
        }
        
        showCheck = true
        
        self.view.frame.origin.y -= 160
    }
    
    func keyboardWillHide(sender: NSNotification) {
        
        if(showCheck == false) {
            return;
        }
        
        showCheck = false
        
        self.view.frame.origin.y += 160
    }
    
    //Calls this function when the tap is recognized.
    func DismissKeyboard(){
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    
    func nextAction(sender: AnyObject?) {
        
        if(userName.text == "") {
            customPop.showInView(self.view, withMessage: "Please enter your name.", animated: true)
            return;
        }
        
        if(imageCheck == false) {
            customPop.showInView(self.view, withMessage: "Please register your profile image.", animated: true)
            return;
        }
        
        pref.setValue(userName.text, forKey: "userName")
        self.performSegueWithIdentifier("genderSegue", sender: sender)
    }
    
    func btnImagePickerClicked(sender: AnyObject) {

        let alert:UIAlertController=UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            self.openCameraButton()
        }
        let gallaryAction = UIAlertAction(title: "Gallary", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            self.selectPicture()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) {
            UIAlertAction in
        }
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }

    func openCameraButton() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera;
            imagePicker.allowsEditing = false
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    func selectPicture() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
            imagePicker.allowsEditing = true
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        var newImage: UIImage
        
        if let possibleImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            newImage = possibleImage
        } else if let possibleImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            newImage = possibleImage
        } else {
            return
        }
        
        userProfileImage = imageResize(newImage, sizeChange: CGSize(width: (screen.size.width * 150) / 414, height: (screen.size.height * 150) / 736))
        
        profileImage.image = userProfileImage
        profileImage.layer.cornerRadius = profileImage.frame.width / 2
        profileImage.clipsToBounds = true
        
        // do something interesting here!
        print(newImage.size)
        
        imageCheck = true
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func backPressed(sender: AnyObject?) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
