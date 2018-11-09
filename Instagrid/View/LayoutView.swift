import UIKit

class LayoutView: UIView {
    
    // buttons / images outlets
    @IBOutlet weak var imageButton1: UIButton!
    @IBOutlet weak var imageButton2: UIButton!
    @IBOutlet weak var imageButton3: UIButton!
    @IBOutlet weak var imageButton4: UIButton!
    
    // Outlets used for thickness
    @IBOutlet weak var layoutViewTopC: NSLayoutConstraint!
    @IBOutlet weak var layoutViewBottomC: NSLayoutConstraint!
    @IBOutlet weak var layoutViewLeftC: NSLayoutConstraint!
    @IBOutlet weak var layoutViewRightC: NSLayoutConstraint!
    @IBOutlet weak var layoutViewRow1: UIStackView!
    @IBOutlet weak var layoutViewRow2: UIStackView!
    @IBOutlet weak var layoutViewContent: UIStackView!
    
    var layout: Int = 2 {
        didSet {
            setLayout(layout)
        }
    }
    
    // sets the layout
    private func setLayout(_ layout: Int) {
        switch layout {
        case 1 :
            hideView(imageButton2)
            showView(imageButton4)
        case 2 :
            showView(imageButton2)
            hideView(imageButton4)
        case 3 :
            showView(imageButton2)
            showView(imageButton4)
        default:
            break
        }
    }
    
    // shows a view with an animation
    private func showView(_ view: UIView) {
        if view.isHidden {
            UIView.transition(with: view, duration: 0.4, options: .transitionFlipFromLeft, animations: {
                view.isHidden = false
            }, completion: nil)
        }
    }
    
    // hides a view with an animation
    private func hideView(_ view: UIView) {
        if !view.isHidden {
            UIView.transition(with: view, duration: 0.4, options: .transitionFlipFromLeft, animations: {
                view.isHidden = true
            }, completion: nil)
        }
    }
    
    // removes all images
    func resetImages() {
        imageButton1.setImage(UIImage(named: "Add image"), for: .normal)
        imageButton2.setImage(UIImage(named: "Add image"), for: .normal)
        imageButton3.setImage(UIImage(named: "Add image"), for: .normal)
        imageButton4.setImage(UIImage(named: "Add image"), for: .normal)
    }
    
    // Changes the margins thickness
    func changeMarginThickness(size: CGFloat) {
        layoutViewTopC.constant = size
        layoutViewBottomC.constant = size
        layoutViewLeftC.constant = size
        layoutViewRightC.constant = size
        layoutViewRow1.spacing = size
        layoutViewRow2.spacing = size
        layoutViewContent.spacing = size
    }
}
