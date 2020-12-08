//
//  UIViewExtension.swift

import UIKit

//MARK: - UIView Extension

extension UIView {
    
    //MARK: - IBInspectable
    //Set Corner Radious
    @IBInspectable var cornerRadius:CGFloat {
        set {
            self.layer.cornerRadius = newValue
        }
        get {
            return self.layer.cornerRadius
        }
    }
    //Set Top Corner Radious
    @IBInspectable var onlyTopCornerRadius:CGFloat {
        set {
            self.roundCorners(corners: [.topLeft, .topRight], radius: newValue)
        }get {
            return self.layer.cornerRadius
        }
    }
    
    //Set Top Corner Radious
    @IBInspectable var onlyLeftCornerRadius:CGFloat {
        set {
            self.roundCorners(corners: [.topLeft, .bottomLeft], radius: newValue)
        }get {
            return self.layer.cornerRadius
        }
    }
    
    @IBInspectable var onlyRightCornerRadius:CGFloat {
        set {
            self.roundCorners(corners: [.bottomRight, .topRight], radius: newValue)
        }get {
            return self.layer.cornerRadius
        }
    }
    
    private func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    //Set Round
    @IBInspectable var Round:Bool {
        set {
            self.layer.cornerRadius = self.frame.size.height / 2.0
        }
        get {
            return self.layer.cornerRadius == self.frame.size.height / 2.0
        }
    }
    //Set Border Color
    @IBInspectable var borderColor:UIColor {
        set {
            self.layer.borderColor = newValue.cgColor
        }
        get {
            return UIColor(cgColor: self.layer.borderColor!)
        }
    }
  
    //Set Border Width
    @IBInspectable var borderWidth:CGFloat {
        set {
            self.layer.borderWidth = newValue
        }
        get {
            return self.layer.borderWidth
        }
    }
    
    //Set Shadow to view
    @IBInspectable var ShdwColor:UIColor {
        set {
            self.layer.shadowColor = newValue.cgColor
        }
        get {
            return UIColor(cgColor: self.layer.shadowColor!)
        }
    }
    @IBInspectable var ShdwOffset:CGSize  {
        set {
            self.layer.shadowOffset = newValue
        }
        get {
            return self.layer.shadowOffset
        }
    }
    @IBInspectable var ShdwOpacity:CGFloat {
        set {
            self.layer.shadowOpacity = Float(newValue)
        }
        get {
            return CGFloat(self.layer.shadowOpacity)
        }
    }
    
    @IBInspectable var ShdwRadius:CGFloat {
        set {
            self.layer.shadowRadius = newValue
        }
        get {
            return self.layer.shadowRadius
        }
    }
    
