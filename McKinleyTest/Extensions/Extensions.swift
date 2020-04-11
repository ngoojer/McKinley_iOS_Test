

import Foundation
import UIKit
import Combine

extension UITextField{
    var textPublisher : AnyPublisher<String, Never>{
        let pulisher = NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: self)
            .compactMap{$0.object as? UITextField}
            .map{$0.text ?? ""}
            .eraseToAnyPublisher()
        return pulisher
    }
    
    var textDidEndEditingPublisher : AnyPublisher<String, Never>{
        let pulisher = NotificationCenter.default.publisher(for: UITextField.textDidEndEditingNotification, object: self)
            .compactMap{$0.object as? UITextField}
            .map{$0.text ?? ""}
            .eraseToAnyPublisher()
        return pulisher
    }
}

extension UIViewController{
    func alert(title: String = "Alert", message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
        
    }
        
}

extension UIApplication {
var statusBarUIView: UIView? {
    if #available(iOS 13.0, *) {
        let tag = 38482
        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first

        if let statusBar = keyWindow?.viewWithTag(tag) {
            return statusBar
        } else {
            guard let statusBarFrame = keyWindow?.windowScene?.statusBarManager?.statusBarFrame else { return nil }
            let statusBarView = UIView(frame: statusBarFrame)
            statusBarView.tag = tag
            keyWindow?.addSubview(statusBarView)
            return statusBarView
        }
    } else if responds(to: Selector(("statusBar"))) {
        return value(forKey: "statusBar") as? UIView
    } else {
        return nil
    }
  }
}
