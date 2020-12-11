//
//  HabitViewController.swift
//  MyHabits
//
//  Created by Andrey Antipov on 10.11.2020.
//  Copyright © 2020 Andrey Antipov. All rights reserved.
//

import UIKit

/// Контроллер окна создания / редактирования привычки
final class HabitViewController: UIViewController {
    // Связь с элементами вида
    @IBOutlet private var navigItem: UINavigationItem?
    @IBOutlet private var scrollView: UIScrollView?
    @IBOutlet private var contentView: UIView?
    @IBOutlet private var nameTextField: UITextField!
    @IBOutlet private var colorView: UIView?
    @IBOutlet private var timeLabel: UILabel?
    @IBOutlet private var timeDatePicker: UIDatePicker?
    @IBOutlet private var deleteHabitButton: UIButton?
    
    // Набор предопределенных констант
    private let defaultName: String = ""
    private let defaultColor: UIColor = UIColor(named: "Color_161_22_204") ?? .blue
    private let defaultHabitColor: UIColor = UIColor(named: "Color_255_159_79") ?? .orange
    
    private let colorPickerTitle: String = "Задайте цвет привычки"
    private let alertControllerTitle: String = "Удалить привычку"
    private let alertControllerMessage: String = "Вы хотите удалить привычку"

    let currentTime: Date = Date()

    /// Текущий режим работы с привычкой (создание или редактирование)
    var state: State?
    /// Привычка лежащая в основе этого вида
    var habit : Habit?
    /// Что нужно сделать, если успешное действие
    var submitFinalAction: (()->Void)?
    /// Что нужно сделать, если отмена
    var cancelFinalAction: (()->Void)?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Начальные значения для визуальных элементов
        if let habit = habit {
            nameTextField?.text = habit.name
            colorView?.backgroundColor = habit.color
            timeDatePicker?.date = habit.date
        } else {
            nameTextField?.text = defaultName
            colorView?.backgroundColor = defaultColor
            timeDatePicker?.date = Date()
        }
        // Обновить текст времени
        timeLabelRefresh()
        
        // Начальные настройки в зависимости от режима
        if let state = state {
            switch state {
            case .create:
                // В режиме создания написать заголовок Создать и спрятать кнопку удаления привычки
                navigItem?.title = "Создать"
                deleteHabitButton?.isEnabled = false
                deleteHabitButton?.alpha = 0
            case .edit:
                // В режиме редактирования написать заголовок Править и показать кнопку удаления привычки
                navigItem?.title = "Править"
                deleteHabitButton?.alpha = 1
                deleteHabitButton?.isEnabled = true
            }
        }

