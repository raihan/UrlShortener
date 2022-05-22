//
//  NoShortUrlView.swift
//  Shortly
//
//  Created by Abdullah Muhammad Zubair on 2/26/22.
//

import UIKit

class NoShortUrlView: UIView {
    
    private enum Constants {
        // MARK: contentView layout constants
        static let contentViewCornerRadius: CGFloat = 4.0
        static let logoHeight: CGFloat = 35.0
        static let hederLabelHeight: CGFloat = 26.0
        static let detailLabelHeight: CGFloat = 44.0
        
        // MARK: Generic layout constants
        static let verticalSpacing: CGFloat = 10
        static let horizontalPadding: CGFloat = 10
    }
    
    lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "logo")
        return imageView
    }()
    
    lazy var bannerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "illustration")
        return imageView
    }()
    
    lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.text = "Let’s get started!"
        label.font = UIFont(name: "Poppins-Bold", size: 20)
        label.textAlignment = .center
        label.textColor = Theme.textColor
        return label
    }()
    
    lazy var detailsLabel: UILabel = {
        let label = UILabel()
        label.text = "Paste your first link into\nthe field to shorten it"
        label.font = UIFont(name: "Poppins-Normal", size: 17)
        label.numberOfLines = 2
        label.textAlignment = .center
        label.textColor = Theme.textColor
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        backgroundColor = Theme.bgPrimaryColor
        addSubiews()
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubiews() {
        let subviews = [logoImageView, bannerImageView, headerLabel, detailsLabel]
        
        subviews.forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            logoImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.horizontalPadding),
            logoImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: Constants.horizontalPadding),
            logoImageView.topAnchor.constraint(equalTo: topAnchor, constant: Constants.verticalSpacing + 60),
            logoImageView.heightAnchor.constraint(equalToConstant: Constants.logoHeight)
        ])
        
        NSLayoutConstraint.activate([
            bannerImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bannerImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            bannerImageView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: Constants.verticalSpacing)
        ])
        
        NSLayoutConstraint.activate([
            headerLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            headerLabel.topAnchor.constraint(equalTo: bannerImageView.bottomAnchor, constant: Constants.verticalSpacing),
            headerLabel.heightAnchor.constraint(equalToConstant: Constants.hederLabelHeight)
        ])
        
        NSLayoutConstraint.activate([
            detailsLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            detailsLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            detailsLabel.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: Constants.verticalSpacing),
            detailsLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.verticalSpacing - 60),
            detailsLabel.heightAnchor.constraint(equalToConstant: Constants.detailLabelHeight)
        ])
    }
    
}
