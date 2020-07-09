//
//  ImageviewViewController.swift
//  newPangestureforSportsApp
//
//  Created by Superpower on 08/07/20.
//  Copyright © 2020 iMac superpower. All rights reserved.
//

import UIKit

class ImageviewViewController: UIViewController {

    @IBOutlet weak var myImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        myImageView.image = CroppedImage
        myImageView.contentMode = .scaleAspectFit
        // Do any additional setup after loading the view.
    }
    

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
