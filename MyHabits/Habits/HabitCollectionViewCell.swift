//
//  HabitCollectionViewCell.swift
//  MyHabits
//
//  Created by Andrey Antipov on 17.11.2020.
//  Copyright © 2020 Andrey Antipov. All rights reserved.
//

import UIKit

class HabitCollectionViewCell: UICollectionViewCell {
    // Связь с элементами вида
    @IBOutlet private var nameLabel: UILabel?
    @IBOutlet private var timeLabel: UILabel?
    @IBOutlet private var repeatedLabel: UILabel?
    @IBOutlet private var didItButton: UIButton?
    
    /// Идентификатор ячейки
    static let id = "habitCollectionViewCell"
    
    /// Ячейка с прогрессом
    var progressCell: ProgressCollectionViewCell?
    
    /// Привычка
    var habit: Habit? {
        didSet {
            layoutRefresh()
        }
    }
    
    /// Метод обновления ячейки
    private func layoutRefresh() {
        // Защита тела метода
        // Привычка задана?
        guard let habit = habit else { return }
        // Метка названия привычки задана?
        guard let nameLabel = nameLabel else { return }
        // Метка времени привычки задана?
        guard let timeLabel = timeLabel else { return }
        // Метка числа повторов привычки задана?
        guard let repeatedLabel = repeatedLabel else { return }
        // Кнопка выполнения привычки задана?
        guard let didItButton = didItButton else { return }

        nameLabel.text = habit.name
        nameLabel.textColor = habit.color
        timeLabel.text = habit.dateString
        repeatedLabel.text = "Подряд: \(habit.trackDates.count)"
        didItButton.isSelected = habit.isAlreadyTakenToday
        didItButton.tintColor = habit.color
    }
    
    /// Событие нажатия на кнопку, чтобы отметить выполнение привычки сегодня
    @IBAction func didItButtonTouched(_ sender: Any) {
        // Защита тела метода
        // Привычка задана?
        guard let habit = habit else { return }
        // Кнопка выполнения привычки задана?
        guard let didItButton = didItButton else { return }
        // Ячейка с прогрессом задана?
        guard let progressCell = progressCell else { return }
        
        // Если привычка еще не выполнялась сегодня
        if !habit.isAlreadyTakenToday {
            // При нажатии на круг должно измениться его состояние (заливка цветом и иконка галочки)
            didItButton.isSelected = !didItButton.isSelected
            // Также нужно сохранить время привычки
            HabitsStore.shared.track(habit)
            // Обновить прогресс
            progressCell.percents = HabitsStore.shared.todayProgress
        }
    }
}
