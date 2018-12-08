//
//  UIView.swift
//  softbank_prototype
//
//  Created by Apple on 2018/09/01.
//  Copyright © 2018年 Apple. All rights reserved.
//

import Foundation
import UIKit

private extension ArraySlice {
    
    var startItem: Element {
        return self[self.startIndex]
    }
    
}

extension UIView {
    
    private typealias `Self` = UIView
    
    private static func animate(eachBlockDuration duration: TimeInterval, eachBlockDelay delay: TimeInterval, eachBlockOptions options: UIViewAnimationOptions, animationArraySlice: ArraySlice<() -> Void>, completion: ((_ finished: Bool) -> Void)?) {
        
        let animation = animationArraySlice.startItem
        
        UIView.animate(withDuration: duration, delay: delay, options: options, animations: animation) { (finished) in
            
            let remainedAnimations = animationArraySlice.dropFirst()
            
            if remainedAnimations.isEmpty {
                completion?(finished)
                
            } else {
                Self.animate(eachBlockDuration: duration, eachBlockDelay: delay, eachBlockOptions: options, animationArraySlice: remainedAnimations, completion: completion)
            }
            
        }
        
    }
    
    public static func animate(eachBlockDuration duration: TimeInterval, eachBlockDelay delay: TimeInterval = 0, eachBlockOptions options: UIViewAnimationOptions = .curveEaseInOut, animationBlocks: (() -> Void)..., completion: ((_ finished: Bool) -> Void)? = nil) {
        
        let isFinished = animationBlocks.isEmpty
        
        guard isFinished == false else {
            completion?(isFinished)
            return
        }
        
        let animationArraySlice = ArraySlice(animationBlocks)
        
        Self.animate(eachBlockDuration: duration, eachBlockDelay: delay, eachBlockOptions: options, animationArraySlice: animationArraySlice, completion: completion)
        
    }
    
}

extension UIView {
    
    func waveCenter() {
        // ①: タップされた場所にlayerを置き、半径200の円を描画
        let location = CGPoint(x: self.right / 2, y: self.bottom / 2)
        let layer = CAShapeLayer.init()
        self.layer.addSublayer(layer)
        layer.frame = CGRect.init(x: location.x, y: location.y, width: 100, height: 100)
        layer.position = CGPoint.init(x: location.x, y: location.y)
        layer.contents = {
            let size: CGFloat = 200.0
            UIGraphicsBeginImageContext(CGSize.init(width: size, height: size))
            let context = UIGraphicsGetCurrentContext()!
            context.saveGState()
            context.setFillColor(UIColor.clear.cgColor)
            context.fill(self.frame)
            let r = CGFloat.init(size/2-10)
            let center = CGPoint.init(x: size/2, y: size/2)
            let path : CGMutablePath = CGMutablePath()
            path.addArc(center: center, radius: r, startAngle: 0, endAngle: CGFloat(Double.pi*2), clockwise: false)
            context.addPath(path)
            context.setFillColor(Constant.mainColor.cgColor) //UIColor.lightGray.cgColor
            context.setStrokeColor(Constant.mainColor.cgColor)
            context.drawPath(using: .fillStroke)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            context.restoreGState()
            return image!.cgImage
        }()
        
        // ②: 円を拡大しつつ透明化するAnimationを用意
        let animationGroup: CAAnimationGroup = {
            let animation: CABasicAnimation = {
                let animation = CABasicAnimation(keyPath: "transform.scale")
                animation.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseOut)
                animation.duration = 0.5
                animation.isRemovedOnCompletion = false
                animation.fillMode = kCAFillModeForwards
                animation.fromValue = NSNumber(value: 0.5)
                animation.toValue = NSNumber(value: 5.0)
                return animation
            }()
            
            let animation2: CABasicAnimation = {
                let animation = CABasicAnimation(keyPath: "opacity")
                animation.duration = 0.5
                animation.isRemovedOnCompletion = false
                animation.fillMode = kCAFillModeForwards
                animation.fromValue = NSNumber(value: 0.5)
                animation.toValue = NSNumber(value: 0.0)
                return animation
            }()
            
            let group = CAAnimationGroup()
            group.beginTime = CACurrentMediaTime()
            group.animations = [animation, animation2]
            group.isRemovedOnCompletion = false
            group.fillMode = kCAFillModeBackwards
            return group
        }()
        
