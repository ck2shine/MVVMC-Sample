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

class CustomerDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var shopper: Shopper?
    var transactionList: [Transaction] = []
    
    @IBOutlet var loadingActivity: UIActivityIndicatorView!
    @IBOutlet var dataTableView: UITableView!
    @IBOutlet var customerNameLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupLayout()
        self.getHistory()
    }
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
   
    fileprivate func getHistory() {
        guard let easyID = self.shopper?.easyID else {
            return
        }
        self.loadingActivity.startAnimating()
        RakutenWalletApiManager.history(easyID: easyID) { [weak self] responseStatus in
            guard let myself = self else {
                return
            }
            switch responseStatus {
            case .success(let transactionList):
                myself.didFinishRecordsRequest(transactionList)
            case .error(let error):
                myself.didFinishRecordWithError(error: error)
            }
        }
    }
    
    fileprivate func didFinishRecordsRequest(_ newData: [Transaction]) {
        self.transactionList = newData
        self.customerNameLabel.text = "\(self.shopper?.lastName ?? "") \(self.shopper?.firstName ?? "") Payment History"
        self.loadingActivity.stopAnimating()
        self.loadingActivity.isHidden = true
        self.dataTableView.reloadData()
    }
    
    fileprivate func didFinishRecordWithError(error: APIError) {
        self.loadingActivity.stopAnimating()
        self.loadingActivity.isHidden = true
        self.alertWithMessage(title: error.errorCode, message: error.errorMessage)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.transactionList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomerDataCell", for: indexPath)
        
        let data = self.transactionList[indexPath.row]
        
        cell.textLabel?.text = data.merchantName
        cell.detailTextLabel?.text = "address : \(data.address)"
        cell.selectionStyle = .none
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
