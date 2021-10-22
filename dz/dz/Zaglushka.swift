//
//  Zaglushka.swift
//  dz
//
//  Created by Марк Некрашевич on 21.10.2021.
//  Copyright © 2021 Mark Nekrashevich. All rights reserved.
//

import UIKit

class Zaglushka: UIView {
    let nibName = "Zaglushka"
    var contentView: UIView?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        self.addSubview(view)
        contentView = view
    }
    
    func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
}
    
