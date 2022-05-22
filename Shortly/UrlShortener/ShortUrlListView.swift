//
//  ShortUrlListView.swift
//  Shortly
//
//  Created by Abdullah Muhammad Zubair on 2/26/22.
//

import UIKit

class ShortUrlListView: UIView {

    lazy var shortUrlTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        return tableView
    }()
    
    
    init() {
        super.init(frame: .zero)
        backgroundColor = Theme.bgPrimaryColor
        addSubviews()
        setUpConstraints()
        setUpViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        let subviews = [shortUrlTableView]
        
        subviews.forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            shortUrlTableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            shortUrlTableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            shortUrlTableView.topAnchor.constraint(equalTo: topAnchor, constant: 50),
            shortUrlTableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func setUpViews() {
        backgroundColor = Theme.bgPrimaryColor
    }
}
