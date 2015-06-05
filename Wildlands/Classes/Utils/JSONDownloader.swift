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
    case DOWNLOAD_LEVELS = "?c=GetAllLevels"
    case DOWNLOAD_LAYERS = "?c=GetAllLayers"
}

protocol JSONDownloaderDelegate {
    
    /**
        Returns the response of the server in a object
    
        :param: response        The response, can be any object
     */
    func JSONDownloaderSuccess(response: AnyObject)
    
    /**
        Is called when the JSON download failed
    
        :param: message         A message with a description of the error
        :param: type            The DownloadType that failed
     */
    func JSONDownloaderFailed(message: String, type: DownloadType)
    
}

class JSONDownloader: NSObject, NSURLConnectionDelegate, NSURLConnectionDataDelegate {
    
    var delegate: JSONDownloaderDelegate?
    var data: NSMutableData = NSMutableData()
    let baseURL: String = "http://wildlands.doornbosagrait.tk/api/api.php"
    var currentType: DownloadType?
    var jsonArray: AnyObject?
    
    var imageURLs: [String] = []

    
    /**
        Start downloading JSON from server
    
        :param: DownloadType        The type of download
     */
    func downloadJSON(type: DownloadType) {
        
        currentType = type
        jsonArray = nil
        data = NSMutableData()
        
        // Add spinner in the statsubar
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        let urlString = baseURL + type.rawValue
        var url = NSURL(string: urlString)
        var request = NSURLRequest(URL: url!)
        // Start the connection
        var connection = NSURLConnection(request: request, delegate: self)
        
    }
    
    /**
        Received data from the server
     */
    func connection(connection: NSURLConnection, didReceiveData data: NSData) {
        
        self.data.appendData(data)
        
    }
    
    /**
        Downloading from the server failed
     */
    func connection(connection: NSURLConnection, didFailWithError error: NSError) {
        
        // Remove spinner from the statusbar
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        
        // Send message to delegate that download failed
        delegate?.JSONDownloaderFailed(error.localizedDescription, type: currentType!)
        
    }
    
    func connectionDidFinishLoading(connection: NSURLConnection) {
        
        // Spinner uitzetten
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        
        var error: NSError?
        // Convert NS data to NSDictionary or NSArray
        jsonArray = NSJSONSerialization.JSONObjectWithData(self.data, options: NSJSONReadingOptions.MutableContainers, error: &error)
        
        // If response from server is a dictionary it probably is a error
        if let jsonError = jsonArray as? NSDictionary {
            
            if jsonError.objectForKey("error") != nil {
            
                delegate?.JSONDownloaderFailed(jsonError.objectForKey("error") as! String, type: currentType!)
                // Prevent function from going on
                return
                
            }
            
        }
        
        // Check the downloadType and call the right function
        if (currentType == DownloadType.DOWNLOAD_PINPOINTS) {
            
            processPinPoints()
            
        } else if (currentType == DownloadType.DOWNLOAD_QUESTIONS) {
            
            processQuestions()
            
        } else if (currentType == DownloadType.DOWNLOAD_CHECKUM) {
            
            processDatabaseChecksum()
            
        } else if (currentType == DownloadType.DOWNLOAD_LEVELS) {
            
            processLevels()
            
        } else if (currentType == DownloadType.DOWNLOAD_LAYERS) {
            
            processLayers()
            
        }
        
    }
    
    /**
        Convert JSON to Pinpoint objects.
    
        :delegate:      Array with Pinpoint objects
     */
    func processPinPoints() {
        
        var pinPoints: [Pinpoint] = []
        
        // Concert JSON to NSArray
        if let JSONPinpoints = jsonArray as? NSArray {
            
            var i: Int = 0
            // Loop through all the Pinpoints
            for anPinpoint in JSONPinpoints {
                
                let pinPointProps = anPinpoint as! NSMutableDictionary
                var thePinpoint: Pinpoint = Pinpoint()
                thePinpoint.id = i
                thePinpoint.xPos = pinPointProps.objectForKey("xPos") as! CGFloat
                thePinpoint.yPos = pinPointProps.objectForKey("yPos") as! CGFloat
                thePinpoint.name = pinPointProps.objectForKey("name") as! String
                thePinpoint.pinDescription = pinPointProps.objectForKey("description") as! String
                if let photo = pinPointProps.objectForKey("image") as? String {
                    thePinpoint.photo = photo as String
                }
                
                // Check if Type object exisits
                if let type = pinPointProps.objectForKey("type") as? NSDictionary {
                    if let image = type.objectForKey("image") as? String {
                        thePinpoint.image = image
                    }
                    if let typeName = type.objectForKey("name") as? String {
                        thePinpoint.typeName = WildlandsTheme(rawValue: typeName)!
                    }
                    
                } else {
                    println("Could not parse pinPoint: type object not found.")
                }
                
                // Process the pages
                if let pages = pinPointProps.objectForKey("pages") as? NSArray {
                    
                    for aPage in pages {
                        
                        var page: ContentPage = ContentPage()
                        page.image = aPage.objectForKey("image") as! String
                        
                        // Add images to the images array so they can be downloaded
                        imageURLs.append(page.image)
                        page.title = aPage.objectForKey("title") as! String
                        page.content = aPage.objectForKey("text") as! String
                        
                        if let level = aPage.objectForKey("level") as? NSDictionary {
                            page.level = level.objectForKey("id") as! Int
                        }
                        
                        thePinpoint.pages.append(page)
                        
                    }
                    
                }
                
                // Add a trigger rectangle for GPS
                var rect = CGRectMake(thePinpoint.xPos - 40, thePinpoint.yPos - 40, 80, 80)
                thePinpoint.trigger = rect
                
                pinPoints.append(thePinpoint)
                i++
                
            }
            
        }
        
        // Send our pinpoints to are delegate
        delegate?.JSONDownloaderSuccess(pinPoints)
        
    }
    
