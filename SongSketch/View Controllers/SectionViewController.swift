//
//  SectionViewController.swift
//  SongSketch
//
//  Created by Samuel Garry on 3/22/21.
//

import UIKit
import CoreData


protocol SectionViewControllerDelegate {
    func takeSelected(index: Int, take: Take)
    func takeDeSelected(sectionIndex: Int)
    func interruptPlayingWithPlay(sectionTag: Int)
}


class SectionViewController: UIViewController {
    
    //For the table view to access cells without risking typing a string wrong in code
    struct Cells {
        static let takeCell = "TakeCell"
    }
    
    //Protocol
    var sectionDelegate: SectionViewControllerDelegate?
    
    // Reference to managed object context -- CORE DATA
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    //Variables
    var tag: Int
//    var cellSize: CGFloat
    var cellWidth: CGFloat
    var cellHeight: CGFloat
    var empty: Bool = true //Checks if the section has no takes yet
    var totalTakes: Int
    var timeOfLastRecording: String
        
    //View Variables
    var holderView = UIView()
    var emptyStarterView = EmptySectionView()
    var takeView = TakeView()
    var recordingView = RecordingView()
    var blockerView: UIView?

    
    //Tableview elements
    let tableView = UITableView()
    let contentView = UIView()
    
    //Takes Array
    var takeViews: [TakeView] = []
    var takeModels: [Take]?
    
    //Variable for Accessing Corresponding Section in Core Data
    var currentSection: Section?
    
    //Variable for Accessing Overall Corresponding Project in Core Data
    public var currentProject: Project?
    
    
    //Variable for knowing when a cell has been deleted vs. another change occuring in nsfetchedresultscontroller
    var numOfCellsInTV: Int!
    
    //var takeModels = [Take]()
    
    
    //INITS
    init(_ index: Int) {
        tag = index
//        cellSize = 0.0
        cellHeight = 0.0
        cellWidth = 0.0
        totalTakes = 0
        timeOfLastRecording = ""
        
        super.init(nibName: nil, bundle: nil)
        //Conductor.shared.fileFinishedDelegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        view = holderView
        
        //Set up the section based on core data information
        setTableViewDelegates()
        self.setUpSection()
        
        //Perform a fetch using the fetchedResultsController
        do {
            try self.fetchedResultsController.performFetch()
        } catch let err {
            print(err)
        }

        //Button Closures
        emptyStarterView.recordTapped = {
            //self.view = self.recordingView
//            self.emptyStarterView.removeFromSuperview()
            self.view = self.holderView
            let newRecordingView = self.recordingView
            newRecordingView.frame = CGRect(width: self.cellWidth, height: self.cellHeight)
            self.view.addSubview(self.recordingView)
            //self.view.addSubview(self.tableView)
            self.recording(1)
        }
        recordingView.endRecordTapped = {
//            //Section is empty
//            if self.empty {
//                self.stopRecording()
//                self.endFirstRecording()
//            }
//            //Section isn't empty
//            else {
//                self.stopRecording()
//                self.endRecording()
//            }
            self.stopRecording()
            self.endRecording()
        }
        
    }
    
    func recording(_ takeIndex: Int) {
        //Tell the conductor what section is being dealt with
        Conductor.shared.currentSection = self.tag
        
        //Tell the conductor what take number is being recorded for that section
        Conductor.shared.numOfTakes = takeIndex
        
        //Tell the conductor what filename to write to for this recording
        print("FileName: \(dateString())")
        timeOfLastRecording = dateString()
        Conductor.shared.writeToFileName = timeOfLastRecording
        
//        //Add a take model to the section's takes data array
//        addTakeData()
        
        //To start the recording
        if (Conductor.shared.data.isRecording != true) {
            Conductor.shared.data.isRecording.toggle()
        }
    }
    
    func stopRecording() {
        //To stop the recording
        if (Conductor.shared.data.isRecording == true) {
            Conductor.shared.data.isRecording.toggle()
        }
    }
    
    func endFirstRecording() {
        print("got to this fucker instead")
        view = holderView
        configureTableView()
        //view = tableView
        //self.view = holderView
//        self.configureTableView()
//        let take = TakeView()
//        self.takeViews.append(take)
        empty = false
    }
    
    func endRecording() {
        print("got to this fucker")
        recordingView.removeFromSuperview()
        //self.view = holderView
        //holderView.backgroundColor = .green
        configureTableView()
        //Add a take model to the section's takes data array
        addTakeData()
        print("got to this bitchass")
        //view = tableView
//        let newCell = tableView.dequeueReusableCell(withIdentifier: Cells.takeCell) as! TakeView
//        self.takeViews.append(newCell)
//        self.tableView.beginUpdates()
//        self.tableView.insertRows(at: [IndexPath.init(row: self.takeViews.count-1, section: 0)], with: .automatic)
//        self.tableView.endUpdates()
       //self.goToLastCell(self.tableView)
    }

