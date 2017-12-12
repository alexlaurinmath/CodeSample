//
//  measurementView.swift
//  CodeSample
//
//  Created by Alexandre Laurin on 12/11/17.
//  Copyright © 2017 Snacktime. All rights reserved.
//

import UIKit

class MeasurementView: UIView {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    @IBOutlet var contentView: UIView!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        self.autoresizesSubviews = true
        Bundle.main.loadNibNamed("MeasurementViewNib", owner: self, options: nil)
        contentView.frame = self.bounds
        addSubview(contentView)
        
    }

}
