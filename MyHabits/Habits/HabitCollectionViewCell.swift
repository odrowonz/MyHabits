//
//  HabitCollectionViewCell.swift
//  MyHabits
//
//  Created by Andrey Antipov on 17.11.2020.
//  Copyright © 2020 Andrey Antipov. All rights reserved.
//

import UIKit

class HabitCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var repeatedLabel: UILabel!
    @IBOutlet weak var didItButton: UIButton!
    
    /// Ячейка с прогрессом
    public var progressCell: ProgressCollectionViewCell?
    
    /// Привычка
    public var habit: Habit = Habit(name: "Test", date: Date(), color: .orange){
        didSet(value) {
            nameLabel.text = habit.name
            nameLabel.textColor = habit.color
            timeLabel.text = habit.dateString
            repeatedLabel.text = "Подряд: \(habit.trackDates.count)"
            didItButton.isSelected = habit.isAlreadyTakenToday
            didItButton.tintColor = habit.color
        }
    }
    
    /// Событие нажатия на кнопку, чтобы отметить выполнение привычки сегодня
    @IBAction func didItButtonTouched(_ sender: Any) {
        // Если привычка еще не выполнялась сегодня
        if !habit.isAlreadyTakenToday {
            // При нажатии на круг должно измениться его состояние (заливка цветом и иконка галочки)
            didItButton.isSelected = !didItButton.isSelected
            // Также нужно сохранить время привычки
            HabitsStore.shared.track(habit)
            // Обновить прогресс
            if let progressCell = self.progressCell {
                progressCell.percents = HabitsStore.shared.todayProgress
            }
        }
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDates"
        {
            let controller = segue.destination as! HabitDetailsViewController
            controller.habit = self.habit
        }
    }*/
    
    
}
