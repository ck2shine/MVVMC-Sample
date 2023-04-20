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

public protocol BookListViewModelInput {
 
    var refreshButtonClick: PassthroughSubject<Void, Never> { get }
        
    func updateBookTitleContent()
}

// Output
public protocol BookListViewModelOutput {
    var bookTitleText: CurrentValueSubject<String, Never> { get }
    
    var _bookItems: [BookItemViewModelProtocol]{ get }
    
//    var loadItem: CurrentValueSubject<[BookItemViewModelProtocol], Never> { get }
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
    public var refreshButtonClick: PassthroughSubject<Void, Never> = .init()
   
    // output
    @Published public var _bookItems: [BookItemViewModelProtocol] = []
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
        refreshButtonClick
            .setFailureType(to: Error.self)
            .flatMap { _ in
                self.useCase.fetchBookItems()
            }.sink { error in
                print("error \(error)")
            } receiveValue: { bookItem in
//             
            }
            .store(in: &subscription)
    }
}

// input actions
public extension BookListViewModel {
    // MARL: update book title
    final func updateBookTitleContent() {}
}
