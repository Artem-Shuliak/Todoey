//
//  extensions.swift
//  Todoey
//
//  Created by Artem Chouliak on 4/14/21.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import UIKit
import ChameleonFramework

extension UILabel {
    func crossedOutString(text: String) -> NSMutableAttributedString {
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: text)
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
        return attributeString
    }
}

extension UINavigationItem {
    func customApperance(color: UIColor, label: String) {
        let appearance = UINavigationBarAppearance()
        
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = color
        appearance.titleTextAttributes = [.foregroundColor : ContrastColorOf(color, returnFlat: true)]
        appearance.largeTitleTextAttributes = [.foregroundColor : ContrastColorOf(color, returnFlat: true)]
        
        standardAppearance = appearance
        scrollEdgeAppearance = appearance
        compactAppearance = appearance
        
        // navigation elements
        title = label

    }
}

