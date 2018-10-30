//
//  ViewController.swift
//  Instagrid
//
//  Created by Guillaume Ramey on 28/10/2018.
//  Copyright © 2018 Guillaume Ramey. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var gridView: UIView!
    @IBOutlet weak var buttonLayout1: UIButton!
    @IBOutlet weak var buttonLayout2: UIButton!
    @IBOutlet weak var buttonLayout3: UIButton!
    @IBOutlet weak var buttonImage1: UIButton!
    @IBOutlet weak var buttonImage2: UIButton!
    @IBOutlet weak var buttonImage3: UIButton!
    @IBOutlet weak var buttonImage4: UIButton!

    var imagePicker = UIImagePickerController()
    var buttonSender: UIButton!
    
    // Layout buttons selection
    @IBAction func tapButtonLayout1(_ sender: Any) {
        setLayout(1)
    }
    @IBAction func tapButtonLayout2(_ sender: Any) {
        setLayout(2)
    }
    @IBAction func tapButtonLayout3(_ sender: Any) {
        setLayout(3)
    }
    
    // Image buttons selection
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout(2)
        imagePicker.delegate = self
        imagePicker.sourceType = .savedPhotosAlbum
        imagePicker.allowsEditing = false
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(dragGridView(_:)))
        gridView.addGestureRecognizer(panGestureRecognizer)
    }
    
    // allows the user to select an image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        buttonSender.setImage(pickedImage, for: .normal)
        buttonSender.imageView?.contentMode = UIView.ContentMode.scaleAspectFill
        dismiss(animated: true)
    }
    
    // canceling the image picker
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
    // sets the grid layout
    func setLayout(_ layout: Int) {
        switch layout {
        case 1:
            selectButtonLayout(buttonLayout1)
            hideButton(buttonImage2)
            showButton(buttonImage4)
        case 2:
            selectButtonLayout(buttonLayout2)
            showButton(buttonImage2)
            hideButton(buttonImage4)
        case 3:
            selectButtonLayout(buttonLayout3)
            showButton(buttonImage2)
            showButton(buttonImage4)
        default:
            break
        }
    }
    
    // selects the current layout button
    func selectButtonLayout(_ buttonLayout: UIButton) {
        buttonLayout1.setImage(UIImage(named: ""), for: .normal)
        buttonLayout2.setImage(UIImage(named: ""), for: .normal)
        buttonLayout3.setImage(UIImage(named: ""), for: .normal)
        buttonLayout.setImage(UIImage(named: "Button Selected.png"), for: .normal)
    }

    // shows the button image
    func showButton(_ button: UIButton) {
        UIView.transition(with: button, duration: 0.4, options: .transitionCrossDissolve, animations: {
            button.isHidden = false
        }, completion: nil)
    }
    
    // hides the button image
    func hideButton(_ button: UIButton) {
        UIView.transition(with: button, duration: 0.4, options: .transitionCrossDissolve, animations: {
            button.isHidden = true
        }, completion: nil)
    }
    
    @objc func dragGridView(_ sender: UIPanGestureRecognizer){
        switch sender.state {
        case .began, .changed : // suis le geste
            transformGridView(gesture: sender)
            /*
        case .ended, .cancelled : // répond à la question
            answerQuestion()
 */
        default:
            break
        }
    }
    
    private func transformGridView(gesture: UIPanGestureRecognizer){
        let translation = gesture.translation(in: gridView)
        gridView.transform = CGAffineTransform(translationX: 0, y: translation.y)
    }
}

