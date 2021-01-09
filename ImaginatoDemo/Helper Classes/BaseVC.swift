//
//  NBSBaseViewController.swift
//  DemoBank
//
//  Created by Vikram on 11/26/16.
//  Copyright © 2016 SDL. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import Reachability
import UserNotifications
import UserNotificationsUI
import MessageUI
import QuartzCore
import CoreLocation
import EventKit
import RxCocoa
import RxSwift
import MBProgressHUD

//swiftlint:disable all
typealias LeftButton = (_ left: UIButton) -> Void
typealias RightButton = (_ right: UIButton) -> Void

class ClosureSleeve {
    let closure: () -> ()
    
    init(attachTo: AnyObject, closure: @escaping () -> ()) {
        self.closure = closure
        objc_setAssociatedObject(attachTo, "[\(arc4random())]", self, .OBJC_ASSOCIATION_RETAIN)
    }
    
    @objc func invoke() {
        closure()
    }
}

class BaseVC: UIViewController,MFMailComposeViewControllerDelegate {
    let locationManager = CLLocationManager()
    var imgEmptyDataSet = UIImage()
    var titleEmptyDataSet = String()
    var currentLatitude = String()
    var currentLongitude = String()
    let network = NetworkManager.sharedInstance
    var hasTopNotch: Bool {
        if #available(iOS 11.0, tvOS 11.0, *) {
            return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0 > 20
        }
        return false
    }
    
    func getDate(strDate: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        if let index = strDate.range(of: ".")?.lowerBound {
            let substring = strDate[..<index]
            let string = String(substring)
            return dateFormatter.date(from: string)
        }
        return dateFormatter.date(from: "2020-12-07T04:30:49")
    }
    
    func setShadow(view: UIView) {
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
            let shadowPath0 = UIBezierPath(roundedRect: view.bounds, cornerRadius: 10)
            view.layer.masksToBounds = false
            view.layer.bounds = view.bounds
            view.layer.position = view.center
            view.layer.shadowPath = shadowPath0.cgPath
            view.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5).cgColor
            view.layer.shadowOpacity = 2
            view.layer.shadowRadius = 2
            view.layer.shadowOffset = CGSize(width: 0, height: 0)
        }
    }
    
    func addBottomCurve(givenView: UIView, curvedPercent:CGFloat) ->UIBezierPath
    {
        let arrowPath = UIBezierPath()
        arrowPath.move(to: CGPoint(x:0, y:0))
        arrowPath.addLine(to: CGPoint(x:givenView.bounds.size.width, y:0))
        arrowPath.addLine(to: CGPoint(x:givenView.bounds.size.width, y:givenView.bounds.size.height - (givenView.bounds.size.height*curvedPercent)))
        arrowPath.addQuadCurve(to: CGPoint(x:0, y:givenView.bounds.size.height - (givenView.bounds.size.height*curvedPercent)), controlPoint: CGPoint(x:givenView.bounds.size.width/2, y:givenView.bounds.size.height))
        arrowPath.addLine(to: CGPoint(x:0, y:0))
        arrowPath.close()
        return arrowPath
    }
    
    func setImage(img1: UIImageView, img2: UIImageView, img3: UIImageView, btn1: UIButton, btn2: UIButton, btn3: UIButton) {
        img1.image = UIImage(named: "icoRadioSelect")
        img2.image = UIImage(named: "icoRadio")
        img3.image = UIImage(named: "icoRadio")
        btn1.setTitleColor(.black, for: .normal)
        btn2.setTitleColor(.lightGray, for: .normal)
        btn3.setTitleColor(.lightGray, for: .normal)
    }
    
    func setSelectedLookingFor(img1: UIImageView, btn1: UIButton) {
        img1.image = UIImage(named: "icoRadioSelect")
        btn1.setTitleColor(.black, for: .normal)
    }
    
    func setUnselectedLookingFor(img1: UIImageView, btn1: UIButton) {
        img1.image = UIImage(named: "icoRadio")
        btn1.setTitleColor(.lightGray, for: .normal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationItem.backBarButtonItem?.isEnabled = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    // MARK: Navigation
        func setNavigationBar(title : NSString? ,
                              titleImage : UIImage?,
                              leftImage : UIImage? ,
                              rightImage : UIImage?,
                              leftTitle : String?,
                              rightTitle : String?,
                              isLeft : Bool ,
                              isRight : Bool,
                              isLeftMenu : Bool ,
                              isRightMenu : Bool ,
                              bgColor : UIColor ,
                              textColor : UIColor,
                              isStatusBarSame: Bool,
                              leftClick : @escaping LeftButton ,
                              rightClick : @escaping RightButton)  {
            
            if isStatusBarSame {
                if #available(iOS 13, *)
                {
                    let keyWindow = UIApplication.shared.connectedScenes
                    .filter({$0.activationState == .foregroundActive})
                    .map({$0 as? UIWindowScene})
                    .compactMap({$0})
                    .first?.windows
                    .filter({$0.isKeyWindow}).last
                    let statusBar = UIView(frame: keyWindow!.frame)
                    statusBar.backgroundColor = bgColor
                    keyWindow?.addSubview(statusBar)
                }
                else{
                    UIApplication.shared.statusBarView?.backgroundColor = bgColor
                }
            }
            
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
            self.navigationController?.navigationBar.clipsToBounds = true
            
    //        Beizer path for curve navigation controller
            if #available(iOS 11.0, *) {
                self.navigationController?.navigationBar.layer.cornerRadius = 20
                self.navigationController?.navigationBar.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
            } else {
                let path = UIBezierPath(roundedRect: (self.navigationController?.navigationBar.bounds)!, byRoundingCorners: [.bottomLeft , .bottomRight], cornerRadii:CGSize(width: 20, height: 20))
                let maskLayer = CAShapeLayer()
                maskLayer.frame = (self.navigationController?.navigationBar.bounds)!
                maskLayer.path = path.cgPath
                self.navigationController?.navigationBar.layer.mask = maskLayer
                self.navigationController?.navigationBar.layer.masksToBounds = true
                // Fallback on earlier versions
            }
            
            self.navigationItem.hidesBackButton = true
            // Left Item
            let btnLeft : UIButton = UIButton(type: .custom)
            btnLeft.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
            btnLeft.imageView?.contentMode = .scaleAspectFit
            let addImg = leftImage
            if leftTitle != nil {
                btnLeft.setTitle(leftTitle, for: .normal)
                self.addConstaintsWithWidth(width: 50, height: 30, btn: btnLeft)
            } else {
                btnLeft.setImage(addImg, for: .normal)
                self.addConstaintsWithWidth(width: 30, height: 30, btn: btnLeft)
            }
            btnLeft.sendActions(for: .touchUpInside)
            let leftBarItem : UIBarButtonItem = UIBarButtonItem(customView: btnLeft)
            if isLeft {
                self.navigationItem.leftBarButtonItem = leftBarItem
            }
            if isLeftMenu {
                btnLeft.addTarget(self, action: #selector(btnLeftMenuOpen(sender:)), for: .touchUpInside)
            }
            else
            {
                btnLeft.addAction {
                    leftClick(btnLeft)
                }
            }
            
            // right item
            let btnRight : UIButton = UIButton(type: .custom)
            btnRight.frame = CGRect(x: self.view.frame.size.width, y: 0, width: 25, height: 25)
            btnRight.imageView?.contentMode = .scaleAspectFit
            let addImg1 = rightImage
            if rightTitle != nil {
                btnRight.frame = CGRect(x: self.view.frame.size.width, y: 0, width: 50, height: 30)
                btnRight.titleLabel?.font = UIFont.systemFont(ofSize: 18.0)
                btnRight.setTitleColor(UIColor.white, for: .normal)
                btnRight.setTitle(rightTitle, for: .normal)
            } else {
                self.addConstaintsWithWidth(width: 30, height: 30, btn: btnRight)
                btnRight.setImage(addImg1, for: .normal)
            }
            
            btnRight.sendActions(for: .touchUpInside)
            
            let rightBarItem : UIBarButtonItem = UIBarButtonItem(customView: btnRight)
            if isRight {
                self.navigationItem.rightBarButtonItem = rightBarItem
            }
            if isRightMenu {
                btnRight.addTarget(self, action: #selector(btnRightMenuOpen(sender:)), for: .touchUpInside)
            }
            else
            {
                btnRight.addAction {
                    rightClick(btnRight)
                }
            }
            
            // title
            if title == nil {
                let imgViewTitle = UIImageView(frame: CGRect(x: self.view.frame.size.width/2-50, y: self.view.frame.size.height/2-40, width:20, height: 40.0)) as UIImageView
                imgViewTitle.backgroundColor = UIColor.clear
                imgViewTitle.contentMode = .scaleAspectFit
                imgViewTitle.image = titleImage
                self.navigationItem.titleView = imgViewTitle
            } else {
                let  lblNavigationTitleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 40.0)) as UILabel
                lblNavigationTitleLabel.text = title! as String
                lblNavigationTitleLabel.font = UIFont.boldSystemFont(ofSize: 18.0   )
                lblNavigationTitleLabel.textColor = textColor
                lblNavigationTitleLabel.textAlignment = .center
                lblNavigationTitleLabel.frame = CGRect(x: 100, y: 0, width: 100, height: 100)
                self.navigationItem.titleView = lblNavigationTitleLabel
            }
            
            self.navigationController?.navigationBar.barTintColor = bgColor
            self.navigationController?.navigationBar.isTranslucent = true
        }
    
    @objc func btnLeftMenuOpen(sender: UIButton) {
        
//        panel?.openLeft(animated: true)
    }

    @objc func btnRightMenuOpen(sender: UIButton) {

    }
    
    func localToUTC(date:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.calendar = NSCalendar.current
        dateFormatter.timeZone = TimeZone.current

        let dt = dateFormatter.date(from: date)
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        return dateFormatter.string(from: dt!)
    }

    func UTCToLocal(date:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")

        let dt = dateFormatter.date(from: date)
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "dd MMM, yyyy"

        return dateFormatter.string(from: dt!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.default   // Make dark again
    }
    
    func convertImageToBase64(image: UIImage) -> String {
        let imageData = image.pngData()!
        return imageData.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)
    }
    
    func convertBase64ToImage(imageString: String) -> UIImage {
        let imageData = Data(base64Encoded: imageString, options: Data.Base64DecodingOptions.ignoreUnknownCharacters)!
        return UIImage(data: imageData)!
    }
    
    
    func addConstaintsWithWidth(width: CGFloat ,height: CGFloat, btn: UIButton) {
        NSLayoutConstraint(item: btn, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: width).isActive = true
        NSLayoutConstraint(item: btn, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: height).isActive = true
    }
    
    func delayWithSeconds(_ seconds: Double, completion: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            completion()
        }
    }
}

