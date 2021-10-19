//
//  UIColor+Extension.swift
//  ToDoList
//
//  Created by Burak on 17.10.2021.
//

import UIKit

extension UIColor {
    struct Custom {
        
        static var stackViewBackgroundColor : UIColor {
            return UIColor.init {(trait) -> UIColor in
                return trait.userInterfaceStyle == .dark ? UIColor.systemGray4.withAlphaComponent(0.3) : UIColor.white
            }
        }
        
        static var generalBackgroundColor : UIColor {
            return UIColor.init {(trait) -> UIColor in
                return trait.userInterfaceStyle == .dark ? UIColor.black : UIColor.tertiarySystemGroupedBackground
            }
        }
    }
}
