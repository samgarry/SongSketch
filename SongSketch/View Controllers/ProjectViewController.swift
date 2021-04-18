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
    let titlebarView = ProjectTitleBarView()
    let topContainerView = UIView()
    var sectionContainerView = UIView()


    
    //NEW STUFF
    var sectionViewControllers = [SectionViewController(0)] //Array of the six section view controllers
    var sectionModels: [Section]?
    var size: Int = 0
    var sizeSetter = UIView()
    
    
    //Variables for Accessing Corresponding Project in Core Data
    var currentProject = Project()
    let projectTag: String
    
    //__________________________________________________________________________________________
    //Core Data Functions
    func setUpProject(_ projectIndex: String) {
        print("Project Index: \(projectIndex)")
        let request = Project.fetchRequest() as NSFetchRequest<Project>
        let pred = NSPredicate(format: "index == %@", projectIndex)
        request.predicate = pred
        
        do {
            //Grab the appropriate project
            let projects = try context.fetch(request)
            let project = projects[0]
            
            //Set this view controller's project variable to the corresponding project model
            currentProject = project
            
            print("current project index: \(currentProject.index)")
            
            if checkIfEmpty(entity: "Section") {
                print("got here")
                loadSectionsData()
            }
        } catch let err {
            fatalError("\(err)")
        }
    }
    
    
    func checkIfEmpty(entity: String) -> Bool {
        var results: NSArray?
                
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        let projectPred = NSPredicate(format: "project == %@", currentProject)
        request.predicate = projectPred
        
        //print("sections: \(try! context.fetch(request))")
        let secs = try! context.fetch(request)
        //let sec = secs[0]
        print("number of sections: \(secs.count)")

        do { results = try self.context.fetch(request) as NSArray
        } catch let err { print(err) }
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
            section.project = currentProject
            print("got here")
            
            do {
                try self.context.save()
            } catch let err {
                fatalError("\(err)")
            }
        }
    }

    
    //End of Core Data Functions
    //__________________________________________________________________________________________
    //Loading Up Functions
    
    init(_ projectTag: String) {
        //setUpProject(projectTag)
        self.projectTag = projectTag
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor(red: 3/255, green: 50/255, blue: 105/255, alpha: 1)
        
//        //Create the six core data section models if they haven't been made yet (first load case scenario)
//        if (checkIfEmpty(entity: "Section")) {
//            loadSectionsData()
//        }
        
        //Connect this ProjectViewController to the corresponding Project in Core Data
        setUpProject(projectTag)
        
        //Create the top and sections container views
        createContainers()
        
        //Create top bar views
        createTopBars()

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

        //BUTTON CLOSURES
        titlebarView.backPressed = {
            self.navigationController?.popToRootViewController(animated: true)
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
    
    //End of Loading Up Functions
    //__________________________________________________________________________________________
    
    func createContainers() {
        //Container Views Set Up
        view.addSubview(topContainerView)
        view.addSubview(sectionContainerView)
        topContainerView.translatesAutoresizingMaskIntoConstraints = false
        sectionContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        //Top Container Constraint Set up
        NSLayoutConstraint(item: topContainerView, attribute: .top, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: topContainerView, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: topContainerView, attribute: .height, relatedBy: .equal, toItem: view, attribute: .height, multiplier: 0.3, constant: 0).isActive = true

        //Section Container Constraint Set up
        NSLayoutConstraint(item: sectionContainerView, attribute: .top, relatedBy: .equal, toItem: topContainerView, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: sectionContainerView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: -50).isActive = true
        NSLayoutConstraint(item: sectionContainerView, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: sectionContainerView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
    }
    
    func createTopBars() {
        //Bar Views Set Up
        topContainerView.addSubview(titlebarView)
        topContainerView.addSubview(toolbarView)
        titlebarView.translatesAutoresizingMaskIntoConstraints = false
        toolbarView.translatesAutoresizingMaskIntoConstraints = false
        
        titlebarView.initialTitle = projectTag
        titlebarView.setInitialTitle()

        //Title Bar Constraint Set up
        NSLayoutConstraint(item: titlebarView, attribute: .top, relatedBy: .equal, toItem: topContainerView, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: titlebarView, attribute: .width, relatedBy: .equal, toItem: topContainerView, attribute: .width, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: titlebarView, attribute: .height, relatedBy: .equal, toItem: topContainerView, attribute: .height, multiplier: 0.35, constant: 0).isActive = true

        //Toolbar Constraint Set up
        NSLayoutConstraint(item: toolbarView, attribute: .top, relatedBy: .equal, toItem: titlebarView, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: toolbarView, attribute: .width, relatedBy: .equal, toItem: topContainerView, attribute: .width, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: toolbarView, attribute: .height, relatedBy: .equal, toItem: topContainerView, attribute: .height, multiplier: 0.2, constant: 0).isActive = true
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

    //Set up the section view controllers
    func setupSectionViewControllers(_ column: Int, _ row: Int, _ index: Int, _ size: Int) {
        let section = SectionViewController(index)
        section.sectionDelegate = self
        section.currentProject = self.currentProject
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
        
        //Set the height and width of the section view controllers
        sectionViewControllers[index].view.widthAnchor.constraint(equalTo: sectionContainerView.widthAnchor, multiplier: 0.40).isActive = true
        sectionViewControllers[index].view.heightAnchor.constraint(equalTo: sectionContainerView.widthAnchor, multiplier: 0.40).isActive = true
    }
}


//Delegate to notify the overall song view controller that the file has finished playing and to update the play buttons for all sections
extension ProjectViewController: FileFinishedDelegate {
    func updateButton() {
        for i in 0..<sectionViewControllers.count {
            let sectionTV = sectionViewControllers[i].tableView
            DispatchQueue.main.async {
                for cell in sectionTV.visibleCells {
                    let indexPath = sectionTV.indexPath(for: cell)
                    if let cell = sectionTV.cellForRow(at: indexPath!) as? TakeView {
                        if cell.playPauseButton.isSelected {
                            cell.playPauseButton.sendActions(for: .touchUpInside)
                        }
                        cell.updateButton(playing: false)
                    } else {
                        print("empty")
                    }
                }
            }
        }
    }
}


extension ProjectViewController: SectionViewControllerDelegate {
    func takeSelected() {
        toolbarView.editButton.tintColor = .white
        toolbarView.notesButton.tintColor = .white
        toolbarView.trashButton.tintColor = .white
    }
}
