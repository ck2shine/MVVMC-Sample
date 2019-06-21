//
//  StudentDataViewController.swift
//  MVVMPractice
//
//  Created by i9400503 on 2019/6/20.
//  Copyright © 2019 Brille. All rights reserved.
//

import UIKit

class StudentDataViewController: UIViewController {
    
    //初始化viewModel
    lazy var viewModel : StudentDataViewModel = StudentDataViewModel()
    
    @IBOutlet weak var dataNameTitle: UILabel!
    @IBOutlet weak var dataTable: UITableView!
    @IBOutlet weak var loadingActivity: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //init UI
        setupUI()
        
        //binding
        binding()
        
        //fetch Data
        self.viewModel.getStudentData()
        
      
    }
    
    func binding(){
        //TITLE
        self.viewModel.viewTitle?.binding(listener: { [unowned self ] (title) in
            self.dataNameTitle.text = title
        })
        
        //Table
        self.viewModel.datas.binding(listener: { [unowned self ] (data) in
            self.dataTable.reloadData()
        })
        
        //Loading activity
        self.viewModel.isLoading?.binding(listener: { [unowned self ] (isload) in
            if isload
            {
                self.loadingActivity.startAnimating()
            }
            else
            {
                self.loadingActivity.stopAnimating()
                self.loadingActivity.isHidden = true
            }
        })
        
        self.viewModel.loadToNextPage?.binding(listener: { [unowned self ](goNext) in
            if goNext
            {
                self.performSegue(withIdentifier: "toMore", sender: nil)
            }
       
        })
    }
    
    
    func setupUI(){
        
        self.dataTable.register(  UINib(nibName: "NormalStudentCell", bundle: nil), forCellReuseIdentifier: "NormalStudentCell")
        self.dataTable.register(  UINib(nibName: "EcommendationStudentCell", bundle: nil), forCellReuseIdentifier: "EcommendationStudentCell")
        
        self.dataTable.delegate = self
        self.dataTable.dataSource = self
    }
}

extension StudentDataViewController : UITableViewDataSource , UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.datas.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let studentCellModel = self.viewModel.datas.value[indexPath.row]
        
        let cellIndentify =  self.viewModel.getCellIndentifier(cellViewModel: studentCellModel)
        
        let cell =  tableView.dequeueReusableCell(withIdentifier: cellIndentify, for: indexPath)
        
        if let cell = cell as? StudentCell
        {
            cell.setupCell(viewModel: studentCellModel)
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellViewModel = self.viewModel.datas.value[indexPath.row]
        
        //if cell has registered the press action
        if let cellViewModel = cellViewModel as? viewModelPress
        {
            cellViewModel.objectPress?()
        }
        
    }
}


extension StudentDataViewController
{
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMore" , let vc = segue.destination as? MoreInfoUIViewController
        {           
            vc.viewModel.saveName = self.viewModel.nextStudentName!
        }
    }
}
