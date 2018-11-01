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
    @IBOutlet weak var backgroundColorButtons: UIStackView!
    @IBOutlet weak var layoutButtons: UIStackView!
    
    var imagePicker = UIImagePickerController()
    var buttonSender: UIButton!
    var activeLayout = 0 {
        didSet {
            if activeLayout != oldValue {
                selectGridLayout(activeLayout)
                selectButtonLayout(activeLayout)
            }
        }
    }
    
    // Layout selection
    @IBAction func changeLayout(_ sender: UIButton) {
        activeLayout = sender.tag
    }
    
    // Image selection
    @IBAction func changeImage(_ sender: UIButton) {
        buttonSender = sender
        self.present(imagePicker, animated: true)
    }
    
    // Background color selection
    @IBAction func changeBackgroundColor(_ sender: UIButton) {
        gridView.backgroundColor = sender.backgroundColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        roundButtons()
        activeLayout = 2
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
    
    // selects the current layout button
    func selectButtonLayout(_ selectedLayout: Int) {
        for case let button as UIButton in layoutButtons.subviews {
            if button.tag == selectedLayout {
                button.setImage(UIImage(named: "Button Selected.png"), for: .normal)
            } else {
                button.setImage(nil, for: .normal)
            }
        }
    }
    
    // sets the grid layout
    func selectGridLayout(_ selectedLayout: Int) {
        switch selectedLayout {
        case 1: // layout with tags 0 and 1
            for case let button as UIButton in gridView.getAllSubviews() {
                if button.tag == 1 && button.isHidden == true || button.tag == 2 && button.isHidden == false {
                    switchViewWithAnimation(button)
                }
            }
        case 2: // layout with tags 0 and 2
            for case let button as UIButton in gridView.getAllSubviews() {
                if button.tag == 2 && button.isHidden == true || button.tag == 1 && button.isHidden == false {
                    switchViewWithAnimation(button)
                }
            }
        case 3: // layout with tags 0, 1 and 2
            for case let button as UIButton in gridView.getAllSubviews() {
                if (button.tag == 1 || button.tag == 2) && button.isHidden == true {
                    switchViewWithAnimation(button)
                }
            }
        default:
            break
        }
    }

    // shows or hides a view with an animation
    func switchViewWithAnimation(_ view: UIView) {
        UIView.transition(with: view, duration: 0.4, options: .transitionFlipFromLeft, animations: {
            view.isHidden = view.isHidden ? false : true
        }, completion: nil)
    }
    
    // swipe gesture
    @objc func swipeGridView(_ sender: UIPanGestureRecognizer){
        let translation = sender.translation(in: gridView)
        switch sender.state {
        // follows the gesture
        case .began, .changed :
            if UIApplication.shared.statusBarOrientation == .portrait {
                if translation.y > 0 { return } // no swiping down
                gridView.transform = CGAffineTransform(translationX: 0, y: translation.y)
            }
            else {
                if translation.x > 0 { return } // no swiping right
                gridView.transform = CGAffineTransform(translationX: translation.x, y: 0)
            }
        // the gesture ends : if the user has not swipe enough, resets position
        case .ended, .cancelled :
            if UIApplication.shared.statusBarOrientation == .portrait { // swiping up
                if translation.y < -UIScreen.main.bounds.height / 4 {
                    UIView.animate(withDuration: 0.3, animations: {
                        self.gridView.transform = CGAffineTransform(translationX: 0, y: -UIScreen.main.bounds.height)
                    }) { (success) in
                        if success {
                            self.shareImage(self.gridView)
                            self.resetGridView()
                        }
                    }
                }
                else {
                    resetGridViewPosition(animate: true)
                }
            }
            else { // swiping left
                if translation.x < -UIScreen.main.bounds.width / 4 {
                    UIView.animate(withDuration: 0.3, animations: {
                        self.gridView.transform = CGAffineTransform(translationX: -UIScreen.main.bounds.width, y: 0)
                    }) { (success) in
                        if success {
                            self.shareImage(self.gridView)
                            self.resetGridView()
                        }
                    }
                }
                else {
                    resetGridViewPosition(animate: true)
                }
            }
        default:
            break
        }
    }
    
    // removes all images in the gridview
    func resetGridView() {
        for case let button as UIButton in gridView.getAllSubviews() {
            button.setImage(UIImage(named: "Add Image.png"), for: .normal)
        }
    }
    
    // puts the gridView back to the center
    func resetGridViewPosition(animate: Bool) {
        if animate {
        UIView.animate(withDuration: 0.2, animations: {
            self.gridView.transform = CGAffineTransform(translationX: 0, y: 0)
        })
        }
        else {
            self.gridView.transform = CGAffineTransform(translationX: 0, y: 0)
        }
    }
    
    // shares an image
    func shareImage(_ view: UIView) {
        let image =  UIImage.init(view)
        let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        present(activityViewController, animated: true, completion: {self.resetGridViewPosition(animate: false)})
    }
    
    // makes the color buttons round
    func roundButtons() {
        for case let button as UIButton in backgroundColorButtons.subviews {
            applyRoundCorners(button)
        }
    }
    
    // rounds the corner of an object
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

// gets all the subviews of a view and its subviews
extension UIView {
    class func getAllSubviews<T: UIView>(_ view: UIView) -> [T] {
        return view.subviews.flatMap { subView -> [T] in
            var result = getAllSubviews(subView) as [T]
            if let view = subView as? T {
                result.append(view)
            }
            return result
        }
    }
    
    func getAllSubviews<T: UIView>() -> [T] {
        return UIView.getAllSubviews(self) as [T]
    }
}
