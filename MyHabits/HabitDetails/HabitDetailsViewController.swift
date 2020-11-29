//
//  HabitDetailsViewController.swift
//  MyHabits
//
//  Created by Andrey Antipov on 18.11.2020.
//  Copyright © 2020 Andrey Antipov. All rights reserved.
//

import UIKit

class HabitDetailsViewController: UITableViewController {

    let reuseIdentifier = "HabitDetailsTableViewCell"
    public var habit: Habit? = nil
    public var colView: UICollectionView? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return HabitsStore.shared.dates.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! HabitDetailsTableViewCell
        let maxI = HabitsStore.shared.dates.count - 1
        cell.dateLabel.text = HabitsStore.shared.dates[maxI-indexPath.row].dateToString()
        cell.accessoryType = HabitsStore.shared.habit(habit!, isTrackedIn: HabitsStore.shared.dates[indexPath.row]) ? .checkmark : .none
        return cell
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "АКТИВНОСТЬ"
    }

    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editHabitButtonPressed" {
            let controller = segue.destination as! HabitViewController
    
            controller.state = .edit
            controller.habit = habit
            controller.colView = colView
            controller.navController = self.navigationController
        }
    }
}
