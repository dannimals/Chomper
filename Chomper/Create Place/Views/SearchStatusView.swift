//
//  Created by Danning Ge on 5/28/17.
//  Copyright © 2017 Danning Ge. All rights reserved.
//

import Common
import SnapKit

class SearchStatusView: UIView {
    private let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        isHidden = true
        backgroundColor = UIColor.softWhite()
        addSubview(label)
        label.snp.makeConstraints { make in
            make.center.equalTo(self)
        }
        label.textColor = UIColor.darkOrange()
        label.font = UIFont.chomperFontForTextStyle("h4")
    }

    func updateLabel(text: String) {
        label.text = text
    }
}