        // ③: layerにAnimationを適用
        CATransaction.setAnimationDuration(5.0)
        CATransaction.setCompletionBlock({
            layer.removeFromSuperlayer()
        })
        CATransaction.begin()
        layer.add(animationGroup, forKey: nil)
        layer.opacity = 0.0
        CATransaction.commit()
    }

    
    func wave(touch: UITapGestureRecognizer) {
        // ①: タップされた場所にlayerを置き、半径200の円を描画
        let location = touch.location(in: self)
        let layer = CAShapeLayer.init()
        self.layer.addSublayer(layer)
        layer.frame = CGRect.init(x: location.x, y: location.y, width: 100, height: 100)
        layer.position = CGPoint.init(x: location.x, y: location.y)
        layer.contents = {
            let size: CGFloat = 200.0
            UIGraphicsBeginImageContext(CGSize.init(width: size, height: size))
            let context = UIGraphicsGetCurrentContext()!
            context.saveGState()
            context.setFillColor(UIColor.clear.cgColor)
            context.fill(self.frame)
            let r = CGFloat.init(size/2-10)
            let center = CGPoint.init(x: size/2, y: size/2)
            let path : CGMutablePath = CGMutablePath()
            path.addArc(center: center, radius: r, startAngle: 0, endAngle: CGFloat(Double.pi*2), clockwise: false)
            context.addPath(path)
            context.setFillColor(Constant.mainColor.cgColor)
            context.setStrokeColor(Constant.mainColor.cgColor)
            context.drawPath(using: .fillStroke)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            context.restoreGState()
            return image!.cgImage
        }()
        
        // ②: 円を拡大しつつ透明化するAnimationを用意
        let animationGroup: CAAnimationGroup = {
            let animation: CABasicAnimation = {
                let animation = CABasicAnimation(keyPath: "transform.scale")
                animation.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseOut)
                animation.duration = 0.5
                animation.isRemovedOnCompletion = false
                animation.fillMode = kCAFillModeForwards
                animation.fromValue = NSNumber(value: 0.5)
                animation.toValue = NSNumber(value: 5.0)
                return animation
            }()
            
            let animation2: CABasicAnimation = {
                let animation = CABasicAnimation(keyPath: "opacity")
                animation.duration = 0.5
                animation.isRemovedOnCompletion = false
                animation.fillMode = kCAFillModeForwards
                animation.fromValue = NSNumber(value: 0.5)
                animation.toValue = NSNumber(value: 0.0)
                return animation
            }()
            
            let group = CAAnimationGroup()
            group.beginTime = CACurrentMediaTime()
            group.animations = [animation, animation2]
            group.isRemovedOnCompletion = false
            group.fillMode = kCAFillModeBackwards
            return group
        }()
        
        // ③: layerにAnimationを適用
        CATransaction.setAnimationDuration(5.0)
        CATransaction.setCompletionBlock({
            layer.removeFromSuperlayer()
        })
        CATransaction.begin()
        layer.add(animationGroup, forKey: nil)
        layer.opacity = 0.0
        CATransaction.commit()
    }
    
    func wavePoint(point: CGPoint, size: CGFloat) {
        // ①: タップされた場所にlayerを置き、半径200の円を描画
        let location = point
        let layer = CAShapeLayer.init()
        self.layer.addSublayer(layer)
        layer.frame = CGRect.init(x: location.x, y: location.y, width: 100, height: 100)
        layer.position = CGPoint.init(x: location.x, y: location.y)
        layer.contents = {
            let size: CGFloat = size
            UIGraphicsBeginImageContext(CGSize.init(width: size, height: size))
            let context = UIGraphicsGetCurrentContext()!
            context.saveGState()
            context.setFillColor(UIColor.clear.cgColor)
            context.fill(self.frame)
            let r = CGFloat.init(size/2-10)
            let center = CGPoint.init(x: size/2, y: size/2)
            let path : CGMutablePath = CGMutablePath()
            path.addArc(center: center, radius: r, startAngle: 0, endAngle: CGFloat(Double.pi*2), clockwise: false)
            context.addPath(path)
            context.setFillColor(UIColor.lightGray.cgColor)
            context.setStrokeColor(UIColor.lightGray.cgColor)
            context.drawPath(using: .fillStroke)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            context.restoreGState()
            return image!.cgImage
        }()
        
        // ②: 円を拡大しつつ透明化するAnimationを用意
        let animationGroup: CAAnimationGroup = {
            let animation: CABasicAnimation = {
                let animation = CABasicAnimation(keyPath: "transform.scale")
                animation.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseOut)
                animation.duration = 0.5
                animation.isRemovedOnCompletion = false
                animation.fillMode = kCAFillModeForwards
                animation.fromValue = NSNumber(value: 0.5)
                animation.toValue = NSNumber(value: 5.0)
                return animation
            }()
            
            let animation2: CABasicAnimation = {
                let animation = CABasicAnimation(keyPath: "opacity")
                animation.duration = 0.5
                animation.isRemovedOnCompletion = false
                animation.fillMode = kCAFillModeForwards
                animation.fromValue = NSNumber(value: 0.5)
                animation.toValue = NSNumber(value: 0.0)
                return animation
            }()
            
            let group = CAAnimationGroup()
            group.beginTime = CACurrentMediaTime()
            group.animations = [animation, animation2]
            group.isRemovedOnCompletion = false
            group.fillMode = kCAFillModeBackwards
            return group
        }()
        
        // ③: layerにAnimationを適用
        CATransaction.setAnimationDuration(5.0)
        CATransaction.setCompletionBlock({
            layer.removeFromSuperlayer()
        })
        CATransaction.begin()
        layer.add(animationGroup, forKey: nil)
        layer.opacity = 0.0
        CATransaction.commit()
    }
    
    func waveColorCenter(color: UIColor, point: CGPoint) {
        // ①: タップされた場所にlayerを置き、半径200の円を描画
        let location = point
        let layer = CAShapeLayer.init()
        self.layer.addSublayer(layer)
        layer.frame = CGRect.init(x: location.x, y: location.y, width: 100, height: 100)
        layer.position = CGPoint.init(x: location.x, y: location.y)
        layer.contents = {
            let size: CGFloat = 1000.0
            UIGraphicsBeginImageContext(CGSize.init(width: size, height: size))
            let context = UIGraphicsGetCurrentContext()!
            context.saveGState()
            context.setFillColor(UIColor.clear.cgColor)
            context.fill(self.frame)
            let r = CGFloat.init(size/2-10)
            let center = CGPoint.init(x: size/2, y: size/2)
            let path : CGMutablePath = CGMutablePath()
            path.addArc(center: center, radius: r, startAngle: 0, endAngle: CGFloat(Double.pi*2), clockwise: false)
            context.addPath(path)
            context.setFillColor(color.cgColor)
            context.setStrokeColor(color.cgColor)
            context.drawPath(using: .fillStroke)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            context.restoreGState()
            return image!.cgImage
        }()
        
        // ②: 円を拡大しつつ透明化するAnimationを用意
        let animationGroup: CAAnimationGroup = {
            let animation: CABasicAnimation = {
                let animation = CABasicAnimation(keyPath: "transform.scale")
                animation.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseOut)
                animation.duration = 0.5
                animation.isRemovedOnCompletion = false
                animation.fillMode = kCAFillModeForwards
                animation.fromValue = NSNumber(value: 0.5)
                animation.toValue = NSNumber(value: 5.0)
                return animation
            }()
            
            let animation2: CABasicAnimation = {
                let animation = CABasicAnimation(keyPath: "opacity")
                animation.duration = 0.5
                animation.isRemovedOnCompletion = false
                animation.fillMode = kCAFillModeForwards
                animation.fromValue = NSNumber(value: 0.5)
                animation.toValue = NSNumber(value: 0.0)
                return animation
            }()
            
            let group = CAAnimationGroup()
            group.beginTime = CACurrentMediaTime()
            group.animations = [animation, animation2]
            group.isRemovedOnCompletion = false
            group.fillMode = kCAFillModeBackwards
            return group
        }()
        
        // ③: layerにAnimationを適用
        CATransaction.setAnimationDuration(5.0)
        CATransaction.setCompletionBlock({
            layer.removeFromSuperlayer()
        })
        CATransaction.begin()
        layer.add(animationGroup, forKey: nil)
        layer.opacity = 0.0
        CATransaction.commit()
    }
}

