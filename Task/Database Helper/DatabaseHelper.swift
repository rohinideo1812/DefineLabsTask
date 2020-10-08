//
//  DatabaseHelper.swift
//  Task
//
//  Created by Rohini Deo on 07/10/20.
//  Copyright © 2020 Taxgenie. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class DataBaseHelper : NSObject{
    
    static let shareInstance = DataBaseHelper()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var matchedData = [Match]()
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Match")
    
    func saveMatchData(details : VenueDetails){
        let match = NSEntityDescription.insertNewObject(forEntityName: "Match", into: context) as! Match
        match.id = details.id
        match.name = details.name
        match.address = details.location.address
        match.phone = details.contact.phone
        match.country = details.location.country
        do{
            try context.save()
        }catch let error{
            print(error.localizedDescription)
        }
    }
    
    func getAllData()->([Match]){
        do {
            matchedData = try context.fetch(request) as! [Match]
        } catch let error{
            print(matchedData,error.localizedDescription)
        }
        return (matchedData)
    }
    
    func deleteMatchData(index:Int)->[Match]{
        matchedData = self.getAllData()
        context.delete(matchedData[index])
        matchedData.remove(at: index)
        do{
            try context.save()
        }catch let error{
            print(error.localizedDescription)
        }
        return matchedData
    }
    
    func deleteData(){
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch let error{
            print (error.localizedDescription)
        }
    }
}
