//
//  Game.swift
//  Open_Quizz
//
//  Created by Gabriel Larue on 2020-06-28.
//  Copyright © 2020 Gabriel Larue. All rights reserved.
//

import Foundation

class Game{
    
    enum State{
        case ongoing, over
    }
    
    var questions: [Question] = [];
    var state: State = .ongoing;
    private var currentIndex: Int = 0;
    var currentQuestion: Question? {
        get {
            guard currentIndex < questions.count else {
                return nil
            }
            return questions[currentIndex];
        }
    };
    
    
    func refresh(){
        state = .over;
        currentIndex = 0;
        }
}
    
