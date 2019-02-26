//
//  UIExtensions.swift
//
//  Created by Star on 2/25/19.
//  Copyright © 2019 Lightning. All rights reserved.
//

import UIKit
import Contacts


extension UIViewController {
    
    func showAlert(message : String, title : String? = nil, actionOk: (() -> Void)? = nil) {

        let alert = UIAlertController(title: title ?? "", message: message, preferredStyle: .alert)
        let actionOk = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { (action) in
            if actionOk != nil {
                actionOk!()
            }
        }
        alert.addAction(actionOk)
        
        self.present(alert, animated: true, completion: nil)
    }

    func showAlertYesNo(message : String, title : String? = nil, actionYes: (() -> Void)? = nil, actionNo: (() -> Void)? = nil){
            showAlertYesNo(message: message, title: title, titleYes: nil, actionYes: actionYes, titleNo: nil, actionNo: actionNo)
    }
    
    func showAlertYesNo(message : String,
                        title : String? = nil,
                        titleYes : String? = nil,
                        actionYes: (() -> Void)? = nil,
                        titleNo : String? = nil,
                        actionNo: (() -> Void)? = nil){
        
        let alert = UIAlertController(title: title ?? "", message: message, preferredStyle: .alert)
        let actionNo = UIAlertAction(title: titleNo ?? "No", style: UIAlertAction.Style.default) { (action) in
            if actionNo != nil {
                actionNo!()
            }
        }
        let actionYes = UIAlertAction(title: titleYes ?? "Yes", style: UIAlertAction.Style.default) { (action) in
            if actionYes != nil {
                actionYes!()
            }
        }
        alert.addAction(actionNo)
        alert.addAction(actionYes)
        
        self.present(alert, animated: true, completion: nil)
    }


    func requestPassword(message : String, title : String? = nil, actionOk: ((_ password : String?) -> Void)? = nil) {
        
        let alert = UIAlertController(title: title ?? "", message: message, preferredStyle: .alert)
        alert.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter your password"
            textField.isSecureTextEntry = true
        }
        let actionOk = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { (action) in
            if actionOk != nil {
                let password = alert.textFields![0].text
                actionOk!(password)
            }
        }
        alert.addAction(actionOk)
        
        self.present(alert, animated: true, completion: nil)
    }

    /// This function will set all the required properties, and then provide a preview for the document
    func share(url: URL, delegate : UIDocumentInteractionControllerDelegate?) {
        let documentInteractionController = UIDocumentInteractionController()
        documentInteractionController.delegate = delegate

        documentInteractionController.url = url
        documentInteractionController.uti = url.typeIdentifier ?? "public.data, public.content"
        documentInteractionController.name = url.localizedName ?? url.lastPathComponent
        documentInteractionController.presentPreview(animated: true)
    }

}

extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}

extension String {
    func removingWhitespaces() -> String {
        return components(separatedBy: .whitespaces).joined()
    }
    
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    func isValidPassword() -> Bool {

        let charsetUp = CharacterSet(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZ")
        let charsetLow = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyz")
        let charsetNum = CharacterSet(charactersIn: "0123456789")
        
        if self.count >= 8,
            self.rangeOfCharacter(from: charsetUp) != nil,
            self.rangeOfCharacter(from: charsetLow) != nil,
            self.rangeOfCharacter(from: charsetNum) != nil {
            return true
        }else {
            return false
        }
    }
    
    func dateMM_YYYY () -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/yyyy"
        return formatter.date(from: self)
    }
}

extension UIColor {
    
    static func colorMain() -> UIColor {
        return UIColor(red: 85/255.0, green: 211/255.0, blue: 203/255.0, alpha: 1.0)
    }
    
    static var colorNotifiYellow : UIColor {
        return UIColor (red: 253/255.0, green: 191/255.0, blue: 45/255.0, alpha: 1.0)
    }
}


extension URL {
    var typeIdentifier: String? {
        return (try? resourceValues(forKeys: [.typeIdentifierKey]))?.typeIdentifier
    }
    var localizedName: String? {
        return (try? resourceValues(forKeys: [.localizedNameKey]))?.localizedName
    }
    
    public var queryItems: [String: String] {
        var params = [String: String]()
        return URLComponents(url: self, resolvingAgainstBaseURL: false)?
            .queryItems?
            .reduce([:], { (_, item) -> [String: String] in
                params[item.name] = item.value
                return params
            }) ?? [:]
    }

}

extension UIImage  {
    
    func imageRotatedByDegrees(deg degrees: CGFloat) -> UIImage {
        //Calculate the size of the rotated view's containing box for our drawing space
        let rotatedViewBox: UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        let t: CGAffineTransform = CGAffineTransform(rotationAngle: degrees * CGFloat.pi / 180)
        rotatedViewBox.transform = t
        let rotatedSize: CGSize = rotatedViewBox.frame.size
        //Create the bitmap context
        UIGraphicsBeginImageContext(rotatedSize)
        let bitmap: CGContext = UIGraphicsGetCurrentContext()!
        //Move the origin to the middle of the image so we will rotate and scale around the center.
        bitmap.translateBy(x: rotatedSize.width / 2, y: rotatedSize.height / 2)
        //Rotate the image context
        bitmap.rotate(by: (degrees * CGFloat.pi / 180))
        //Now, draw the rotated/scaled image into the context
        bitmap.scaleBy(x: 1.0, y: -1.0)
        bitmap.draw(self.cgImage!, in: CGRect(x: -self.size.width / 2, y: -self.size.height / 2, width: self.size.width, height: self.size.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
}

