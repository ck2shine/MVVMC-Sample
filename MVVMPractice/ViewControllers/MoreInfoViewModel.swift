//
//  MoreInfoViewModel.swift
//  MVVMPractice
//
//  Created by i9400503 on 2019/6/20.
//  Copyright © 2019 Brille. All rights reserved.
//

import Foundation

class MoreInfoViewModel {
    
    var saveName : String?
    
    var showName : Box<String>? = Box("")
    
}

extension MoreInfoViewModel
{
    func setupAllData()
    {
        self.showName?.value = saveName ?? ""
    }
}