    func configureTableView() {
        view.addSubview(tableView)
        tableView.backgroundColor = UIColor(red: 3/255, green: 50/255, blue: 105/255, alpha: 1)
        //setTableViewDelegates()
        //tableView.rowHeight = cellSize
        //print("height: \(view.frame.size.height)")
        //setTableViewDelegates()
        tableView.register(TakeView.self, forCellReuseIdentifier: Cells.takeCell)
        tableView.pin(to: view)
        //tableView.allowsSelection = false
        tableView.isUserInteractionEnabled = true
        tableView.allowsMultipleSelection = false
        
        //Set up Long Press Functionality
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.longPress(longPressGestureRecognizer:)))
          tableView.addGestureRecognizer(longPressRecognizer)
    }
    
    @objc func longPress(longPressGestureRecognizer: UILongPressGestureRecognizer) {

        if longPressGestureRecognizer.state == UIGestureRecognizer.State.began {
            let touchPoint = longPressGestureRecognizer.location(in: tableView)
            if let indexPath = tableView.indexPathForRow(at: touchPoint) {
                // add your code here
                // you can use 'indexPath' to find out which row is selected
                print("Long pressed")
                
                //PUT MY MOVING CODE HERE
            }
        }
    }
    
    func setTableViewDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func dateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "ddMMMYY_hhmmssa"
        let fileName = formatter.string(from: Date())
//      return "\(fileName).aif"
        return "\(fileName).caf"
    }
    
    
    //__________________________________________________________________________________________
    //Core Data Content
    
    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<Take> = {
        // Create Fetch Request
        let fetchRequest: NSFetchRequest<Take> = Take.fetchRequest()

        //Configure Fetch Request
        if let currSection = self.currentSection {
            let pred = NSPredicate(format: "section == %@", currSection)
            fetchRequest.predicate = pred
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "index", ascending: true)]
        } else {
            print("currentSection hasn't been set")
        }

        print("Fetch Request size: \(try! context.fetch(fetchRequest).count)")

        // Create Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.context, sectionNameKeyPath: nil, cacheName: nil)

        // Configure Fetched Results Controller
        fetchedResultsController.delegate = self

        return fetchedResultsController
    }()

    
    //Fetch the appropriate section model from Core Data
    func setUpSection() {
        let request = Section.fetchRequest() as NSFetchRequest<Section>
        if let currProject = currentProject {
            let indexPredicate = NSPredicate(format: "index == %i", tag)
            let projectPredicate = NSPredicate(format: "project == %@", currProject)
            let pred = NSCompoundPredicate(andPredicateWithSubpredicates: [indexPredicate, projectPredicate])
            request.predicate = pred
        } else {
            print("currentProject was not set")
        }
        do {
            //Grab the appropriate section
            let sections = try context.fetch(request)
            let section = sections[0]
            
            //Set this view controller's section variable to the appropriate section model
            currentSection = section
            
            if section.totalTakes == 0 {
                print("got here 1")
                //Starting Situation
//                let newStarterView = self.emptyStarterView
//                print("cellsize: \(cellSize)")
//                newStarterView.frame = CGRect(width: self.cellSize, height: self.cellSize)
//                self.view.addSubview(newStarterView)
                view = emptyStarterView
                print("It's empty")
            }
            else {
                print("got here 2")
                //Set the number of takes for this view controller
                totalTakes = Int(section.totalTakes)
                
                //Perform a fetch using the fetchedResultsController
                do {
                    try self.fetchedResultsController.performFetch()
                } catch let err {
                    print(err)
                }
                configureTableView()
//                tableView.reloadData()
            }
        } catch let err {
            fatalError("\(err)")
        }
    }
    
    
    func iterateNumOfTakes() {
        let request = Section.fetchRequest() as NSFetchRequest<Section>
        if let currProject = currentProject {
            let indexPred = NSPredicate(format: "index == %i", tag)
            let projectPred = NSPredicate(format: "project == %@", currProject)
            let pred = NSCompoundPredicate(andPredicateWithSubpredicates: [indexPred, projectPred])
            request.predicate = pred
        } else {
            print("currentProject was not set")
        }
        
        do {
            //Get the appropriate section to update
            let sections = try context.fetch(request)
            let section = sections[0]
            section.totalTakes += 1
            print("section.numOfTakes: \(section.totalTakes)")
            //Save the changes
            try self.context.save()
            
        } catch let err {
            fatalError("\(err)")
        }
    }
    
    func resetSection() {
        let request = Section.fetchRequest() as NSFetchRequest<Section>
        if let currProject = currentProject {
            let indexPred = NSPredicate(format: "index == %i", tag)
            let projectPred = NSPredicate(format: "project == %@", currProject)
            let pred = NSCompoundPredicate(andPredicateWithSubpredicates: [indexPred, projectPred])
            request.predicate = pred
        } else {
            print("currentProject was not set")
        }
        
        do {
            //Get the appropriate section to update
            let sections = try context.fetch(request)
            if sections.count > 0 {
                let section = sections[0]
                section.totalTakes = 0
                section.name = "Section \(section.index)"
            } else {
                print("sections is empty")
            }
        } catch let err {
            print(err)
        }
    }

    func addTakeData() {
        
        //Update the section model's numOfTakes variable
        iterateNumOfTakes()

        //Create a take
        //let take = Take(context: self.context)
        let take = NSEntityDescription.insertNewObject(forEntityName: "Take", into: context) as! Take // NSManagedObject
        totalTakes += 1
        print("numOfTakes: \(totalTakes)")
        take.name = "Take \(totalTakes)"
        take.index = Int64(totalTakes)
        if let currSection = self.currentSection {
            take.section = currSection
        } else {
            print("currentSection hasn't been set")
        }
        take.audioFilePath = timeOfLastRecording
                
        //Save Data
        do {
            try self.context.save()
        } catch let err {
            fatalError("\(err)")
        }
    }
    
    func fetchAudioPath(_ indexPath: Int) -> String {
        
        let request = Take.fetchRequest() as NSFetchRequest<Take>
        if let currSection = self.currentSection {
            let sectionPred = NSPredicate(format: "section == %@", currSection)
            let takeIndexPred = NSPredicate(format: "index == %i", indexPath)
            let pred = NSCompoundPredicate(andPredicateWithSubpredicates: [sectionPred, takeIndexPred])
            request.predicate = pred
        } else {
            print("currentSection hasn't been set")
        }
        
        do {
            let fetch = try context.fetch(request)
            let take = fetch[0]
            return take.audioFilePath
        } catch let err {
            print(err)
        }
        print("Could not retrieve a Take with given index path and current section")
        return "Could not retrieve a Take with given index path and current section"
    }


    //End of Core Data Functions
    //__________________________________________________________________________________________
}


