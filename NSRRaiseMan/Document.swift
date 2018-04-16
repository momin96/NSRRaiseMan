//
//  Document.swift
//  NSRRaiseMan
//
//  Created by Nasir Ahmed Momin on 27/03/18.
//  Copyright © 2018 Nasir Ahmed Momin. All rights reserved.
//

import Cocoa

class Document: NSDocument {

    @objc dynamic var employees : [NSREmployee] = []

    @IBOutlet weak var arraController : NSArrayController!
    
    override init() {
        super.init()
        // Add your subclass-specific initialization here.
    }

    override class var autosavesInPlace: Bool {
        return true
    }

    override func makeWindowControllers() {
        // Returns the Storyboard that contains your Document window.
        let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
        let windowController = storyboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier("Document Window Controller")) as! NSWindowController
        self.addWindowController(windowController)
    }

    override func data(ofType typeName: String) throws -> Data {
        // Insert code here to write your document to data of the specified type. If outError != nil, ensure that you create and set an appropriate error when returning nil.
        // You can also choose to override fileWrapperOfType:error:, writeToURL:ofType:error:, or writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.
        
        
        return NSKeyedArchiver.archivedData(withRootObject:employees)
        
//        throw NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
    }

    override func read(from data: Data, ofType typeName: String) throws {
        // Insert code here to read your document from the given data of the specified type. If outError != nil, ensure that you create and set an appropriate error when returning false.
        // You can also choose to override readFromFileWrapper:ofType:error: or readFromURL:ofType:error: instead.
        // If you override either of these, you should also override -isEntireFileLoaded to return false if the contents are lazily loaded.
//        throw NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
        employees = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as! [NSREmployee]
    }

    
    @objc func insertObject(_ employee : NSREmployee, inEmployeesAtIndex index : Int) {
        
        let undo : UndoManager = undoManager!
        let target = undo.prepare(withInvocationTarget: self) as? Document
        target?.removeObjectFromEmployeesAtIndex(index)
        if !undo.isUndoing {
            undo.setActionName("Remove person")
        }
        
        employees.insert(employee, at: index)
    }

    @objc func removeObjectFromEmployeesAtIndex(_ index : Int) {
        let employee = employees[index]
        
        let undo : UndoManager = undoManager!
        let target = undo.prepare(withInvocationTarget: self) as AnyObject
        target.insertObject(employee, inEmployeesAtIndex: index)
        if !undo.isUndoing {
            undo.setActionName("Add Person")
        }
                
        employees.remove(at: index)
    }
    
    
    @IBAction func removeEmployees(sender : NSButton) {
        let selectedPeople = arraController.selectedObjects as! [NSREmployee]
        let alert = NSAlert()
        alert.messageText = "Do you really want to remove these peoples"
        alert.informativeText = "\(selectedPeople.count) people will be removed"
        
        alert.addButton(withTitle: "Remove")
        alert.addButton(withTitle: "Cancel")
        
        let window = sender.window!
        alert.beginSheetModal(for: window) { (response) in
                switch response {
                case .alertFirstButtonReturn :
                    self.arraController.remove(nil)
                default: break
            }
        }
    }
    
}

