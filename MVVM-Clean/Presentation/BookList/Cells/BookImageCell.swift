/*
 * Copyright (c) Rakuten Payment, Inc. All Rights Reserved.
 *
 * This program is the information asset which are handled
 * as "Strictly Confidential".
 * Permission of use is only admitted in Rakuten Payment, Inc.
 * If you don't have permission, MUST not be published,
 * broadcast, rewritten for broadcast or publication
 * or redistributed directly or indirectly in any medium.
 */

import UIKit
import Combine
public class BookImageCell: UITableViewCell , BookCellSettingProtocol{

    private var subscription = Set<AnyCancellable>()
    
    public var nibID: String = "BookImageCell"
    
    public var cellViewModel: BookItemViewModelProtocol?
    
    public func setupCell(_ viewModel: BookItemViewModelProtocol) {
        self.cellViewModel = viewModel
        if let model = self.cellViewModel as? BookImageCellViewModel{
            self.bindingUI(viewModel: model)
        }
    }
    
    private func bindingUI(viewModel: BookImageCellViewModel){
        viewModel.mainTitle
            .sink {[unowned self] titleStr in
                self.textLabel?.text = titleStr
            }
            .store(in: &subscription)
        
        viewModel.subTitle
            .sink {[unowned self] subTitle in
                self.detailTextLabel?.text = subTitle
            }
            .store(in: &subscription)
        
        viewModel.imageName
            .sink {[unowned self] imageName in
                if let name = imageName{
                    self.imageView?.image = UIImage(systemName: name)
                }
            }
            .store(in: &subscription)
    }
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: "BookImageCell")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    public override func prepareForReuse() {
        super.prepareForReuse()
        cellViewModel = nil
    }
    
}