        // Keyboard observers
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        // Нажатие на фон чтобы скрыть клавиатуру
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapBackground))
        contentView?.addGestureRecognizer(tapGesture)
        
        // Tap on color view for open  UIColorPickerViewController
        let tapColorGesture = UITapGestureRecognizer(target: self, action: #selector(tapColorAction))
        colorView?.addGestureRecognizer(tapColorGesture)
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        // Убрать Keyboard observers
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // Обработчик нажатия Отменить
    @IBAction func closeButton(_ sender: UIBarButtonItem) {
        // Защита тела метода
        // Получить таббар удаётся?
        //guard let tab = presentingViewController as? UITabBarController else { return }
        // Получить навигатор удаётся?
        //guard let nav = tab.selectedViewController as? UINavigationController else { return }

        // Закрыть текущее окно
        self.dismiss(animated: true, completion: nil)
        
        // Финальное действие
        self.cancelFinalAction?()

        // Закрыть родительское окно
        //nav.popToRootViewController(animated: true)
    }
    
    // Обработчик нажатия Удалить привычку
    @IBAction func deleteHabitButtonTap(_ sender: UIButton) {
        // Защита тела метода
        // Привычка задана?
        guard let habit = habit else { return }
        // Привычка нашлась среди сохранённых?
        guard let index = HabitsStore.shared.habits.firstIndex(of: habit) else { return }
        // Получить таббар удаётся?
        //guard let tab = presentingViewController as? UITabBarController else { return }
        // Получить навигатор удаётся?
        //guard let nav = tab.selectedViewController as? UINavigationController else { return }
        // Получить корневой контроллер удаётся?
        //guard let root = nav.viewControllers[0] as? HabitsViewController else { return }
        

        let alertController = UIAlertController(title: alertControllerTitle, message: "\(alertControllerMessage) \(habit.name)?", preferredStyle: .alert)
        
        // Создание кнопок
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: "Удалить", style: .default) {
            // Обработчик удаления
            [] action in
            // Удалить привычку
            HabitsStore.shared.habits.remove(at: index)
            
            // Перезагрузить коллекцию привычек
            //root.isUpdateNeeded = true

            // Закрыть текущее окно
            self.dismiss(animated: true, completion: nil)
            
            // Финальное действие
            self.submitFinalAction?()
            
            // Закрыть родительское окно
            //nav.popToRootViewController(animated: true)
        }
        
        // Добавление кнопок к алерт-контроллеру
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        
        // Модальный показ
        self.present(alertController, animated: true, completion: nil)
    }
    
    // Обработчик нажатия Сохранить / Править
    @IBAction func saveButton(_ sender: UIBarButtonItem) {
        // Защита тела метода
        // Режим задан?
        guard let state = state else { return }
        // Наименование привычки задано?
        guard let name = nameTextField?.text else { return }
        if name == "" { return }
        // Цвет привычки определен?
        guard let color = colorView?.backgroundColor else { return }
        // Время привычки задано?
        guard let date = timeDatePicker?.date else { return }
        // Получить таббар удаётся?
        //guard let tab = presentingViewController as? UITabBarController else { return }
        // Получить навигатор удаётся?
        //guard let nav = tab.selectedViewController as? UINavigationController else { return }
        // Получить корневой контроллер удаётся?
        //guard let root = nav.viewControllers[0] as? HabitsViewController else { return }
        
        switch state {
        case .create:
            // В режиме создания создать новую привычку,
            // обновить коллекцию привычек и
            // закрыть текущее модальное окно
            habit = Habit(name: name, date: date, color: color)
            HabitsStore.shared.habits.append(habit!)
        case .edit:
            // Защита тела метода (нужна только при редактировании привычки)
            // Задана ли привычка?
            guard let habit = habit else { return }
            
            // В режиме редактирования исправить текущую привычку,
            // обновить коллекцию привычек и
            // закрыть текущее модальное окно
            habit.name = name
            habit.date = date
            habit.color = color
            HabitsStore.shared.save()
        }
        
        // Перезагрузить коллекцию привычек
        //root.isUpdateNeeded = true
        
        // Закрыть текущее окно
        self.dismiss(animated: true, completion: nil)
        
        // Финальное действие
        self.submitFinalAction?()
        
        // Закрыть родительское окно
        //nav.popToRootViewController(animated: true)
    }
    
    // Обработчик исправления DatePicker
    @IBAction func timeDatePickerChanged(_ sender: Any) {
        // Обновить текст времени
        timeLabelRefresh()
    }
    
    /// Обновить текст времени
    private func timeLabelRefresh() {
        if let date = timeDatePicker?.date {
            timeLabel?.setColorForPart(wholeText: date.timeToHabitString(), coloredPartText: date.timeToString(), colorOfPart: defaultColor)
        }
    }
    
    // MARK: Keyboard actions
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height + view.safeAreaInsets.bottom, right: 0)
            scrollView?.contentInset = contentInsets
            scrollView?.verticalScrollIndicatorInsets = contentInsets
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        scrollView?.contentInset = .zero
        scrollView?.verticalScrollIndicatorInsets = .zero
    }
    
    // MARK: Actions
    @objc private func tapBackground() {
        // Спрятать клавиатуру
        hideKeyboard()
    }
    
    @objc private func tapColorAction() {
        showUIColorPickerViewController()
    }
    
    // Спрятать клавиатуру
    private func hideKeyboard() {
        view.endEditing(true)
    }
    
    // Подготовить и показать UIColorPickerViewController
    private func showUIColorPickerViewController() {
        let colorPicker = UIColorPickerViewController()
        colorPicker.delegate = self
        colorPicker.selectedColor = colorView?.backgroundColor ?? defaultColor
        colorPicker.title = colorPickerTitle
        present(colorPicker, animated: true, completion: nil)
    }
}

extension HabitViewController: UIColorPickerViewControllerDelegate {
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        // Присвоить цвет визуальному элементу
        // после выбора в UIColorPickerViewController
        colorView?.backgroundColor = viewController.selectedColor
    }
}


