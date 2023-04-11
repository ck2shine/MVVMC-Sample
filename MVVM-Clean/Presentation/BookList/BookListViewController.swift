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
        return lable
    }()
    
    public lazy var searchButton: UIButton = {
        let button = UIButton()
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 5
        button.layer.borderColor = UIColor.systemGray.cgColor
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
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-20)
            $0.width.equalTo(130)
            $0.height.equalTo(50)
        }
        
        view.addSubview(bookTitleLabel)
        bookTitleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.height.equalTo(searchButton.snp.height)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(10)
            $0.trailing.equalTo(searchButton.snp.leading).offset(-10)
        }
        
        view.addSubview(bookListTableView)
        bookListTableView.snp.makeConstraints {
            $0.top.equalTo(searchButton.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(10)
            $0.bottom.equalToSuperview().offset(-10)
            $0.trailing.equalToSuperview().offset(-10)
        }
        
        bookListTableView.delegate = self
        bookListTableView.dataSource = self
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

extension BookListViewController: UITableViewDataSource{
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.textLabel!.text = "Title text"
          cell.imageView!.image = UIImage(named: "bunny")
          return cell
    }
    
    
}

extension BookListViewController: UITableViewDelegate{
    
}
