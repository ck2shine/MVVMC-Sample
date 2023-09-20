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

public class RPCusomerDetailViewController: UIViewController {
    private var subscriptions = Set<AnyCancellable>()
    private var dependency: Container?
        
    private var viewModel: RPCusomerDetailViewModel?
        
    public func injectDependency(dependency: Container) {
        self.dependency = dependency
        guard let viewModel = dependency.resolve(forKey: RPCusomerDetailViewModel.self) else {
            fatalError("can not find RPCusomerDetailViewModel")
        }
        self.viewModel = viewModel
    }
        
    @IBOutlet var loadingActivity: UIActivityIndicatorView!
    @IBOutlet var dataTableView: UITableView!
    @IBOutlet var customerNameLabel: UILabel!
        
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.bindingUIs()
            
        self.viewModel?.userHistoryTrigger = ()
    }
}

extension RPCusomerDetailViewController {
    private func setupUI() {
        self.setupLayout()
    }
        
    private func bindingUIs() {
        guard let viewModel = self.viewModel else { return }

        self.viewModel?.$userNamePublisher
            .dropFirst()
            .sink { [unowned self] name in
                self.customerNameLabel.text = name
            }
            .store(in: &self.subscriptions)
            
        self.viewModel?.$loadingActivityPublisher
            .dropFirst()
            .sink { [unowned self] isStart in
                if isStart {
                    self.loadingActivity.startAnimating()
                    self.loadingActivity.isHidden = false
                } else {
                    self.loadingActivity.stopAnimating()
                    self.loadingActivity.isHidden = true
                }
            }
            .store(in: &self.subscriptions)
                          
        // alert
        self.viewModel?.$alertPublisher
            .dropFirst()
            .sink { [unowned self] msg in
                self.alertWithMessage(title: msg.title, message: msg.message)
            }
            .store(in: &self.subscriptions)
            
        self.viewModel?.transactionItemsPublisher
            .dropFirst()
            .sink { [unowned self] _ in
                self.dataTableView.reloadData()
            }
            .store(in: &self.subscriptions)
    }
        
    private func setupLayout() {
        let logoView = UIImageView(image: UIImage(named: "logo_rakuten_header", in: Bundle(for: Self.self), compatibleWith: nil))
        logoView.contentMode = .scaleAspectFit
        self.navigationItem.titleView = logoView
        self.navigationController?.navigationBar.backgroundColor = .white
            
        self.dataTableView.delegate = self
        self.dataTableView.dataSource = self
        self.dataTableView.register(CustomerDataCell.self, forCellReuseIdentifier: "CustomerDataCell")
            
        self.view.backgroundColor = .systemGray6
    }
}

extension RPCusomerDetailViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel?.transactionItemsPublisher.value.count ?? 0
    }
        
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomerDataCell", for: indexPath)
            
        if let cellViewModel = self.viewModel?.transactionItemsPublisher.value[indexPath.row], let customerCell = cell as? CustomerCellSettingProtocol {
            customerCell.setupCell(cellViewModel)
        }
            
        return cell
    }
}

extension RPCusomerDetailViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let cellViewModel = self.viewModel?.transactionItemsPublisher.value[indexPath.row] {
            return cellViewModel.cellHeight
        } else {
            return 80
        }
    }
}
