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
import UIKit

public class AppIneractor{
    
    private var window: UIWindow?
    
    public init(window: UIWindow? = nil) {
        self.window = window
    }
    
    public func start(){
        self.startBookListProcess()
    }
    
    private func startBookListProcess(){
        
        let bookDIContrainer = BookListDependency(denpendency: BookListDependency.Dependency(bookListAPILoader: GeneralServiceLoader().bookListAPILoader()))
        
//
//        let bookDIContrainer = BookListFlowDIContainer(denpendency: BookListFlowDIContainer.Dependency(bookListAPILoader: GeneralServiceLoader().bookListAPILoader()))
    
       
        let rootViewController = BookListViewController(dependency: bookDIContrainer)
        self.window?.rootViewController = rootViewController
        self.window?.makeKeyAndVisible()
        
    }
    
}
