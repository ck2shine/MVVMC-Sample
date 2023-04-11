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
import Combine

public protocol BookListViewModelInput {
 
    var initialDataTrigger: PassthroughSubject<(),Never>{get}
 
    func updateBookTitleContent()
    
   
}
// Output
public protocol BookListViewModelOutput {
    
    var bookTitleText: CurrentValueSubject<String,Never>{get}

}
// Manager
public protocol BookListViewModelManager {
    // Input
    var input: BookListViewModelInput { get }
    // Output
    var output: BookListViewModelOutput { get }
}

public class BookListViewModel:BookListViewModelManager , BookListViewModelInput, BookListViewModelOutput{
    //input
    public var initialDataTrigger: PassthroughSubject<(), Never> = PassthroughSubject()
   
    //output
    public var bookTitleText: CurrentValueSubject<String, Never> = CurrentValueSubject("default bookName")
    
    
    public var input: BookListViewModelInput{
        return self
    }
    
    public var output: BookListViewModelOutput{
        return self
    }
    
    private var useCase: BookListUseCase
    
    public init(useCase: BookListUseCase){
        self.useCase = useCase
        initializeAction()
    }
    
    //MARK: initializeActions
    private func initializeAction(){
        
    }
}

//input actions
extension BookListViewModel{
    
    //MARL: update book title
    public final func updateBookTitleContent() {
        
    }
}


