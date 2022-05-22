//
//  ShortUrlTableViewCell.swift
//  Shortly
//
//  Created by Abdullah Muhammad Zubair on 2/28/22.
//

import UIKit

class ShortUrlTableViewCell: UITableViewCell {

    private enum Constants {
        // MARK: contentView layout constants
        static let contentViewCornerRadius: CGFloat = 4.0
        
        // MARK: imageView layout constants
        static let fullUrlHeight: CGFloat = 22.0
        static let shortUrlHeight: CGFloat = 22.0
        static let deleteHeight: CGFloat = 18.0
        static let deleteWidth: CGFloat = 14.0
        static let copyHeight: CGFloat = 43.0
        
        // MARK: Generic layout constants
        static let verticalSpacing: CGFloat = 23
        static let horizontalPadding: CGFloat = 23
        static let profileDescriptionVerticalPadding: CGFloat = 0
    }
    
    static let identifier = "ShortUrlTableViewCell"
    typealias OnClick = (() -> Void)

    var viewModel: ShortUrlCellViewModel? {
        didSet { setUpViewModel() }
    }
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = Constants.contentViewCornerRadius
        return view
    }()
    
    lazy var fullUrl: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .left
        label.textColor = Theme.textColor
        label.font = UIFont(name: "Poppins-SemiBold", size: 17)
        return label
    }()
    
    lazy var separator: UILabel = {
        let label = UILabel(frame: .zero)
        label.backgroundColor = .lightGray
        return label
    }()
    
    lazy var shortUrl: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .left
        label.textColor = Theme.buttonBgColor
        label.font = UIFont(name: "Poppins-SemiBold", size: 17)
        return label
    }()
    
    lazy var delete: UIButton = {
        let button = UIButton(frame: .zero)
        button.setBackgroundImage(UIImage(named: "del"), for: .normal)
        return button
    }()
    
    lazy var copy: UIButton = {
        let button = UIButton(frame: .zero)
        button.titleLabel?.textAlignment = .center
        button.backgroundColor = Theme.buttonBgColor
        button.layer.cornerRadius = Constants.contentViewCornerRadius
        button.setTitleColor(.white, for: .normal)
        button.setTitle("COPY", for: .normal)
        button.titleLabel?.font = UIFont(name: "Poppins-Bold", size: 17)
        return button
    }()
    
    var onDelete: OnClick?
    var onCopy: OnClick?

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubiews()
        setUpConstraints()
        setUpTargets()
    }
    
    init(style: UITableViewCell.CellStyle, reuseIdentifier: String?, customString: String) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubiews() {
        let subviews = [containerView, fullUrl, shortUrl, separator, delete, copy]
        contentView.layer.cornerRadius = Constants.contentViewCornerRadius
        contentView.layer.masksToBounds = true
        contentView.clipsToBounds = true
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        
        subviews.forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func setUpConstraints() {
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.horizontalPadding),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.horizontalPadding),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.verticalSpacing/2),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.verticalSpacing/2),
        ])
                
        NSLayoutConstraint.activate([
            fullUrl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 2 * Constants.horizontalPadding),
            fullUrl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -2 * 1.75 * Constants.horizontalPadding),
            fullUrl.topAnchor.constraint(equalTo: contentView.topAnchor, constant:  1.55 * Constants.verticalSpacing)
        ])
        
        NSLayoutConstraint.activate([
            delete.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -2 * Constants.horizontalPadding),
            delete.topAnchor.constraint(equalTo: contentView.topAnchor, constant:  1.55 * Constants.verticalSpacing),
            delete.heightAnchor.constraint(equalToConstant: Constants.deleteHeight),
            delete.widthAnchor.constraint(equalToConstant: Constants.deleteWidth)
        ])
        
        NSLayoutConstraint.activate([
            separator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.horizontalPadding),
            separator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.horizontalPadding),
            separator.topAnchor.constraint(equalTo: fullUrl.bottomAnchor, constant: 12),
            separator.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        NSLayoutConstraint.activate([
            shortUrl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 2 * Constants.horizontalPadding),
            shortUrl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -2 * Constants.horizontalPadding),
            shortUrl.topAnchor.constraint(equalTo: separator.bottomAnchor, constant: 12)
        ])
        
        NSLayoutConstraint.activate([
            copy.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 2 *  Constants.horizontalPadding),
            copy.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -2 * Constants.horizontalPadding),
            copy.topAnchor.constraint(equalTo: shortUrl.bottomAnchor, constant: 25),
            copy.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40),
            copy.heightAnchor.constraint(equalToConstant: Constants.copyHeight)
        ])
    }
    
    private func setUpTargets() {
        delete.addTarget(self, action: #selector(deleteAction), for: .touchUpInside)
        copy.addTarget(self, action: #selector(copyAction), for: .touchUpInside)
    }
    
    @objc private func deleteAction() {
        onDelete?()
    }
    
    @objc private func copyAction() {
        onCopy?()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setUpViewModel() {
        shortUrl.text = viewModel?.shortLink
        fullUrl.text = viewModel?.fullUrl
        updateCopidState(isSelected: viewModel?.isSelected ?? false)
    }
    
    func updateCopidState(isSelected: Bool)
    {
        copy.setTitle(isSelected ? "COPIED!" : "COPY", for: .normal)
        copy.backgroundColor = isSelected ? Theme.bgSecondaryColor : Theme.buttonBgColor
    }

}
