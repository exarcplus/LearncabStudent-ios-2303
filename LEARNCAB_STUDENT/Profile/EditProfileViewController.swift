//
//  EditProfileViewController.swift
//  LearnCab
//
//  Created by Exarcplus on 19/04/18.
//  Copyright © 2018 Exarcplus. All rights reserved.
//

import UIKit
import Alamofire
import KKActionSheet
import SDWebImage
import AFNetworking
import SKPhotoBrowser
import LGSideMenuController

class EditProfileViewController: UIViewController,UIImagePickerControllerDelegate,SKPhotoBrowserDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,PECropViewControllerDelegate,UITextViewDelegate {

    
    var myclass : MyClass!
    var passuserid : String!
    var tokenstr : String!
    var firstnamestr : String!
    var lastnamestr : String!
    var statestr : String!
    var citystr : String!
    var addressstr : String!
    var username : String!
    var vimage = ""
    @IBOutlet weak var firstName : SkyFloatingLabelTextField!
    @IBOutlet weak var lastName : SkyFloatingLabelTextField!
    @IBOutlet weak var statetext : SkyFloatingLabelTextField!
    @IBOutlet weak var citytext : SkyFloatingLabelTextField!
     @IBOutlet weak var picode : SkyFloatingLabelTextField!
    @IBOutlet weak var address : UITextView!
    @IBOutlet weak var scrollView : UIScrollView!
    @IBOutlet weak var imgview : UIImageView!
    var listarr = [Dictionary<String,AnyObject>]()
    var list = [Dictionary<String,AnyObject>]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = false
        var colors = [UIColor]()
        colors.append(UIColor(red: 18/255, green: 98/255, blue: 151/255, alpha: 1))
        colors.append(UIColor(red: 28/255, green: 154/255, blue: 96/255, alpha: 1))
        navigationController?.navigationBar.setGradientBackground(colors: colors)
        
        myclass = MyClass()
        tokenstr = UserDefaults.standard.string(forKey: "tokens")
        print(tokenstr)
        if UserDefaults.standard.value(forKey: "Logindetail") != nil{
            
            let result = UserDefaults.standard.value(forKey: "Logindetail")
            let newResult = result as! Dictionary<String,AnyObject>
            print(newResult)
            passuserid = newResult["_id"] as! String
            print(passuserid)
           
        }
        
        let borderColor = UIColor.lightGray.cgColor
        address.delegate = self
//        address.layer.borderColor = borderColor.copy(alpha: 1.0)
//        address.layer.borderWidth = 0.5;
//        address.layer.cornerRadius = 3;
        address.translatesAutoresizingMaskIntoConstraints = false
        address.isScrollEnabled = false

