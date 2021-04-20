//
//  RootViewController.swift
//  SongSketch
//
//  Created by Samuel Garry on 4/14/21.
//

import UIKit
import CoreData

class RootViewController: UIViewController {

    //Table View Variables
    let tableView = UITableView()
    let projectCell = ProjectCell()
    let footerCell = ProjectTableFooter(frame: CGRect(width: 300, height: 75))
    
    //View Variables
    let topContainerView = UIView()
    let tableContainerView = UIView()
    let titleBarView = HomeTitleBar()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 2/255, green: 41/255, blue: 86/255, alpha: 1)
        
        createContainers()
        configureTableView()
        
        //Perform a fetch using the fetchedResultsController
        do {
            try self.fetchedResultsController.performFetch()
//            tableView.reloadData()
        } catch let err {
            print(err)
        }
        
        //Hide the navigation controller's Navigation Bar everywhere in the app
        navigationController?.isNavigationBarHidden = true
        
        //Closure
        footerCell.addProject = {
            self.addProjectData()
        }
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        tableView.reloadData()
//
////        createContainers()
////        configureTableView()
////
////        //Perform a fetch using the fetchedResultsController
////        do {
////            try self.fetchedResultsController.performFetch()
////            tableView.reloadData()
////        } catch let err {
////            print(err)
////        }
//    }
    
    func configureTableView() {
        tableContainerView.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = footerCell
        tableView.backgroundColor = UIColor(red: 2/255, green: 41/255, blue: 86/255, alpha: 1)
        tableView.register(ProjectCell.self, forCellReuseIdentifier: Cells.projectCell)
        tableView.pin(to: tableContainerView)
        tableView.allowsSelection = false
        tableView.isUserInteractionEnabled = true
    }
    
    func createContainers() {
        //Container View Set Up
        view.addSubview(titleBarView)
        view.addSubview(tableContainerView)
        titleBarView.translatesAutoresizingMaskIntoConstraints = false
        tableContainerView.translatesAutoresizingMaskIntoConstraints = false
                
        //Top Container Constraint Set up
        NSLayoutConstraint(item: titleBarView, attribute: .top, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: titleBarView, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: titleBarView, attribute: .height, relatedBy: .equal, toItem: view, attribute: .height, multiplier: 0.16, constant: 0).isActive = true

        //Table Container Constraint Set up
        NSLayoutConstraint(item: tableContainerView, attribute: .top, relatedBy: .equal, toItem: titleBarView, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: tableContainerView, attribute: .bottom, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .bottom, multiplier: 1, constant: 1).isActive = true
        NSLayoutConstraint(item: tableContainerView, attribute: .width, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .width, multiplier: 0.9, constant: 1).isActive = true
        NSLayoutConstraint(item: tableContainerView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
    }
    
//    func createProject() {
//        addProjectData()
//    }
    
    func startProject(_ projectIndex: String) {
        //Create and go to the new corresponding view controller
        let projectVC = ProjectViewController(projectIndex)
        navigationController?.pushViewController(projectVC, animated: true)
    }
    
    func dateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "ddMMMYY_hhmmssa"
        let projectIndex = formatter.string(from: Date())
//      return "\(fileName).aif"
        return projectIndex
    }
    
    func makeDateLegible(_ date: String) -> String {
        //Date
        let day = date[0..<2]
        let month = date[2..<5]
        let year = date[5..<7]
        //Time
        let hour = date[8..<10]
        let min = date[10..<12]
        let sec = date[12..<14]

        return "\(month) \(day), 20\(year) \(hour):\(min):\(sec)"
    }
    
    //__________________________________________________________________________________________
    //Core Data Content
    
    // Reference to managed object context -- CORE DATA
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<Project> = {
        // Create Fetch Request
        let fetchRequest: NSFetchRequest<Project> = Project.fetchRequest()
        
        let test = try! context.fetch(fetchRequest)
        print("number of projects: \(test.count)")

        //Configure Fetch Request
//        let pred = NSPredicate(format: "section == %@", self.currentSection)
//        fetchRequest.predicate = pred
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "index", ascending: true)]

        //print("Fetch Request size: \(try! context.fetch(fetchRequest).count)")

        // Create Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.context, sectionNameKeyPath: nil, cacheName: nil)

        // Configure Fetched Results Controller
        fetchedResultsController.delegate = self

        return fetchedResultsController
    }()
    
    //Function for adding a new project to CoreData
    func addProjectData() {
        let project = NSEntityDescription.insertNewObject(forEntityName: "Project", into: context) as! Project // NSManagedObject
        let currentProjectTitle = dateString()
        project.name = makeDateLegible(currentProjectTitle)
        project.index = currentProjectTitle
        
        //Save Data
        do {
            try self.context.save()
        } catch let err {
            fatalError("\(err)")
        }
    }
}


extension RootViewController: UITableViewDelegate, UITableViewDataSource {
    
    //For the table view to access cells without risking typing a string wrong in code
    struct Cells {
        static let projectCell = "ProjectCell"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let projects = fetchedResultsController.fetchedObjects else { return 0 }
        print("projects.count: \(projects.count)")
        return projects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Cells.projectCell) as? ProjectCell else {
            fatalError("Unexpected Index Path")
        }
        
        //Fetch Project
        let project = fetchedResultsController.object(at: indexPath)
        
        //Configure Cell
        cell.projectLabel.text = project.name
        
        //print("project.name: \(project.name)")
        
        //Closure
        cell.cellTapped = {
            print("Cell's Project Index: \(project.index)")
            self.startProject(project.index)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            //Fetch Project
            let project = fetchedResultsController.object(at: indexPath)
            
            //Delete the fetched project
            context.delete(project)
            
            //Save the Core Data
            do {
                try context.save()
            } catch let err {
                print(err)
            }
        }
    }
    
    func configureCell(_ cell: ProjectCell, at indexPath: IndexPath) {
        //let project = fetchedResultsController.object(at: indexPath)
        tableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.automatic) //try other animations
        //tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}


//NSFetchedResultsController Functionality
extension RootViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch (type) {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break;
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        case .update:
            if let indexPath = indexPath, let cell = tableView.cellForRow(at: indexPath) as? ProjectCell {
                configureCell(cell, at: indexPath)
            }
        default:
            print("...")
        }
    }
}
