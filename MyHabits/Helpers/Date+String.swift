//
//  Date+String.swift
//  MyHabits
//
//  Created by Andrey Antipov on 28.11.2020.
//  Copyright © 2020 Andrey Antipov. All rights reserved.
//
import UIKit

extension Date {
    /// Текстовое представление даты
    func dateToString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.doesRelativeDateFormatting = true
        dateFormatter.locale = Locale(identifier: "ru")
        //dateFormatter.dateFormat = "dd MMMM yyyy"
        return dateFormatter.string(from: self)
    }
    
    /// Текстовое представление времени.
    func timeToString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: self)
    }
    
    /// Описание времени выполнения привычки.
    func timeToHabitString() -> String {
        "Каждый день в " + timeToString()
    }
}
