//
//  SectionViewController.swift
//  SongSketch
//
//  Created by Samuel Garry on 3/22/21.
//

import UIKit

class SectionViewController: UIViewController {
    
    //Variables
    var tag: Int
    var cellSize: CGFloat
    var empty: Bool = true //Checks if the section has no takes yet
    
    struct Cells {
        static let takeCell = "TakeCell"
    }
        
    //View Variables
    var holderView = UIView()
    var emptyStarterView = EmptySectionView()
    var takeView = TakeView()
    var recordingView = RecordingView()
    
    //Tableview elements
    let tableView = UITableView()
    let contentView = UIView()
    
    //Takes Array
    var takes: [TakeView] = []
    
    
    //INITS
    init(_ index: Int) {
        tag = index
        cellSize = 0.0
        
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
        //Calling configureTableView() in the SongViewController()
//        for _ in 0..<5 {
//            let take = TakeView()
//            takes.append(take)
//        }
        
        //Starting Situation
        view = emptyStarterView //Must be called in viewDidLoad() instead of LoadView()
                                //because it references its own self's view
                
        emptyStarterView.recordTapped = {
            self.view = self.recordingView
            self.recording()
        }
        
        recordingView.endRecordTapped = {
            //Section is empty
            if self.empty {
                self.stopRecording()
                self.endFirstRecording()
            }
            //Section isn't empty
            else {
                self.stopRecording()
                self.endRecording()
            }
        }
    }
    
    func recording() {
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
        self.view = holderView
        self.configureTableView()
        let take = TakeView()
        self.takes.append(take)
        empty = false
    }
    
    func endRecording() {
        view = holderView
        let newCell = tableView.dequeueReusableCell(withIdentifier: Cells.takeCell) as! TakeView
        self.takes.append(newCell)
        self.tableView.beginUpdates()
        self.tableView.insertRows(at: [IndexPath.init(row: self.takes.count-1, section: 0)], with: .automatic)
        self.tableView.endUpdates()
        self.goToLastCell(self.tableView)
    }

    func configureTableView() {
        view.addSubview(tableView)
        tableView.backgroundColor = UIColor(red: 3/255, green: 50/255, blue: 105/255, alpha: 1)
        setTableViewDelegates()
        tableView.rowHeight = cellSize
        //print("height: \(view.frame.size.height)")
        tableView.register(TakeView.self, forCellReuseIdentifier: Cells.takeCell)
        tableView.pin(to: view)
        //tableView.allowsSelection = false
        tableView.isUserInteractionEnabled = true
    }
    
    func setTableViewDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
    }
}


//Table View Functionality
extension SectionViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return takes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cells.takeCell) as! TakeView
        //let take = takes[indexPath.row]
        cell.set(label: "Take \(indexPath.row+1)", section: "Section \(self.tag)")
        
        //Set the cell's selected background view
        let selectedBackgroundView = SelectedSectionBackgroundView()
        cell.selectedBackgroundView = selectedBackgroundView
        
        //Assign the recordTapped action which will be executed when the user taps the plus button
        cell.recordTapped = { (cell) in
            self.view = self.recordingView
            self.recording()
        }
        
        cell.playTapped = {
            //To start playing
            if Conductor.shared.data.isPlaying != true {
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
    
    func goToLastCell(_ tableView: UITableView) {
        let indexPath = IndexPath(row: self.takes.count-1, section: 0)
        self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
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
}





//Delegate to notify the overall song view controller that the file has finished playing and to update the play buttons for all sections
extension SongViewController: FileFinishedDelegate {
    func fileFinished() {
        for i in 0..<sections.count {
            let sectionTV = sections[i].tableView
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
