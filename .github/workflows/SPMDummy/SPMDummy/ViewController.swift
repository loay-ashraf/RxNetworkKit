//
//  ViewController.swift
//  SPMDummy
//
//  Created by Loay Ashraf on 25/08/2023.
//

#if os(iOS)
import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}
#elseif os(macOS)
import AppKit
class ViewController: NSViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
}
#endif
