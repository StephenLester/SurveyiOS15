//
//  SurveyViewController.swift
//  SurveyiOS15
//
//  Created by Steve Lester on 10/5/17.
//  Copyright © 2017 Steve Lester. All rights reserved.
//

import UIKit

class SurveyViewController: UIViewController {

   
    
    @IBAction func submitButtonTapped(_ sender: Any) {
    
    guard let name = nameTextField.text, let emoji = emojiTextField.text, name != "", !emoji.isEmpty else { return }
        SurveyController.shared.putSurvey(wirh: name, emoji: emoji) { (success) in
            guard success else { return }
            DispatchQueue.main.async {
                // Clears out the textFields
                self.nameTextField.text = ""
                self.emojiTextField.text = ""
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var emojiTextField: UITextField!

    


}
