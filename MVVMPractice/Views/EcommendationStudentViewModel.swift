//
//  EcommendationStudentViewModel.swift
//  MVVMPractice
//
//  Created by i9400503 on 2019/6/20.
//  Copyright © 2019 Brille. All rights reserved.
//

import Foundation

class EcommendationStudentViewModel : StudentModel
{    

    var EcoStudentName : String?
    var Rank : String?
    var moreInfoPress : (()->())?
    
    init(EcoStudentName : String , Rank : String , moreInfoPress : (()->())? = nil) {
        self.EcoStudentName = EcoStudentName
        self.Rank = Rank
        self.moreInfoPress = moreInfoPress
    }
}
