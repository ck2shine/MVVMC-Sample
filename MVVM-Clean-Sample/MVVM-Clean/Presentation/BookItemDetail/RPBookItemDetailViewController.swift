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
public class RPBookItemDetailViewController: UIViewController {
    private var bookTitleLable: UILabel!
    private var descriptionLabel: UILabel!
    private var coverImageView: UIImageView!
    private var subscriptions = Set<AnyCancellable>()
    
    private var dependency: ContainerDependency
    
    private var viewModel: RPBookItemDetailViewModel
    
    public init(dependency: ContainerDependency) {
        self.dependency = dependency
        guard let viewModel = dependency.resolve(RPBookItemDetailViewModel.self) else {
            fatalError("cano not find RPBookItemDetailViewModel")
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
        self.setupUI()
        self.bindingUIs()
    }
}

extension RPBookItemDetailViewController {
    private func setupUI() {
        self.view.backgroundColor = .white
        self.bookTitleLable = UILabel()
        self.bookTitleLable.font = UIFont.boldSystemFont(ofSize: 22)
        self.bookTitleLable.translatesAutoresizingMaskIntoConstraints = false
    
        self.view.addSubview(self.bookTitleLable)
        self.bookTitleLable.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        self.bookTitleLable.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 10).isActive = true
        self.bookTitleLable.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -10).isActive = true
        self.bookTitleLable.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.bookTitleLable.textAlignment = .center
        
        
        self.descriptionLabel = UILabel()
        self.descriptionLabel.font = UIFont.systemFont(ofSize: 18)
        self.descriptionLabel.numberOfLines = 0
        self.descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.descriptionLabel)
        self.descriptionLabel.topAnchor.constraint(equalTo: self.bookTitleLable.bottomAnchor, constant: 20).isActive = true
        self.descriptionLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 10).isActive = true
        self.descriptionLabel.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -10).isActive = true
        self.descriptionLabel.heightAnchor.constraint(greaterThanOrEqualToConstant:  100).isActive = true
        self.descriptionLabel.textAlignment = .left
        
        self.coverImageView = UIImageView()
        self.coverImageView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.coverImageView)
        self.descriptionLabel.topAnchor.constraint(equalTo: self.bookTitleLable.bottomAnchor, constant: 20).isActive = true
        self.descriptionLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 10).isActive = true
        self.descriptionLabel.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -10).isActive = true
        self.descriptionLabel.heightAnchor.constraint(greaterThanOrEqualToConstant:  100).isActive = true
    }
    
    private func bindingUIs() {
        let input = self.viewModel.input
        let output = self.viewModel.output
        
        output.bookTitleNamePublisher
            .assign(to: \.text, on: self.bookTitleLable)
            .store(in: &self.subscriptions)
        
        output.bookDescriptionPublisher
            .assign(to: \.text, on: self.descriptionLabel)
            .store(in: &self.subscriptions)
    }
}
