//
//  EcommendationStudentCell.swift
//  MVVMPractice
//
//  Created by i9400503 on 2019/6/20.
//  Copyright © 2019 Brille. All rights reserved.
//

import UIKit

class EcommendationStudentCell: UITableViewCell  , StudentCell {
   
    
    var viewModel : EcommendationStudentViewModel?
    
   
  
    @IBOutlet weak var EcoStudentName: UILabel!
    @IBOutlet weak var Rank: UILabel!
    //MARK:更多資訊
    @IBAction func moreInfo(_ sender: Any) {
        viewModel?.moreInfoPress?()
    }
    
    @IBOutlet weak var moreInfoBtn: UIButton!
    
    
    func setupCell(viewModel: StudentModel) {
        guard let viewModel = viewModel as? EcommendationStudentViewModel else {
            return
        }
        self.viewModel = viewModel
        self.EcoStudentName.text = viewModel.EcoStudentName
        self.Rank.text = viewModel.Rank
    }
}
