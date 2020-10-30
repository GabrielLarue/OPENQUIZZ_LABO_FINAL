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

    @IBOutlet weak var incorrectLabel: UILabel!
    
    var scoreIncorrect: Int = 0 {
        didSet{
            if(oldValue != scoreIncorrect) {
                modifLabelIncorrect()
            }
        }
    };
    


    @IBOutlet weak var newGameButton: UIButton!
    
    @IBAction func didTapNewGame() {
        startNewGame();
    }

    
    private func startNewGame() {
        newGameButton.isHidden = true;
        activityIndicator.isHidden = false;
        
        questionView.style = .standard;
        questionView.title = "Loading...";
        incorrectLabel.text = "0"
        
        
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
        newGameButton.setBackgroundImage(UIImage(data: newGameData.imageData!), for: .normal)
        activityIndicator.isHidden = true
        newGameButton.isHidden = false;
        
        print(newGameData.imageData!)
        
        guard game.currentQuestion != nil else {
            questionView.title = "Erreur, questions introuvables!"
            game.state = .over
            return
        }
        questionView.title = game.currentQuestion!.title
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(dragQuestionView(_:)));
        questionView.addGestureRecognizer(panGestureRecognizer)
        startNewGame();
    }
    
    @objc func dragQuestionView(_ sender: UIPanGestureRecognizer) {
        if game.state == .ongoing {
            switch sender.state {
            case .began, .changed:
                transformQuestionViewWith(gesture: sender);
            case .ended, .cancelled:
                answerQuestion();
            default:
                break;
            }
        }
    }
    
    private func transformQuestionViewWith(gesture: UIPanGestureRecognizer) {
        let screenWidth = UIScreen.main.bounds.width;
        
        let translation = gesture.translation(in: questionView);
        let translationPercent = translation.x/(screenWidth/2);
        let rotationAngle = (CGFloat.pi/6) * translationPercent;
        let rotationTransform = CGAffineTransform(rotationAngle: rotationAngle)
        let translationTransform = CGAffineTransform(translationX: translation.x, y: translation.y)
        let transform = translationTransform.concatenating(rotationTransform);
        
        if translation.x > 0 {
            questionView.style = .correct;
        }else {
            questionView.style = .incorrect;
        }
        
        questionView.transform = transform;
    }
    
    private func answerQuestion() {
        switch questionView.style {
            case .correct:
                game.answerCurrentQuestion(with: true);
            case .incorrect:
                game.answerCurrentQuestion(with: false);
            case .standard:
                break;
        }
        scoreIncorrect = game.incorrectAnswer
      
        let screenWidth = UIScreen.main.bounds.width;
        
        var translationTransform: CGAffineTransform;
        
        if questionView.style == .correct {
            translationTransform = CGAffineTransform(translationX: screenWidth, y: 0);
        } else {
            translationTransform = CGAffineTransform(translationX: -screenWidth, y: 0);
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            self.questionView.transform = translationTransform
        }, completion: { (success) in
            if success {
                self.showQuestionView();
            }
        });

    }
    
    private func showQuestionView() {
        questionView.transform = .identity;
        questionView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01);
        
        questionView.style = .standard;
        
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

    private func modifLabelIncorrect(){
        incorrectLabel.text = "\(game.incorrectAnswer)";
        incorrectLabel.transform = CGAffineTransform(scaleX: 3.5, y: 3.5);
        UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: {
            self.incorrectLabel.transform = .identity;
        }, completion:nil)
    }
    
}

