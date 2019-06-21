//
//  Box.swift
//  MVVMPractice
//
//  Created by i9400503 on 2019/6/20.
//  Copyright © 2019 Brille. All rights reserved.
//

import Foundation

class Box<T> {
    
    typealias Listener = (T)->()
    
    var listener : Listener?
    
    var value : T {
        didSet {
            listener?(value)
        }
    }
    
    init(_ value : T) {
       
        self.value = value
    }
    
    func binding( listener : Listener?){
        self.listener = listener
            listener?(value)
    }
    
    func unbind(){
        self.listener = nil
    }
}
