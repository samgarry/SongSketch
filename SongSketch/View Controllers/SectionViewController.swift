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
    
    
    struct Cells {
        static let takeCell = "TakeCell"
    }
    
    
    //Takes Array
    var takes: [TakeView] = []
    
    let tableView = UITableView()
    
    
    var frame = CGRect(x: 0, y: 0, width: 0, height: 0) //Section size
    
    
    let contentView = UIView()
    
    //Views
    var emptyStarterView = EmptySectionView()
    var takeView = TakeView()
    var recordingView = RecordingView()
    
    //INITS
    init(_ index: Int) {
        tag = index
        cellSize = 0.0
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        //Calling configureTableView() in the SongViewController()
        for _ in 0..<5 {
            let take = TakeView()
            takes.append(take)
        }
        
        //Starting Situation
        //view = emptyStarterView //Must be called in viewDidLoad() instead of LoadView()
                                //because it references its own self's view
        
        
        print("Section tag: \(self.tag)")
        
        emptyStarterView.recordTapped = {
            //self.view = self.recordingView
        }
        
        recordingView.endRecordTapped = {
            //self.view = self.takeView
        }
    }
    
    
    public func configureTableView() {
        view.addSubview(tableView)
        tableView.backgroundColor = UIColor(red: 3/255, green: 50/255, blue: 105/255, alpha: 1)
        setTableViewDelegates()
        tableView.rowHeight = cellSize
        print("height: \(view.frame.size.height)")
        tableView.register(TakeView.self, forCellReuseIdentifier: Cells.takeCell)
        tableView.pin(to: view)
        tableView.allowsSelection = false
    }
    
    func setTableViewDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
    }
}



extension SectionViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return takes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cells.takeCell) as! TakeView
        //let take = takes[indexPath.row]
        cell.set(title: "Take \(indexPath.row)")

        return cell
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
