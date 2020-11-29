//
//  HabitsViewController.swift
//  MyHabits
//
//  Created by Andrey Antipov on 16.11.2020.
//  Copyright © 2020 Andrey Antipov. All rights reserved.
//

import UIKit

private let progressCellReuseIdentifier = "progressCollectionViewCell"
private let habitCellReuseIdentifier = "habitCollectionViewCell"

class HabitsViewController: UICollectionViewController {
    
    @IBOutlet var colView: UICollectionView!
    
    private var progressCell: ProgressCollectionViewCell?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        self.title = "Сегодня"
        
        // Register cell classes
        //colView.register(ProgressCollectionViewCell.self, forCellWithReuseIdentifier: progressCellReuseIdentifier)

        // Do any additional setup after loading the view.
        colView.toAutoLayout()
        colView.dataSource = self
        colView.delegate = self
    }

    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "createHabitButtonPressed" {
            let controller = segue.destination as! HabitViewController
    
            controller.state = .create
            controller.colView = collectionView
        }
        else if segue.identifier == "showDates"
        {
            let controller = segue.destination as! HabitDetailsViewController
            controller.habit = (sender as! HabitCollectionViewCell).habit
            controller.colView = collectionView
        }
    }

}

// MARK: UICollectionViewDataSource
extension HabitsViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return (1 + HabitsStore.shared.habits.count)
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 && indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: progressCellReuseIdentifier, for: indexPath) as! ProgressCollectionViewCell
    
            // Configure the cell
            cell.percents = HabitsStore.shared.todayProgress
            progressCell = cell
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: habitCellReuseIdentifier, for: indexPath) as! HabitCollectionViewCell
    
            // Configure the cell
            cell.progressCell = self.progressCell
            cell.habit = HabitsStore.shared.habits[indexPath.item - 1]
            return cell
        }
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}

extension HabitsViewController: UICollectionViewDelegateFlowLayout {
    var topOffset: CGFloat {
        return 22
    }
    
    var offset: CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 && indexPath.item == 0 {
            return CGSize(width: collectionView.bounds.width-2*offset, height: 60)
        } else {
            return CGSize(width: collectionView.bounds.width-2*offset, height: 130)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return offset
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return offset
    }
   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: topOffset, left: offset, bottom: .zero, right: offset)
    }
}
