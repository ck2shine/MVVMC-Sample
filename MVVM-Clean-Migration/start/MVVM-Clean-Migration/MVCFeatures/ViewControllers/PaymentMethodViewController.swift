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

import Foundation
import UIKit
class PaymentMethodViewController: UIViewController {
    var shopper: Shopper?
    
    private var customerNameLabel: UILabel!
   
    private var barcodeImageView: UIImageView!
    private var qrcodeImageView: UIImageView!
    private var loadingActivityView: UIActivityIndicatorView!
    private var confirmButton: RPayStyleButton!
    private var qrdetailButton: RPayStyleButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupLayout()
        self.setupRPayNavigationBarHeader()
        self.getUserInformation()
    }
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
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
        
        self.confirmButton = RPayStyleButton(.confirm)
        self.confirmButton.addAction = { [weak self] in
            self?.refreshQRBarcode()
        }
        stackView.addArrangedSubview(self.confirmButton)
        self.qrdetailButton = RPayStyleButton(.qrScan)
        self.qrdetailButton.addAction = { [weak self] in
            self?.transitToHistory()
        }
        stackView.addArrangedSubview(self.qrdetailButton)
    }
    
    private func refreshQRBarcode() {
        self.getUserInformation()
    }
    
    private func transitToHistory() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let viewController = storyboard.instantiateViewController(withIdentifier: "CustomerDetailViewController") as? CustomerDetailViewController {
            viewController.shopper = self.shopper
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    private func getUserInformation() {
        self.loadingActivityView.startAnimating()
        
        // load stack memory first
        if let shopper = self.shopper {
            self.handleAuthResponse(shopper)
            // refresh again
            self.performAPI()
        } else {
            // force refresh
            self.performAPI()
        }
    }
    
    private func performAPI() {
        RakutenWalletApiManager.auth { [weak self] responseStatus in
            guard let myself = self else { return }
            switch responseStatus {
            case .success(let shopper):
                myself.handleAuthResponse(shopper)
            case .error(let error):
                myself.handleAuthFail(apiError: error)
            }
        }
    }
    
    private func setupRPayNavigationBarHeader() {
        let logoView = UIImageView(image: UIImage(named: "logo_rakuten_header", in: Bundle(for: Self.self), compatibleWith: nil))
        logoView.contentMode = .scaleAspectFit
        self.navigationItem.titleView = logoView
        self.navigationController?.navigationBar.backgroundColor = .white
    }
    
    fileprivate func handleAuthResponse(_ shopper: Shopper) {
        // stop animate
        self.loadingActivityView.stopAnimating()
        // load date to view
        self.shopper = shopper
        self.customerNameLabel.text = "\(shopper.lastName ?? "") \(shopper.firstName ?? "")"
        self.qrcodeImageView.image = UIImage(named: shopper.qrcodeName)!
        self.barcodeImageView.image = UIImage(named: shopper.barcodeName)!
    }
    
    fileprivate func handleAuthFail(apiError: APIError) {
        self.loadingActivityView.stopAnimating()
        self.alertWithMessage(title: apiError.errorCode, message: apiError.errorMessage)
        self.shopper = nil
    }
}
