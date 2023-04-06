//
//  TableViewCell.swift
//  RxNetworkKit
//
//  Created by Loay Ashraf on 01/04/2023.
//

import UIKit

class TableViewCell: UITableViewCell {
    @IBOutlet weak var customTextLabel: UILabel!
    @IBOutlet weak var customImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        customImageView.layer.cornerRadius = 50.0
        customImageView.layer.cornerCurve = .continuous
    }
}
