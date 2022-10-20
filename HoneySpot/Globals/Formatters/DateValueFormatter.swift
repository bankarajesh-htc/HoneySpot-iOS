//
//  DateValueFormatter.swift
//  ChartsDemo-iOS
//
//  Created by Jacob Christie on 2017-07-09.
//  Copyright © 2017 jc. All rights reserved.
//

import Foundation
import Charts

public class DateValueFormatter: NSObject, AxisValueFormatter {
    private let dateFormatter = DateFormatter()
    private var _values: [String] = [String]()
    private var _valueCount: Int = 0
    private var valueString:String?
    @objc public var values: [String]
    {
        get
        {
            return _values
        }
        set
        {
            _values = newValue
            _valueCount = _values.count
        }
    }

    
    override init() {
        super.init()
    }
    @objc public init(values: [String])
    {
        super.init()
        self.values = values
    }
    @objc public static func with(values: [String]) -> IndexAxisValueFormatter?
    {
        return IndexAxisValueFormatter(values: values)
    }
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        
        let index = Int(value.rounded())
        guard values.indices.contains(index), index == Int(value) else { return "" }
        valueString = GlobalFunctions.convertDateStringForChart(dateString: _values[index], passedDateFormatter: "yyyy-MM-dd")
        return valueString!
        
       // return dateFormatter.string(from: Date(timeIntervalSince1970: value))
    }
}