//Table View Functionality
extension SectionViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let takes = fetchedResultsController.fetchedObjects else { return 0 }
        return takes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Cells.takeCell) as? TakeView else {
            fatalError("Unexpected Index Path")
        }

        //let take = takes[indexPath.row]
        
        //Fetch Take
        let take = fetchedResultsController.object(at: indexPath)
        //let take = takeModels[indexPath.row]
        
        //Configure Cell
        cell.takeLabel.text = take.name
        cell.sectionLabel.text = take.section.name
        
                
        //cell.set(label: "Take \(indexPath.row+1)", section: "Section \(self.tag)")
        
            
        //Set the cell's selected background view
        let selectedBackgroundView = SelectedSectionBackgroundView()
        cell.selectedBackgroundView = selectedBackgroundView
        
        //Assign the recordTapped action which will be executed when the user taps the plus button
        cell.recordTapped = { /*(cell) in */
            
            //Deselecting the cell if it is currently selected
            if let indexPathForSelectedRow = tableView.indexPathForSelectedRow,
                indexPathForSelectedRow == indexPath {
                tableView.deselectRow(at: indexPath, animated: false)
                self.sectionDelegate?.takeDeSelected(sectionIndex: self.tag)
            }
            
            //tableView.removeFromSuperview()
            //self.view = self.recordingView
            tableView.removeFromSuperview()
            let newRecordingView = self.recordingView
            newRecordingView.frame = CGRect(width: self.cellWidth, height: self.cellHeight)
            self.view.addSubview(self.recordingView)
            //self.holderView.addSubview(self.recordingView)
//            self.view.addSubview(self.recordingView)
           // self.holderView.bringSubviewToFront(self.recordingView)
            //self.recordingView.superview?.bringSubviewToFront(self.recordingView)
            self.recording(indexPath.row+2)
        }
        
        cell.playTapped = {
            //Tell the conductor what section is being dealt with
            Conductor.shared.currentSection = self.tag
            
            //To start playing
            if Conductor.shared.data.isPlaying != true {
                                
                //Tell the conductor what take number is being recorded for that section
                Conductor.shared.numOfTakes = indexPath.row+1

                //DELETE THIS
                print("indexPath.row+1: \(indexPath.row+1)")
                
                //ADDITION
                // Fetch Take
                let fetchedTake = self.fetchedResultsController.object(at: indexPath)
                print("currentTake: \(fetchedTake)")
                         
                //ADDITION
                Conductor.shared.readToFileName = fetchedTake.audioFilePath
                
                
//                //Tell the conductor what file to read
//                Conductor.shared.readToFileName = self.fetchAudioPath(indexPath.row+1)

                Conductor.shared.data.isPlaying.toggle()
                cell.playPauseButton.isSelected = true
                cell.updateButton(playing: true)
            }
            //To stop playing
            else {
                // Fetch Take
                let fetchedTake = self.fetchedResultsController.object(at: indexPath)
                
                if Conductor.shared.readToFileName != fetchedTake.audioFilePath {
//                if Conductor.shared.readToFileName != self.fetchAudioPath(indexPath.row+1) {
                    //Tell the conductor the new file to read
//                    Conductor.shared.readToFileName = self.fetchAudioPath(indexPath.row+1)
                    Conductor.shared.readToFileName = fetchedTake.audioFilePath

                    print("did i get here")
                    cell.playPauseButton.isSelected = true
                    cell.updateButton(playing: true)

                    //Update the buttons and stop the conductor
                    self.sectionDelegate?.interruptPlayingWithPlay(sectionTag: self.tag)


//                    //Restart the conductor
//                    Conductor.shared.data.isPlaying.toggle()
                }
                else {
                    Conductor.shared.data.isPlaying.toggle()
                    cell.playPauseButton.isSelected = false
                    cell.updateButton(playing: false)
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
        
    func goToLastCell(_ tableView: UITableView) {
        let indexPath = IndexPath(row: tableView.numberOfRows(inSection: 0)-1, section: 0)
        print("numOfRows: \(tableView.numberOfRows(inSection: 0)-1)")
        self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        //self.tableView.setContentOffset( CGPoint(x: 0, y: 0) , animated: true)
    }
    
    //Selection Handling
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Fetch Current Take
        let fetchedTake = self.fetchedResultsController.object(at: indexPath)
        
        sectionDelegate?.takeSelected(index: self.tag, take: fetchedTake)
    }
//    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
//        sectionDelegate?.takeDeSelected(index: self.tag)
//    }
    
    //Function for enabling deselection upon second tap 
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {

        if let indexPathForSelectedRow = tableView.indexPathForSelectedRow,
            indexPathForSelectedRow == indexPath {
            tableView.deselectRow(at: indexPath, animated: false)
            sectionDelegate?.takeDeSelected(sectionIndex: self.tag)
            return nil
        }
        return indexPath
    }
    
    //Functions for snapping to cell
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        var visibleRect = CGRect()
        visibleRect.origin = tableView.contentOffset
        visibleRect.size = tableView.bounds.size
        let visiblePoint = CGPoint(x: visibleRect.origin.x, y: visibleRect.origin.y + cellHeight/2.0)
//        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        guard let indexPath = tableView.indexPathForRow(at: visiblePoint)
            else { return }
        tableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView,
        withVelocity velocity: CGPoint,
        targetContentOffset: UnsafeMutablePointer<CGPoint>)
    {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.scrollViewDidEndDecelerating(scrollView)
        }
    }
    
    func configureCell(_ cell: TakeView, at indexPath: IndexPath) {
        //let project = fetchedResultsController.object(at: indexPath)
        tableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.automatic) //try other animations
        //tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
}



//NSFetchedResultsController Functionality
extension SectionViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        //Check how many cells are in tableview before change
        numOfCellsInTV = tableView.numberOfRows(inSection: 0)
        tableView.beginUpdates()
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
        
        //Check to see if a cell has been deleted or added
        if tableView.numberOfRows(inSection: 0) != numOfCellsInTV {
            if (tableView.numberOfRows(inSection: 0)) == 0 {
                let freshSectionView = emptyStarterView
                view.addSubview(freshSectionView)
                freshSectionView.pin(to: view)
                totalTakes = 0
                resetSection()
                tableView.removeFromSuperview()
            }
            else {
                self.goToLastCell(self.tableView)
            }
        }
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
            break;
        case .update:
//            if let indexPath = indexPath, let cell = tableView.cellForRow(at: indexPath) as? TakeView {
//                print("this lil shindig got called")
//                configureCell(cell, at: indexPath)
//            }
            print("this shindig right here")
            tableView.reloadData()
            break;
        default:
            print("...")
        }
    }
}
