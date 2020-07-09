//
//  BorderView.swift
//  SportsCardScanAppSwift
//
//  Created by Superpower on 29/06/20.
//  Copyright © 2020 iMac superpower. All rights reserved.
//

import Foundation
import UIKit


class BorderView: NSObject, NSCoding {

    var id: Int!
    var x: CGFloat!
    var y: CGFloat!
    var scale: CGFloat!
    
    
    init(id: Int, x: CGFloat, y: CGFloat, scale: CGFloat) {
        self.id = id
        self.x = x
        self.y = y
        self.scale = scale
    }
    
    required init!(coder aDecoder: NSCoder) {
        
        self.id = (aDecoder.decodeObject(forKey: "id") as! Int)
        self.x = (aDecoder.decodeObject(forKey: "x") as! CGFloat)
        self.y = (aDecoder.decodeObject(forKey: "y") as! CGFloat)
        self.scale = (aDecoder.decodeObject(forKey: "scale") as! CGFloat)
        
        super.init()
       }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(x, forKey: "x")
        aCoder.encode(y, forKey: "y")
        aCoder.encode(scale, forKey: "scale")
    }

}


class SaveUtil {
    
    static func saveBorder(borderview: BorderView) {
        
        print("Border Saved")

        let defaults =  UserDefaults.standard
        guard let encodedData = try? NSKeyedArchiver.archivedData(withRootObject: borderview, requiringSecureCoding: false) //archivedData(withRootObject: category as Array, requiringSecureCoding: false) as NSData
                else {
            fatalError("Can't encode data")
        }
                               
        defaults.set(encodedData, forKey: "borderview1XY")
        
    }

    static func loadBorder() -> BorderView  {
        
        let defaults =  UserDefaults.standard
        
        let data = defaults.data(forKey: "borderview1XY")
        
        return try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data!) as! BorderView
    }
    
    static func saveBorder2(borderview: BorderView) {
        
        print("Border2 Saved")

        let defaults =  UserDefaults.standard
        guard let encodedData = try? NSKeyedArchiver.archivedData(withRootObject: borderview, requiringSecureCoding: false) //archivedData(withRootObject: category as Array, requiringSecureCoding: false) as NSData
                else {
            fatalError("Can't encode data")
        }
                               
        defaults.set(encodedData, forKey: "borderview2XY")
        
    }

    static func loadBorder2() -> BorderView  {
        
        let defaults =  UserDefaults.standard
        
        let data = defaults.data(forKey: "borderview2XY")
        
        return try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data!) as! BorderView
    }
    
    
    
    static func saveBorder3(borderview: BorderView) {
           
           print("Border3 Saved")

           let defaults =  UserDefaults.standard
           guard let encodedData = try? NSKeyedArchiver.archivedData(withRootObject: borderview, requiringSecureCoding: false) //archivedData(withRootObject: category as Array, requiringSecureCoding: false) as NSData
                   else {
               fatalError("Can't encode data")
           }
                                  
           defaults.set(encodedData, forKey: "borderview3XY")
           
       }

       static func loadBorder3() -> BorderView  {
           
           let defaults =  UserDefaults.standard
           
           let data = defaults.data(forKey: "borderview3XY")
           
           return try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data!) as! BorderView
       }
    
    static func saveBorder4(borderview: BorderView) {
              
              print("Border4 Saved")

              let defaults =  UserDefaults.standard
              guard let encodedData = try? NSKeyedArchiver.archivedData(withRootObject: borderview, requiringSecureCoding: false) //archivedData(withRootObject: category as Array, requiringSecureCoding: false) as NSData
                      else {
                  fatalError("Can't encode data")
              }
                                     
              defaults.set(encodedData, forKey: "borderview4XY")
              
          }

          static func loadBorder4() -> BorderView  {
              
              let defaults =  UserDefaults.standard
              
              let data = defaults.data(forKey: "borderview4XY")
              
              return try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data!) as! BorderView
          }
    
    
}



