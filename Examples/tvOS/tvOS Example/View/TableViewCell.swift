//
//  TableViewCell.swift
//  tvOS Example
//
//  Created by Loay Ashraf on 10/01/2024.
//

import UIKit

class TableViewCell: UITableViewCell {
    @IBOutlet weak var customTextLabel: UILabel!
    @IBOutlet weak var customImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        customImageView.layer.cornerRadius = 150.0
        customImageView.layer.cornerCurve = .continuous
    }
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        super.didUpdateFocus(in: context, with: coordinator)
        if context.nextFocusedView == self {
            customTextLabel.textColor = .black
        } else {
            customTextLabel.textColor = .white
        }
    }
}
