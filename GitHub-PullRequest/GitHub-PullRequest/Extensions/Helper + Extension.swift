//
//  Helper.swift
//  GitHub-PullRequest
//
//  Created by Monish Kumar on 25/01/23.
//

import Foundation
import UIKit

enum TxtType {
    case create
    case update
}

class Helper {
    static func formatDate(date: String) -> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ssX"
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMM d, yyyy"
        if let date = dateFormatterGet.date(from: date) {
            return dateFormatterPrint.string(from: date)
        } else {
            return "---"
        }
    }

    static func attributedDate(text: String, type: TxtType) -> NSMutableAttributedString {
        let firstAttribute = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        let secondAttribute = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.darkGray]
        var attributedString1: NSMutableAttributedString!
        if type == .create {
            attributedString1 = NSMutableAttributedString(string: "Created at \n", attributes: firstAttribute)
        } else {
            attributedString1 = NSMutableAttributedString(string: "Updated at \n", attributes: firstAttribute)
        }
        let attributedString2 = NSMutableAttributedString(string: "\(Helper.formatDate(date: text))", attributes: secondAttribute)
        attributedString1.append(attributedString2)
        return attributedString1
    }

    static func makeLabel(line: Int? = nil, fontFamily: UIFont, textColor: UIColor? = nil, align: NSTextAlignment? = nil) -> UILabel {
        let label = UILabel()
        label.font = fontFamily
        label.textColor = textColor
        label.textAlignment = align ?? .natural
        label.numberOfLines = line ?? 1
        label.translatesAutoresizingMaskIntoConstraints = false // Enable Autolayout
        return label
    }

    static func makeUIView(color: UIColor? = nil, cornerRadius: CGFloat = 0) -> UIView {
        let view = UIView()
        view.backgroundColor = color ?? .white
        view.layer.cornerRadius = cornerRadius
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }

    static func makeStackView(axis: NSLayoutConstraint.Axis, distribution: UIStackView.Distribution, alignment: UIStackView.Alignment, color: UIColor? = nil, value: CGFloat? = nil) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = axis
        stackView.backgroundColor = color ?? .white
        stackView.alignment = alignment
        stackView.distribution = distribution
        stackView.spacing = value ?? 0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }

    static func makeImageView(cornerRadius: CGFloat? = nil, color: UIColor = .clear) -> UIImageView {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = cornerRadius ?? 0
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = color
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }
}
