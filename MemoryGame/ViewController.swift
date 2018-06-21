//
//  ViewController.swift
//  Memory game
//
//  Created by Polina Guryeva on 19/06/2018.
//  Copyright © 2018 Polina Guryeva. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var scoreTitle: UILabel!
    var score = 0
    
    var firstCard: Card? = nil
    var secondCard: Card? = nil
    var cards: [Card] = []
    
    let cardNames = ["card1-1.jpg", "card2-1.jpg", "card3-1.jpg", "card4-1.jpg",
                     "card5-1.jpg", "card6-1.jpg", "card7-1.jpg", "card8-1.jpg"]
    let backSideImage = UIImage(named: "back_side.jpg")
    let COUNT_CARD_IN_ROW = 4
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        initCards()
        cardsLayout()
        shuffle()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cardWasChosen(_ sender: Card) {
        
        sender.setImage(sender.backgroundImage(for: .normal), for: .normal)
        
        if firstCard == nil {
            firstCard = sender
        } else {
            secondCard = sender
            score += 1
        }
        
        if let first = firstCard {
            if let second = secondCard {
                if first.backgroundImage(for: .normal) != second.backgroundImage(for: .normal) {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4, execute: {
                        first.setImage(self.backSideImage, for: .normal)
                        second.setImage(self.backSideImage, for: .normal)
                    })
                } else {
                    first.isEnabled = false
                    first.wasFounded = true
                    second.isEnabled = false
                    second.wasFounded = true
                }
                firstCard = nil
                secondCard = nil
            }
        }
        
        if gameFinished() {
            let alert = UIAlertController(title: "Congratulation", message: "Your result is \(score)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "New game!", style: .default, handler:  { action in
                self.newGame();
            }))
            self.present(alert, animated: true, completion: nil)
        }
        scoreTitle.text = "Score: \(score)"
    }
    
    func newGame() {
        score = 0
        scoreTitle.text = "Score: \(score)"
        for card in cards {
            card.setImage(backSideImage!, for: .normal)
            card.isEnabled = true
            card.wasFounded = false
        }
        shuffle()
    }
    
    func gameFinished() -> Bool {
        for card in cards {
            if !card.wasFounded {
                return false
            }
        }
        return true
    }
    
    func initCards() {
        for name in cardNames {
            cards.append(Card(image: backSideImage!, backgroundImage: UIImage(named: name)!))
            cards.append(Card(image: backSideImage!, backgroundImage: UIImage(named: name)!))
        }
    }
    
    func shuffle() {
        
        for _ in 0..<cards.count {
            let first = Int(arc4random_uniform(UInt32(cards.count)))
            let second = Int(arc4random_uniform(UInt32(cards.count)))
            
            if first != second {
                let bufImage = cards[first].backgroundImage(for: .normal)
                cards[first].setBackgroundImage(cards[second].backgroundImage(for: .normal), for: .normal)
                cards[second].setBackgroundImage(bufImage, for: .normal)
            }
        }
    }
    
    func cardsLayout() {
        let offsetBeetwenCardsW: CGFloat = self.view.frame.width / 25.0
        let offsetBeetwenCardsH: CGFloat = self.view.frame.height / 25.0
        
        let width = min((backSideImage?.size.width)!,  view.frame.width  / CGFloat(COUNT_CARD_IN_ROW) - offsetBeetwenCardsW) + offsetBeetwenCardsW
        let height = min((backSideImage?.size.height)!, view.frame.height / CGFloat(COUNT_CARD_IN_ROW) - offsetBeetwenCardsH) + offsetBeetwenCardsH
        
        let offsetBeforeFirstCardW = (view.frame.width  - (CGFloat(COUNT_CARD_IN_ROW) * width)) / 2.0
        let offsetBeforeFirstCardH = (view.frame.height - (CGFloat(COUNT_CARD_IN_ROW) * height)) / 2.0
        
        for i in 0..<COUNT_CARD_IN_ROW {
            for j in 0..<COUNT_CARD_IN_ROW {
                cards[i * COUNT_CARD_IN_ROW + j].frame = CGRect(x: CGFloat(CGFloat(i) * width + offsetBeforeFirstCardW),
                                                                y: CGFloat(CGFloat(j) * height + offsetBeforeFirstCardH),
                                                                width: (backSideImage?.size.width)!,
                                                                height: (backSideImage?.size.height)!)
                cards[i * COUNT_CARD_IN_ROW + j].addTarget(self, action: #selector(cardWasChosen(_:)), for: .touchUpInside)
                view.addSubview(cards[i * COUNT_CARD_IN_ROW + j])
            }
        }
    }
    
    
    
}

