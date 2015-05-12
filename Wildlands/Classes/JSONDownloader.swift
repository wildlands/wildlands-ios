//
//  JSONDownloader.swift
//  Wildlands
//
//  Created by Jan on 24-03-15.
//  Copyright (c) 2015 INF2A. All rights reserved.
//

import Foundation
import UIKit

enum DownloadType: String {
    case DOWNLOAD_PINPOINTS = "?c=GetAllPinpoints"
    case DOWNLOAD_QUESTIONS = "?c=GetAllQuestions"
    case DOWNLOAD_CHECKUM = "?c=GetDatabaseChecksum"
}

protocol JSONDownloaderDelegate {
    
    func JSONDownloaderSuccess(response: AnyObject)
    func JSONDownloaderFailed(message: String, type: DownloadType)
    
}

class JSONDownloader: NSObject, NSURLConnectionDelegate, NSURLConnectionDataDelegate {
    
    var delegate: JSONDownloaderDelegate?
    var data: NSMutableData = NSMutableData()
    let baseURL: String = "http://wildlands.doornbosagrait.tk/api/api.php"
    var currentType: DownloadType?
    var jsonArray: AnyObject?

    
    /*
     * Start downloaden van JSON vanaf de server
     *
     * @param DownloadType      Wat moet er gedownload worden?
     */
    func downloadJSON(type: DownloadType) {
        
        currentType = type
        jsonArray = nil
        data = NSMutableData()
        
        // Spinner in statusbar inschakelen
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        let urlString = baseURL + type.rawValue
        var url = NSURL(string: urlString)
        var request = NSURLRequest(URL: url!)
        var connection = NSURLConnection(request: request, delegate: self)
        
    }
    
    /*
     * Download ontving data...
     */
    func connection(connection: NSURLConnection, didReceiveData data: NSData) {
        
        self.data.appendData(data)
        
    }
    
    /*
     * Downloaden van data is mislukt...
     */
    func connection(connection: NSURLConnection, didFailWithError error: NSError) {
        
        // Spinner uitzetten
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        
        delegate?.JSONDownloaderFailed(error.localizedDescription, type: currentType!)
        
    }
    
    func connectionDidFinishLoading(connection: NSURLConnection) {
        
        // Spinner uitzetten
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        
        var error: NSError?
        // Data omzetten in JSON
        jsonArray = NSJSONSerialization.JSONObjectWithData(self.data, options: NSJSONReadingOptions.MutableContainers, error: &error)
        
        if (currentType == DownloadType.DOWNLOAD_PINPOINTS) {
            
            processPinPoints()
            
        } else if (currentType == DownloadType.DOWNLOAD_QUESTIONS) {
            
            processQuestions()
            
        } else if (currentType == DownloadType.DOWNLOAD_CHECKUM) {
            
            processDatabaseChecksum()
            
        }
        
    }
    
    /*
     * Pinpoint JSON omzetten in Pinpoint objecten
     *
     * @delegate    Array met Pinpoint objecten
     */
    func processPinPoints() {
        
        var pinPoints: [Pinpoint] = []
        
        // Ontvangen JSON omzetten in NSArray
        if let JSONPinpoints = jsonArray as? NSArray {
            
            var i: Int = 0
            // Door alle ontvangen Pinpoint loopen
            for anPinpoint in JSONPinpoints {
                
                let pinPointProps = anPinpoint as! NSMutableDictionary
                var thePinpoint: Pinpoint = Pinpoint()
                //thePinpoint.id = pinPointProps.objectForKey("id") as Int
                thePinpoint.id = i
                thePinpoint.xPos = pinPointProps.objectForKey("xPos") as! CGFloat
                thePinpoint.yPos = pinPointProps.objectForKey("yPos") as! CGFloat
                thePinpoint.name = pinPointProps.objectForKey("name") as! String
                thePinpoint.pinDescription = pinPointProps.objectForKey("description") as! String
                if let photo = pinPointProps.objectForKey("image") as? String {
                    thePinpoint.photo = photo as String
                }
                
                // Checken of type object bestaat
                if let type = pinPointProps.objectForKey("type") as? NSDictionary {
                    if let image = type.objectForKey("image") as? String {
                        thePinpoint.image = image
                    }
                    if let typeName = type.objectForKey("name") as? String {
                        thePinpoint.typeName = typeName
                    }
                    
                } else {
                    println("Could not parse pinPoint: type object not found.")
                }
                
                // Pagina's verwerken in pinpoint
                if let pages = pinPointProps.objectForKey("pages") as? NSArray {
                    
                    for aPage in pages {
                        
                        var page: ContentPage = ContentPage()
                        page.image = aPage.objectForKey("image") as! String
                        page.title = aPage.objectForKey("title") as! String
                        page.content = aPage.objectForKey("text") as! String
                        thePinpoint.pages.append(page)
                        
                    }
                    
                }
                
                var rect = CGRectMake(thePinpoint.xPos - 40, thePinpoint.yPos - 40, 80, 80)
                thePinpoint.trigger = rect
                
                pinPoints.append(thePinpoint)
                i++
                
            }
            
        }
        
        delegate?.JSONDownloaderSuccess(pinPoints)
        
    }
    
    func processQuestions() {
        
        var questions: [Question] = []
        
        if let JSONVragen = jsonArray as? NSArray {
            
            for deVraag in JSONVragen {
                
                let dict = deVraag as! NSMutableDictionary
                // Maak een nieuwe vraag aan
                var eenVraag: Question = Question(text: dict.objectForKey("text") as! String)
                
                if let type = deVraag.objectForKey("type") as? NSDictionary {
                    if let typeName = type.objectForKey("name") as? String {
                        eenVraag.typeName = typeName
                    }
                }
                
                var antwoorden: NSArray = dict.objectForKey("answers") as! NSArray
                
                // Door alle antwoorden loopen
                for antwoord in antwoorden {
                    
                    // Antwoord in dictionary zetten
                    let hetAntwoord = antwoord as! NSMutableDictionary
                    var eenAntwoord: Answer = Answer()
                    eenAntwoord.text = hetAntwoord.objectForKey("text") as? String
                    
                    if hetAntwoord.objectForKey("rightWrong") as! Bool {
                        eenAntwoord.isRightAnswer = true
                    }
                    // Antwoord toevoegen aan de antwoorden
                    eenVraag.addAnswer(eenAntwoord)
                    
                }
                questions.append(eenVraag)
                
            }
            
        }
        
        delegate?.JSONDownloaderSuccess(questions)
        
    }
    
    func processDatabaseChecksum() {
        
        var checksum: Int = 0
        
        if let JSONCheckum = jsonArray as? NSMutableDictionary {
            
            checksum = JSONCheckum.objectForKey("checksum") as! Int
            
        }
        
        delegate?.JSONDownloaderSuccess(checksum)
        
    }
    

}
