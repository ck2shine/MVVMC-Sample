/*
 * Copyright (c) Rakuten Payment, Inc. All Rights Reserved.
 *
 * This program is the information asset which are handled
 * as "Strictly Confidential".
 * Permission of use is only admitted in Rakuten Payment, Inc.
 * If you don't have permission, MUST not be published,
 * broadcast, rewritten for broadcast or publication
 * or redistributed directly or indirectly in any medium.
 */

import Foundation
import UIKit
import Combine
extension UIControl{
    public class InteractionSubscription<S: Subscriber>: Subscription where S.Input == (){
        
        private let subscribe: S?
        private let control: UIControl
        private let event: UIControl.Event
        
        
        public init(subscriber: S ,
             control: UIControl,
             event: UIControl.Event){
            self.subscribe = subscriber
            self.control = control
            self.event = event
            
            self.control.addTarget(self, action: #selector(handleEvent(_:)), for: event)
        }
        
        @objc func handleEvent(_ sender: UIControl){
            _ = self.subscribe?.receive(())
        }
        
        
        public func request(_ demand: Subscribers.Demand) {}
        
        public func cancel() {}
    }
    
    public struct InteractionPublisher: Publisher{
        
        public typealias Output = ()
        
        public typealias Failure = Never
        
        
        private let control: UIControl
        private let event: UIControl.Event
        
        public init(control: UIControl , event: UIControl.Event){
            self.control = control
            self.event = event
            
        }
        
        public func receive<S>(subscriber: S) where S : Subscriber, Never == S.Failure, () == S.Input {
            
            let subscription = InteractionSubscription(subscriber: subscriber, control: self.control, event: self.event)
            
            subscriber.receive(subscription: subscription)
        }
    }
    
    public func publisher(for event: UIControl.Event) -> UIControl.InteractionPublisher{
        return InteractionPublisher(control: self, event: event)
    }
}
