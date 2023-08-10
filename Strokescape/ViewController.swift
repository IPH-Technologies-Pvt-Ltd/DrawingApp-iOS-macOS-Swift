//
//  ViewController.swift
//  Strokescape
//
//  Created by IPH Technologies Pvt. Ltd. on 08/08/23.
//

import UIKit
class ViewController: UIViewController {
    
    @IBOutlet weak var canvasView: Canvas!
    @IBOutlet weak var undoButton: UIButton!
    @IBOutlet weak var redoButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var eraserButton: UIButton!
    @IBOutlet weak var lineButton: UIButton!
    
    var lineIndicator = true
    var eraserIndicator = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        canvasView.backgroundColor = .white
        canvasView.setNeedsDisplay()
    }
    
    @IBAction func undoAction(_ sender: UIButton) {
        print("Undo lines")
        canvasView.undo()
    }
    
    @IBAction func redoAction(_ sender: UIButton) {
        print("Redo lines")
        canvasView.redo()
    }
    
    @IBAction func clearAction(_ sender: UIButton) {
        print("Clear lines")
        canvasView.clear()
    }
    
    @IBAction func inkColorAction(_ sender: UIButton) {
        canvasView.inkColor(color: sender.backgroundColor ?? .black)
    }
    
    @IBAction func eraserAction(_ sender: UIButton) {
        if eraserIndicator{
            eraserButton.backgroundColor = UIColor.lightGray
            eraserIndicator = false
            canvasView.eraser()
        }
        else{
            eraserButton.backgroundColor = UIColor.white
            eraserIndicator = true
            canvasView.defaultPencil()
        }
    }
    
    @IBAction func lineAction(_ sender: UIButton) {
        print("you clicked me!")
        if lineIndicator{
            lineButton.backgroundColor = UIColor.lightGray
            lineIndicator = false
        }
        else{
            lineButton.backgroundColor = UIColor.white
            lineIndicator = true
        }
        canvasView.straightLineIdentifier = !canvasView.straightLineIdentifier
    }
}
