//
//  MemeModel.swift
//  MemeApp
//
//  Created by vasu on 28/10/18.
//  Copyright © 2018 Vasu. All rights reserved.
//

import Foundation
import UIKit


class MemeModel: NSObject{
    

        var toptext : String!
        var bottomText:String!
        var originalImages    : UIImage!
        var memedImage: UIImage!
        
        init(_ toptext :String, _ bottomText:String, _ originalImage:UIImage ,_ memedImage:UIImage) {
            
            self.toptext = toptext
            self.bottomText = bottomText
            self.originalImages = originalImage
            self.memedImage = memedImage
        }
  
    
}



    
