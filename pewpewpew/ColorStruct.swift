//
//  colorStruct.swift
//  QuotesEZ
//
//  Created by Gabriel Querbes on 10/6/15.
//  Copyright © 2015 The Modern Tech. All rights reserved.
//

import Foundation
import UIKit
//start of ColorStruct
struct ColorStruct{
    //ColorArray is an array of different colors, each with their own values for RGB and alpha
    let colorArray = [
        UIColor(red:244/255.0, green: 241/255.0, blue: 187/255.0, alpha:1.0),
        UIColor(red:155/255.0, green: 193/255.0, blue: 188/255.0, alpha:1.0),
        UIColor(red:92/255.0, green: 164/255.0, blue: 169/255.0, alpha:1.0),
        UIColor(red:230/255.0, green: 235/255.0, blue: 224/255.0, alpha:1.0),
       
    ]
    
    
    //function to get return one of the above generated colors
    func getRandomColor() ->UIColor{
        let randomNumber = Int(arc4random_uniform(UInt32(colorArray.count)))
        return colorArray[randomNumber]
    }
    
    
}

