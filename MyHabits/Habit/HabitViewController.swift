//
//  HabitViewController.swift
//  MyHabits
//
//  Created by Andrey Antipov on 10.11.2020.
//  Copyright © 2020 Andrey Antipov. All rights reserved.
//

import UIKit

/// Контроллер окна создания / редактирования привычки
class HabitViewController: UIViewController {

    @IBOutlet weak var navigItem: UINavigationItem!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var timeDatePicker: UIDatePicker!
    @IBOutlet weak var deleteHabitButton: UIButton!
    
    // набор предопределенных констант
    private let defaultName: String? = ""
    private let defaultColor: UIColor? = UIColor(named: "Color_161_22_204")
    private let defaultHabitColor: UIColor? = UIColor(named: "Color_255_159_79")
    public let currentTime: Date = Date()

    // текущий режим работы с привычкой (создание или редактирование)
    public var state: State = .create
    public var habit: Habit? = nil
    public var colView: UICollectionView? = nil
    public var navController: UINavigationController? = nil
        
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Начальные значения для визуальных элементов
        if let habit = habit {
            nameTextField.text = habit.name
            colorView.backgroundColor = habit.color
            timeDatePicker.date = habit.date
        } else {
            nameTextField.text = defaultName
            colorView.backgroundColor = defaultColor
            timeDatePicker.date = currentTime
        }
        // Обновить текст времени
        timeLabel.setColorForPart(wholeText: timeDatePicker.date.timeToHabitString(), coloredPartText: timeDatePicker.date.timeToString(), colorOfPart: defaultColor!)
        
        // Начальные настройки в зависимости от режима
        switch state {
        case .create:
            // В режиме создания написать заголовок Создать и спрятать кнопку удаления привычки
            navigItem.title = "Создать"
            deleteHabitButton.isEnabled = false
            deleteHabitButton.alpha = 0
        default:
            // В режиме редактирования написать заголовок Править и показать кнопку удаления привычки
            navigItem.title = "Править"
            deleteHabitButton.alpha = 1
            deleteHabitButton.isEnabled = true
        }

        // Keyboard observers
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        // Нажатие на фон чтобы скрыть клавиатуру
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapBackground))
        contentView.addGestureRecognizer(tapGesture)
        
        // Tap on color view for open  UIColorPickerViewController
        let tapColorGesture = UITapGestureRecognizer(target: self, action: #selector(tapColorAction))
        colorView.addGestureRecognizer(tapColorGesture)
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        // Убрать Keyboard observers
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // Обработчик нажатия Отменить
    @IBAction func closeButton(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // Обработчик нажатия Удалить привычку
    @IBAction func deleteHabitButtonTap(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Удалить привычку", message: "Вы хотите удалить привычку \(habit!.name)?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        //let deleteAction = UIAlertAction(title: "Удалить", style: .destructive)
        let deleteAction = UIAlertAction(title: "Удалить", style: .default) { [self] action in
            // Удалить привычку
            if let index = HabitsStore.shared.habits.firstIndex(of: habit!) {
                HabitsStore.shared.habits.remove(at: index)
            }
            // Перезагрузить коллекцию привычек
            colView!.reloadData()
            // Закрыть родительское окно
            navController!.popViewController(animated: true)
            // Закрыть текущее окно
            self.dismiss(animated: true, completion: nil)
        }
            
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    // Обработчик нажатия Сохранить / Править
    @IBAction func saveButton(_ sender: UIBarButtonItem) {
        switch state {
        case .create:
            // В режиме создания создать новую привычку,
            // обновить коллекцию привычек и
            // закрыть текущее модальное окно
            habit = Habit(name: nameTextField.text!,
                          date: timeDatePicker.date,
                          color: colorView.backgroundColor!)
            
            HabitsStore.shared.habits.append(habit!)
        default:
            // В режиме редактирования исправить текущую привычку,
            // обновить коллекцию привычек и
            // закрыть текущее модальное окно
            habit!.name = nameTextField.text!
            habit!.date = timeDatePicker.date
            habit!.color = colorView.backgroundColor!
            
            HabitsStore.shared.save()
        }
        
        // Перезагрузить коллекцию привычек
        colView!.reloadData()
        
        // Закрыть текущее окно
        self.dismiss(animated: true, completion: nil)
    }
    
    // Обработчик исправления DatePicker
    @IBAction func timeDatePickerChanged(_ sender: Any) {
        // Обновить текст времени
        timeLabel.setColorForPart(wholeText: timeDatePicker.date.timeToHabitString(), coloredPartText: timeDatePicker.date.timeToString(), colorOfPart: defaultColor!)
    }
    
    
    
    // MARK: Keyboard actions
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {

            let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height + view.safeAreaInsets.bottom, right: 0)
            scrollView.contentInset = contentInsets
            scrollView.verticalScrollIndicatorInsets = contentInsets
            }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset = .zero
        scrollView.verticalScrollIndicatorInsets = .zero
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
    func hideKeyboard() {
        view.endEditing(true)
    }
    
    // Подготовить и показать UIColorPickerViewController
    func showUIColorPickerViewController() {
        let colorPicker = UIColorPickerViewController()
        colorPicker.delegate = self
        colorPicker.selectedColor = colorView.backgroundColor!
        colorPicker.title = "Задайте цвет привычки"
        present(colorPicker, animated: true, completion: nil)
    }
}

extension HabitViewController: UIColorPickerViewControllerDelegate {
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        // Присвоить цвет викуальному элементу
        // после выбора в UIColorPickerViewController
        colorView.backgroundColor = viewController.selectedColor
    }
}


