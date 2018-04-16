//
//  NSREmployee.swift
//  NSRRaiseMan
//
//  Created by Nasir Ahmed Momin on 27/03/18.
//  Copyright © 2018 Nasir Ahmed Momin. All rights reserved.
//

import Cocoa

class NSREmployee: NSObject, NSCoding {

    
    @objc dynamic var name : String = "New Employee"
    @objc dynamic var raise : Float = 0.05
    
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(raise, forKey: "raise")
    }
    
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "name") as! String
        raise = aDecoder.decodeFloat(forKey: "raise") as Float
        super.init()
    }
    
    override init() {
        super.init()
    }
    
    func validateRaise(raiseNumberPointer : AutoreleasingUnsafeMutablePointer<NSNumber?>, error outError: NSErrorPointer) -> Bool {
        let raiseNumber = raiseNumberPointer.pointee
        if raiseNumber == nil {
            let domain = "UserInputValidationErrorDomain"
            let code = 0
            let userInfo = [NSLocalizedDescriptionKey : "An employee's raise must be an number"]
            outError?.pointee = NSError(domain: domain, code: code, userInfo: userInfo);
            return false;
        }
        else {
            return true;
        }
    }
    
    
    
    
    
    
    
    
}
