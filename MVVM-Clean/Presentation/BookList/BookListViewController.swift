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
import SnapKit
import UIKit
public class BookListViewController: UIViewController {
    private var subscriptions = Set<AnyCancellable>()
    
    public lazy var bookListTableView: UITableView = {
        let tableView = UITableView()
        
        return tableView
    }()
    
    public lazy var bookTitleLabel: UILabel = {
        let lable = UILabel()
        lable.font = UIFont.boldSystemFont(ofSize: 20)
        lable.textAlignment = .center
        lable.textColor = .black
        lable.text = "This is book title"
        lable.layer.borderWidth = 1
        lable.layer.borderColor = UIColor.black.cgColor
        return lable
    }()
    
    public lazy var searchButton: UIButton = {
        let button = UIButton()
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.setTitle("Search", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    public var viewModel: BookListViewModel
    
    public init(viewModel: BookListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        initializeBinding()
    }
}

public extension BookListViewController {
    func setupUI() {
        view.backgroundColor = .white
        view.addSubview(searchButton)
      
        searchButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            $0.width.equalTo(200)
            $0.height.equalTo(50)
        }
        
        view.addSubview(bookTitleLabel)
        bookTitleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.height.equalTo(50)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            $0.trailing.equalTo(searchButton.snp.leading).offset(-10)
        }
    }
    
    func initializeBinding() {
        let output = viewModel.output
        output.bookTitleText
            .sink { [weak self] titleName in
                self?.bookTitleLabel.text = titleName
            }
            .store(in: &subscriptions)
    }
}
