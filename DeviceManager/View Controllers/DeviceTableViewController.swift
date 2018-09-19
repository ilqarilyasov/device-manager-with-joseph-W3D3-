//
//  DeviceTableViewController.swift
//  DeviceManager
//
//  Created by Spencer Curtis on 9/12/18.
//  Copyright © 2018 Lambda School. All rights reserved.
//

import UIKit

class DeviceTableViewController: UITableViewController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        deviceController.fetchDevicesFromServer { (_) in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func addDevice(_ sender: Any) {
        deviceController.createNewDevice { (_) in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return deviceController.devices.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DeviceCell", for: indexPath)

        let device = deviceController.devices[indexPath.row]
        
        cell.textLabel?.text = device.model.rawValue
        cell.detailTextLabel?.text = device.uuid

        return cell
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ViewDevice" {
            
            guard let indexPath = tableView.indexPathForSelectedRow,
                let destinationVC = segue.destination as? DeviceDetailViewController else { return }
            
            let device = deviceController.devices[indexPath.row]
            
            destinationVC.device = device
            destinationVC.deviceController = deviceController
            destinationVC.recordIndex = indexPath.row
        }
    }
    
    let deviceController = DeviceController()
}
