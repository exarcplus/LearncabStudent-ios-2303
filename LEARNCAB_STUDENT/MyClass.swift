//
//  MyClass.swift
//  BNI
//
//  Created by Exarcplus on 21/05/16.
//  Copyright © 2016 exarcplus. All rights reserved.
//

import UIKit
import CoreLocation
import AFNetworking
import SVProgressHUD

class MyClass: NSObject {

//    var HUD : MBProgressHUD!
//    var HUD : SVProgressHUD!
    
//    var newhud :  RSLoadingView!
//    var block: SDWebImageCompletionBlock! = {(image: UIImage!, error: NSError!, cacheType: SDImageCacheType!, imageURL: NSURL!) -> Void in
//        print(self)
//    }
//    var sdwimdpblock:SDWebImageDownloaderProgressBlock! = {( receivedSize:NSInteger!,expectedSize:NSInteger!) -> Void in }

    typealias MyCompletionHandler = (_ jsonObject:NSArray,_ Stats:Bool) -> Void
    func colorWithHexString (hex:String) -> UIColor
    {
//        var cString:String = hex.trimmingCharacters(NSCharacterSet.whitespaceAndNewlineCharacterSet()).uppercaseString
        
        var cString:String = hex.trimmingCharacters(in: NSCharacterSet.whitespaces).uppercased()
        if (cString.hasPrefix("#")) {
            cString = (cString as NSString).substring(from: 1)
        }
        
        if (cString.characters.count != 6) {
            return UIColor.gray
        }
        
        let rString = (cString as NSString).substring(to: 2)
        let gString = ((cString as NSString).substring(from: 2) as NSString).substring(to: 2)
        let bString = ((cString as NSString).substring(from: 4) as NSString).substring(to: 2)
        
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)
        
        
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(1))
    }
    
    func colorWithHexString (hex:String,Alpha:CGFloat) -> UIColor
    {
//        var cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).uppercaseString
        var cString:String = hex.trimmingCharacters(in: NSCharacterSet.whitespaces).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString = (cString as NSString).substring(from: 1)
        }
        
        if (cString.characters.count != 6) {
            return UIColor.gray
        }
        
        let rString = (cString as NSString).substring(to: 2)
        let gString = ((cString as NSString).substring(from: 2) as NSString).substring(to: 2)
        let bString = ((cString as NSString).substring(from: 4) as NSString).substring(to: 2)
        
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)
        
        
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: Alpha)
    }
    
    
    func StringfromKey(Key:String) -> String
    {
        return Localization.sharedInstance().localizedString(forKey: Key)
    }
    
    
    
    func cropimage(image:UIImage,scaledToSize newSize:CGSize) -> UIImage
    {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))

        let newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return newImage!;
    }
   
    func GetArraryfromURL(urlstring: String,inviewController viewController:UIViewController,Withhud check:Bool,completionHandler:@escaping (_ jsonObject:NSArray,_ Stats:Bool) -> Void)
    {
        if AFNetworkReachabilityManager.shared().isReachable
        {
//            HUD = MBProgressHUD()
//            HUD = SVProgressHUD()
        
//            newhud = RSLoadingView()
//            let encodestr = urlstring.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)! as String;
            let encodestr = urlstring.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)
            if check == true
            {
                self.createhudinview(viewController: viewController, value:true)
            }
            print(urlstring)
            let manager = AFHTTPSessionManager();
            manager.responseSerializer = AFHTTPResponseSerializer()
            manager.get(encodestr!, parameters: nil, success:{(task,responseObject) -> Void in
                print("JSON: %@", responseObject);
                
                do {
                   
                    if check == true
                    {
                        self.createhudinview(viewController: viewController, value:false)
                    }
                    let jsonResults = try JSONSerialization.jsonObject(with: (responseObject as! NSData) as Data, options:JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                    
                    print("status:%@",jsonResults.value(forKey: "result"))
                    
                    let copyarr = jsonResults.value(forKey: "result") as! NSArray;
                    
                    let flag = true // true if download succeed,false otherwise
                    completionHandler(copyarr,flag);
                    
                    // success ...
                } catch {
                    // failure
                    
                    if check == true
                    {
                        self.createhudinview(viewController: viewController, value:false)
                    }
                    let flag = false // true if download succeed,false otherwise
                    completionHandler(NSArray(),flag);
                    
                }
                
               
                }, failure:{(task,error) -> Void in
                    print("Error: %@", error);
                    if check == true
                    {
                        self.createhudinview(viewController: viewController, value:false)
                    }
                    let flag = false // true if download succeed,false otherwise
                    completionHandler(NSArray(),flag);
            })
        }
        else
        {
            let flag = false // true if download succeed,false otherwise
            completionHandler(NSArray(),flag);
        }
    }
    
    func createhudinview(viewController:UIViewController,value check:Bool)
    {
        if check == true
        {

        }
        else
        {
//            HUD .hide(animated: true)
//            newhud.hide()
            
            SVProgressHUD.dismiss()
        }
    }
//
    func ShowsinglebutAlertwithTitle(title:String,withAlert alert:String,withIdentifier identifier:String)
    {
//        let alert = UIAlertView(title:title, message:alert, delegate:self, cancelButtonTitle:self.StringfromKey(Key: "ok"))
//        alert.restorationIdentifier = identifier;
//        alert.show()
    }

    func changeimagecolor(fromimage image:UIImage,withcolor color:UIColor) -> UIImage
    {
        var newImage = image.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale);
        color.set()
        newImage.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
        newImage = UIGraphicsGetImageFromCurrentImageContext()!;
        UIGraphicsEndImageContext();
        return newImage;
    }
    func degreesToRadians(val:Double) -> Double
    {
        return val * M_PI / 180
    }
    func radiandsToDegrees(val:Double) -> Double
    {
       return val * 180 / M_PI
    }
    func getHeadingForDirectionFromCoordinate(fromLoc:CLLocationCoordinate2D, toCoordinate toLoc:CLLocationCoordinate2D ) -> Double
    {
        let fLat = self.degreesToRadians(val: fromLoc.latitude);
        let fLng = self.degreesToRadians(val: fromLoc.longitude);
        let tLat = self.degreesToRadians(val: toLoc.latitude);
        let tLng = self.degreesToRadians(val: toLoc.longitude);
        
        let degree = self.radiandsToDegrees(val: atan2(sin(tLng-fLng)*cos(tLat), cos(fLat)*sin(tLat)-sin(fLat)*cos(tLat)*cos(tLng-fLng)));
        
        if (degree >= 0)
        {
            return degree;
        }
        else
        {
            return 360+degree;
        }
    }
    
    func roundCorners(corners:UIRectCorner, radius: CGFloat,view:UIView)
    {
        let path = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        view.layer.mask = mask
    }
    
    func validateEmail(candidate: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: candidate)
    }
}
