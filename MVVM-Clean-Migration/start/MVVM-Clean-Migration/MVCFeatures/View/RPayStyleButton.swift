/*
 * Copyright (c) Rakuten Payment, Inc. All Rights Reserved.
 *
 * This program is the information asset which are handled
 * as "Strictly Confidential".
 * Permission of use is only admitted in Rakuten Payment, Inc.
 * If you don't have permission, MUST not be published,
 * broadcast, rewritten for broadcast or publication
 * or redistributed directly or indirectly in any medium.
 */

import UIKit

enum RPayStyleButtonType: String {
    case confirm
    case selfPay
    case qrScan
    case receiveSuicaPocket
}

class RPayStyleButton: UIButton {
    var addAction: (() -> ())?
    init(_ type: RPayStyleButtonType) {
        super.init(frame: .zero)
        self.setupUI(type)
    }

    private func setupUI(_ type: RPayStyleButtonType) {
        self.config(type)
        self.setTitleColor(UIColor.crimson, for: .normal)
        self.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)

        self.backgroundColor = UIColor.white
        self.layer.borderWidth = 1.0 // MUST larger than 0
        self.layer.cornerRadius = 4.0
        self.layer.shadowOpacity = 0.2
        self.layer.shadowRadius = 4.0
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.borderColor = UIColor.crimson.cgColor

        self.addTarget(self, action: #selector(self.didTapButton), for: .touchUpInside)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        let tag = self.tag
        switch tag {
        case 1:
            self.setupUI(.confirm)
        case 2:
            self.setupUI(.qrScan)
        default:
            self.setupUI(.confirm)
        }
    }

    private func config(_ type: RPayStyleButtonType) {
        var imageName = ""
        var title = ""
        switch type {
        case .confirm:
            imageName = "oval_check"
            title = "Rrefresh"
        case .selfPay:
            imageName = "selfRed"
            title = "Self"
        case .qrScan:
            imageName = "RPayQRRed"
            title = "QRDetail"
        case .receiveSuicaPocket:
            title = "Receive"
        }
        self.setImage(UIImage(named: imageName), for: .normal)
        self.setTitle(title, for: .normal)
        self.accessibilityIdentifier = type.rawValue
    }

    @objc func didTapButton() {
        self.addAction?()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
    }
}
