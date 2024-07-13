//
//  CustomTabBar.swift
//  CustomTabbarController
//
//  Created by Arpit iOS Dev. on 13/07/24.
//

import UIKit

class CustomTabBar: UITabBar {
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var sizeThatFits = super.sizeThatFits(size)
        sizeThatFits.height = 65
        return sizeThatFits
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var frame = self.frame
        frame.origin.y = self.superview!.frame.height - frame.height - 32.5
        frame.origin.x = 17
        frame.size.width = self.superview!.frame.width - 35
        self.frame = frame
        
        applyGradient(colors: [UIColor(red: 1, green: 0.47, blue: 0.38, alpha: 1).cgColor, UIColor(red: 1, green: 0.3, blue: 0.3, alpha: 1).cgColor])
        
        roundCorners(corners: [.topLeft, .topRight, .bottomLeft, .bottomRight], radius: 30)
    }
    
    func applyGradient(colors: [CGColor]) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.frame = bounds
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    func applyCircleToTabBarItem(view: UIView, inset: CGFloat = 10) {
        let circleLayer = CALayer()
        circleLayer.backgroundColor = UIColor.white.cgColor
        circleLayer.bounds = CGRect(x: 0, y: 0, width: view.bounds.height - inset, height: view.bounds.height - inset)
        circleLayer.position = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
        circleLayer.cornerRadius = (view.bounds.height - inset) / 2
        view.layer.insertSublayer(circleLayer, at: 0)
    }
}

extension UITabBar {
    func setItemColors(defaultColor: UIColor, selectedColor: UIColor) {
        self.unselectedItemTintColor = defaultColor
        self.tintColor = selectedColor
    }
}

class CustomTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tabBar = self.tabBar as! CustomTabBar
        tabBar.setItemColors(defaultColor: .white, selectedColor: UIColor(red: 1, green: 0.3, blue: 0.3, alpha: 1))
        self.delegate = self
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let items = tabBar.items else { return }
        
        for (index, tabBarItem) in items.enumerated() {
            if tabBarItem == item {
                let tabBarItemView = tabBar.subviews[index + 1]
                removeCircle(from: tabBarItemView)
                (tabBar as! CustomTabBar).applyCircleToTabBarItem(view: tabBarItemView)
            } else {
                let tabBarItemView = tabBar.subviews[index + 1]
                removeCircle(from: tabBarItemView)
            }
        }
    }
    
    private func removeCircle(from view: UIView) {
        view.layer.sublayers?.forEach {
            if $0.backgroundColor == UIColor.white.cgColor && $0.cornerRadius == (view.bounds.height - 10) / 2 {
                $0.removeFromSuperlayer()
            }
        }
    }
}
