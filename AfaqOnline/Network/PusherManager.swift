//
//  PusherManager.swift
//  AfaqOnline
//
//  Created by MGoKu on 7/12/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import Foundation
import PusherSwift


class PusherManager: PusherDelegate {
    static let shared = PusherManager()
    var pusher: Pusher!
    let options = PusherClientOptions(
      host: .cluster("eu")
    )

    
    func connectPusher() {
        pusher = Pusher (
          key: "34c74d3251d60d194475",
          options: options
        )
        pusher.delegate = self
        pusher.connect()
    }
    
    func ListenToChannel(ChannelId room_id: Int, completion: @escaping (_ data: PusherEvent) -> Void) {
        // subscribe to channel
        let channel = pusher.subscribe("room.\(room_id)")

        // bind a callback to handle an event
        let _ = channel.bind(eventName: "new_message", eventCallback: { (event: PusherEvent) in
            completion(event)
        })
    }
    // print Pusher debug messages
    func debugLog(message: String) {
      print(message)
    }
}
