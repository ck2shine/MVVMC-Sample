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
public protocol BookListFlowDependency {
    func createBookListViewController() -> UIViewController
}

public class BookListFlowDIContainer: BookListFlowDependency {
    private var denpendency: Dependency
    
    public struct Dependency {
        var bookListAPILoader: DataServiceLoader
    }
    
    public init(denpendency: Dependency) {
        self.denpendency = denpendency
    }
}

public extension BookListFlowDIContainer {
    func createBookListViewController() -> UIViewController {
        let repository = BookListDefaultRepository(bookListServiceLoader: denpendency.bookListAPILoader)
        let useCase = BookListDefaultUseCase(repository: repository)
        let viewModel = BookListViewModel(useCase: useCase)
        let view = BookListViewController(viewModel: viewModel)
        return view
    }
}
