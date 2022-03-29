//
//  FlightsViewCell.swift
//  TabBar App
//
//  Created by Fabri on 2021/07/29.
//

import UIKit

class FlightsViewCell: UITableViewCell {

    var nameLabel = UILabel()
    var detailLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.selectionStyle = .none
        let frame = CGRect(x: 12, y: 0, width: UIScreen.main.bounds.size.width, height: self.frame.size.height)
        let boxView = UIView(frame: frame)
        self.contentView.backgroundColor = UIColor.clear
        boxView.backgroundColor = .white
        self.contentView.addSubview(boxView)
        boxView.layer.cornerRadius = 2.0

        nameLabel = UILabel(frame: CGRect(x: 12, y: 0, width: boxView.frame.size.width, height: 40) )
        boxView.addSubview(nameLabel)
        nameLabel.textColor = UIColor.black
        nameLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)

        detailLabel = UILabel(frame: CGRect(x: 12, y: 30, width: boxView.frame.size.width, height: 30))
        boxView.addSubview(detailLabel)
        detailLabel.textColor = UIColor.gray

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
