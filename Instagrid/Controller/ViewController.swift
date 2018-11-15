import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK: - Outlets
    @IBOutlet weak var layoutView: LayoutView!
    @IBOutlet weak var layoutButtons: UIStackView!
    @IBOutlet weak var colorButtons: UIStackView!

    // MARK: - Properties
    // Lets the user pick an image
    var imagePicker = UIImagePickerController()

    // Permits multiple image pickers in a view
    var buttonSender: UIButton!

    // Original position of the layout
    var layoutOrigin = CGPoint(x: 0, y: 0)

    // Determines the device orientation
    var orientationIsPortrait: Bool {
        return UIApplication.shared.statusBarOrientation == .portrait
    }
    var orientationIsLandscape: Bool {
        return UIApplication.shared.statusBarOrientation == .landscapeLeft
            || UIApplication.shared.statusBarOrientation == .landscapeRight
    }

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

    // Margins thickness selection
    @IBAction func decreaseMarginsThickness(_ sender: UIButton) {
        if layoutView.marginsThickness > 0 {
            layoutView.marginsThickness -= 3
        }
    }
    @IBAction func increaseMarginsThickness(_ sender: UIButton) {
        if layoutView.marginsThickness < 15 {
            layoutView.marginsThickness += 3
        }
    }

    // the user swipes
    @IBAction func swiped(recognizer: UISwipeGestureRecognizer) {
        var translationX: CGFloat = 0
        var translationY: CGFloat = 0

        switch recognizer.direction {
        case .left:
            if orientationIsLandscape {
                translationX = -UIScreen.main.bounds.width
            }
        case .up:
            if orientationIsPortrait {
                translationY = -UIScreen.main.bounds.height
            }
        default:
            break
        }

        if translationX != 0 || translationY != 0 {
            UIView.animate(withDuration: 0.5, animations: {
                self.layoutView.transform = CGAffineTransform(translationX: translationX, y: translationY)
            }, completion: { _ in
                self.shareImage(self.layoutView)
            })
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
    }

    // Makes the color buttons round
    func roundButtons() {
        for case let button as UIButton in colorButtons.subviews {
            button.layer.cornerRadius = button.frame.size.width / 2
        }
    }

    // Marks the current layout button as selected
    func selectButtonLayout(_ selectedLayout: Int) {
        for case let button as UIButton in layoutButtons.subviews {
            if button.tag == selectedLayout {
                button.setImage(UIImage(named: "Selected"), for: .normal)
            } else {
                button.setImage(nil, for: .normal)
            }
        }
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

    // Puts the layout view back to it's original position
    func resetLayoutPosition() {
        UIView.animate(withDuration: 0.5, animations: {
            self.layoutView.transform = CGAffineTransform(translationX: self.layoutOrigin.x, y: self.layoutOrigin.y)
        })
    }
}
