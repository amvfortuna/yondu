//
//  SyndicationUpdatePeriod.swift
//
//  Copyright (c) 2016 Nuno Manuel Dias
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import Foundation

/**
 
 Describes the period over which the channel format is updated. Acceptable
 values are: hourly, daily, weekly, monthly, yearly. If omitted, daily is
 assumed.
 
 */
public enum SyndicationUpdatePeriod: String {

    /** 
     
     Every hour, the channel is updated the number of times specified 
     by `syUpdateFrequency`
     
     */
    case Hourly = "hourly"
    
    /** 
     
     Every day, the channel is updated the number of times specified 
     by `syUpdateFrequency`
     
     */
    case Daily = "daily"
    
    /** 
     
     Every week, the channel is updated the number of times specified 
     by `syUpdateFrequency`
     
     */
    case Weekly = "weekly"
    
    /** 
     
     Every month, the channel is updated the number of times specified 
     by `syUpdateFrequency`
     
     */
    case Monthly = "monthly"
    
    /** 
     
     Every year, the channel is updated the number of times specified 
     by `syUpdateFrequency
     
     */
    case Yearly = "yearly"
    
}

extension SyndicationUpdatePeriod {
    
    /**
     
     Lowercase the incoming `rawValue` string to try and match the
     `SyUpdatePeriod`'s `rawValue`
     
     */
    public init?(rawValue: String) {
        
        switch rawValue.lowercased() {
            
        case "hourly":  self = .Hourly
        case "daily":   self = .Daily
        case "weekly":  self = .Weekly
        case "monthly": self = .Monthly
        case "yearly":  self = .Yearly
            
        default: return nil
            
        }
        
    }
    
}
