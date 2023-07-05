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
import NetworkInfra
import UIKit

public protocol ContainerDependency {
    func resolve<Service>(_ type: Service.Type) -> Service?
    func register<Service>(_ item: Service)
}

public class BookListDependency: ContainerDependency {
    private let container = Container()
    public struct Dependency {
        public init(bookListAPILoader: DataServiceLoader) {
            self.bookListAPILoader = bookListAPILoader
        }

        var bookListAPILoader: DataServiceLoader
    }

    private var denpendency: Dependency
    public init(denpendency: Dependency) {
        self.denpendency = denpendency
        registerBookDependencies()
    }

    private func registerBookDependencies() {
        /// register bookList
        container.register(forKey: BookListViewModel.self) {
//            let repository = BookListDefaultRepository(bookListServiceLoader: self.denpendency.bookListAPILoader)
            let repository = BookListMockDefaultRepository()

            let useCase = BookListDefaultUseCase(repository: repository)
            let viewModel = BookListViewModel(useCase: useCase)
            return viewModel
        }

        // register bookDetail
        container.register(forKey: RPBookItemDetailViewModel.self) { [weak self] in

//            let repository = BookListDefaultRepository(bookListServiceLoader: self.denpendency.bookListAPILoader)
            let repository = RPBookItemDetailDefaultRepository()
            let entity = self?.container.resolve(forKey: RPBookItemDetailEntity.self)
            let useCase = RPBookItemDetailDefaultUseCase(repository: repository)
            let viewModel = RPBookItemDetailViewModel(usecase: useCase, entity: entity)
            return viewModel
        }
    }

    public func register<Service>(_ item: Service) {
        container.register(forKey: Service.self) {
            item
        }
    }

    public func resolve<Service>(_ type: Service.Type) -> Service? {
        return container.resolve(forKey: type)
    }
}
