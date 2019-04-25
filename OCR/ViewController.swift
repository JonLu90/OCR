//
//  ViewController.swift
//  OCR
//
//  Created by Jon Lu on 4/24/19.
//  Copyright © 2019 Jon Lu. All rights reserved.
//

import UIKit
import TesseractOCR

class ViewController: UIViewController {

    let uploadButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.backgroundColor = .gray
        return button
    }()
    
    let textView: UITextView = {
        let textView = UITextView(frame: .zero)
        textView.backgroundColor = .lightGray
        textView.text = "nutrition information :"
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        config()
    }


    private func performOCR(image: UIImage) {
        if let tess = G8Tesseract(language: "eng") {
            tess.engineMode = .tesseractCubeCombined
            tess.pageSegmentationMode = .auto
            tess.image = image.g8_blackAndWhite()
            tess.recognize()
            textView.text = tess.recognizedText
        }
    }
    
    private func setupView() {
        let naviBarHeight = self.navigationController?.navigationBar.bounds.height ?? 0
        let screenHeight = view.bounds.height - naviBarHeight
        let screenWidth = view.bounds.width
        view.backgroundColor = .white
        
        uploadButton.frame = CGRect(x: 0, y: screenHeight - 60, width: 120, height: 30)
        uploadButton.center.x = view.center.x
        uploadButton.setTitle("choose image", for: .normal)
        view.addSubview(uploadButton)

        textView.frame = CGRect(x: 0, y: naviBarHeight + 48, width: screenWidth - 16, height: screenHeight - 200)
        textView.center.x = view.center.x
        view.addSubview(textView)
    }
    
    private func config() {
        uploadButton.addTarget(self, action: #selector(presentImageLibrary(sender:)), for: .touchUpInside)
    }
    
    @objc private func presentImageLibrary(sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        navigationController?.present(imagePicker, animated: true, completion: nil)
    }
}

extension ViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedPhoto = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            print("photo resolution : \(selectedPhoto.size)")
            
            textView.text = "Processing ..."

            navigationController?.dismiss(animated: true, completion: {
                self.performOCR(image: selectedPhoto)
            })
        }
    }
}

extension ViewController: UINavigationControllerDelegate {}