    /**
        Process questions.

        :delegate:      Array with Question objects
     */
    func processQuestions() {
        
        var questions: [Question] = []
        
        if let JSONVragen = jsonArray as? NSArray {
            
            for deVraag in JSONVragen {
                
                let dict = deVraag as! NSMutableDictionary
                // Make a new Question object
                var eenVraag: Question = Question()
                eenVraag.id = dict.objectForKey("id") as! Int
                eenVraag.text = dict.objectForKey("text") as! String
                eenVraag.imageURL = dict.objectForKey("image") as! String
                // Add images to the images array so they can be downloaded
                imageURLs.append(eenVraag.imageURL)
                
                if let type = deVraag.objectForKey("type") as? NSDictionary {
                    if let typeName = type.objectForKey("name") as? String {
                        eenVraag.typeName = typeName
                    }
                }
                
                if let levelDict = deVraag.objectForKey("level") as? NSDictionary {
                    if let levelID = levelDict.objectForKey("id") as? Int {
                        eenVraag.levelID = levelID
                    }
                }
                
                var antwoorden: NSArray = dict.objectForKey("answers") as! NSArray
                
                // Loop trough the answers
                for antwoord in antwoorden {
                    
                    // Put the answers in a dictionairy
                    let hetAntwoord = antwoord as! NSMutableDictionary
                    var eenAntwoord: Answer = Answer()
                    eenAntwoord.text = hetAntwoord.objectForKey("text") as! String
                    
                    if hetAntwoord.objectForKey("rightWrong") as! Bool {
                        eenAntwoord.isRightAnswer = true
                    }
                    // Add this answer to the answers
                    eenVraag.addAnswer(eenAntwoord)
                    
                }
                questions.append(eenVraag)
                
            }
            
        }
        
        // Send our questions to the delegate
        delegate?.JSONDownloaderSuccess(questions)
        
    }
    
    /**
        Process database checksum.

        :delegate:      Int with database checksum
     */
    func processDatabaseChecksum() {
        
        var checksum: Int = 0
        
        if let JSONCheckum = jsonArray as? NSMutableDictionary {
            
            checksum = JSONCheckum.objectForKey("checksum") as! Int
            
        }
        
        // Send our checksum to the delegate
        delegate?.JSONDownloaderSuccess(checksum)
        
    }
    
    /**
        Process the levels.
    
        :delegate:      Array with Level objects
     */
    func processLevels() {
        
        var levels: [Level] = []
        
        if let jsonLevels = jsonArray as? NSArray {
            
            for level in jsonLevels {
                
                let deLevel = level as! NSDictionary
                
                var eenLevel: Level = Level()
                eenLevel.id = deLevel.objectForKey("id") as! Int
                eenLevel.name = deLevel.objectForKey("name") as! String
                
                levels.append(eenLevel)
                
            }
            
        }
        
        // Send levels to the delegate
        delegate?.JSONDownloaderSuccess(levels)
        
    }
    
    /**
        Process the layers.
     */
    func processLayers() {
        
        if let jsonLayers = jsonArray as? NSArray {
            
            for layer in jsonLayers {
             
                let theLayer = layer as! NSDictionary
                
                if let type = theLayer.objectForKey("type") as? NSDictionary {
                    
                    if type.objectForKey("name") as! String == "Bio Mimicry" {
                        Utils.saveObjectToDisk(theLayer.objectForKey("image") as! String, forKey: WildlandsTheme.BIO_MIMICRY.rawValue)
                    }
                    if type.objectForKey("name") as! String == "Materiaal" {
                        Utils.saveObjectToDisk(theLayer.objectForKey("image") as! String, forKey: WildlandsTheme.MATERIAAL.rawValue)
                    }
                    if type.objectForKey("name") as! String == "Water" {
                        Utils.saveObjectToDisk(theLayer.objectForKey("image") as! String, forKey: WildlandsTheme.WATER.rawValue)
                    }
                    if type.objectForKey("name") as! String == "Energie" {
                        Utils.saveObjectToDisk(theLayer.objectForKey("image") as! String, forKey: WildlandsTheme.ENERGIE.rawValue)
                    }
                    if type.objectForKey("name") as! String == "Dierenwelzijn" {
                        Utils.saveObjectToDisk(theLayer.objectForKey("image") as! String, forKey: WildlandsTheme.DIERENWELZIJN.rawValue)
                    }
                    
                }
                
                imageURLs.append(theLayer.objectForKey("image") as! String)
                
            }
            
            delegate?.JSONDownloaderSuccess(LayerResponse())
            
        } else {
            
            delegate?.JSONDownloaderFailed("Kon Layers niet verwerken", type: .DOWNLOAD_LAYERS)
            
        }
        
    }
    

}
