//
//  ViewController.swift
//  project5
//
//  Created by Renoy Chowdhury on 27/10/2019.
//  Copyright © 2019 Renoy Chowdhury. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    var allWords = [String]()
    var usedWords = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAswer))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(startGame))
        
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt"){
            if let startWords = try? String(contentsOf: startWordsURL) {
                allWords = startWords.components(separatedBy: "\n")
            }
        }

        if allWords.isEmpty {
            allWords = ["silaworm"]
        }
        
        startGame()
    }
    
    @objc
    func startGame() {
        title = allWords.randomElement()
        self.usedWords.removeAll()
        tableView.reloadData()
    }
    
    func submit(_ answer: String){
        let lowerAswer = answer.lowercased()
        
        let errorTitle: String = "ERROR"
        
        if isPossible(word: lowerAswer) {
            if isOriginal(word: lowerAswer){
                if isReal(word: lowerAswer) {
                    if answer == title {
                        showErrorMessage(title: errorTitle, message: "Cant use the same word brosuke")
                        return
                    }else {
                        usedWords.insert(answer, at: 0)
                    }
                    
                    let indexPath = IndexPath(row: 0, section: 0)
                    tableView.insertRows(at: [indexPath], with: .automatic)
                    
                    return
                } else {
                    showErrorMessage(title: errorTitle, message: "Not a real word hue")
                }
            } else {
                showErrorMessage(title: errorTitle, message: "Already tried dummeh")
            }
        } else {
            showErrorMessage(title: errorTitle, message: "Nice try ma dudleton")
        }
    }
    
    func showErrorMessage(title: String, message: String) {
        
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Okke", style: .cancel))
        present(ac, animated: true)
    }
    
    
    func isPossible(word: String) -> Bool {
        guard var tmpWord = title?.lowercased() else { return false }
        
        for letter in word {
            if let position = tmpWord.firstIndex(of: letter) {
                tmpWord.remove(at: position)
            } else {
                return false
            }
        }
        
        return true
    }
    
    func isOriginal(word: String) -> Bool {
        return !usedWords.contains(word)
    }
    
    func isReal(word: String) -> Bool  {
        if word.count < 3 {
            showErrorMessage(title: "Error", message: "less than 3 letters don count Boii")
            return false
        } else {
            let checker = UITextChecker()
            let range = NSRange(location: 0, length: word.utf16.count)
            let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
            return misspelledRange.location == NSNotFound
        }
    }
    
    @objc
    func promptForAswer() {
        let alertController = UIAlertController(title: "Enter Aswer", message: nil, preferredStyle: .alert)
        alertController.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self, weak alertController ] _ in
            guard let answer = alertController?.textFields?.first?.text else { return }
            self?.submit(answer)
        }
        
        alertController.addAction(submitAction)
        present(alertController, animated: true)
    }
    
    // UITABLEVIEW
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usedWords.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "word", for: indexPath)
        cell.textLabel?.text = usedWords[indexPath.row]
        
        return cell
    }
    
}
