//
//  NormalStudentViewModel.swift
//  MVVMPractice
//
//  Created by i9400503 on 2019/6/20.
//  Copyright © 2019 Brille. All rights reserved.
//

import Foundation

class NormalStudentViewModel : StudentModel , viewModelPress
{
    var objectPress: (() -> ())?
    
    var name : String?
    var schoolName : String?
    var ExamGrade : String?
    
    init(name : String , schoolName : String , ExamGrade : String ) {
        self.name = name
        self.schoolName = schoolName
        self.ExamGrade = ExamGrade
    }
}
