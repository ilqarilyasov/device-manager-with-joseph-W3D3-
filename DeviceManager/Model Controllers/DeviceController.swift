//
//  DeviceController.swift
//  DeviceManager
//
//  Created by Spencer Curtis on 9/12/18.
//  Copyright © 2018 Lambda School. All rights reserved.
//

import Foundation

class DeviceController {
    
    func fetchDevicesFromServer(completion: @escaping (Error?) -> Void) {
        
        let request = createRequest(method: .get)
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            
            if let error = error {
                NSLog("Error fetching devices from server: \(error)")
                completion(error)
                return
            }
            
            guard let data = data else {
                NSLog("No data returned from data task")
                completion(NSError())
                return
            }
            
            do {
                self.deviceDictionary = try JSONDecoder().decode([String: Device].self, from: data)
                completion(nil)
            } catch {
                NSLog("Error decoding data: \(error)")
                completion(error)
                return
            }
        }.resume()
    }
    
    func createRandomDevice() -> Device {
        return Device(model: Model.randomModel())
    }
    
    // POST
    func createNewDevice(completion: @escaping (Error?) -> Void) {
        let newDevice = createRandomDevice()
        postDevice(device: newDevice, completion: completion)
    }
    
    func postDevice(device: Device, completion: @escaping (Error?) -> Void) {
        let request = createRequest(with: device, method: .post)
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error posting new device: \(error)")
                completion(error)
                return
            }
            
            guard let data = data else {
                NSLog("No data returned")
                completion(NSError())
                return
            }
            
            do {
                let postReply = try JSONDecoder().decode([String:String].self, from: data)
                let keys = Array(postReply.keys)
                
                guard keys.count == 1, keys[0] == "name" else {
                    NSLog("Post not succedssful")
                    completion(NSError())
                    return
                }
                
                self.deviceDictionary[postReply["name"]!] = device
                print("Post was successful")
                completion(nil)
                
            } catch {
                NSLog("Error decoding data: \(error)")
                completion(error)
                return
            }
        }.resume()
    }
    
    // Update the device's unique identifier (PUT)
    func updateDevice(record: String, completion: @escaping (Error?) -> Void) {
        
        guard let device = deviceDictionary[record] else {
            fatalError("Unanle to retreive device by key")
        }
        
        let replacementDevice = Device.init(model: device.model)
        
        let request = createRequest(with: replacementDevice, method: .put, record: record)
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error updating \(replacementDevice): \(error)")
                completion(error)
                return
            }
            
            guard let data = data else {
                NSLog("No data returned")
                completion(NSError())
                return
            }
            
            let responseString = String(data: data, encoding: .utf8)!
            NSLog(responseString)
            NSLog("Device updated with PUT")
            self.deviceDictionary[record] = replacementDevice
            completion(nil)
        }.resume()
        
    }
    
    func updateDeviceWithPOST(record: String, completion: @escaping (Error?) -> Void) {
        
        guard let device = deviceDictionary[record] else {
            fatalError("Unable to retrieve device by key")
        }
        
        let replacementDevice = Device(model: device.model)
        
        let request = createRequest(with: replacementDevice, method: .post, record: record)
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            
            if let error = error {
                NSLog("Error updating device: \(error)")
                completion(error)
                return
            }
            
            guard let data = data else {
                NSLog("No data returned from data task")
                completion(NSError())
                return
            }
            
            let responseString = String(data: data, encoding: .utf8)!
            NSLog(responseString)
            
            NSLog("Device and record updated with post")
            self.deviceDictionary[record] = replacementDevice
            completion(nil)
            
            }.resume()
    }
    
    public func updateDeviceWithPOST2(_ record: String, completion: @escaping (Error?) -> Void) {
        guard let device = deviceDictionary[record] else {
            fatalError("Unable to retrieve device by key.")
        }
        
        // Assign it a new UUID string
        let replacementDevice = Device(model: device.model)
        let request = createRequest(with: replacementDevice, method: .post)
        
        // Start URL session
        let task = URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error POSTing new device: \(error)")
                completion(error)
                return
            }
            
            guard let data = data else {
                NSLog("Data was not recieved from service")
                completion(NSError())
                return
            }
            
            let response = String(data: data, encoding: .utf8)!
            NSLog(response)
            
            NSLog("Device UUID string updated with post")
            self.deviceDictionary[record] = replacementDevice
            completion(nil)
        }
        task.resume()
        
    }
    
    func createRequest(with device: Device? = nil, method: HTTPMethod, record: String? = nil) -> URLRequest {
        
        var requestURL = baseURL.appendingPathComponent("devices")
        
        if let record = record {
            // When PUTting, this is making sure we PUT the device in a unique location
            requestURL.appendPathComponent(record)
        }
        
        requestURL.appendPathExtension("json")
        
        var request = URLRequest(url: requestURL)
        
        request.httpMethod = method.rawValue
        
        // If there is a device, we want to encode it and use it as the body of the request.
        guard let device = device else { return request }
        
        do {
            request.httpBody = try JSONEncoder().encode(device)
            
            return request
        } catch {
            fatalError("Error encoding device \(device): \(error)")
        }
    }


    let baseURL = URL(string: "https://put-and-post.firebaseio.com/")!
    
    private(set) var deviceDictionary: [String: Device] = [:]
    
    var devices: [Device] { return Array(deviceDictionary.values) }
    var keys: [String] { return Array(deviceDictionary.keys) }
    
    
}
