//
//  AppDelegate.swift
//  Messenger
//
//  Created by Carter Appleton on 4/9/15.
//  Copyright (c) 2015 Carter Appleton. All rights reserved.
//

import Cocoa
import WebKit

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    
    @IBOutlet weak var webView: WebView!
    
    private var initialRequest: NSURLRequest!
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        
        // Insert code here to initialize your application
        self.initialRequest = NSURLRequest(URL: NSURL(string: "https://www.messenger.com/")!)
        webView.resourceLoadDelegate = self
        webView.mainFrame.loadRequest(initialRequest)
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }
    
    func sendMessageNotification(fromUserName: NSString, message: NSString) {
        var notification = NSUserNotification()
        notification.title = "\(fromUserName)"
        notification.informativeText = message as String
        notification.deliveryDate = NSDate()
        notification.soundName = NSUserNotificationDefaultSoundName
        var center = NSUserNotificationCenter.defaultUserNotificationCenter()
        center.scheduleNotification(notification)
    }
    
    override func webView(sender: WebView!, resource identifier: AnyObject!, didFinishLoadingFromDataSource dataSource: WebDataSource!) {
        
        for resource in dataSource.subresources as! [WebResource] {
            if let url = resource.URL {
                let urlString = url.absoluteString! as NSString
                if urlString.containsString("-edge-chat.messenger.com") {
                    if let body = resource.data {
                        let str = NSString(data: body, encoding: NSUTF8StringEncoding)
                        
                        if let str = str {
                            let jsonString = str.substringFromIndex(9)
                            
                            var parseError: NSError?
                            let obj: AnyObject? = NSJSONSerialization.JSONObjectWithData(jsonString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, options: NSJSONReadingOptions.AllowFragments, error: nil)
                            if let dict = obj as? NSDictionary {
                                if let ms = dict["ms"] as? NSArray {
                                    if let msData = ms[0] as? NSDictionary {
                                        if let event = msData["event"] as? NSString {
                                            if event == "deliver" {
                                                
                                                if let message = msData["message"] as? NSDictionary {
                                                    
                                                    if let groupInfo = message["group_thread_info"] as? NSDictionary {
                                                        if let name = groupInfo["name"] as? NSString {
                                                            if let fromName = message["sender_name"] as? NSString {
                                                                if let message = message["body"] as? NSString {
                                                                    self.sendMessageNotification("\(fromName) (in \(name))", message: message)
                                                                }
                                                            }
                                                        }
                                                    } else {
                                                        if let fromName = message["sender_name"] as? NSString {
                                                            if let message = message["body"] as? NSString {
                                                                self.sendMessageNotification(fromName, message: message)
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            
                            //NSLog("\(jsonString)")
                        }

                        
                        
                        
                        
                    }
                }
                
            }
        }
        
        /*
        
 {
        "t":"msg",
        "seq":5,
        "u":532284176,
        "tr":"uToBB",
        "ms":
            [{
                "message":{
                    "subject":null,
                    "body":"jjj",
                    "timestamp":1428785225446,
                    "mid":"mid.1428785225364:288ed8a462e9f78461",
                    "tid":"id.1458485277763806",
                    "sender_fbid":640520940,
                    "offline_threading_id":null,
                    "sender":"640520940\u0040facebook.com",
                    "sender_name":"Kevin Chen",
                    "tags":"source:messenger:web,inbox",
                    "source":"source:unknown",
                    "attachmentIds":null,
                    "forward":0,
                    "replyActionType":0,
                    "coordinates":null,
                    "action_id":"1428785225539000000",
                    "prev_last_visible_action_id":"1428785210842000000",
                    "mercury_author_id":"fbid:640520940",
                    "mercury_author_email":"640520940\u0040facebook.com",
                    "is_spoof_warning":false,
                    "mercury_source":"source:messenger:web",
                    "mercury_source_tags":[],
                    "mercury_coordinates":null,
                    "html_body":"",
                    "short_source":1,
                    "is_unread":true,
                    "has_attachment":false,
                    "attachments":[],
                    "attachment_map":{},
                    "share_map":null,
                    "ranges":[],
                    "threading_id":"\u003C1428785224989:3289365017-1042948294\u0040mail.projektitan.com>",
                    "api_tags":["inbox","source:web"],
                    "timestamp_absolute":"Today",
                    "timestamp_datetime":"4:47pm",
                    "timestamp_relative":"4:47pm",
                    "timestamp_time_passed":0,
                    "group_thread_info":{
                        "participant_ids":[640520940,532284176,697877541,100001280754725],
                        "participant_names":["Kevin","Carter","Michelle","Zack"],
                        "participant_total_count":4,
                        "name":"actual belieze",
                        "pic_hash":""},
                    "thread_fbid":1458485277763806},"event":"deliver","html":"","msg_body":"","is_unread":true,"folder":"inbox","thread_row":"","unread_counts":{"other":0,"spam":0,"sent":3,"inbox":3},"new_participants":"","realtime_viewer_fbid":532284176,"type":"messaging"}]}

*/
        
    }


}