    //Set Shadow in View
    func addShadowView(width:CGFloat=0.2, height:CGFloat=0.2, opacity:Float=0.7, maskToBounds:Bool=false, radius:CGFloat=0.5) {
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: width, height: height)
        self.layer.shadowRadius = radius
        self.layer.shadowOpacity = opacity
        self.layer.masksToBounds = maskToBounds
    }
    struct NLInnerShadowDirection: OptionSet {
        let rawValue: Int
        
        static let None = NLInnerShadowDirection(rawValue: 0)
        static let Left = NLInnerShadowDirection(rawValue: 1 << 0)
        static let Right = NLInnerShadowDirection(rawValue: 1 << 1)
        static let Top = NLInnerShadowDirection(rawValue: 1 << 2)
        static let Bottom = NLInnerShadowDirection(rawValue: 1 << 3)
        static let All = NLInnerShadowDirection(rawValue: 15)
    }
    
    //Remove Inner Shadow
    func removeInnerShadow() {
        
        for view in self.subviews {
            if (view.tag == 2639) {
                
                view.removeFromSuperview()
                break
            }
        }
    }
   
    //Add Inner Shadow
    func addInnerShadow() {
        let c = UIColor()
        let color = c.withAlphaComponent(0.5)
        let frame = CGRect(x: 0,y: 0,width: self.bounds.size.width,height: self.bounds.size.height)
        self.addInnerShadowWithRadius(frame: frame, radius: 3.0, color: color, inDirection: NLInnerShadowDirection.All)
    }
    
    //Add Inner Shadow With Radius
    func addInnerShadowWithRadius(radius: CGFloat, andAlpha: CGFloat) {
        let c = UIColor()
        let color = c.withAlphaComponent(alpha)
        let frame = CGRect(x: 0,y: 0,width: self.bounds.size.width,height: self.bounds.size.height)
        self.addInnerShadowWithRadius(frame: frame, radius: radius, color: color, inDirection: NLInnerShadowDirection.All)
    }
    
    //Add Inner Shadow With Radius
    func addInnerShadowWithRadius(radius: CGFloat, andColor: UIColor) {
        
        let frame = CGRect(x: 0,y: 0,width: self.bounds.size.width,height: self.bounds.size.height)
        self.addInnerShadowWithRadius(frame: frame, radius: radius, color: andColor, inDirection: NLInnerShadowDirection.All)
    }
    
    //Add Inner Shadow With Radius
    func addInnerShadowWithRadius(frame:CGRect,radius: CGFloat, color: UIColor, inDirection: NLInnerShadowDirection) {
        
        self.removeInnerShadow()
        
        let shadowView = self.createShadowViewWithRadius(frame: frame,radius: radius, andColor: color, direction: inDirection)
        
        self.addSubview(shadowView)
    }
    
    //Create Shadow View With Radius
    func createShadowViewWithRadius(frame:CGRect,radius: CGFloat, andColor: UIColor, direction: NLInnerShadowDirection) -> UIView {
        
        let shadowView = UIView(frame: frame)
        shadowView.backgroundColor = UIColor.clear
        shadowView.tag = 2639
        
        let colorsArray: Array = [ andColor.cgColor, UIColor.clear.cgColor ]
        
        if direction.contains(.Top) {
            let xOffset: CGFloat = 0.0
            let topwidth = frame.size.width
            
            let shadow = CAGradientLayer()
            shadow.colors = colorsArray
            shadow.startPoint = CGPoint(x:0.5,y: 0.0)
            shadow.endPoint = CGPoint(x:0.5,y: 1.0)
            shadow.frame = CGRect(x: xOffset,y: 0,width: topwidth,height: radius)
            shadowView.layer.insertSublayer(shadow, at: 0)
        }
        
        if direction.contains(.Bottom) {
            
            let xOffset: CGFloat = 0.0
            let bottomwidth = frame.size.width
            
            let shadow = CAGradientLayer()
            shadow.colors = colorsArray
            shadow.startPoint = CGPoint(x:0.5,y: 1.0)
            shadow.endPoint = CGPoint(x:0.5,y: 0.0)
            shadow.frame = CGRect(x:xOffset,y: frame.size.height - radius, width: bottomwidth,height: radius)
            shadowView.layer.insertSublayer(shadow, at: 0)
        }
        
        if direction.contains(.Left) {
            
            let yOffset: CGFloat = 0.0
            let leftheight = frame.size.height
            
            let shadow = CAGradientLayer()
            shadow.colors = colorsArray
            shadow.frame = CGRect(x:0,y: yOffset,width: radius,height: leftheight)
            shadow.startPoint = CGPoint(x:0.0,y: 0.5)
            shadow.endPoint = CGPoint(x:1.0,y: 0.5)
            shadowView.layer.insertSublayer(shadow, at: 0)
        }
        
        if direction.contains(.Right) {
            
            let yOffset: CGFloat = 0.0
            let rightheight = frame.size.height
            
            let shadow = CAGradientLayer()
            shadow.colors = colorsArray
            shadow.frame = CGRect(x:frame.size.width - radius,y: yOffset,width: radius,height: rightheight)
            shadow.startPoint = CGPoint(x:1.0,y: 0.5)
            shadow.endPoint = CGPoint(x:0.0,y: 0.5)
            shadowView.layer.insertSublayer(shadow, at: 0)
        }
        return shadowView
    }
  
    func snapaChallengeGradient() -> CAGradientLayer{
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 2.4 * self.frame.maxY)
        let firstColor = UIColor.init(red: 0, green:0 , blue: 0, alpha: 0.8 )
        gradientLayer.colors = [firstColor.cgColor, UIColor.clear.cgColor ]
        gradientLayer.masksToBounds = false
        return gradientLayer
    }
    
    //Rotate Animation
    func rotate(_ toValue: CGFloat, duration: CFTimeInterval = 0.2) {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        
        animation.toValue = toValue
        animation.duration = duration
        animation.isRemovedOnCompletion = false
        animation.fillMode = CAMediaTimingFillMode.forwards
        
        self.layer.add(animation, forKey: nil)
    }
    
    /**
     Simply zooming in of a view: set view scale to 0 and zoom to Identity on 'duration' time interval.
     
     - parameter duration: animation duration
     */
    func zoomIn(duration: TimeInterval = 0.2) {
        self.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
        UIView.animate(withDuration: duration, delay: 0.0, options: [.curveLinear], animations: { () -> Void in
            self.transform = CGAffineTransform.identity
        }) { (animationCompleted: Bool) -> Void in
        }
    }
    
    /**
     Simply zooming out of a view: set view scale to Identity and zoom out to 0 on 'duration' time interval.
     
     - parameter duration: animation duration
     */
    func zoomOut(duration: TimeInterval = 0.2) {
        self.transform = CGAffineTransform.identity
        UIView.animate(withDuration: duration, delay: 0.0, options: [.curveLinear], animations: { () -> Void in
            self.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
        }) { (animationCompleted: Bool) -> Void in
        }
    }
    
    /**
     Zoom in any view with specified offset magnification.
     
     - parameter duration:     animation duration.
     - parameter easingOffset: easing offset.
     */
    func zoomInWithEasing(duration: TimeInterval = 0.2, easingOffset: CGFloat = 0.2) {
        let easeScale = 1.0 + easingOffset
        let easingDuration = TimeInterval(easingOffset) * duration / TimeInterval(easeScale)
        let scalingDuration = duration - easingDuration
        UIView.animate(withDuration: scalingDuration, delay: 0.0, options: .curveEaseIn, animations: { () -> Void in
            self.transform = CGAffineTransform(scaleX: easeScale, y: easeScale)
        }, completion: { (completed: Bool) -> Void in
            UIView.animate(withDuration: easingDuration, delay: 0.0, options: .curveEaseOut, animations: { () -> Void in
                self.transform = CGAffineTransform.identity
            }, completion: { (completed: Bool) -> Void in
            })
        })
    }
    
    /**
     Zoom out any view with specified offset magnification.
     
     - parameter duration:     animation duration.
     - parameter easingOffset: easing offset.
     */
    func zoomOutWithEasing(duration: TimeInterval = 0.2, easingOffset: CGFloat = 0.2) {
        let easeScale = 1.0 + easingOffset
        let easingDuration = TimeInterval(easingOffset) * duration / TimeInterval(easeScale)
        let scalingDuration = duration - easingDuration
        UIView.animate(withDuration: easingDuration, delay: 0.0, options: .curveEaseOut, animations: { () -> Void in
            self.transform = CGAffineTransform(scaleX: easeScale, y: easeScale)
        }, completion: { (completed: Bool) -> Void in
            UIView.animate(withDuration: scalingDuration, delay: 0.0, options: .curveEaseOut, animations: { () -> Void in
                self.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
            }, completion: { (completed: Bool) -> Void in
            })
        })
    }
    func addTouchDownAniamtion(compltionHandler:@escaping (()->())){
        self.isUserInteractionEnabled = false
        self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        UIView.animate(withDuration: 0.3, animations: {
              self.transform = CGAffineTransform.identity
        }, completion: { (compt) in
            self.isUserInteractionEnabled = true
            compltionHandler()
        })
    }
    func shadow(aView:UIView) {
        DispatchQueue.main.async {
            if aView.layer.sublayers != nil{
                if !aView.layer.sublayers!.isEmpty{
                    for layer in aView.layer.sublayers! {
                        if layer.name == "maskShdowlayer" {
                            layer.removeFromSuperlayer()
                        }
                    }
                }
            }
            DispatchQueue.main.async {
                // let shadowLayer = CAShapeLayer()
                aView.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.cornerRadius).cgPath
                //  aView.layer.fillColor = self.backgroundColor?.cgColor
                aView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.17).cgColor
                // aView.layer.shadowPath = shadowLayer.path
                aView.layer.shadowOffset = CGSize(width: 0.0, height: 10.0)
                aView.layer.shadowOpacity = 1.0
                aView.layer.shadowRadius = 5.0
                aView.layer.name = "maskShdowlayer"
                //  self.layer.insertSublayer(shadowLayer, at: 0)
            }
        }
    }
    
    func gradiantBorder(borderWidth:CGFloat = 5.0) {
        self.borderWidth = 0
        self.borderColor = .clear
        DispatchQueue.main.async {
            if self.layer.sublayers != nil{
                if !self.layer.sublayers!.isEmpty{
                    for layer in self.layer.sublayers! {
                        if layer.name == "gradiantBorder" {
                            layer.removeFromSuperlayer()
                        }
                    }
                }
            }
        }
        DispatchQueue.main.async {
            let gradient = CAGradientLayer()
            gradient.frame =  CGRect(origin: CGPoint.zero, size: self.frame.size)
            gradient.colors = [UIColor(red: 0.342, green: 0.721, blue: 0.632, alpha: 1).cgColor,UIColor(red: 0.801, green: 0.379, blue: 1, alpha: 1).cgColor]
            gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
            let shape = CAShapeLayer()
            shape.lineWidth = borderWidth
            shape.path = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.cornerRadius).cgPath
            shape.strokeColor = UIColor.black.cgColor
            shape.fillColor = UIColor.clear.cgColor
            gradient.mask = shape
            gradient.name = "gradiantBorder"
            self.layer.addSublayer(gradient)
        }
    }
    func grayBorder(borderWidth:CGFloat = 2.0) {
        DispatchQueue.main.async {
            if self.layer.sublayers != nil{
                if !self.layer.sublayers!.isEmpty{
                    for layer in self.layer.sublayers! {
                        if layer.name == "gradiantBorder" {
                            layer.removeFromSuperlayer()
                        }
                    }
                }
            }
        }
        self.borderWidth = borderWidth
        self.borderColor = UIColor.init(red: 168.0/255.0, green: 168.0/255.0, blue: 168.0/255.0, alpha: 1.0)
    }
    func gradiantToview() {
        DispatchQueue.main.async {
            if self.layer.sublayers != nil{
                if !self.layer.sublayers!.isEmpty{
                    for layer in self.layer.sublayers! {
                        if layer.name == "gradiant" {
                            layer.removeFromSuperlayer()
                        }
                    }
                }
            }
        }
        DispatchQueue.main.async {
            let layer = CAGradientLayer()
            layer.frame = CGRect(x: 0, y: 0, width: self.frame.width, height:self.frame.height)
            layer.colors = [UIColor(red: 0.342, green: 0.721, blue: 0.632, alpha: 1).cgColor,UIColor(red: 0.801, green: 0.379, blue: 1, alpha: 1).cgColor]
            layer.startPoint = CGPoint(x: 0.0, y: 0.5)
            layer.endPoint = CGPoint(x: 1.0, y: 0.5)
            layer.name = "gradiant"
            self.layer.insertSublayer(layer, at: 0)
            self.layer.masksToBounds = true
        }
    }
}

