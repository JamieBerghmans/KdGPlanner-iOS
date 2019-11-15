import UIKit

class UnderlinedTextField: UITextField {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        let lineView = UIView()
        lineView.backgroundColor = UIColor(red: 32/255, green: 117/255, blue: 192/255, alpha: 1)
        lineView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(lineView)
        
        let metrics = ["width": NSNumber(value: 1.7)]
        let views = ["lineView": lineView]
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[lineView]|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: metrics, views: views))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[lineView(width)]|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: metrics, views: views))
    }
}
