//
//  MoreInfoUIViewController.swift
//  MVVMPractice
//
//  Created by i9400503 on 2019/6/20.
//  Copyright © 2019 Brille. All rights reserved.
//

import UIKit

class MoreInfoUIViewController: UIViewController {

    lazy var viewModel :MoreInfoViewModel = MoreInfoViewModel()
    
    @IBOutlet weak var StudentName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        binding()
        
         self.viewModel.setupAllData()
    }   
    
    func binding(){
        self.viewModel.showName?.binding(listener: { [unowned self] (StudentName) in
            self.StudentName.text = StudentName
        })
    }

  

}
