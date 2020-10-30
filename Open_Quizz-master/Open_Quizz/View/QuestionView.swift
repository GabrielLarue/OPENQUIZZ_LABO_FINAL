//
//  QuestionView.swift
//  Open_Quizz
//
//  Created by Gabriel Larue on 2020-07-01.
//  Copyright © 2020 Gabriel Larue. All rights reserved.
//

import UIKit

class QuestionView: UIView {

    @IBOutlet private var label: UILabel!;
    
    var title: String = "" {
        didSet{
            label.text = title;
        }
    }
    
}
