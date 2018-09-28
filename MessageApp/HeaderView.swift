//
//  HeaderView.swift
//  MessageApp
//
//  Created by Sharon  Macasaol on 9/26/18.
//  Copyright © 2018 Sharon  Macasaol. All rights reserved.
//

import Foundation
import UIKit

class HeaderView: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var logoutView: UIView!
    @IBOutlet weak var logoutBtn: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("HeaderView", owner: self, options: nil)
        self.addSubview(self.contentView)
        self.contentView.frame = self.bounds
        self.contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.layoutIfNeeded()
        self.logoutView.layer.cornerRadius = 8
    }
    
    
}
