//
//  DeviceDetailViewController.swift
//  DeviceManager
//
//  Created by Spencer Curtis on 9/12/18.
//  Copyright © 2018 Lambda School. All rights reserved.
//

import UIKit

class DeviceDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    @IBAction func putDevice(_ sender: Any) {
        guard let record = deviceController?.keys[recordIndex] else { return }
        
        deviceController?.updateDevice(record: record, completion: { (_) in
            print("Update successful!")
            DispatchQueue.main.async {
                self.updateViews()
            }
        })
    }
    
    @IBAction func postDevice(_ sender: Any) {
        
        guard let record = deviceController?.keys[recordIndex] else { return }
        
        deviceController?.updateDeviceWithPOST(record: record, completion: { (_) in
            print("Update successful!")
            DispatchQueue.main.async {
                self.updateViews()
            }
        })
    }
    
    @IBAction func postDevice2(_ sender: Any) {
        guard let record = deviceController?.keys[recordIndex] else { return }
        
        deviceController?.updateDeviceWithPOST2(record, completion: { (_) in
            print("Update 2 successful!")
            DispatchQueue.main.async {
                self.updateViews()
            }
        })
    }
    
    private func updateViews() {
        guard let device = device else { return }
        
        modelLabel.text = device.model.rawValue
        identifierLabel.text = device.uuid
        
        let record = deviceController?.keys[recordIndex]
        
        recordLabel.text = record
    }
    
    var deviceController: DeviceController?
    var device: Device?
    var recordIndex: Int = 0
  
    @IBOutlet weak var modelLabel: UILabel!
    @IBOutlet weak var identifierLabel: UILabel!
    @IBOutlet weak var recordLabel: UILabel!
    
}