extension UIView {
    func fadeIn(duration: TimeInterval = 0.5, delay: TimeInterval = 0.2, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: .curveEaseIn, animations: {
            self.alpha = 1.0
        }, completion: completion)
    }
    func fadeOut(duration: TimeInterval = 0.5, delay: TimeInterval = 0.0, completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: .curveEaseIn, animations: {
            self.alpha = 0.0
        }, completion: completion)
    }
} 

extension NSLayoutConstraint {
    
    @IBInspectable var manageScrollSafeAreaTop:Bool  {
        set {
            if newValue && (UIDevice.deviceType == .iPhoneXSMax || UIDevice.deviceType == .iPhoneXR || UIDevice.deviceType == .iPhoneX_XS) {
              
                if #available(iOS 11.0, *) {
                    self.constant +=  (UIApplication.shared.delegate?.window??.safeAreaInsets.top)!
                }else{
                    self.constant += ((UIApplication.shared.delegate?.window??.rootViewController!.topLayoutGuide.length)!)
                }
            }
        }
        get {
            return false
        }
    }
    
    @IBInspectable var manageScrollSafeAreaBottom:Bool  {
        set {
            if newValue && (UIDevice.deviceType == .iPhoneXSMax || UIDevice.deviceType == .iPhoneXR || UIDevice.deviceType == .iPhoneX_XS) {
//                if #available(iOS 11.0, *) {
//                    self.constant +=  (UIApplication.shared.delegate?.window??.safeAreaInsets.bottom)!
//                }else{
//                    self.constant += ((UIApplication.shared.delegate?.window??.rootViewController!.bottomLayoutGuide.length)!)
//                }
            }
        }
        get {
            return false
        }
    }
}

extension UIView {

    public func removeAllConstraints() {
        var _superview = self.superview

        while let superview = _superview {
            for constraint in superview.constraints {

                if let first = constraint.firstItem as? UIView, first == self {
                    superview.removeConstraint(constraint)
                }

                if let second = constraint.secondItem as? UIView, second == self {
                    superview.removeConstraint(constraint)
                }
            }

            _superview = superview.superview
        }

        self.removeConstraints(self.constraints)
        self.translatesAutoresizingMaskIntoConstraints = true
    }
}
extension UIScrollView {
    //Bonus: Scroll to bottom
    func scrollToBottom(iSAnimated : Bool) {
        let bottomOffset = CGPoint(x: 0, y: contentSize.height - bounds.size.height + contentInset.bottom)
        if(bottomOffset.y > 0) {
            setContentOffset(bottomOffset, animated: iSAnimated)
        }
    }
    
}
