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

    var bookItemsPublisher: CurrentValueSubject<[BookItemViewModelProtocol], Never> { get }

    var activityItemPublisher: CurrentValueSubject<Bool, Never> { get }

    var bookDetailItemPublisher: CurrentValueSubject<RPBookItemDetailEntity?, Never> { get }
}

// Manager
public protocol BookListViewModelManager {
    // Input
    var input: BookListViewModelInput { get }
    // Output
    var output: BookListViewModelOutput { get }
}

public class BookListViewModel: BookListViewModelManager, BookListViewModelInput, BookListViewModelOutput {
    // input
    public var refreshTableContent: PassthroughSubject<Void, Never> = .init()
    public var startLoadingActivity: PassthroughSubject<Bool, Never> = .init()
    public var itemSelectedTrigger: PassthroughSubject<Int, Never> = .init()

    // output
    @Published public var activityItemPublisher = CurrentValueSubject<Bool, Never>(false)

    @Published public var bookItemsPublisher = CurrentValueSubject<[BookItemViewModelProtocol], Never>([])

    @Published public var bookDetailItemPublisher = CurrentValueSubject<RPBookItemDetailEntity?, Never>(nil)

    @Published public var bookTitleText = CurrentValueSubject<String, Never>("default bookName")

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
                self.activityItemPublisher.value = true
                return self.useCase.fetchBookItems()
            }.sink { error in
                print("error \(error)")
            } receiveValue: { [unowned self] bookItems in
                self.activityItemPublisher.value = false
                let model = BookListModel()
                let items = model.convertDataToModels(entity: bookItems)
                self.bookItemsPublisher.value = items
               
            }
            .store(in: &subscription)

        itemSelectedTrigger
            .sink { [weak self] index in
                guard let self = self else { return }
                let model = BookListModel()
                if let cellViewModel = self.bookItemsPublisher.value[index] as? BookImageCellViewModel {
                    self.bookDetailItemPublisher.value = model.converToBookItemDetailEntity(cellViewModel: cellViewModel)
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
