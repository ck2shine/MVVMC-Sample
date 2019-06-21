//
//  StudentViewModel.swift
//  MVVMPractice
//
//  Created by i9400503 on 2019/6/20.
//  Copyright © 2019 Brille. All rights reserved.
//

import Foundation

//MARK Cell Protocol for classifing cell
protocol StudentModel {
    
}

protocol viewModelPress {
    var  objectPress : (()->())? { get set }
}
