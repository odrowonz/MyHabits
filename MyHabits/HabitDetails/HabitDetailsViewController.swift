//
//  HabitDetailsViewController.swift
//  MyHabits
//
//  Created by Andrey Antipov on 18.11.2020.
//  Copyright © 2020 Andrey Antipov. All rights reserved.
//

import UIKit

final class HabitDetailsViewController: UITableViewController {

    /// Привычка
    var habit: Habit?
    
    var colView: UICollectionView? = nil
    
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
        if let cell = tableView.dequeueReusableCell(withIdentifier: HabitDetailsTableViewCell.id, for: indexPath) as? HabitDetailsTableViewCell {
            // Сортировка дат от сегодня в прошлое
            let maxI = HabitsStore.shared.dates.count - 1
            cell.date = HabitsStore.shared.dates[maxI-indexPath.row]
            // Привычка для выставления галочки (или невыставления)
            cell.habit = habit
            return cell
        }
        
        // Недостижимо
        return UITableViewCell()
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "АКТИВНОСТЬ"
    }

    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editHabitButtonPressed" {
            if let controller = segue.destination as? HabitViewController {
                controller.state = .edit
                controller.habit = habit
                controller.colView = colView
                controller.navController = self.navigationController
            }
        }
    }
}
