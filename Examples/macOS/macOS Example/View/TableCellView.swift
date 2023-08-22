//
//  TableCellView.swift
//  RxNetworkKit
//
//  Created by Loay Ashraf on 01/04/2023.
//

import Cocoa

class TableCellView: NSTableCellView {
    @IBOutlet weak var customTextField: NSTextField!
    @IBOutlet weak var customImageView: NSImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        customImageView.wantsLayer = true
        customImageView.layer?.cornerRadius = 50.0
        customImageView.layer?.cornerCurve = .continuous
    }
}
