//
//  AnalogClockView.swift
//  AnalogClock
//
//  Created by Jan Doornbos on 10-05-15.
//  Copyright (c) 2015 Doornbos Agra-IT. All rights reserved.
//

import UIKit

@objc protocol AnalogClockDelegate {
    
    optional func currentTimeOnClock(clock: AnalogClockView, hours: String, minutes: String, seconds: String)
    optional func dateFormatterForClock(clock: AnalogClockView) -> String
    optional func timeForClock(clock: AnalogClockView) -> String
    optional func analogClock(clock: AnalogClockView, graduationColorForIndex: Int) -> UIColor
    optional func analogClock(clock: AnalogClockView, graduationAlphaForIndex: Int) -> CGFloat
    optional func analogClock(clock: AnalogClockView, graduationWidthForIndex: Int) -> CGFloat
    optional func analogClock(clock: AnalogClockView, graduationLengthForIndex: Int) -> CGFloat
    optional func analogClock(clock: AnalogClockView, graduationOffsetForIndex: Int) -> CGFloat
    
    optional func clockDidBeginLoading(clock: AnalogClockView)
    optional func clockDidFinishLoading(clock: AnalogClockView)
    
}

@IBDesignable

class AnalogClockView: UIView, UIGestureRecognizerDelegate {

    var delegate: AnalogClockDelegate?
    @IBInspectable var hours: Int = 10
    @IBInspectable var minutes: Int = 10
    @IBInspectable var seconds: Int = 0
    @IBInspectable var enableShadows: Bool = true
    @IBInspectable var enableGraduations: Bool = false
    @IBInspectable var enableDigit: Bool = false
    @IBInspectable var realTime: Bool = false
    @IBInspectable var currentTime: Bool = false
    @IBInspectable var setTimeViaTouch: Bool = false
    @IBInspectable var militaryTime: Bool = false
    
    @IBInspectable var faceBackgroundColor: UIColor = UIColor.blackColor()
    @IBInspectable var faceBackgroundAlpha: CGFloat = 1.0
    @IBInspectable var borderColor: UIColor = UIColor.whiteColor()
    @IBInspectable var borderAlpha: CGFloat = 1.0
    @IBInspectable var borderWidth: CGFloat = 2.0
    @IBInspectable var digitFont: UIFont = UIFont.systemFontOfSize(12)
    @IBInspectable var digitColor: UIColor = UIColor.whiteColor()
    @IBInspectable var digitOffset: CGFloat = 0.0
    
    @IBInspectable var hourHandColor: UIColor = UIColor.whiteColor()
    @IBInspectable var hourHandAlpha: CGFloat = 1.0
    @IBInspectable var hourHandWidth: CGFloat = 4.0
    @IBInspectable var hourHandLength: CGFloat = 30.0
    @IBInspectable var hourHandOffsetLength: CGFloat = 10.0
    
    @IBInspectable var minuteHandColor: UIColor = UIColor.whiteColor()
    @IBInspectable var minuteHandAlpha: CGFloat = 1.0
    @IBInspectable var minuteHandWidth: CGFloat = 3.0
    @IBInspectable var minuteHandLength: CGFloat = 55.0
    @IBInspectable var minuteHandOffsetLength: CGFloat = 20.0
    
    @IBInspectable var secondHandColor: UIColor = UIColor.whiteColor()
    @IBInspectable var secondHandAlpha: CGFloat = 1.0
    @IBInspectable var secondHandWidth: CGFloat = 1.0
    @IBInspectable var secondHandLength: CGFloat = 60.0
    @IBInspectable var secondHandOffsetLength: CGFloat = 20.0
    
    private(set) var realTimeIsActivated: Bool = false
    private(set) var shouldUpdateSubviews: Bool = true
    private(set) var timerAlreadyInAction: Bool = false
    private(set) var skipOneCycle: Bool = false
    
    private var graduationColor: UIColor = UIColor.blackColor()
    private var graduationAlpha: CGFloat = 1.0
    private var graduationWidth: CGFloat = 1.0
    private var graduationLength: CGFloat = 5.0
    private var graduationOffset: CGFloat = 10.0
    
