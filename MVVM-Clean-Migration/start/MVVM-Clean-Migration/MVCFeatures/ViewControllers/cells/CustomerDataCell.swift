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
public class CustomerDataCell: UITableViewCell {
    override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: "CustomerDataCell")
    }

    required init?(coder: NSCoder) {
        super.init(style: .subtitle, reuseIdentifier: "CustomerDataCell")
    }

    override public func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .systemGray6
    }
}
