//
//  UrlEntryView.swift
//  Shortly
//
//  Created by Abdullah Muhammad Zubair on 2/26/22.
//

import UIKit

class UrlEntryView: UIView {
    
    private enum Constants {
        // MARK: Generic layout constants
        static let verticalSpacing: CGFloat = 46
        static let horizontalPadding: CGFloat = 48
        static let profileDescriptionVerticalPadding: CGFloat = 0
        static let contentViewCornerRadius: CGFloat = 5.0
    }
    
    lazy var urlTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .white
        textField.placeholder = "Shorten a link here ..."
        textField.placeHolderColor = UIColor.lightGray
        textField.font = UIFont(name: "Poppins-SemiBold", size: 17) 
        textField.textAlignment = .center
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.layer.cornerRadius = Constants.contentViewCornerRadius
        return textField
    }()
    
    lazy var shortenButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = Theme.buttonBgColor
        button.setTitle("SHORTEN IT!", for: .normal)
        button.titleLabel?.font = UIFont(name: "Poppins-Bold", size: 20)
        button.titleLabel?.textAlignment = .center
        button.layer.cornerRadius = Constants.contentViewCornerRadius
        return button
    }()
    
    lazy var bgImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .topRight
        imageView.image = UIImage(named: "shape")
        return imageView
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [urlTextField, shortenButton])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        return stackView
    }()

    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        backgroundColor = Theme.bgSecondaryColor
        addSubiews()
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubiews() {
        let subviews = [bgImageView, stackView]
        
        subviews.forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func setUpConstraints() {
        
        // Layout constraints for `bgImageView`
        NSLayoutConstraint.activate([
            bgImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bgImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            bgImageView.topAnchor.constraint(equalTo: topAnchor),
            bgImageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        // Layout constraints for `stackView`
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.horizontalPadding),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.horizontalPadding),
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: Constants.verticalSpacing),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.verticalSpacing - 10.0)
        ])
    }

}
