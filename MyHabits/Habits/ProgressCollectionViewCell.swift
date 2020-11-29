//
//  ProgressCollectionViewCell.swift
//  MyHabits
//
//  Created by Andrey Antipov on 17.11.2020.
//  Copyright © 2020 Andrey Antipov. All rights reserved.
//

import UIKit

class ProgressCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var progressLabel: UILabel!
    
    /// Доля выполненных привычек (от 0 до 1)
    public var percents: Float = HabitsStore.shared.todayProgress {
        didSet(value) {
            percentsShow()
        }
    }
    
    private func percentsShow() {
        progressView.progress = percents
        progressLabel.text = "\(Int(percents*100))%"
    }
    
    override func layerWillDraw(_ layer: CALayer) {
        percentsShow()
    }
}
