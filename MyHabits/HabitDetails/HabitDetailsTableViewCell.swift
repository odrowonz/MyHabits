//
//  HabitDetailsTableViewCell.swift
//  MyHabits
//
//  Created by Andrey Antipov on 18.11.2020.
//  Copyright © 2020 Andrey Antipov. All rights reserved.
//

import UIKit

final class HabitDetailsTableViewCell: UITableViewCell {
    // Связь с элементами вида
    @IBOutlet private var dateLabel: UILabel?
    
    /// Дата
    var date: Date? {
        didSet {
            if let value = date {
                // Прописать дату строкой
                dateLabel?.text = value.dateToString()
            }
        }
    }
    
    /// Привычка
    var habit: Habit? {
        didSet {
            if let value = habit, let date = date {
                // Выставить галочку, если привычка затрекана
                accessoryType = HabitsStore.shared.habit(value, isTrackedIn: date) ? .checkmark : .none
            }
        }
    }
    
    /// Идентификатор ячейки
    static let id = "habitDetailsTableViewCell"
}
