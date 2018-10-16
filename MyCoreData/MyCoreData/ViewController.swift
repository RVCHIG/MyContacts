//
//  ViewController.swift
//  MyCoreData
//
//  Created by cis290 on 10/15/18.
//  Copyright © 2018 Rock Valley College. All rights reserved.
//

import UIKit

import CoreData

class ViewController: UIViewController {
    @IBOutlet weak var strong: UITextField!
    @IBOutlet weak var weak: UITextField!
    @IBOutlet weak var sour: UITextField!
    @IBOutlet weak var sweet: UITextField!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var status: UILabel!
    
    @IBAction func btnEdit(_ sender: UIButton) {
        strong.isEnabled = true
        weak.isEnabled = true
        sour.isEnabled = true
        sweet.isEnabled = true
        btnSave.isHidden = false
        btnEdit.isHidden = true
        strong.becomeFirstResponder()
    }
    
    @IBAction func btnBack(_ sender: UIBarButtonItem) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func btnSave(_ sender: UIButton) {
        if (contactdb != nil)
        {
            
            contactdb.setValue(strong.text, forKey: "strong")
            contactdb.setValue(weak.text, forKey: "weak")
            contactdb.setValue(sour.text, forKey: "sour")
            contactdb.setValue(sweet.text, forKey: "sweet")
            
        }
        else
        {
            let entityDescription =
                NSEntityDescription.entity(forEntityName: "Cocktail",in: managedObjectContext)
            
            let cocktail = Cocktail(entity: entityDescription!,
                                  insertInto: managedObjectContext)
            
            cocktail.strong = strong.text!
            cocktail.weak = weak.text!
            cocktail.sour = sour.text!
            cocktail.sweet = sweet.text!
        }
        var error: NSError?
        do {
            try managedObjectContext.save()
        } catch let error1 as NSError {
            error = error1
        }
        
        if let err = error {
            //if error occurs
            status.text = err.localizedFailureReason
        } else {
            self.dismiss(animated: false, completion: nil)
            
        }
        //**End Copy**
    }
    
   
    
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var contactdb:NSManagedObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if (contactdb != nil)
        {
            strong.text = contactdb.value(forKey: "strong") as? String
            weak.text = contactdb.value(forKey: "weak") as? String
            sour.text = contactdb.value(forKey: "sour") as? String
            sweet.text = contactdb.value(forKey: "sweet") as? String
            btnSave.setTitle("Update", for: UIControl.State())
            btnEdit.isHidden = false
            strong.isEnabled = false
            weak.isEnabled = false
            sour.isEnabled = false
            sweet.isEnabled = false
            btnSave.isHidden = true
        }else{
            btnEdit.isHidden = true
            strong.isEnabled = true
            weak.isEnabled = true
            sour.isEnabled = true
            sweet.isEnabled = true
        }
        strong.becomeFirstResponder()
        // Do any additional setup after loading the view.
        //Looks for single or multiple taps
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.DismissKeyboard))
        //Adds tap gesture to view
        view.addGestureRecognizer(tap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches , with:event)
        if (touches.first as UITouch!) != nil {
            DismissKeyboard()
        }
    }
    

    //7 Add to hide keyboard
    
    @objc func DismissKeyboard(){
        //forces resign first responder and hides keyboard
        strong.endEditing(true)
        weak.endEditing(true)
        sour.endEditing(true)
        sweet.endEditing(true)
        
    }
   
    //8 Add to hide keyboard
    
    func textFieldShouldReturn(_ textField: UITextField!) -> Bool     {
        textField.resignFirstResponder()
        return true;
    }

}

