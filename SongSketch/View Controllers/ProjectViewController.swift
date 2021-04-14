//
//  ProjectViewController.swift
//  SongSketch
//
//  Created by Samuel Garry on 2/25/21.
//

import Foundation
import UIKit
import AVFoundation
import CoreData


class ProjectViewController: UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate {

    
    // Reference to managed object context -- CORE DATA
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //UI View Variables
    let leftSpacer = UIView()       //Spacer
    let midSpacer = UIView()        //Spacer
    let rightSpacer = UIView()      //Spacer
    let toolbarView = ToolbarView()

    
    //NEW STUFF
    var sectionViewControllers = [SectionViewController(0)] //Array of the six section view controllers
    //var sectionViewControllers: [SectionViewController] = []
    var sectionModels: [Section]?
    var sectionContainerView = UIView()
    var size: Int = 0
    var sizeSetter = UIView()
    
    //__________________________________________________________________________________________
    //Core Data Functions
    func checkIfEmpty(entity: String) -> Bool {
        var results: NSArray?
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        //var error = NSErrorPointer()

        do {
            results = try self.context.fetch(request) as NSArray
        } catch {
            
        }
        if let res = results {
            if res.count == 0 {
                return true
            }
            else {
                return false
            }
        }
        else {
            print("Error")
            return true
        }
    }
    
    
    func loadSectionsData() {
        for i in 1...6 {
            let section = Section(context: self.context)
            section.index = Int64(i)
            section.position = Int64(i)
            section.name = "Section \(i)"
            
            //Add the section model to the array of section models
            //sectionModels?.append(section)
            
            
            do {
                try self.context.save()
            } catch let err {
                fatalError("\(err)")
            }
        }
    }
    
    func getSections() {
        guard let sections = try! context.fetch(Section.fetchRequest()) as? [Section] else { return }
        
        sections.forEach( { print($0.name ?? "Section had no name") } )
    }
    
    func fetchSection(index: Int) {
        do {
            
        }
    }
    
    
    func fetchSections() {
        //fetch the sections from Core Data to display on screen
        do {
            self.sectionModels = try context.fetch(Section.fetchRequest())

            DispatchQueue.main.async {
                //self.
            }

        } catch let err{
            print(err)
        }
    }
    
    //End of Core Data Functions
    //__________________________________________________________________________________________
    //Loading View Functions
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor(red: 3/255, green: 50/255, blue: 105/255, alpha: 1)
        
        //Core Data Stuff
        //Create the six section models if they haven't been made yet (first load case scenario)
        if (checkIfEmpty(entity: "Section")) {
            loadSectionsData()
        }
        
        //Otherwise load up the sections
        
        
        //Print out the sections names
        getSections()

        //Create the toolbar and sections container
        createContainers()

        //Create spacer views
        createSpacers()
        
        //Create the empty view that determines the size of the section view controller children
        getSectionSize()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set the Delegate
        Conductor.shared.fileFinishedDelegate = self
        
        //Create the section view controllers
        var i = 1
        for row in 0..<3 {
            for column in 0..<2 {
                //setupSectionDataModels(0, i, "Section \(i)")
                setupSectionViewControllers(column, row, i, size)
                i += 1
            }
        }
        //Delete the Section 0 element of the section view controller array that was initialized first
        sectionViewControllers.removeFirst()
        
        //DELETE ME
        for i in 0..<sectionViewControllers.count {
            print ("Section: \(sectionViewControllers[i].tag)")
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        //Set the section view controllers' cell properties and set up its table view
        for i in 0..<sectionViewControllers.count {
            sectionViewControllers[i].cellSize = sizeSetter.frame.height
            //sections[i].configureTableView()
            sizeSetter.removeFromSuperview() //Delete the unnecessary view now that the size has been retreived
        }
    }
    
    //End of Loading View Functions
    //__________________________________________________________________________________________
    
