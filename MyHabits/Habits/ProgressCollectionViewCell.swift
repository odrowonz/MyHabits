//
//  ProgressCollectionViewCell.swift
//  MyHabits
//
//  Created by Andrey Antipov on 17.11.2020.
//  Copyright © 2020 Andrey Antipov. All rights reserved.
//

import UIKit

final class ProgressCollectionViewCell: UICollectionViewCell {
    // Связь с элементами вида
    @IBOutlet private var progressView: UIProgressView?
    @IBOutlet private var progressLabel: UILabel?
    
    /// Идентификатор ячейки
    static let id = "progressCollectionViewCell"
    
    // Вызывает обновление прогресса
    var progressRefresh: (() -> Void)?
    
    /// Метод обновления ячейки
    func layoutRefresh(_ percents: Float) {
        // Защита тела метода
        // Вид прогресса задан?
        guard let progressView = progressView else { return }
        // Надпись процентов задана?
        guard let progressLabel = progressLabel else { return }
        
        progressView.progress = percents
        progressLabel.text = "\(Int(percents*100))%"
    }
    
    override func layerWillDraw(_ layer: CALayer) {
        super.layerWillDraw(layer)
        progressRefresh?()
    }
}
