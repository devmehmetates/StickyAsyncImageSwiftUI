//
// Double + Ext.swift
//  
//
//  Created by Mehmet Ateş on 10.10.2022.
//

import SwiftUI

extension Double {
    var relativeToWidth: Double { return (UIScreen.main.bounds.size.width * self) / 100 }
    var relativeToHeight: Double { return (UIScreen.main.bounds.size.height * self) / 100 }
}
