//
//  ViewController.swift
//  Open_Quizz
//
//  Created by Gabriel Larue on 2020-06-28.
//  Copyright © 2020 Gabriel Larue. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var game = Game();

    @IBOutlet weak var questionView: QuestionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private func startNewGame() {
        activityIndicator.isHidden = false;
        
        questionView.title = "Loading...";
        
        QuestionManager.shared.get { (success, newGameData) in
        if success, let newGameData = newGameData {
            self.update(newGameData: newGameData)
        }else{
                print("erreur")
        }
    }
        
        game.refresh();
    }
    
    func update(newGameData: NewGameData){
        game.questions = newGameData.questions!;
        game.state = .ongoing
        activityIndicator.isHidden = true
        
        guard game.currentQuestion != nil else {
            questionView.title = "Erreur, questions introuvables!"
            game.state = .over
            return
        }
        questionView.title = game.currentQuestion!.title
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startNewGame();
    }
    
    private func showQuestionView() {
        questionView.transform = .identity;
        questionView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01);
        
        switch game.state {
            case .ongoing:
                guard game.currentQuestion != nil else {
                    questionView.title = "Erreur, questions introuvables!"
                    game.state = .over
                    return
                }
                questionView.title = game.currentQuestion!.title;
            case .over:
                questionView.title = "Game Over";
        }
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: {
            self.questionView.transform = .identity;
        }, completion:nil)
    }

}

