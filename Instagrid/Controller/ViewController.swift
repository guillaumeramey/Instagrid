import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK: - Outlets
    @IBOutlet weak var layoutView: LayoutView!
    @IBOutlet weak var layoutButtons: UIStackView!
    @IBOutlet weak var colorButtons: UIStackView!
    @IBOutlet weak var thicknessButtons: UIStackView!

    // MARK: - Properties
    // Lets the user pick an image
    var imagePicker = UIImagePickerController()
    // Permits multiple image pickers in a view
    var buttonSender: UIButton!
    // Original position of the layout
    var layoutOrigin = CGPoint(x: 0, y: 0)
    // Margins thickness
    var thicknessSize = CGFloat(15)

    // MARK: - Actions
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
    // Margin thickness selection
    @IBAction func changeThickness(_ sender: UIButton) {
        if sender.tag == 0 {
            if thicknessSize > 0 {
                thicknessSize -= 3
                layoutView.changeMarginThickness(size: thicknessSize)
            }
        } else {
            if thicknessSize < 15 {
                thicknessSize += 3
                layoutView.changeMarginThickness(size: thicknessSize)
            }
        }
    }

    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        roundButtons()

        layoutView.layout = 2
        layoutOrigin = layoutView.bounds.origin

        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.modalPresentationStyle = .overCurrentContext // allows the landscape mode for the image picker

        let swipeUpRec = UISwipeGestureRecognizer(target: self, action: #selector(swipedUp))
        swipeUpRec.direction = .up
        layoutView.addGestureRecognizer(swipeUpRec)

        let swipeLeftRec = UISwipeGestureRecognizer(target: self, action: #selector(swipedLeft))
        swipeLeftRec.direction = .left
        layoutView.addGestureRecognizer(swipeLeftRec)
    }

    // Makes the color buttons round
    func roundButtons() {
        for case let button as UIButton in colorButtons.subviews {
            button.layer.cornerRadius = button.frame.size.width / 2
        }
    }

    // Selects the current layout button
    func selectButtonLayout(_ selectedLayout: Int) {
        for case let button as UIButton in layoutButtons.subviews {
            if button.tag == selectedLayout {
                button.setImage(UIImage(named: "Selected"), for: .normal)
            } else {
                button.setImage(nil, for: .normal)
            }
        }
    }

    // the user swipes up
    @objc func swipedUp() {
        if UIApplication.shared.statusBarOrientation == .portrait {
            UIView.animate(withDuration: 0.5, animations: {
                self.layoutView.transform = CGAffineTransform(translationX: 0, y: -UIScreen.main.bounds.height)
            }, completion: { _ in
                self.shareImage(self.layoutView)
            })
        }
    }

    // the user swipes left
    @objc func swipedLeft() {
        if UIApplication.shared.statusBarOrientation == .landscapeLeft
            || UIApplication.shared.statusBarOrientation == .landscapeRight {
            UIView.animate(withDuration: 0.5, animations: {
                self.layoutView.transform = CGAffineTransform(translationX: -UIScreen.main.bounds.width, y: 0)
            }, completion: { _ in
                self.shareImage(self.layoutView)
            })
        }
    }

    // Puts the view back to it's original position
    func resetLayoutPosition() {
        UIView.animate(withDuration: 0.5, animations: {
            self.layoutView.transform = CGAffineTransform(translationX: self.layoutOrigin.x, y: self.layoutOrigin.y)
        })
    }

    // Allows the user to select an image
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        buttonSender.setImage(pickedImage, for: .normal)
        buttonSender.imageView?.contentMode = UIView.ContentMode.scaleAspectFill
        dismiss(animated: true)
    }

    // Canceling the image picker
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }

    // Shares an image
    func shareImage(_ view: UIView) {
        let imageToShare =  Image().convert(view)
        let activityVC = UIActivityViewController(activityItems: [imageToShare], applicationActivities: nil)
        activityVC.completionWithItemsHandler = {(activityType: UIActivity.ActivityType?, completed: Bool,
            returnedItems: [Any]?, error: Error?) in
            if completed {
                self.layoutView.resetImages()
            }
            self.resetLayoutPosition()
        }
        present(activityVC, animated: true, completion: nil)
    }
}