extension UIControl {
    func addAction(for controlEvents: UIControl.Event = .primaryActionTriggered, action: @escaping () -> ()) {
        let sleeve = ClosureSleeve(attachTo: self, closure: action)
        addTarget(sleeve, action: #selector(ClosureSleeve.invoke), for: controlEvents)
    }
}

extension Date {
    func localDate() -> Date {
        let nowUTC = Date()
        let timeZoneOffset = Double(TimeZone.current.secondsFromGMT(for: nowUTC))
        guard let localDate = Calendar.current.date(byAdding: .second, value: Int(timeZoneOffset), to: nowUTC) else {return Date()}
        return localDate
    }
}

extension BaseVC : UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
}


extension BaseVC: CLLocationManagerDelegate {
    // Location
    func currentLocation() {
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        if locValue.latitude != 0 && locValue.longitude != 0 {
            locationManager.stopUpdatingLocation()
        }
    }
    
    func configuredMailComposeViewController(strMail: String) {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        mailComposerVC.setToRecipients([strMail])
        mailComposerVC.setSubject("")
        mailComposerVC.setMessageBody("", isHTML: false)
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposerVC, animated: true, completion: nil)
        }
    }
    
    func removeAllPreference() {
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
    }
    
    func bottomViewCurve(viewNavigation: UIView) {
        if #available(iOS 11.0, *) {
            viewNavigation.layer.cornerRadius = 20
            viewNavigation.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        } else {
            let path = UIBezierPath(roundedRect: (viewNavigation.bounds), byRoundingCorners: [.bottomLeft , .bottomRight], cornerRadii:CGSize(width: 20, height: 20))
            let maskLayer   = CAShapeLayer()
            maskLayer.frame = (viewNavigation.bounds)
            maskLayer.path  = path.cgPath
            viewNavigation.layer.mask = maskLayer
            viewNavigation.layer.masksToBounds = true
            // Fallback on earlier versions
        }
    }
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
}

