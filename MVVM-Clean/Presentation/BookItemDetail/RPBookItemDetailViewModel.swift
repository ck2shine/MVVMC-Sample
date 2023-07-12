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

public protocol RPBookItemDetailViewModelInput {}

public protocol RPBookItemDetailViewModelOutput {
    var bookTitleNamePublisher: CurrentValueSubject<String?, Never> { get set }
    var bookDescriptionPublisher: CurrentValueSubject<String?, Never> { get set }
}

public protocol RPBookItemDetailViewModelManager {
    var input: RPBookItemDetailViewModelInput { get }
    var output: RPBookItemDetailViewModelOutput { get }
}

public class RPBookItemDetailViewModel: RPBookItemDetailViewModelInput, RPBookItemDetailViewModelOutput, RPBookItemDetailViewModelManager {
  
    
    //output
    public var bookTitleNamePublisher =  CurrentValueSubject<String?, Never>(nil)
    public var bookDescriptionPublisher = CurrentValueSubject<String?, Never>(nil)
    
    
    public var entity: RPBookItemDetailEntity?

    private var subscription = Set<AnyCancellable>()
    private let useCase: RPBookItemDetailUseCase

    public init(usecase: RPBookItemDetailUseCase , entity: RPBookItemDetailEntity? = nil) {
        self.useCase = usecase
        self.entity = entity
        self.initializeAction()
    }

    public var input: RPBookItemDetailViewModelInput {
        return self
    }

    public var output: RPBookItemDetailViewModelOutput {
        return self
    }

    /// input

    /// output
}

extension RPBookItemDetailViewModel {
    private func initializeAction() {
        bookTitleNamePublisher.value = entity?.bookName
        bookDescriptionPublisher.value = entity?.bookDescription
    }
}
