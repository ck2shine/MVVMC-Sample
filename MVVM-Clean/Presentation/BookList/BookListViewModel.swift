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

// Input
public protocol BookListViewModelInput {
    var refreshTableContent: PassthroughSubject<Void, Never> { get }

    func updateBookTitleContent()

    var itemSelectedTrigger: PassthroughSubject<Int, Never> { get }
}

// Output
public protocol BookListViewModelOutput {
    var bookTitleText: CurrentValueSubject<String, Never> { get }

    var bookItemsPublisher: AnyPublisher<[BookItemViewModelProtocol], Never> { get }

    var activityItemPublisher: AnyPublisher<Bool, Never> { get }
    
    var bookDetailItemPublisher: AnyPublisher<RPBookItemDetailEntity?, Never>{ get }
}

// Manager
public protocol BookListViewModelManager {
    // Input
    var input: BookListViewModelInput { get }
    // Output
    var output: BookListViewModelOutput { get }
}

public class BookListViewModel: BookListViewModelManager, BookListViewModelInput, BookListViewModelOutput {
    @Published private var _activityItem: Bool = false
    public var activityItemPublisher: AnyPublisher<Bool, Never> {
        return $_activityItem.eraseToAnyPublisher()
    }

    // private variables
    @Published public var _bookItems: [BookItemViewModelProtocol] = []
    @Published private var _bookDetailItem: RPBookItemDetailEntity?
    // input
    public var refreshTableContent: PassthroughSubject<Void, Never> = .init()
    public var startLoadingActivity: PassthroughSubject<Bool, Never> = .init()
    public var itemSelectedTrigger: PassthroughSubject<Int, Never> = .init()

    // output
    public var bookItemsPublisher: AnyPublisher<[BookItemViewModelProtocol], Never> {
        return $_bookItems.eraseToAnyPublisher()
    }

    public var bookDetailItemPublisher: AnyPublisher<RPBookItemDetailEntity?, Never> {
        return $_bookDetailItem.eraseToAnyPublisher()
    }

    public var bookTitleText: CurrentValueSubject<String, Never> = CurrentValueSubject("default bookName")

    let buttonTapped = PassthroughSubject<Void, Never>()
    public var input: BookListViewModelInput {
        return self
    }

    public var output: BookListViewModelOutput {
        return self
    }

    private var subscription = Set<AnyCancellable>()
    private var useCase: BookListUseCase

    public init(useCase: BookListUseCase) {
        self.useCase = useCase
        initializeAction()
    }

    // MARK: initializeActions

    private func initializeAction() {
        // binding tableview event
        self.refreshTableContent
            .setFailureType(to: Error.self)
            .flatMap { [unowned self] _ in
                self._activityItem = true
                return self.useCase.fetchBookItems()
            }.sink { error in
                print("error \(error)")
            } receiveValue: { [unowned self] bookItems in
                let model = BookListModel()
                let items = model.convertDataToModels(entity: bookItems)
                self._bookItems = items
                self._activityItem = false
            }
            .store(in: &subscription)

        self.itemSelectedTrigger
            .sink { [weak self] index in
                guard let self = self else { return }
                let model = BookListModel()
                if let cellViewModel = self._bookItems[index] as? BookImageCellViewModel {
                    self._bookDetailItem = model.converToBookItemDetailEntity(cellViewModel: cellViewModel)
                }
            }
            .store(in: &subscription)
    }
}

// input actions
public extension BookListViewModel {
    // MARL: update book title
    final func updateBookTitleContent() {}
}
