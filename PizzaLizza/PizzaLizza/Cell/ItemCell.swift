//
//  ItemCell.swift
//  PizzaLizza
//
//  Created by Muhammad Ziddan Hidayatullah on 10/11/22.
//

import UIKit

class ItemCell: UITableViewCell {

    static let identifier = "ItemCell"
    
    private let mainLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        
        return label
    }()
    private let secondaryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.textAlignment = .right
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(mainLabel)
        contentView.addSubview(secondaryLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func mainConfigure(mainText: String, secondaryText: String) {
        mainLabel.text = "\(mainText) pizza"
        secondaryLabel.text = secondaryText
    }
    
    public func cartConfigure(mainText: String, secondaryText: String, count: Int) {
        mainLabel.text = "\(mainText) pizza (\(count))"
        secondaryLabel.text = secondaryText
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        mainLabel.text = nil
        secondaryLabel.text = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        mainLabel.frame = CGRect(x: 10,
                                 y: 0,
                                 width: 200,
                                 height: contentView.frame.size.height)
        secondaryLabel.frame = CGRect(x: contentView.frame.maxX - 10,
                                      y: 0,
                                      width: -(contentView.frame.size.width - 5 - mainLabel.frame.width),
                                      height: contentView.frame.size.height)
    }
    
}
