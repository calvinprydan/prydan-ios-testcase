import Foundation
import UIKit

public class snackBar:UIView {
    
    private let textView = PaddingSnakeBar()
    private var bottomPadding = CGFloat()
    private var textViewHeight: CGFloat = 50.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = CGRect.zero
        textView.frame = CGRect.zero
        self.addSubview(self.textView)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public func showSnackBar(view:UIView,bgColor:UIColor,text:String,textColor:UIColor,interval:Int){
        
        //Bottom Pading for iPhone X.
        if #available(iOS 11.0, *) {
            bottomPadding = view.safeAreaInsets.bottom
            
        }
        
        //Calcute height & set frame.
        self.frame = CGRect(x:0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: textViewHeight)
        self.textViewHeight = calculateHeight(text: text)
        textView.frame = CGRect(x:0, y:0, width: self.frame.width ,height: textViewHeight)
      
        textView.text = String(format: "%@", text)
        textView.textColor = textColor
        textView.font = UIFont(name: "MesmerizeLt-Regular", size: 15)
        textView.setScalable = true
        textView.textAlignment = NSTextAlignment.left
        textView.numberOfLines = 0
        self.backgroundColor = bgColor
        view.addSubview(self)
        
        UIView.animate(withDuration: 0.5) { 
            self.frame = CGRect(x:0, y: UIScreen.main.bounds.height - (self.textViewHeight + self.bottomPadding), width: UIScreen.main.bounds.width, height: self.textViewHeight + self.bottomPadding)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(interval)) {
            UIView.animate(withDuration: 0.5, animations: {
                  self.frame = CGRect(x:0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: 50)
            }) { (success) in
                self.removeFromSuperview()
            }
        }

    }
    
    private func calculateHeight(text:String) -> CGFloat{
        let rect = text.boundingRect(with: CGSize(width: self.frame.width - 30 , height: 10000000),options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14)], context: nil)
        let height = rect.size.height <= 50 ? 50 : rect.size.height + 10
        return height
    }
}

private class PaddingSnakeBar: UILabel {
    
    var topInset: CGFloat = 0.0
    var bottomInset: CGFloat = 0.0
    var leftInset: CGFloat = 15.0
    var rightInset: CGFloat = 15.0
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets.init(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + leftInset + rightInset,
                      height: size.height + topInset + bottomInset)
    }
}
