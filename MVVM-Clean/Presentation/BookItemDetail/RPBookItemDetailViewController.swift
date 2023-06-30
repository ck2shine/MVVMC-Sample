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
import Combine
public class RPBookItemDetailViewController: UIViewController {

    private var subscriptions =  Set<AnyCancellable>()
    
    private var dependency: ContainerDependency
    
    private var viewModel: RPBookItemDetailViewModel
    
    public init(dependency: ContainerDependency) {
        self.dependency = dependency
        guard let viewModel = dependency.resolve(RPBookItemDetailViewModel.self) else {
            fatalError("cano not find viewModel")
        }
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: Bundle(for: Self.self))
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.bindingUIs()
    }
}

extension RPBookItemDetailViewController{
    private func setupUI(){
        
    }
    
    private func bindingUIs(){
        let input = viewModel.input
        let output = viewModel.output
    }
}
