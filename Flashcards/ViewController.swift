//
//  ViewController.swift
//  Flashcards
//
//  Created by Grace Carlson on 10/13/18.
//  Copyright © 2018 GraceCarlson. All rights reserved.
//

import UIKit

//declaring the flashcard struct
struct Flashcard {
    var question: String
    var answer: String
}

class ViewController: UIViewController {

    
    @IBOutlet weak var frontLabel: UILabel!
    @IBOutlet weak var backLabel: UILabel!
    
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    //array to hold out flashcards
    var flashcards = [Flashcard]()
    
    //flashcard index
    var currentIndex = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //read saved flashcards
        readSavedFlashcards()
        
        //set the first flashcard
        if flashcards.count == 0{
            updateFlashcard(question: "What's the capital of Colorado?", answer: "Denver")
        } else{
            updateLables()
            updateNextPreviousButtons()
        }
    }
    
    //controller for prev button
    @IBAction func didTapOnPrevious(_ sender: Any) {
        
        currentIndex = currentIndex - 1
        
        //update labels
        updateLables()
        
        //update prev and next buttons
        updateNextPreviousButtons()
    }
    
    
    //controller for next button
    @IBAction func didTapOnNext(_ sender: Any) {
        //updating index
        currentIndex = currentIndex + 1
        
        //updating labels
        updateLables()
        
        //update next and previous buttons
        updateNextPreviousButtons()
    }
    
    
    @IBAction func didTapOnFlashCard(_ sender: Any) {
        if frontLabel.isHidden == true{
            frontLabel.isHidden = false
        } else {
            frontLabel.isHidden = true
        }
    }
    
    func updateFlashcard(question: String, answer: String){
        let flashcard = Flashcard(question: question, answer: answer)
        
        //adding flashcard to flashcards array
        flashcards.append(flashcard)
        print("added new flashcard")
        print("we now have \(flashcards.count) flashcards")
        
        //update current Index
        currentIndex = flashcards.count - 1
        print("our currentIndex is \(currentIndex)")
        
        //update prev and next buttons
        updateNextPreviousButtons()
        
        //update labels
        updateLables()
        
        
    }
    
    //updating previous and next buttons
    func updateNextPreviousButtons() {
        
        //disable the next button if at the end
        if currentIndex == flashcards.count - 1 {
            nextButton.isEnabled = false
            
        } else {
            nextButton.isEnabled = true
        }
        
        //diable prev button if at the beginning
        
        if currentIndex == 0 {
            previousButton.isEnabled = false
        } else {
            previousButton.isEnabled = true
        }
        
    }
    
    //updating labels
    func updateLables() {
        
        print("current index \(currentIndex)")
        //get current flashcard
        let currentFlashcard = flashcards[currentIndex]
        
        //update labels
        frontLabel.text = currentFlashcard.question
        backLabel.text = currentFlashcard.answer
    }
    
    //saving flashcards
    func saveAllFlashcardsToDisk() {
        
        //from flashcard array to dictionary array
        let dictionaryArray = flashcards.map { (card) -> [String: String] in
            return ["question": card.question, "answer": card.answer]
        }
        
        //storing flashcards to disk
        UserDefaults.standard.set(dictionaryArray, forKey: "flashcards")
        
        //log it
        print("flashcards saved to UserDefaults")
    }
    
    //reading old flashcards from the disk
    func readSavedFlashcards() {
        //read flashcards from the disk, if any
        if let dictionaryArray = UserDefaults.standard.array(forKey: "flashcards") as? [[String: String]]{
            let savedCards = dictionaryArray.map { dictionary  -> Flashcard in
                return Flashcard(question: dictionary["question"]!, answer: dictionary["answer"]!)
            }
            
            //put all these cards into our flashcards array
            flashcards.append(contentsOf: savedCards)
            
        }
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let navigationController = segue.destination as! UINavigationController
        
        let creationController = navigationController.topViewController as! CreationViewController
        
        creationController.flashcardsController = self
    }
    
}

