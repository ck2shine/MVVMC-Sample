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

public class RPPaymentMethodViewController: UIViewController {
    private var subscriptions = Set<AnyCancellable>()
    
    private var dependency: Container
    
    private var viewModel: RPPaymentMethodViewModel
    
    public init(dependency: Container) {
        self.dependency = dependency
        guard let viewModel = dependency.resolve(forKey: RPPaymentMethodViewModel.self) else {
            fatalError("can not find viewModel")
        }
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: Bundle(for: Self.self))
    }
    
    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindingUIs()
    }
}

extension RPPaymentMethodViewController {
    private func setupUI() {}
    
    private func bindingUIs() {
        let input = viewModel.input
        let output = viewModel.output
    }
}