    private var oldMinutes: Int?
    private var hourHand: AnalogClockHandView = AnalogClockHandView()
    private var minuteHand: AnalogClockHandView = AnalogClockHandView()
    private var secondHand: AnalogClockHandView = AnalogClockHandView()
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        
    }

    required init(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
    }
    
    override func layoutSubviews() {
        
        if shouldUpdateSubviews {
            
            self.delegate?.clockDidBeginLoading?(self)
            
            if self.delegate?.dateFormatterForClock?(self) != nil && self.delegate?.timeForClock?(self) != nil {
                self.getTimeFromString()
            }
            
            if currentTime {
                self.setClockToCurrentTime(animated: true)
            }
            
            self.timeFormatVerification()
            
            self.hourHand = AnalogClockHandView(frame: CGRectMake(0, 0, self.frame.size.width, self.frame.size.height))
            self.hourHand.degree = degreesFrom(hour: self.hours, andMinutes: self.minutes)
            self.hourHand.color = self.hourHandColor
            self.hourHand.alpha = self.hourHandAlpha
            self.hourHand.width = self.hourHandWidth
            self.hourHand.length = self.hourHandLength
            self.hourHand.offsetLength  = self.hourHandOffsetLength
            self.addSubview(self.hourHand)
            
            self.minuteHand = AnalogClockHandView(frame: CGRectMake(0, 0, self.frame.size.width, self.frame.size.height))
            self.minuteHand.degree = degreesFrom(minutes: self.minutes)
            self.minuteHand.color = self.minuteHandColor
            self.minuteHand.alpha = self.minuteHandAlpha
            self.minuteHand.width = self.minuteHandWidth
            self.minuteHand.length = self.minuteHandLength
            self.minuteHand.offsetLength  = self.minuteHandOffsetLength
            self.addSubview(self.minuteHand)
            
            self.secondHand = AnalogClockHandView(frame: CGRectMake(0, 0, self.frame.size.width, self.frame.size.height))
            self.secondHand.degree = degreesFrom(minutes: self.seconds)
            self.secondHand.color = self.secondHandColor
            self.secondHand.alpha = self.secondHandAlpha
            self.secondHand.width = self.secondHandWidth
            self.secondHand.length = self.secondHandLength
            self.secondHand.offsetLength  = self.secondHandOffsetLength
            self.addSubview(self.secondHand)
            
            if !self.enableShadows {
                self.hourHand.shadowEnabled = false
                self.minuteHand.shadowEnabled = false
                self.secondHand.shadowEnabled = false
            }
            
            if self.realTime && !self.timerAlreadyInAction {
                self.realTimeIsActivated = true
                self.timerAlreadyInAction = true
                NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "updateEverySecond", userInfo: nil, repeats: true)
            }
            
            if self.setTimeViaTouch {
                var panView: UIView = UIView(frame: CGRectMake(0, 0, self.frame.size.width, self.frame.size.height))
                panView.backgroundColor = UIColor.clearColor()
                self.viewForBaselineLayout()?.addSubview(panView)
    
                var panGesture: UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: "handlePan:")
                panGesture.delegate = self
                panGesture.maximumNumberOfTouches = 1
                panView.addGestureRecognizer(panGesture)
            }
            
            self.delegate?.currentTimeOnClock?(self, hours: "\(self.hours)", minutes: "\(self.minutes)", seconds: "\(self.seconds)")
            
            self.shouldUpdateSubviews = false
            
            self.delegate?.clockDidFinishLoading?(self)
            
        }
        
    }
    
    func updateEverySecond() {
        
        if realTimeIsActivated {
            self.seconds += 1
            if self.skipOneCycle {
                self.skipOneCycle = false
            } else {
                self.timeFormatVerification()
                AnalogClockHandView.rotateHand(self.secondHand, rotationDegree: self.degreesFrom(minutes: self.seconds))
                self.delegate?.currentTimeOnClock?(self, hours: "\(self.hours)", minutes: "\(self.minutes)", seconds: "\(self.seconds)")
            }
        }
    }
    
    func reloadClock() {
        self.subviews.map({ $0.removeFromSuperview() })
        shouldUpdateSubviews = true
        self.setNeedsLayout()
        self.setNeedsDisplay()
    }
    
    func updateTime(#animated: Bool) {
        
        if self.delegate?.dateFormatterForClock?(self) != nil && self.delegate?.timeForClock?(self) != nil {
            self.getTimeFromString()
        }
        
        self.timeFormatVerification()
        
        if animated {
            
            skipOneCycle = true
            AnalogClockHandView.rotateHand(self.minuteHand, rotationDegree: self.degreesFrom(minutes: self.minutes))
            AnalogClockHandView.rotateHand(self.hourHand, rotationDegree: self.degreesFrom(hour: self.hours, andMinutes: self.minutes))
            AnalogClockHandView.rotateHand(self.secondHand, rotationDegree: self.degreesFrom(minutes: self.seconds))
            
        } else {
            
            let minDegree: CGFloat = self.degreesFrom(minutes: self.minutes) * CGFloat(M_PI / 180.0)
            let hourDegree: CGFloat = self.degreesFrom(hour: self.hours, andMinutes: self.minutes) * CGFloat(M_PI / 180.0)
            let secondDegree: CGFloat = self.degreesFrom(minutes: self.seconds) * CGFloat(M_PI / 180.0)
            
            self.minuteHand.transform = CGAffineTransformMakeRotation(minDegree)
            self.hourHand.transform = CGAffineTransformMakeRotation(hourDegree)
            self.secondHand.transform = CGAffineTransformMakeRotation(secondDegree)
            
        }
        
        self.delegate?.currentTimeOnClock?(self, hours: "\(self.hours)", minutes: "\(self.minutes)", seconds: "\(self.seconds)")
        
    }
    
    func setClockToCurrentTime(#animated: Bool) {
        
    }
    
    func startRealTime() {
    
        self.realTimeIsActivated = true
        if self.realTime && !timerAlreadyInAction {
            timerAlreadyInAction = true
            NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "updateEverySecond", userInfo: nil, repeats: true)
        }
    
    }
    
    func stopRealTime() {
        self.realTimeIsActivated = false
    }
    
    func handlePan(recognizer: UIPanGestureRecognizer) {
        
    }
    
    func timeFormatVerification() {
        
        if self.hours > 12 && !self.militaryTime {
            self.hours -= 12
        }
        
        if self.seconds >= 60 {
            self.seconds = 0
            self.minutes += 1
            AnalogClockHandView.rotateHand(self.minuteHand, rotationDegree: self.degreesFrom(minutes: self.minutes))
            AnalogClockHandView.rotateHand(self.hourHand, rotationDegree: self.degreesFrom(hour: self.hours, andMinutes: self.minutes))
        } else if self.seconds < 0 {
            self.seconds = 59
            self.minutes -= 1
            AnalogClockHandView.rotateHand(self.minuteHand, rotationDegree: self.degreesFrom(minutes: self.minutes))
            AnalogClockHandView.rotateHand(self.hourHand, rotationDegree: self.degreesFrom(hour: self.hours, andMinutes: self.minutes))
        }
        
        if self.minutes >= 60 {
            self.minutes = 0
            self.hours += 1
        } else if self.minutes < 0 {
            self.minutes = 59
            self.hours -= self.hours - 1
        }
        
        if !self.militaryTime {
            if self.hours >= 13 {
                self.hours = 1
            } else if self.hours <= 0 {
                self.hours = 12
            }
        } else {
            if self.hours >= 24 {
                self.hours = 00
            } else if self.hours <= 0 {
                self.hours = 23
            }
        }
    }
    
    func degreesFrom(#hour: Int, andMinutes minutes: Int) -> CGFloat {
        
        return CGFloat(hour * 30) + CGFloat(minutes/10) * 6.0;
        
    }
    
    func degreesFrom(#minutes: Int) -> CGFloat {
        
        return CGFloat(minutes * 6)
        
    }
    
    func getTimeFromString() {
        
        let stringDateFormatter: String? = self.delegate?.dateFormatterForClock?(self)
        let stringTime: String? = self.delegate?.timeForClock?(self)
        
        let dateFormatter: NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = stringDateFormatter
        let time: NSDate = dateFormatter.dateFromString(stringTime!)!
        
        let calendar: NSCalendar = NSCalendar.currentCalendar()
        let components: NSDateComponents = calendar.components((.CalendarUnitHour | .CalendarUnitMinute), fromDate: time)
        
        self.hours = components.hour
        self.minutes = components.minute
        
    }
    
    override func drawRect(rect: CGRect) {
        
        var ctx: CGContextRef = UIGraphicsGetCurrentContext()
        CGContextAddEllipseInRect(ctx, rect)
        CGContextSetFillColorWithColor(ctx, self.faceBackgroundColor.CGColor)
        CGContextSetAlpha(ctx, self.faceBackgroundAlpha)
        CGContextFillPath(ctx)
        
        CGContextAddEllipseInRect(ctx, CGRectMake(rect.origin.x + self.borderWidth / 2, rect.origin.y + self.borderWidth / 2, rect.size.width - self.borderWidth, rect.size.height - self.borderWidth))
        CGContextSetStrokeColorWithColor(ctx, self.borderColor.CGColor)
        CGContextSetAlpha(ctx, self.borderAlpha)
        CGContextSetLineWidth(ctx, self.borderWidth)
        CGContextStrokePath(ctx)
        
    }
    
}
