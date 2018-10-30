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
    @IBOutlet weak var buttonLayout1: UIButton!
    @IBOutlet weak var buttonLayout2: UIButton!
    @IBOutlet weak var buttonLayout3: UIButton!
    @IBOutlet weak var buttonImage1: UIButton!
    @IBOutlet weak var buttonImage2: UIButton!
    @IBOutlet weak var buttonImage3: UIButton!
    @IBOutlet weak var buttonImage4: UIButton!
    @IBOutlet weak var buttonImage5: UIButton!

    @IBAction func tapButtonLayout1(_ sender: Any) {
        setLayout(1)
    }
    @IBAction func tapButtonLayout2(_ sender: Any) {
        setLayout(2)
    }
    @IBAction func tapButtonLayout3(_ sender: Any) {
        setLayout(3)
    }
    @IBAction func tapButtonImage1(_ sender: UIButton) {
        buttonSender = buttonImage1
        self.present(imagePicker, animated: true)
    }
    @IBAction func tapButtonImage2(_ sender: UIButton) {
        buttonSender = buttonImage2
        self.present(imagePicker, animated: true)
    }
    @IBAction func tapButtonImage3(_ sender: UIButton) {
        buttonSender = buttonImage3
        self.present(imagePicker, animated: true)
    }
    @IBAction func tapButtonImage4(_ sender: UIButton) {
        buttonSender = buttonImage4
        self.present(imagePicker, animated: true)
    }
    @IBAction func tapButtonImage5(_ sender: UIButton) {
        buttonSender = buttonImage5
        self.present(imagePicker, animated: true)
    }
    
    var imagePicker = UIImagePickerController()
    var buttonSender: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout(2)
        imagePicker.delegate = self
        imagePicker.sourceType = .savedPhotosAlbum
        imagePicker.allowsEditing = false
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        buttonSender.setImage(pickedImage, for: .normal)
        buttonSender.imageView?.contentMode = UIView.ContentMode.scaleAspectFill
        buttonSender.backgroundColor = #colorLiteral(red: 0.06274509804, green: 0.4, blue: 0.5960784314, alpha: 1)
        dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
    func setLayout(_ layout: Int) {
        switch layout {
        case 1:
            selectButtonLayout(buttonLayout1)
            showRow(gridRow2)
            showRow(gridRow3)
            hideRow(gridRow1)
        case 2:
            selectButtonLayout(buttonLayout2)
            showRow(gridRow1)
            showRow(gridRow2)
            hideRow(gridRow3)
        case 3:
            selectButtonLayout(buttonLayout3)
            showRow(gridRow1)
            showRow(gridRow3)
            hideRow(gridRow2)
        default:
            break
        }
    }
    
    func selectButtonLayout(_ buttonLayout: UIButton) {
        buttonLayout1.setImage(UIImage(named: ""), for: .normal)
        buttonLayout2.setImage(UIImage(named: ""), for: .normal)
        buttonLayout3.setImage(UIImage(named: ""), for: .normal)
        buttonLayout.setImage(UIImage(named: "Button Selected.png"), for: .normal)
    }
    
    func showRow(_ row: UIStackView) {
        if row.isHidden {
            UIView.transition(with: gridRow1, duration: 0.5, options: .transitionCrossDissolve, animations: {
                row.isHidden = false
            }, completion: nil)
        }
    }
    
    func hideRow(_ row: UIStackView) {
        if !row.isHidden {
            UIView.transition(with: gridRow1, duration: 0.5, options: .transitionCrossDissolve, animations: {
                row.isHidden = true
            }, completion: nil)
        }
    }
}