extension UIView {
    func addBottomBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width,
                              width: self.frame.size.width, height: width)
        self.layer.addSublayer(border)
    }
}

@IBDesignable
public class GradientView: UIView {
    private func createGradient() -> CAGradientLayer {
        let gradient = CAGradientLayer()
        gradient.transform = CATransform3DMakeRotation(.pi / 2, 0, 0, 1)
        gradient.frame = bounds
        layer.insertSublayer(gradient, at: 0)
        return gradient
    }

    private var gradient: CAGradientLayer?

    @IBInspectable
    public var color1: UIColor? {
        didSet {
            updateColors()
        }
    }

    @IBInspectable
    public var color2: UIColor? {
        didSet {
            updateColors()
        }
    }
    
    @IBInspectable
    public var color3: UIColor? {
        didSet {
            updateColors()
        }
    }

    @IBInspectable
    public var color4: UIColor? {
        didSet {
            updateColors()
        }
    }


    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        gradient = createGradient()
        updateColors()
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        gradient = createGradient()
        updateColors()
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        gradient?.frame = bounds
    }

    private func updateColors() {
        guard
            let color1 = color1,
            let color2 = color2,
        let color3 = color3,
        let color4 = color4
        else {
            return
        }

        gradient?.colors = [color1.cgColor, color2.cgColor, color3.cgColor, color4.cgColor]
    }
}

extension UIView {
    func insertHorizontalGradient(_ color1: UIColor, _ color2: UIColor, _ color3: UIColor, _ color4: UIColor) -> GradientView {
        let gradientView = GradientView(frame: bounds)
        gradientView.color1 = color1
        gradientView.color2 = color2
        gradientView.color3 = color3
        gradientView.color4 = color4
        gradientView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.insertSubview(gradientView, at: 0)
        return gradientView
    }
}
