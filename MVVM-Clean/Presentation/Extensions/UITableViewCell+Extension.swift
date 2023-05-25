//
//  UITableViewCell+Extension.swift
//  MVVM-Clean
//
//  Created by Chang, Chih Hsiang | Shine | RP on 2023/05/24.
//

import Foundation
import UIKit

extension UITableViewCell{
    public static var identifier: String{
        return .init(describing: Self.self)
    }
}
