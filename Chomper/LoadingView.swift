//
//  Created by Danning Ge on 5/28/17.
//  Copyright © 2017 Danning Ge. All rights reserved.
//

import Common
import SnapKit

final class ChomperLoadingHUD {
    static let sharedView = LoadingView()
    static var isShowing = false

    class func show() {
        guard let app = UIApplication.shared.delegate as? AppDelegate, let window = app.window else {
            return
        }
        isShowing = true
        sharedView.startAnimating()

        window.addSubview(sharedView)
        sharedView.snp.remakeConstraints { (make) in
            make.edges.equalTo(window)
        }
    }

    class func dismiss() {
        isShowing = false
        sharedView.stopAnimating { [unowned sharedView] _ in
            sharedView.removeFromSuperview()
        }
    }
}

class LoadingView: UIView {
    private let loadingLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup() {
        translatesAutoresizingMaskIntoConstraints = false

        backgroundColor = UIColor.softWhite()
        addSubview(loadingLabel)
        loadingLabel.text = NSLocalizedString("Loading", comment: "Loading")
        loadingLabel.textColor = UIColor.darkOrange()
        loadingLabel.font = UIFont.chomperFontForTextStyle("h4")
        loadingLabel.snp.makeConstraints { make in
            make.center.equalTo(self)

        }
    }

    func startAnimating() {
        isHidden = false
        loadingLabel.alpha = 0
        UIView.animate(withDuration: 1.0, delay: 0.0, options: [.repeat, .autoreverse], animations: {
            self.loadingLabel.alpha = 1
            }, completion: nil)
    }

    func stopAnimating(completion: () -> Void) {
        UIView.animate(withDuration: 0.4, animations: {
            self.isHidden = true
        })
        completion()
    }
}