        self.profilelink()
        // Do any additional setup after loading the view.
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
       
    }
    override func viewWillLayoutSubviews(){
        super.viewWillLayoutSubviews()
       // scrollView.contentSize = CGSize(width: 320, height: 570)
    }
    @IBAction func backclick(_sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    func editlink()
    {
        print(tokenstr)
        print(passuserid)
        print(firstnamestr)
        print(lastnamestr)
        print(statestr)
        print(citystr)
        print(addressstr)
        print(vimage)
        let params:[String:String] = ["token":tokenstr,"student_id":passuserid,"first_name":firstnamestr,"last_name":lastnamestr,"address":addressstr,"city":citystr,"state":statestr,"profile_image":vimage,"pin_code":picode.text!]
        // SVProgressHUD.show()
        let kLurl = "\(kBaseURL)update_profile"
        Alamofire.request(kLurl, method: .post, parameters: params).responseJSON { response in

            print(response)

            let result = response.result
            print(response)


            if let dict = result.value as? Dictionary<String,AnyObject>{
                print(dict)

                
                let dat = dict["result"] as! String
                if dat == "success"
                {
                    UserDefaults.standard.set(self.vimage , forKey:"Profile")
                    UserDefaults.standard.synchronize()
                    
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    let mainview = kmainStoryboard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
                    let nav = UINavigationController.init(rootViewController: mainview)
                    appDelegate.SideMenu = LGSideMenuController.init(rootViewController: nav)
                    appDelegate.SideMenu.setLeftViewEnabledWithWidth(240, presentationStyle: .slideAbove, alwaysVisibleOptions: [])
                    appDelegate.SideMenuView = kmainStoryboard.instantiateViewController(withIdentifier: "SideMenuViewController") as! SideMenuViewController
                    appDelegate.SideMenu.leftViewStatusBarVisibleOptions = .onAll
                    appDelegate.SideMenu.leftViewStatusBarStyle = .default
                    var rect = appDelegate.SideMenuView.view.frame;
                    rect.size.width = 240;
                    appDelegate.SideMenuView.view.frame = rect
                    appDelegate.SideMenu.leftView().addSubview(appDelegate.SideMenuView.view)
                    print(appDelegate.SideMenu)
                    self.present(appDelegate.SideMenu, animated:true, completion: nil)
                    }
                }
            }
        }


    @IBAction func submitbutton(_ x:AnyObject)
    {
        firstnamestr = firstName.text
        lastnamestr = lastName.text
        statestr = statetext.text
        citystr = citytext.text
        addressstr = address.text!
        
        self.editlink()
    }
    
    
    @IBAction func Addbutton(_ x:AnyObject)
    {
        let actionsheet = KKActionSheet.init(title:nil, delegate:self, cancelButtonTitle:myclass.StringfromKey(Key: "Calncle"), destructiveButtonTitle:nil ,otherButtonTitles:myclass.StringfromKey(Key: "Camera"),myclass.StringfromKey(Key: "Photo Gallery"))
        actionsheet.show(in: self.view)
    }
    
    
    // MARK: - Action Sheet
    
    func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int)
    {
        if buttonIndex == 1
        {
            let imagePickerController = UIImagePickerController()
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)
            {
                imagePickerController.delegate = self
                imagePickerController.sourceType = UIImagePickerControllerSourceType.camera;
                imagePickerController.allowsEditing = false
                UIApplication.shared.statusBarStyle = UIStatusBarStyle.default;
                self.present(imagePickerController, animated: true, completion: nil)
                UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent;
            }
        }
        else if buttonIndex == 2
        {
            let imagePickerController = UIImagePickerController()
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.savedPhotosAlbum)
            {
                imagePickerController.delegate = self
                imagePickerController.sourceType = UIImagePickerControllerSourceType.savedPhotosAlbum;
                imagePickerController.allowsEditing = false
                UIApplication.shared.statusBarStyle = UIStatusBarStyle.default;
                self.present(imagePickerController, animated: true, completion: nil)
                
            }
        }
        
    }
    
    // MARK: - Image Picker Delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        picker .dismiss(animated: true, completion: nil)
        let media =  info[UIImagePickerControllerOriginalImage] as? UIImage
        
        let controller = PECropViewController();
        controller.delegate = self;
        controller.image = media;
        
        // controller.navigationController?.navigationBar.backgroundColor = UIColor.blue
        controller.toolbarItems=nil;
        let ratio:CGFloat = 2.0 / 2.0;
        controller.cropAspectRatio = ratio;
        
        controller.dismiss(animated: true, completion:nil)
        
        let navigationController = UINavigationController.init(rootViewController: controller);
        if UIDevice.current.userInterfaceIdiom == .pad
        {
            var colors = [UIColor]()
            colors.append(UIColor(red: 18/255, green: 98/255, blue: 151/255, alpha: 1))
            colors.append(UIColor(red: 28/255, green: 154/255, blue: 96/255, alpha: 1))
            navigationController.navigationBar.setGradientBackground(colors: colors)
            navigationController.modalPresentationStyle = UIModalPresentationStyle.formSheet;
        }
        self.present(navigationController, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        picker .dismiss(animated: true, completion: nil)
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent;
    }
    
    func cropViewController(_ controller: PECropViewController!, didFinishCroppingImage croppedImage: UIImage!)
    {
        let ims:UIImage=croppedImage
        controller.dismiss(animated: true, completion:nil)
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent;
        //        self.UploadimageWithImage(image: ims, size:CGSizeMake(200,200))
        self.UploadimageWithImage(image: ims, size: CGSize(width: 200, height: 200))
    }
    
    func cropViewControllerDidCancel(_ controller: PECropViewController!)
    {
        
        controller.dismiss(animated: true, completion:nil)
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent;
    }
    
    
    func UploadimageWithImage(image:UIImage,size:CGSize)
    {
        UIGraphicsBeginImageContext(size)
        image.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let newimage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        let date=NSDate() as NSDate;
        let form = DateFormatter() as DateFormatter
        form.dateFormat="yyyy-MM-dd"
        let form1 = DateFormatter() as DateFormatter
        form1.dateFormat="HH:MM:SS"
        let datesstr = form.string(from: date as Date);
        let timestr = form1.string(from: date as Date);
        let datearr = datesstr.components(separatedBy: "-") as NSArray
        let timearr = timestr.components(separatedBy: ":") as NSArray
        let imageData = UIImageJPEGRepresentation(newimage,0.7);
        let imagename = String(format:"pic_%@_%@_%@_%@_%@_%@.png",datearr.object(at: 0) as! String,datearr.object(at: 1) as! String,datearr.object(at: 2) as! String,timearr.object(at: 0) as! String,timearr.object(at: 1) as! String,timearr.object(at: 2) as! String)
        let kLurl = "\(kBaseURL)upload_profile_picture"
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(imageData!, withName: "profilePicture", fileName: imagename, mimeType: "image/jpeg")
        }, to:"https://apps.learncab.com/upload_profile_picture")
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (Progress) in
                    print("Upload Progress: \(Progress.fractionCompleted)")
                })
                
                upload.responseJSON { response in
                    //self.delegate?.showSuccessAlert()
                    print(response.request)  // original URL request
                    print(response.response) // URL response
                    print(response.data)     // server data
                    print(response.result)   // result of response serialization
                    
                    if let JSON = response.result.value {
                        print("JSON: \(JSON)")
                        self.vimage = String(format:"https://apps.learncab.com/student_images/%@",imagename)
                        self.imgview.image = image
                        
                    }
                }
                
            case .failure(let encodingError):
                //self.delegate?.showFailAlert()
                print(encodingError)
            }
            
        }
    }
    

    func profilelink()
    {
        let params:[String:String] = ["token":tokenstr]
        // SVProgressHUD.show()
        let kLurl = "\(kBaseURL)get_student_details1/"
        Alamofire.request(kLurl+passuserid+"/", method: .get, parameters: params).responseJSON { response in
            
            print(response)
            
            let result = response.result
            print(response)
            
            
            if let dict = result.value as? Dictionary<String,AnyObject>{
                print(dict)
                if let list = dict["data"] as? [Dictionary<String,AnyObject>]{
                    let fname = list[0]["first_name"] as! String
                    let lname = list[0]["last_name"] as! String
                    self.firstName.text = fname
                    self.lastName.text = lname
                    self.statetext.text =  list[0]["state"] as! String
                    self.citytext.text = list[0]["city"] as! String
                    self.address.text = list[0]["address"] as! String
                    self.vimage = list[0]["profile_image"] as! String
                    self.picode.text = list[0]["pin_code"] as! String
                    let img = list[0]["profile_image"] as! String
                    if img == ""
                    {
                        self.imgview.image = UIImage.init(named: "profile_unselect.png")
                    }
                    else
                    {
                        self.imgview.sd_setImage(with: URL(string: img))
                    }
                }
            }
        }
    }
}

