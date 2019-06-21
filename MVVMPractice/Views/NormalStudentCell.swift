//
//  NormalStudentCell.swift
//  MVVMPractice
//
//  Created by i9400503 on 2019/6/20.
//  Copyright © 2019 Brille. All rights reserved.
//

import UIKit

class NormalStudentCell: UITableViewCell  , StudentCell{
   
    var viewModel : NormalStudentViewModel?
    
    @IBOutlet weak var normalName: UILabel!
    
    @IBOutlet weak var schoolName: UILabel!
    
    @IBOutlet weak var ExamGrade: UILabel!
    
    func setupCell(viewModel: StudentModel) {
        guard  let viewModel = viewModel as? NormalStudentViewModel else {
            return
        }
        self.viewModel = viewModel
        self.normalName.text = viewModel.name
        self.schoolName.text = viewModel.schoolName
        self.ExamGrade.text = viewModel.ExamGrade
    }
}
