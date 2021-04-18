//
//  SectionViewController.swift
//  SongSketch
//
//  Created by Samuel Garry on 3/22/21.
//

import UIKit
import CoreData


protocol SectionViewControllerDelegate {
    func takeSelected()
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
    var cellSize: CGFloat
    var empty: Bool = true //Checks if the section has no takes yet
    var numOfTakes: Int
    var timeOfLastRecording: String
        
    //View Variables
    var holderView = UIView()
    var emptyStarterView = EmptySectionView()
    var takeView = TakeView()
    var recordingView = RecordingView()
    
    //Tableview elements
    let tableView = UITableView()
    let contentView = UIView()
    
    //Takes Array
    var takeViews: [TakeView] = []
    //var takeModels: [Take]?
    
    //Variable for Accessing Corresponding Section in Core Data
    var currentSection = Section()
    
    //Variable for Accessing Overall Corresponding Project in Core Data
    public var currentProject: Project?
    
    //var takeModels = [Take]()
    
    
    //INITS
    init(_ index: Int) {
        tag = index
        cellSize = 0.0
        numOfTakes = 0
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
            newRecordingView.frame = CGRect(width: self.cellSize, height: self.cellSize)
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
        let pred = NSPredicate(format: "section == %@", self.currentSection)
        fetchRequest.predicate = pred
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "index", ascending: true)]

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
        let indexPredicate = NSPredicate(format: "index == %i", tag)
        let projectPredicate = NSPredicate(format: "project == %@", currentProject!)
        let pred = NSCompoundPredicate(andPredicateWithSubpredicates: [indexPredicate, projectPredicate])
        request.predicate = pred
        do {
            //Grab the appropriate section
            let sections = try context.fetch(request)
            let section = sections[0]
            
            //Set this view controller's section variable to the appropriate section model
            currentSection = section
            
            if section.numOfTakes == 0 {
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
                numOfTakes = Int(section.numOfTakes)
                
                //Perform a fetch using the fetchedResultsController
                do {
                    try self.fetchedResultsController.performFetch()
                } catch let err {
                    print(err)
                }
                configureTableView()
                
                //DELETE
                let testView = UIView()
                testView.backgroundColor = .clear
                view.addSubview(testView)
                testView.pin(to: view)
                
                
//                tableView.reloadData()
            }
        } catch let err {
            fatalError("\(err)")
        }
    }
    
    
    func updateNumOfTakes() {
        let request = Section.fetchRequest() as NSFetchRequest<Section>
        let indexPred = NSPredicate(format: "index == %i", tag)
        let projectPred = NSPredicate(format: "project == %@", currentProject!)
        let pred = NSCompoundPredicate(andPredicateWithSubpredicates: [indexPred, projectPred])
        request.predicate = pred
        
        do {
            //Get the appropriate section to update
            let sections = try context.fetch(request)
            let section = sections[0]
            section.numOfTakes += 1
            print("section.numOfTakes: \(section.numOfTakes)")
            //Save the changes
            try self.context.save()
            
        } catch let err {
            fatalError("\(err)")
        }
    }

    func addTakeData() {
        
        //Update the section model's numOfTakes variable
        updateNumOfTakes()

        //Create a take
        //let take = Take(context: self.context)
        let take = NSEntityDescription.insertNewObject(forEntityName: "Take", into: context) as! Take // NSManagedObject
        numOfTakes += 1
        print("numOfTakes: \(numOfTakes)")
        take.name = "Take \(numOfTakes)"
        take.index = Int64(numOfTakes)
        take.section = currentSection
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
        let sectionPred = NSPredicate(format: "section == %@", currentSection)
        let takeIndexPred = NSPredicate(format: "index == %i", indexPath)
        let pred = NSCompoundPredicate(andPredicateWithSubpredicates: [sectionPred, takeIndexPred])
        request.predicate = pred
        
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
        
        print("take.name: \(take.name)")
        print("section.name: \(take.section.name)")
                
        //cell.set(label: "Take \(indexPath.row+1)", section: "Section \(self.tag)")
        
        //Set the cell's selected background view
        let selectedBackgroundView = SelectedSectionBackgroundView()
        cell.selectedBackgroundView = selectedBackgroundView
        
        //Assign the recordTapped action which will be executed when the user taps the plus button
        cell.recordTapped = { /*(cell) in */
            //tableView.removeFromSuperview()
            //self.view = self.recordingView
            tableView.removeFromSuperview()
            let newRecordingView = self.recordingView
            newRecordingView.frame = CGRect(width: self.cellSize, height: self.cellSize)
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

                //Tell the conductor what file to read
                Conductor.shared.readToFileName = self.fetchAudioPath(indexPath.row+1)

                Conductor.shared.data.isPlaying.toggle()
                cell.playPauseButton.isSelected = true
                cell.updateButton(playing: true)
            }
            //To stop playing
            else {
                Conductor.shared.data.isPlaying.toggle()
                cell.playPauseButton.isSelected = false
                cell.updateButton(playing: false)
            }
        }
        return cell
    }
    
    //Selection Handling
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        sectionDelegate?.takeSelected()
    }
    
    func goToLastCell(_ tableView: UITableView) {
        let indexPath = IndexPath(row: tableView.numberOfRows(inSection: 0)-1, section: 0)
        print("numOfRows: \(tableView.numberOfRows(inSection: 0)-1)")
        self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        //self.tableView.setContentOffset( CGPoint(x: 0, y: 0) , animated: true)
    }
    
    //Function for enabling deselection upon second tap 
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {

        if let indexPathForSelectedRow = tableView.indexPathForSelectedRow,
            indexPathForSelectedRow == indexPath {
            tableView.deselectRow(at: indexPath, animated: false)
            return nil
        }
        return indexPath
    }
    
    //Functions for snapping to cell
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        var visibleRect = CGRect()
        visibleRect.origin = tableView.contentOffset
        visibleRect.size = tableView.bounds.size
        let visiblePoint = CGPoint(x: visibleRect.origin.x, y: visibleRect.origin.y + cellSize/2.0)
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellSize
    }
}



//NSFetchedResultsController Functionality
extension SectionViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
        print("tableview size: \(tableView.numberOfRows(inSection: 0))")
        self.goToLastCell(self.tableView)
        //updateView()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch (type) {
        case .insert:
            if let indexPath = newIndexPath {
                print("got in this bitch")
                print("index path: \(indexPath)")
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break;
        default:
            print("...")
        }
    }
}
