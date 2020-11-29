//
//  State.swift
//  MyHabits
//
//  Created by Andrey Antipov on 28.11.2020.
//  Copyright © 2020 Andrey Antipov. All rights reserved.
//

/// Состояние формы создания или редактирования привычки
public enum State {
    // режим создания привычки
    case create
    // режим редактирования привычки
    case edit
    // свойство изменяющее режим на противополжный
    var change: State {
        switch self {
        case .create: return .edit
        case .edit: return .create
        }
    }
}
