

import UIKit

class CustomTextField: UITextField {
    let padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)

    required init?(coder aDecorder: NSCoder) {
        super.init(coder: aDecorder)
        self.layer.borderColor = UIColor.darkGray.cgColor
        self.layer.borderWidth = 0.5
        self.backgroundColor = .white
    }
    override func textRect(forBounds bounds: CGRect) -> CGRect {
       return bounds.inset(by: padding)
     }
     
     override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
       return bounds.inset(by: padding)
     }
     
     override func editingRect(forBounds bounds: CGRect) -> CGRect {
       return bounds.inset(by: padding)
     }

}
