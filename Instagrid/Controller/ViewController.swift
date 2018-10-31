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
    @IBOutlet weak var buttonColor1: UIButton!
    @IBOutlet weak var buttonColor2: UIButton!
    @IBOutlet weak var buttonColor3: UIButton!
    @IBOutlet weak var buttonColor4: UIButton!
    @IBOutlet weak var buttonColor5: UIButton!
    @IBOutlet weak var buttonColor6: UIButton!
    @IBOutlet weak var buttonColor7: UIButton!
    @IBOutlet weak var buttonColor8: UIButton!
    
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
    @IBAction func tapButtonImage1(_ sender: Any) {
        buttonSender = buttonImage1
        self.present(imagePicker, animated: true)
    }
    @IBAction func tapButtonImage2(_ sender: Any) {
        buttonSender = buttonImage2
        self.present(imagePicker, animated: true)
    }
    @IBAction func tapButtonImage3(_ sender: Any) {
        buttonSender = buttonImage3
        self.present(imagePicker, animated: true)
    }
    @IBAction func tapButtonImage4(_ sender: Any) {
        buttonSender = buttonImage4
        self.present(imagePicker, animated: true)
    }
    
    // changes the background color
    @IBAction func tapbuttonColor1(_ sender: Any) {
        gridView.backgroundColor = buttonColor1.backgroundColor
    }
    @IBAction func tapbuttonColor2(_ sender: Any) {
        gridView.backgroundColor = buttonColor2.backgroundColor
    }
    @IBAction func tapbuttonColor3(_ sender: Any) {
        gridView.backgroundColor = buttonColor3.backgroundColor
    }
    @IBAction func tapbuttonColor4(_ sender: Any) {
        gridView.backgroundColor = buttonColor4.backgroundColor
    }
    @IBAction func tapbuttonColor5(_ sender: Any) {
        gridView.backgroundColor = buttonColor5.backgroundColor
    }
    @IBAction func tapbuttonColor6(_ sender: Any) {
        gridView.backgroundColor = buttonColor6.backgroundColor
    }
    @IBAction func tapbuttonColor7(_ sender: Any) {
        gridView.backgroundColor = buttonColor7.backgroundColor
    }
    @IBAction func tapbuttonColor8(_ sender: Any) {
        gridView.backgroundColor = buttonColor8.backgroundColor
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyRoundCorners(buttonColor1)
        applyRoundCorners(buttonColor2)
        applyRoundCorners(buttonColor2)
        applyRoundCorners(buttonColor3)
        applyRoundCorners(buttonColor4)
        applyRoundCorners(buttonColor5)
        applyRoundCorners(buttonColor6)
        applyRoundCorners(buttonColor7)
        applyRoundCorners(buttonColor8)
        setLayout(2)
        imagePicker.delegate = self
        imagePicker.sourceType = .savedPhotosAlbum
        imagePicker.allowsEditing = false
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(swipeGridView(_:)))
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
        buttonLayout1.setImage(nil, for: .normal)
        buttonLayout2.setImage(nil, for: .normal)
        buttonLayout3.setImage(nil, for: .normal)
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
    
    // swipe gesture
    @objc func swipeGridView(_ sender: UIPanGestureRecognizer){
        let translation = sender.translation(in: gridView)
        switch sender.state {
        case .began, .changed :
            if UIApplication.shared.statusBarOrientation == .portrait {
                if translation.y > 0 { return } // no swiping down
                gridView.transform = CGAffineTransform(translationX: 0, y: translation.y)
            }
            else {
                if translation.x > 0 { return } // no swiping right
                gridView.transform = CGAffineTransform(translationX: translation.x, y: 0)
            }
        case .ended, .cancelled :
            if UIApplication.shared.statusBarOrientation == .portrait {
                if translation.y < -UIScreen.main.bounds.height / 4 {
                    UIView.animate(withDuration: 0.3, animations: {
                        self.gridView.transform = CGAffineTransform(translationX: 0, y: -UIScreen.main.bounds.height)
                    }) { (success) in
                        if success {
                            self.shareImage(self.gridView)
                        }
                    }
                }
                else {
                    resetGridViewPosition()
                }
            }
            else {
                if translation.x < -UIScreen.main.bounds.width / 4 {
                    UIView.animate(withDuration: 0.3, animations: {
                        self.gridView.transform = CGAffineTransform(translationX: -UIScreen.main.bounds.width, y: 0)
                    }) { (success) in
                        if success {
                            self.shareImage(self.gridView)
                        }
                    }
                }
                else {
                    resetGridViewPosition()
                }
            }
        default:
            break
        }
    }
    
    // puts the gridView to the center
    func resetGridViewPosition() {
        UIView.animate(withDuration: 0.2, animations: {
            self.gridView.transform = CGAffineTransform(translationX: 0, y: 0)
        })
    }
    
    // shares an image
    func shareImage(_ view: UIView) {
        let image =  UIImage.init(view)
        let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        present(activityViewController, animated: true, completion: resetGridViewPosition)
    }
    
    // makes the buttons round
    func applyRoundCorners(_ object: AnyObject) {
        object.layer.cornerRadius = object.frame.size.width / 2
        object.layer.masksToBounds = true
    }
}

// converts a view into an image
extension UIImage{
    convenience init(_ view: UIView) {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 0.0)
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: false)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.init(cgImage: (image?.cgImage)!)
        
    }
}

// allows the landscape mode for the image picker
extension UIImagePickerController {
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .all
    }
}
