import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var layoutView: LayoutView!
    @IBOutlet weak var backgroundColorButtons: UIStackView!
    @IBOutlet weak var layoutButtons: UIStackView!
    
    var imagePicker = UIImagePickerController()
    var buttonSender: UIButton!
    
    // Layout selection
    @IBAction func changeLayout(_ sender: UIButton) {
        layoutView.layout = sender.tag
        selectButtonLayout(sender.tag)
    }
    
    // Image selection
    @IBAction func changeImage(_ sender: UIButton) {
        buttonSender = sender
        self.present(imagePicker, animated: true)
    }
    
    // Background color selection
    @IBAction func changeBackgroundColor(_ sender: UIButton) {
        layoutView.backgroundColor = sender.backgroundColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        roundButtons()
        layoutView.layout = 2
        imagePicker.delegate = self
        imagePicker.sourceType = .savedPhotosAlbum
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(dragLayoutView(_:)))
        layoutView.addGestureRecognizer(panGestureRecognizer)
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
                button.setImage(UIImage(named: "Selected"), for: .normal)
            } else {
                button.setImage(nil, for: .normal)
            }
        }
    }
    
    // drag gesture
    @objc func dragLayoutView(_ sender: UIPanGestureRecognizer){
        let translation = sender.translation(in: layoutView)
        switch sender.state {
        case .began, .changed :
            if UIApplication.shared.statusBarOrientation == .portrait {
                if translation.y > 0 { return } // no drag down
                layoutView.transform = CGAffineTransform(translationX: 0, y: translation.y)
            }
            else {
                if translation.x > 0 { return } // no drag right
                layoutView.transform = CGAffineTransform(translationX: translation.x, y: 0)
            }
        case .ended, .cancelled :
            if UIApplication.shared.statusBarOrientation == .portrait { // drag up
                if translation.y < -UIScreen.main.bounds.height / 4 {
                    UIView.animate(withDuration: 0.3, animations: {
                        self.layoutView.transform = CGAffineTransform(translationX: 0, y: -UIScreen.main.bounds.height)
                    }) { (success) in
                        if success {
                            self.shareImage(self.layoutView)
                            self.layoutView.reset()
                        }
                    }
                }
                else { // the user didn't drag enough
                    layoutView.resetPosition(animate: true)
                }
            }
            else { // drag left
                if translation.x < -UIScreen.main.bounds.width / 4 {
                    UIView.animate(withDuration: 0.3, animations: {
                        self.layoutView.transform = CGAffineTransform(translationX: -UIScreen.main.bounds.width, y: 0)
                    }) { (success) in
                        if success {
                            self.shareImage(self.layoutView)
                            self.layoutView.reset()
                        }
                    }
                }
                else { // the user didn't drag enough
                    layoutView.resetPosition(animate: true)
                }
            }
        default:
            break
        }
    }
    
    // shares an image
    func shareImage(_ view: UIView) {
        let image =  UIImage.init(view)
        let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        present(activityViewController, animated: true, completion: {self.layoutView.resetPosition(animate: false)})
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
