//
//  ViewController.swift
//  Instagrid
//
//  Created by Guillaume Ramey on 28/10/2018.
//  Copyright © 2018 Guillaume Ramey. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var buttonLayout1: UIButton!
    @IBOutlet weak var buttonLayout2: UIButton!
    @IBOutlet weak var buttonLayout3: UIButton!
    @IBOutlet weak var gridRow1: UIStackView!
    @IBOutlet weak var gridRow2: UIStackView!
    @IBOutlet weak var gridRow3: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout = .layout2
    }
    
    enum Layout {
        case layout1, layout2, layout3
    }
    
    var layout: Layout = .layout2 {
        didSet {
            setLayout(layout)
        }
    }
    
    @IBAction func buttonLayout1(_ sender: Any) {
        layout = .layout1
    }
    
    @IBAction func buttonLayout2(_ sender: Any) {
        layout = .layout2
    }
    
    @IBAction func buttonLayout3(_ sender: Any) {
        layout = .layout3
    }
    
    func setLayout(_ layout: Layout) {
        switch layout {
        case .layout1:
            buttonLayout1.setImage(UIImage(named: "Button Selected.png"), for: .normal)
            buttonLayout2.setImage(UIImage(named: ""), for: .normal)
            buttonLayout3.setImage(UIImage(named: "B"), for: .normal)
            gridRow1.isHidden = true
            gridRow2.isHidden = false
            gridRow3.isHidden = false
        case .layout2:
            buttonLayout1.setImage(UIImage(named: ""), for: .normal)
            buttonLayout2.setImage(UIImage(named: "Button Selected.png"), for: .normal)
            buttonLayout3.setImage(UIImage(named: ""), for: .normal)
            gridRow1.isHidden = false
            gridRow2.isHidden = false
            gridRow3.isHidden = true
        case .layout3:
            buttonLayout1.setImage(UIImage(named: ""), for: .normal)
            buttonLayout2.setImage(UIImage(named: ""), for: .normal)
            buttonLayout3.setImage(UIImage(named: "Button Selected.png"), for: .normal)
            gridRow1.isHidden = false
            gridRow2.isHidden = true
            gridRow3.isHidden = false
        }
    }
 
}