extension UIView {
    func removeAllSubviews() {
        subviews.forEach {
            $0.removeFromSuperview()
        }
    }
}

extension Comparable {
    func clamped(min: Self, max: Self) -> Self {
        if self < min {
            return min
        }
        
        if self > max {
            return max
        }
        
        return self
    }
}

public protocol NibInstantiatable {
    static var nibName: String { get }
    static var nibBundle: Bundle { get }
    static var nibOwner: Any? { get }
    static var nibOptions: [AnyHashable: Any]? { get }
    static var instantiateIndex: Int { get }
}

public extension NibInstantiatable where Self: NSObject {
    public static var nibName: String { return className }
    public static var nibBundle: Bundle { return Bundle(for: self) }
    public static var nibOwner: Any? { return self }
    public static var nibOptions: [AnyHashable: Any]? { return nil }
    public static var instantiateIndex: Int { return 0 }
}

public extension NibInstantiatable where Self: UIView {
    public static func instantiate() -> Self {
        let nib = UINib(nibName: nibName, bundle: nibBundle)
        return nib.instantiate(withOwner: nibOwner, options: nibOptions)[instantiateIndex] as! Self
    }
}

extension UIView {
    func screenShot(width: CGFloat) -> UIImage? {
        let imageBounds = CGRect(x: 0, y: 0, width: width, height: bounds.size.height * (width / bounds.size.width))
        
        UIGraphicsBeginImageContextWithOptions(imageBounds.size, true, 0)
        
        drawHierarchy(in: imageBounds, afterScreenUpdates: true)
        
        var image: UIImage?
        let contextImage = UIGraphicsGetImageFromCurrentImageContext()
        
        if let contextImage = contextImage, let cgImage = contextImage.cgImage {
            image = UIImage(
                cgImage: cgImage,
                scale: UIScreen.main.scale,
                orientation: contextImage.imageOrientation
            )
        }
        
        UIGraphicsEndImageContext()
        
        return image
    }
}

