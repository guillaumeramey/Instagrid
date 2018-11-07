import UIKit

class LayoutView: UIView {
    
    var layout: Int = 2 {
        didSet {
            setLayout(layout)
        }
    }
    
    // sets the layout
    private func setLayout(_ layout: Int) {
        switch layout {
        case 1: // layout with tags 0 and 1
            for case let button as UIButton in self.getAllSubviews() {
                if button.tag == 1 && button.isHidden == true || button.tag == 2 && button.isHidden == false {
                    switchViewWithAnimation(button)
                }
            }
        case 2: // layout with tags 0 and 2
            for case let button as UIButton in self.getAllSubviews() {
                if button.tag == 2 && button.isHidden == true || button.tag == 1 && button.isHidden == false {
                    switchViewWithAnimation(button)
                }
            }
        case 3: // layout with tags 0, 1 and 2
            for case let button as UIButton in self.getAllSubviews() {
                if (button.tag == 1 || button.tag == 2) && button.isHidden == true {
                    switchViewWithAnimation(button)
                }
            }
        default:
            break
        }
    }
    
    // shows or hides a view with an animation
    private func switchViewWithAnimation(_ view: UIView) {
        UIView.transition(with: view, duration: 0.4, options: .transitionFlipFromLeft, animations: {
            view.isHidden = view.isHidden ? false : true
        }, completion: nil)
    }
    
    
    // removes all images
    func reset() {
        for case let button as UIButton in self.getAllSubviews() {
            button.setImage(UIImage(named: "Add image"), for: .normal)
        }
    }

    // puts the view back to the center
    func resetPosition(animate: Bool) {
        if animate {
            UIView.animate(withDuration: 0.2, animations: {
                self.transform = CGAffineTransform(translationX: 0, y: 0)
            })
        }
        else {
            self.transform = CGAffineTransform(translationX: 0, y: 0)
        }
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
