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
import Foundation
import UIKit
public class PaymentMethodViewController: UIViewController {
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
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// UI components
    private var customerNameLabel: UILabel!
    private var barcodeImageView: UIImageView!
    private var qrcodeImageView: UIImageView!
    private var loadingActivityView: UIActivityIndicatorView!
    private var refreshButton: RPayStyleButton!
    private var qrdetailButton: RPayStyleButton!
    
    /// Life cycle
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.bindingUIs()
        
        // start to load data
        self.viewModel.userAuthTrigger.send(())
    }
   
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}

extension PaymentMethodViewController {
    private func setupUI() {
        self.setupLayout()
        self.setupRPayNavigationBarHeader()
    }
    
    private func bindingUIs() {
        let input = self.viewModel.input
        let output = self.viewModel.output
        
        // load activity
        output.loadingActivityPublisher
            .sink { [unowned self] isStart in
                if isStart {
                    self.loadingActivityView.startAnimating()
                } else {
                    self.loadingActivityView.stopAnimating()
                }
            }
            .store(in: &self.subscriptions)
        
        // data
        output.responseDataPublisher
            .dropFirst()
            .sink { [unowned self] itemTupple in
                self.barcodeImageView.image = UIImage(named: itemTupple.brImage)
                self.qrcodeImageView.image = UIImage(named: itemTupple.qrImage)
                self.customerNameLabel.text = itemTupple.name
            }
            .store(in: &self.subscriptions)
        
        // alert
        output.alertPublisher
            .sink { [unowned self] msg in
                self.alertWithMessage(title: msg.title, message: msg.message)
            }
            .store(in: &self.subscriptions)
        
        // transit
        output.transitPublisher
            .sink { [unowned self] entity in
                let storyboard = UIStoryboard(name: "Main", bundle: Bundle(for: Self.self))
                if let vc = storyboard.instantiateViewController(identifier: "CustomerDetailViewController") as? CustomerDetailViewController, let container = self.dependency as? PaymentFlowContainer {
                    container.registerCustomerDetailDependency(entity: entity)
                    vc.injectDependency(dependency: container)
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            .store(in: &self.subscriptions)
    }
 
    private func setupRPayNavigationBarHeader() {
        let logoView = UIImageView(image: UIImage(named: "logo_rakuten_header", in: Bundle(for: Self.self), compatibleWith: nil))
        logoView.contentMode = .scaleAspectFit
        self.navigationItem.titleView = logoView
        self.navigationController?.navigationBar.backgroundColor = .white
    }
    
    /// private method
    private func setupLayout() {
        self.view.backgroundColor = .systemGray6
        
        self.customerNameLabel = UILabel()
        self.customerNameLabel.textAlignment = .center
        self.customerNameLabel.text = "Customer Name"
        self.customerNameLabel.font = UIFont.boldSystemFont(ofSize: 24.0)
        self.customerNameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.customerNameLabel)
        NSLayoutConstraint.activate([
            self.customerNameLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10),
            self.customerNameLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            self.customerNameLabel.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            self.customerNameLabel.heightAnchor.constraint(equalToConstant: 35)
        ])
        
        self.barcodeImageView = UIImageView()
        self.barcodeImageView.image = UIImage(systemName: "barcode")
        self.barcodeImageView.tintColor = .black
        self.barcodeImageView.contentMode = .scaleAspectFit
        self.barcodeImageView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.barcodeImageView)
        NSLayoutConstraint.activate([
            self.barcodeImageView.topAnchor.constraint(equalTo: self.customerNameLabel.bottomAnchor, constant: 30),
            self.barcodeImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.barcodeImageView.widthAnchor.constraint(equalToConstant: 260),
            self.barcodeImageView.heightAnchor.constraint(equalToConstant: 80)
        ])
        
        self.qrcodeImageView = UIImageView()
        self.qrcodeImageView.image = UIImage(systemName: "qrcode")
        self.qrcodeImageView.tintColor = .black
        self.qrcodeImageView.contentMode = .scaleAspectFit
        self.qrcodeImageView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.qrcodeImageView)
        NSLayoutConstraint.activate([
            self.qrcodeImageView.topAnchor.constraint(equalTo: self.barcodeImageView.bottomAnchor, constant: 10),
            self.qrcodeImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.qrcodeImageView.widthAnchor.constraint(equalToConstant: 130),
            self.qrcodeImageView.heightAnchor.constraint(equalToConstant: 130)
        ])
        
        self.loadingActivityView = UIActivityIndicatorView()
        self.loadingActivityView.color = .red
        self.loadingActivityView.style = .large
        self.loadingActivityView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.loadingActivityView)
        NSLayoutConstraint.activate([
            self.loadingActivityView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            self.loadingActivityView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            stackView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            stackView.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        self.refreshButton = RPayStyleButton(.confirm)
        self.refreshButton.addAction = { [weak self] in
            guard let self = self else { return }
            self.viewModel.userAuthTrigger.send(())
        }
        stackView.addArrangedSubview(self.refreshButton)
        self.qrdetailButton = RPayStyleButton(.qrScan)
        self.qrdetailButton.addAction = { [weak self] in
            guard let self = self else { return }
            self.viewModel.transitTrigger.send(())
        }
        stackView.addArrangedSubview(self.qrdetailButton)
    }
}
