//
//  StudentDataViewModel.swift
//  MVVMPractice
//
//  Created by i9400503 on 2019/6/20.
//  Copyright © 2019 Brille. All rights reserved.
//

import Foundation

class StudentDataViewModel {
    
    var viewTitle : Box<String>? = Box("")
    
    var datas : Box<[StudentModel]> = Box([StudentModel]())
    
    var isLoading : Box<Bool>? = Box(true)
    
    var loadToNextPage : Box<Bool>? = Box(false)
    
    var nextStudentName : String?
}

//MARK : functions
extension StudentDataViewModel
{
    func getStudentData(){
        //call net API
        OriginDataSerice().fetchStudentData(complete: { [weak self] (data)  in
            
            guard let self = self else {
                return
            }
            
            //把資料轉成viewModel
            self.buildAllCellViewModels(dataModels: data)
            self.viewTitle?.value = "指考成績名冊"
            self.isLoading?.value = false
           
        })
    }
    
    func buildAllCellViewModels(dataModels : [StudentInfo]){
        var tableDatas : [StudentModel] = [StudentModel]()
        //depend on sudentInfo Data trasfering to Cell Model
        for (idx , dataInfo) in dataModels.enumerated()
        {
            if let normalData = dataInfo as? NormalStudent
            {
                let cellViewModel = NormalStudentViewModel(name: normalData.Name ?? "", schoolName: normalData.HighSchoolName ?? "", ExamGrade: normalData.UniteExamGrade ?? "")
                cellViewModel.objectPress = {
                    print("touch to NormalStudent cell at index : \(idx)")
                }
                tableDatas.append(cellViewModel)
                
            }
            else if let ecoData = dataInfo as? EcommendationStudent
            {
                let cellViewModel = EcommendationStudentViewModel(EcoStudentName: ecoData.Name ?? "", Rank: ecoData.Rank ?? "")
                //bindind action for more info
                cellViewModel.moreInfoPress = {[weak self] in
                    guard let self = self else
                    {
                        return
                    }
                    self.nextStudentName = cellViewModel.EcoStudentName
                    self.loadToNextPage?.value = true
                }
                
                tableDatas.append(cellViewModel)
            }
        }
         self.datas.value = tableDatas
    }
    
    func getCellIndentifier(cellViewModel : StudentModel) -> String{
        switch cellViewModel {
        case is NormalStudentViewModel:
            return "NormalStudentCell"
        case is EcommendationStudentViewModel:
            return "EcommendationStudentCell"
        default:
            fatalError("error type: \(cellViewModel)")
        }        
    }
}
