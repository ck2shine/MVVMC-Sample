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
    
    private lazy var loadingActiviy: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView(style: .large)
        return activity
    }()
    
    private lazy var bookListTableView: UITableView = {
        let tableView = UITableView()
        
        return tableView
    }()
    
    private lazy var bookTitleLabel: UILabel = {
        let lable = UILabel()
        lable.font = UIFont.boldSystemFont(ofSize: 20)
        lable.textAlignment = .center
        lable.textColor = .black
        lable.text = "This is book title"
        return lable
    }()
    
    private lazy var searchButton: UIButton = {
        let button = UIButton()
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 5
        button.layer.borderColor = UIColor.systemGray.cgColor
        button.setTitle("Refresh", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    private var dependency: ContainerDependency
    
    private var viewModel: BookListViewModel
    
    public init(dependency: ContainerDependency) {
        self.dependency = dependency
        guard let viewModel = dependency.resolve(BookListViewModel.self) else {
            fatalError("cano not find viewModel")
        }
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
        viewModel.input.refreshTableContent.send(())
    }
}

public extension BookListViewController {
    private func setupUI() {
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
        bookListTableView.register(BookImageCell.self, forCellReuseIdentifier: BookImageCell.identifier)
        
        
        view.addSubview(loadingActiviy)
        loadingActiviy.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
    }
    
    private func initializeBinding() {
        // input
        searchButton
            .publisher(for: .touchUpInside)
            .sink { [unowned self] in
                self.viewModel.input.refreshTableContent.send(())
            }
            .store(in: &subscriptions)
        
        // output
        let output = viewModel.output
        
        // label binding
        output.bookTitleText
            .sink { [unowned self] titleName in
                self.bookTitleLabel.text = titleName
            }
            .store(in: &subscriptions)
        
        // tableview binding
        output.bookItemsPublisher
            .dropFirst()
            .sink { [unowned self] _ in
                self.bookListTableView.reloadData()
            }
            .store(in: &subscriptions)
        
        output.activityItemPublisher
            .sink { [unowned self] in
                if $0 {
                    self.loadingActiviy.startAnimating()
                }else{
                    self.loadingActiviy.stopAnimating()
                }
            }
            .store(in: &subscriptions)
        
        output.bookDetailItemPublisher
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink {[weak self] itemDetailEntity in
                guard let self = self else {return}
                if let entity = itemDetailEntity{
                    self.dependency.register(entity)
                }
       
                let view = RPBookItemDetailViewController(dependency: self.dependency)
                self.navigationController?.pushViewController(view, animated: true)
            }
            .store(in: &subscriptions)
    }
}

extension BookListViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.bookItemsPublisher.value.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: BookImageCell.identifier, for: indexPath)
        
        let cellViewModel = viewModel.bookItemsPublisher.value[indexPath.row]
        if let bookImageCell = cell as? BookCellSettingProtocol{
            bookImageCell.setupCell(cellViewModel)
        }
        
        cell.selectionStyle = .none
        
        return cell
    }
}

extension BookListViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellHeight = self.viewModel.bookItemsPublisher.value[indexPath.row].cellHeight
        return cellHeight
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.viewModel.input.itemSelectedTrigger.send(indexPath.row)
    }
}