    func createContainers() {
        //Container Views Set Up
        view.addSubview(sectionContainerView)
        //view.addSubview(topContainerView)
        view.addSubview(toolbarView)
        toolbarView.translatesAutoresizingMaskIntoConstraints = false
        sectionContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        
        //Toolbar Constraint Set up
        NSLayoutConstraint(item: toolbarView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: toolbarView, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: toolbarView, attribute: .height, relatedBy: .equal, toItem: view, attribute: .height, multiplier: 1/3, constant: 0).isActive = true
        
        
        //Section Container Constraint Set up
        NSLayoutConstraint(item: sectionContainerView, attribute: .top, relatedBy: .equal, toItem: toolbarView, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: sectionContainerView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: -50).isActive = true
        NSLayoutConstraint(item: sectionContainerView, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: sectionContainerView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
    }
    
    func createSpacers() {
        //Add spacers to the button view
        sectionContainerView.addSubview(leftSpacer)
        sectionContainerView.addSubview(midSpacer)
        sectionContainerView.addSubview(rightSpacer)
        
        //Spacer Constraints
        //left spacer
        leftSpacer.translatesAutoresizingMaskIntoConstraints = false
        leftSpacer.leadingAnchor.constraint(equalTo: sectionContainerView.leadingAnchor).isActive = true
        leftSpacer.widthAnchor.constraint(equalTo: sectionContainerView.widthAnchor, multiplier: 0.05).isActive = true
        leftSpacer.heightAnchor.constraint(equalTo: sectionContainerView.heightAnchor, multiplier: 1).isActive = true
        
        //mid spacer
        midSpacer.translatesAutoresizingMaskIntoConstraints = false
        midSpacer.centerXAnchor.constraint(equalTo: sectionContainerView.centerXAnchor).isActive = true
        midSpacer.widthAnchor.constraint(equalTo: sectionContainerView.widthAnchor, multiplier: 0.1).isActive = true
        midSpacer.heightAnchor.constraint(equalTo: sectionContainerView.heightAnchor, multiplier: 1).isActive = true
        
        //right spacer
        rightSpacer.translatesAutoresizingMaskIntoConstraints = false
        rightSpacer.trailingAnchor.constraint(equalTo: sectionContainerView.trailingAnchor).isActive = true
        rightSpacer.widthAnchor.constraint(equalTo: sectionContainerView.widthAnchor, multiplier: 0.05).isActive = true
        rightSpacer.heightAnchor.constraint(equalTo: sectionContainerView.heightAnchor, multiplier: 1).isActive = true
    }
    
    func getSectionSize() {
        view.addSubview(sizeSetter)
        sizeSetter.backgroundColor = .red
        sizeSetter.translatesAutoresizingMaskIntoConstraints = false
        sizeSetter.leadingAnchor.constraint(equalTo: leftSpacer.trailingAnchor).isActive = true
        sizeSetter.topAnchor.constraint(equalTo: sectionContainerView.topAnchor).isActive = true
        sizeSetter.widthAnchor.constraint(equalTo: sectionContainerView.widthAnchor, multiplier: 0.40).isActive = true
        sizeSetter.heightAnchor.constraint(equalTo: sectionContainerView.widthAnchor, multiplier: 0.40).isActive = true
    }
    
//    func setupSectionDataModels(_ position: Int, _ index: Int, _ name: String) {
//        let section = Section()
//        section.position = Int64(position)
//        section.index = Int64(index)
//        section.name = name
//
//        //Add the section model to the array of section models
//        sectionModels?.append(section)
//    }

    //Set up the section view controllers
    func setupSectionViewControllers(_ column: Int, _ row: Int, _ index: Int, _ size: Int) {
        let section = SectionViewController(index)
        sectionViewControllers.append(section)
        
        //Add the section to the section array for accessing/modifying later
        self.add(sectionViewControllers[index], CGRect(width: size, height: size))
        
        //Set up the initial constraints
        sectionViewControllers[index].view.translatesAutoresizingMaskIntoConstraints = false

        if column == 0 {
            sectionViewControllers[index].view.leadingAnchor.constraint(equalTo: leftSpacer.trailingAnchor).isActive = true
        }
        else {
            sectionViewControllers[index].view.leadingAnchor.constraint(equalTo: midSpacer.trailingAnchor).isActive = true
        }
        if row == 0 {
            sectionViewControllers[index].view.topAnchor.constraint(equalTo: sectionContainerView.topAnchor).isActive = true
        }
        else if row == 1 {
            sectionViewControllers[index].view.centerYAnchor.constraint(equalTo: sectionContainerView.centerYAnchor).isActive = true
        }
        else {
            sectionViewControllers[index].view.bottomAnchor.constraint(equalTo: sectionContainerView.bottomAnchor).isActive = true
        }
        
        //Set the height and width of the button views
        sectionViewControllers[index].view.widthAnchor.constraint(equalTo: sectionContainerView.widthAnchor, multiplier: 0.40).isActive = true
        sectionViewControllers[index].view.heightAnchor.constraint(equalTo: sectionContainerView.widthAnchor, multiplier: 0.40).isActive = true
    }
}

