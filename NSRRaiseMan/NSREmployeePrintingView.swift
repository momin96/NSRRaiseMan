//
//  NSREmployeePrintingView.swift
//  NSRRaiseMan
//
//  Created by Nasir Ahmed Momin on 19/04/18.
//  Copyright © 2018 Nasir Ahmed Momin. All rights reserved.
//

import Cocoa

private let font : NSFont = NSFont.userFixedPitchFont(ofSize: 12.0)!
private let textAttribute : [NSAttributedStringKey : Any] = [NSAttributedStringKey.font : font]
private let lineHeight : CGFloat = font.capHeight * 2

class NSREmployeePrintingView: NSView {

    let employees : [NSREmployee]
    
    var pageRect = NSRect()
    var linesPerPage : Int = 0
    var currentpage : Int = 0
    
    // MARK: Life cycle
    
    init(employees : [NSREmployee]) {
        self.employees = employees
        super.init(frame: NSRect())
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
    
        var nameRect = NSRect(x: pageRect.minX, y: 0, width: 200.0, height: lineHeight)
        
        var raiseRect = NSRect(x: nameRect.maxX, y: 0, width: 100.0, height: lineHeight)
        
        for indexOnPage in 0..<linesPerPage {
            let indexInEmployees = currentpage * linesPerPage + indexOnPage
            
            if indexInEmployees >= employees.count {
                break
            }
            let employee = employees[indexInEmployees]
            
            nameRect.origin.y = pageRect.minY + CGFloat(indexOnPage) * lineHeight
            
            let employeesName = employee.name ?? ""
            let indexAndName = "\(indexInEmployees)  \(employeesName)" as NSString
            indexAndName.draw(in: nameRect, withAttributes: textAttribute)
        
            
            raiseRect.origin.y = nameRect.minY
            let raise = String.init(format: "%4.1f%%", employee.raise * 100)
            let raiseString = raise as NSString
            raiseString.draw(in: raiseRect, withAttributes: textAttribute)
            
            
        }
        
    }
    
    
    // MARK: pagination
    
    override func knowsPageRange(_ range: NSRangePointer) -> Bool {
        let printOperation = NSPrintOperation.current
        let printInfo : NSPrintInfo = (printOperation?.printInfo)!
        
        pageRect = printInfo.imageablePageBounds
        let newFrame = NSRect(origin: CGPoint(), size: printInfo.paperSize)
        frame = newFrame
        
        linesPerPage = Int(pageRect.height / lineHeight)
        
        var rangeOut = NSRange(location: 0, length: 0)
        
        rangeOut.location = 1
        
        rangeOut.length = employees.count / linesPerPage
        
        if employees.count % linesPerPage > 0 {
            rangeOut.length += 1
        }
        
//        range.memory =  rangeOut
        
        return true
    }
    
    override func rectForPage(_ page: Int) -> NSRect {
        currentpage = page - 1
        
        return pageRect
    }
    
    
    // MARK: Drawing
    
    override var isFlipped: Bool {
        return true
    }
    
    
    
}
