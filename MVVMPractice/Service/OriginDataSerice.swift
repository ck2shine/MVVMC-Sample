//
//  OriginDataSerice.swift
//  MVVMPractice
//
//  Created by i9400503 on 2019/6/20.
//  Copyright © 2019 Brille. All rights reserved.
//

import Foundation

class OriginDataSerice
{
    
    private lazy var studentDatas : [StudentInfo] = {
        let datas : [StudentInfo] = (0...10).map({ (idx) in
            if idx % 3 == 0
            {
                return NormalStudent(ID: String(idx), Name: "Normal\(idx)", UniteExamGrade: String(idx), HighSchoolName: "School\(idx)")
            }
            else
            {
               return  EcommendationStudent(ID: String(idx), Name: "Ecommend\(idx)", Rank: "Rank\(idx)", UniOrder: "Order\(idx)")
            }
        })
        return datas
    }()
    
    func fetchStudentData(complete : @escaping ([StudentInfo])->()){
        DispatchQueue.global().async {
            sleep(2)
            DispatchQueue.main.async {
                complete(self.studentDatas)
            }
        }
    }
    
}
