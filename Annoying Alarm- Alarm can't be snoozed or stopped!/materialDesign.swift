//
//  materialDesign.swift
//  Annoying Alarm- Alarm can't be snoozed or stopped!
//
//  Created by Ali Abouelatta on 7/15/17.
//  Copyright © 2017 Ali Abouelatta. All rights reserved.
//

import UIKit

private var materialKey = false

extension UIView {
    
    @IBInspectable var materialDesign: Bool {
        
        get {
            
            return materialKey
        }
        
        set {
            
            materialKey = newValue
            
            if materialKey {
                
                self.layer.masksToBounds = false
                self.layer.cornerRadius = 3.0
                self.layer.shadowOpacity = 0.2
                self.layer.shadowRadius = 5.0
                self.layer.shadowOffset = CGSize(width: 1.0, height: 0)
                self.layer.shadowColor = UIColor(red: 120/255, green: 120/255, blue: 120/255, alpha: 120/255).cgColor
                
            } else {
                
                self.layer.cornerRadius = 0
                self.layer.shadowOpacity = 0
                self.layer.shadowRadius = 0
                self.layer.shadowColor = nil
            }
            
        }
        
    }
    
}
