//
//  UIView + Extension.swift
//  GitHub-PullRequest
//
//  Created by Monish Kumar on 24/01/23.
//

import Foundation
import UIKit

extension UIViewController {
    func showAlert(_ message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension UIView {
    func applyShadow(cornerRadius: CGFloat) {
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = false
        layer.shadowRadius = 3
        layer.shadowOpacity = 0.30
        layer.shadowColor = UIColor.darkGray.cgColor
        layer.shadowOffset = CGSize(width: .zero, height: 5)
    }

    @discardableResult
    func leadingSpace(with: Any? = nil, constant: CGFloat = 0, priority: UILayoutPriority = .required) -> UIView {
        guard let view = getView(with) else {
            return self
        }
        let constraint = leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: constant)
        constraint.isActive = true
        constraint.priority = priority
        return self
    }

    @discardableResult
    func trailingSpace(with: Any? = nil, constant: CGFloat = 0, priority: UILayoutPriority = .required) -> UIView {
        guard let view = getView(with) else {
            return self
        }
        let constraint = trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: constant)
        constraint.isActive = true
        constraint.priority = priority
        return self
    }

    @discardableResult
    func topSpace(with: Any? = nil, constant: CGFloat = 0, priority: UILayoutPriority = .required) -> UIView {
        guard let view = getView(with) else {
            return self
        }
        let constraint = topAnchor.constraint(equalTo: view.topAnchor, constant: constant)
        constraint.isActive = true
        constraint.priority = priority
        return self
    }

    @discardableResult
    func bottomSpace(with: Any? = nil, constant: CGFloat = 0, priority: UILayoutPriority = .required) -> UIView {
        guard let view = getView(with) else {
            return self
        }
        let constraint = bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: constant)
        constraint.isActive = true
        constraint.priority = priority
        return self
    }

    @discardableResult
    func widthConstraint(constant: CGFloat, priority: UILayoutPriority = .required) -> UIView {
        let constraint = widthAnchor.constraint(equalToConstant: constant)
        constraint.isActive = true
        constraint.priority = priority
        return self
    }

    @discardableResult
    func heightConstraint(constant: CGFloat, priority: UILayoutPriority = .required) -> UIView {
        let constraint = heightAnchor.constraint(equalToConstant: constant)
        constraint.isActive = true
        constraint.priority = priority
        return self
    }

    @discardableResult
    func horizontalSpacing(with: Any? = nil, constant: CGFloat = 0, priority: UILayoutPriority = .required) -> UIView {
        guard let _ = getView(with) else {
            return self
        }
        return leadingSpace(constant: constant, priority: priority).trailingSpace(constant: -constant, priority: priority)
    }

    @discardableResult
    func verticalSpacing(with: Any? = nil, constant: CGFloat = 0, priority: UILayoutPriority = .required) -> UIView {
        guard let _ = getView(with) else {
            return self
        }
        return topSpace(constant: constant, priority: priority).bottomSpace(constant: -constant, priority: priority)
    }

    @discardableResult
    func spaceAround(with: Any? = nil, constant: CGFloat = 0, priority: UILayoutPriority = .required) -> UIView {
        guard let _ = getView(with) else {
            return self
        }
        translatesAutoresizingMaskIntoConstraints = false
        return topSpace(constant: constant, priority: priority).bottomSpace(constant: -constant, priority: priority).leadingSpace(constant: constant, priority: priority).trailingSpace(constant: -constant, priority: priority)
    }

    @discardableResult
    func getView(_ with: Any?) -> UIView? {
        if let view = with as? UIView {
            return view
        } else {
            return superview
        }
    }
}

extension UIView {
    // ->1
    enum Direction: Int {
        case topToBottom = 0
        case bottomToTop
        case leftToRight
        case rightToLeft
    }

    func startShimmeringAnimation(animationSpeed: Float = 1.4,
                                  direction: Direction = .leftToRight,
                                  repeatCount: Float = MAXFLOAT) {
        // Create color  ->2
        let lightColor = UIColor(displayP3Red: 1.0, green: 1.0, blue: 1.0, alpha: 0.1).cgColor
        let blackColor = UIColor.black.cgColor

        // Create a CAGradientLayer  ->3
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [blackColor, lightColor, blackColor]
        gradientLayer.frame = CGRect(x: -bounds.size.width, y: -bounds.size.height, width: 3 * bounds.size.width, height: 3 * bounds.size.height)

        switch direction {
        case .topToBottom:
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)

        case .bottomToTop:
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)

        case .leftToRight:
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)

        case .rightToLeft:
            gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.5)
        }

        gradientLayer.locations = [0.35, 0.50, 0.65] // [0.4, 0.6]
        layer.mask = gradientLayer

        // Add animation over gradient Layer  ->4
        CATransaction.begin()
        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [0.0, 0.1, 0.2]
        animation.toValue = [0.8, 0.9, 1.0]
        animation.duration = CFTimeInterval(animationSpeed)
        animation.repeatCount = repeatCount
        CATransaction.setCompletionBlock { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.layer.mask = nil
        }
        gradientLayer.add(animation, forKey: "shimmerAnimation")
        CATransaction.commit()
    }

    func stopShimmeringAnimation() {
        layer.mask = nil
    }
}
