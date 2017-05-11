//
//  Created by Danning Ge on 7/17/16.
//  Copyright © 2016 Danning Ge. All rights reserved.
//

import Common
import RxSwift

class BaseViewController: UIViewController, BaseViewControllerProtocol {
    let disposeBag = DisposeBag()

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
}