public protocol EmbeddedNibInstantiatable {
    associatedtype Embedded: NibInstantiatable
}

public extension EmbeddedNibInstantiatable where Self: UIView, Embedded: UIView {
    public var embedded: Embedded { return subviews[0] as! Embedded }
    
    public func configureEmbededView() {
        let view = Embedded.instantiate()
        insertSubview(view, at: 0)
        view.fillSuperview()
    }
}


public extension UIView {
    public func fillSuperview() {
        guard let superview = self.superview else { return }
        translatesAutoresizingMaskIntoConstraints = superview.translatesAutoresizingMaskIntoConstraints
        if translatesAutoresizingMaskIntoConstraints {
            autoresizingMask = [.flexibleWidth, .flexibleHeight]
            frame = superview.bounds
        } else {
            topAnchor.constraint(equalTo: superview.topAnchor).isActive = true
            bottomAnchor.constraint(equalTo: superview.bottomAnchor).isActive = true
            leftAnchor.constraint(equalTo: superview.leftAnchor).isActive = true
            rightAnchor.constraint(equalTo: superview.rightAnchor).isActive = true
        }
    }
}

public extension UIView {
    public var viewController: UIViewController? {
        var parent: UIResponder? = self
        while parent != nil {
            parent = parent?.next
            if let viewController = parent as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}



enum FadeType: TimeInterval {
    case
    Normal = 0.3,
    Slow = 1.0
}


extension UIView {
    func fadeIn(type: FadeType = .Normal, completed: (() -> ())? = nil) {
        fadeIn(duration: type.rawValue, completed: completed)
    }
    
    /** For typical purpose, use "public func fadeIn(type: FadeType = .Normal, completed: (() -> ())? = nil)" instead of this */
    func fadeIn(duration: TimeInterval = FadeType.Slow.rawValue, completed: (() -> ())? = nil) {
        alpha = 0
        isHidden = false
        UIView.animate(withDuration: duration,
                                   animations: {
                                    self.alpha = 1
        }) { finished in
            completed?()
        }
    }
    func fadeOut(type: FadeType = .Normal, completed: (() -> ())? = nil) {
        fadeOut(duration: type.rawValue, completed: completed)
    }
    /** For typical purpose, use "public func fadeOut(type: FadeType = .Normal, completed: (() -> ())? = nil)" instead of this */
    func fadeOut(duration: TimeInterval = FadeType.Slow.rawValue, completed: (() -> ())? = nil) {
        UIView.animate(withDuration: duration
            , animations: {
                self.alpha = 0
        }) { [weak self] finished in
            self?.isHidden = true
            self?.alpha = 1
            completed?()
        }
    }
}

extension UIView {
    
    var top : CGFloat{
        get{
            return self.frame.origin.y
        }
        set{
            var frame       = self.frame
            frame.origin.y  = newValue
            self.frame      = frame
        }
    }
    
    var bottom : CGFloat{
        get{
            return frame.origin.y + frame.size.height
        }
        set{
            var frame       = self.frame
            frame.origin.y  = newValue - self.frame.size.height
            self.frame      = frame
        }
    }
    
    var right : CGFloat{
        get{
            return self.frame.origin.x + self.frame.size.width
        }
        set{
            var frame       = self.frame
            frame.origin.x  = newValue - self.frame.size.width
            self.frame      = frame
        }
    }
    
    var left : CGFloat{
        get{
            return self.frame.origin.x
        }
        set{
            var frame       = self.frame
            frame.origin.x  = newValue
            self.frame      = frame
        }
    }
}

public protocol Appliable {}

public extension Appliable {
    @discardableResult
    public func apply(closure: (Self) -> Void) -> Self {
        closure(self)
        return self
    }
}

public protocol Runnable {}

public extension Runnable {
    @discardableResult
    public func run<T>(closure: (Self) -> T) -> T {
        return closure(self)
    }
}

extension NSObject: Appliable {}
extension NSObject: Runnable {}
