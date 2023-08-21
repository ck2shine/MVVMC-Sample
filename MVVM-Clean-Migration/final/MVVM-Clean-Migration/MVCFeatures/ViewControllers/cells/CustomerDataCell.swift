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

import Combine
import UIKit
public class CustomerDataCell: UITableViewCell, CustomerCellSettingProtocol {
    public var nibID: String = "CustomerDataCell"
    private var subscription = Set<AnyCancellable>()
    public var cellViewModel: CustomerItemViewModelProtocol?

    public func setupCell(_ viewModel: CustomerItemViewModelProtocol) {
        if let cellViewModel = viewModel as? RPCustomerDataCellViewModel {
            self.cellViewModel = cellViewModel
            self.bindingUIs(viewModel: cellViewModel)
        }
    }

    private func bindingUIs(viewModel: RPCustomerDataCellViewModel) {
        viewModel.mainTitle
            .sink { [unowned self] titleStr in
                self.textLabel?.text = titleStr
            }
            .store(in: &self.subscription)

        viewModel.subTitle
            .sink { [unowned self] subTitle in
                self.detailTextLabel?.text = subTitle
            }
            .store(in: &self.subscription)
    }

    override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: "CustomerDataCell")
    }

    required init?(coder: NSCoder) {
        super.init(style: .subtitle, reuseIdentifier: "CustomerDataCell")
    }

    override public func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .systemGray6
        self.selectionStyle = .none
    }

    override public func prepareForReuse() {
        super.prepareForReuse()
        self.cellViewModel = nil
        self.subscription.forEach { $0.cancel() }
        self.subscription.removeAll(keepingCapacity: true)
    }
}
