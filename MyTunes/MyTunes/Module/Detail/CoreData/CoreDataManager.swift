//
//  CoreDataManager.swift
//  MyTunes
//
//  Created by Mert AKBAŞ on 9.06.2023.
//

import CoreData
import UIKit

class CoreDataManager {
    static let shared = CoreDataManager()

    func saveAudioData(_ trackid: Int64) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        let newWord = NSEntityDescription.insertNewObject(forEntityName: "FavoriAudio", into: context)
        newWord.setValue(trackid, forKey: "trackid")
        do {
            try context.save()
        } catch {
            print("Kayıt başarısız")
        }
    }
    
    func fetchAudioData() -> [Int] {
        var trackIds: [Int] = []
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return trackIds }
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FavoriAudio")
        
        do {
            let results = try context.fetch(fetchRequest)
            if let favoriAudios = results as? [NSManagedObject] {
                for favoriAudio in favoriAudios {
                    if let trackId = favoriAudio.value(forKey: "trackid") as? Int {
                        trackIds.append(trackId)
                    }
                }
            }
        } catch {
            print(error.localizedDescription)
        }
        
        return trackIds
    }

    func deleteAudioData(withTrackId trackId: Int) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FavoriAudio")
        fetchRequest.predicate = NSPredicate(format: "trackid == %d", trackId)
        
        do {
            let results = try context.fetch(fetchRequest)
            if let favoriAudios = results as? [NSManagedObject], let favoriAudio = favoriAudios.first {
                context.delete(favoriAudio)
                try context.save()
            }
        } catch {
            print(error.localizedDescription)
        }
    }

  
}
