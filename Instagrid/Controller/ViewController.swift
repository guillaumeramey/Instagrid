//
//  ViewController.swift
//  Instagrid
//
//  Created by Guillaume Ramey on 28/10/2018.
//  Copyright © 2018 Guillaume Ramey. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var gridRow1: UIStackView!
    @IBOutlet weak var gridRow2: UIStackView!
    @IBOutlet weak var gridRow3: UIStackView!
    
    var imagePicker = UIImagePickerController()
    var imagePicked = 0
    
    @IBOutlet weak var buttonImage1: UIButton!
    @IBAction func tapButtonImage1(_ sender: UIButton) {
        imagePicked = sender.tag
        self.present(imagePicker, animated: true)
    }
    
    @IBOutlet weak var buttonImage2: UIButton!
    @IBAction func tapButtonImage2(_ sender: UIButton) {
        imagePicked = sender.tag
        self.present(imagePicker, animated: true)
    }
    
    @IBOutlet weak var buttonImage3: UIButton!
    @IBAction func tapButtonImage3(_ sender: UIButton) {
        imagePicked = sender.tag
        self.present(imagePicker, animated: true)
    }
    
    @IBOutlet weak var buttonImage4: UIButton!
    @IBAction func tapButtonImage4(_ sender: UIButton) {
        imagePicked = sender.tag
        self.present(imagePicker, animated: true)
    }
    
    @IBOutlet weak var buttonImage5: UIButton!
    @IBAction func tapButtonImage5(_ sender: UIButton) {
        imagePicked = sender.tag
        self.present(imagePicker, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout = .layout2
        imagePicker.delegate = self
        imagePicker.sourceType = .savedPhotosAlbum
        imagePicker.allowsEditing = false
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        
        switch imagePicked {
        case 1:
            buttonImage1.setImage(pickedImage, for: .normal)
        case 2:
            buttonImage2.setImage(pickedImage, for: .normal)
        case 3:
            buttonImage3.setImage(pickedImage, for: .normal)
        case 4:
            buttonImage4.setImage(pickedImage, for: .normal)
        case 5:
            buttonImage5.setImage(pickedImage, for: .normal)
        default:
            break
        }
        
        dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
    enum Layout {
        case layout1, layout2, layout3
    }
    
    var layout: Layout = .layout2 {
        didSet {
            setLayout(layout)
        }
    }
    
    @IBOutlet weak var buttonLayout1: UIButton!
    @IBAction func tapButtonLayout1(_ sender: Any) {
        layout = .layout1
    }
    
    @IBOutlet weak var buttonLayout2: UIButton!
    @IBAction func tapButtonLayout2(_ sender: Any) {
        layout = .layout2
    }
    
    @IBOutlet weak var buttonLayout3: UIButton!
    @IBAction func tapButtonLayout3(_ sender: Any) {
        layout = .layout3
    }
    
    func setLayout(_ layout: Layout) {
        switch layout {
        case .layout1:
            buttonLayout1.setImage(UIImage(named: "Button Selected.png"), for: .normal)
            buttonLayout2.setImage(UIImage(named: ""), for: .normal)
            buttonLayout3.setImage(UIImage(named: ""), for: .normal)
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

