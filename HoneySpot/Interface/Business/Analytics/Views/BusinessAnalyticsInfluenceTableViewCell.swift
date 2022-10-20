//
//  BusinessAnalyticsInfluenceTableViewCell.swift
//  HoneySpot
//
//  Created by Kaan Baris BAYRAK on 25.02.2021.
//  Copyright © 2021 HoneySpot. All rights reserved.
//

import UIKit
import Charts

class BusinessAnalyticsInfluenceTableViewCell: UITableViewCell,ChartViewDelegate {

	@IBOutlet var titleLabel: UILabel!
	@IBOutlet var selectTimePeriod: UIButton!
	@IBOutlet var emptyView: UIView!
	@IBOutlet var chartView: UIView!
    @IBOutlet var selectedChartView: UIView!
	
	@IBOutlet var totalUsersCount: UILabel!
	@IBOutlet var totalUserCountPercentage: UILabel!
	@IBOutlet var totalUserCountPercentageImage: UIImageView!
	
	@IBOutlet var totalHoneyspotUsersCount: UILabel!
	@IBOutlet var totalHoneyspotUsersPercentage: UILabel!
	@IBOutlet var totalHoneyspotUserPercentageImage: UIImageView!
    
    @IBOutlet weak var approximateReachSelectedView: UIView!
    @IBOutlet weak var totalHoneySpotersSelectedView: UIView!
	
    var influenceArr = [ActivityType]()
    var influenceCompareArr = [ActivityType]()
    var influenceRange = 0
    var selectedType = "approximatereach"
    let customMarkerView = CustomMarkerView()
	
	@IBAction func selectTimePeriodTapped(_ sender: Any) {
	
	}
    
    
    func prepareCell(){
        DispatchQueue.main.async {
            self.configureView()
        }
    }
    
    @IBAction func approximateReachTapped(_ sender: Any) {
        selectedType = "approximatereach"
        configureView()
        
    }
    
    @IBAction func totalHoneySpotersTapped(_ sender: Any) {
        selectedType = "totalhoneyspoters"
        //configureView()
        
    }
    
    func configureView(){
        
       
        
        if(selectedType == "approximatereach"){
            
            approximateReachSelectedView.isHidden = false
            totalHoneySpotersSelectedView.isHidden = true
        }
        else if(selectedType == "totalhoneyspoters"){
            
            approximateReachSelectedView.isHidden = true
            totalHoneySpotersSelectedView.isHidden = false
        }
            
        configureChart()
    }
    
    
    
    func configureChart(){
        
        
        
        for v in selectedChartView.subviews {
            v.removeFromSuperview()
        }
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "yyyy-MM-dd"
        
        var dataKeyArray = [String]()
        var dataValuesArray = [Double]()
        var dataDateValuesArray = [Double]()
        
        let cal = Calendar.current
        var d = Date()
        d.changeDays(by: 1)
        var date = cal.startOfDay(for: d)
        var days = [Int]()
        
        for i in 1 ... self.influenceRange {
            let day = cal.component(.day, from: date)
            days.append(day)
            date = cal.date(byAdding: .day, value: -1, to: date)!
            dataKeyArray.append(dateFormatterPrint.string(from: date))
            dataDateValuesArray.append(date.timeIntervalSince1970)
        }
        
        dataKeyArray.reverse()
        dataDateValuesArray.reverse()
        
        
        for i in dataKeyArray{
            print(i)
            var val = 0
            for j in self.influenceArr {
                if (i == dateFormatterPrint.string(from:j.date)){
                    
                    if(selectedType == "approximatereach")
                    {
                        val = j.reachCount
                        if(j.eventName == "feedFull"){
                            
                        }
                        
                    }
                    else if(selectedType == "totalhoneyspoters")
                    {
                        if(j.eventName == "spotAdd"){
                            val += j.userCount
                        }
                    }
                }
                
            }
            dataValuesArray.append(Double(val))
        }
        
        let chart = LineChartView()
        chart.frame = CGRect(x: 0, y: 0, width: selectedChartView.frame.width, height: selectedChartView.frame.height)
        chart.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        chart.backgroundColor = UIColor.clear
        chart.delegate = self
        chart.leftAxis.enabled = true
        customMarkerView.chartView = chart
        chart.marker = customMarkerView
        
        
        
        
        var data = [LineChartDataSet]()
        var value = [ChartDataEntry]()
        for i in 0..<dataKeyArray.count {
            value.append(ChartDataEntry(x: dataDateValuesArray[i], y: dataValuesArray[i]))
        }
        
        let dataSet = LineChartDataSet(entries: value, label: "Data")
        data.append(dataSet)
        dataSet.axisDependency = .left
        dataSet.colors = [UIColor(red: 245.0/255.0, green: 125.0/255.0, blue: 44.0/255.0, alpha: 1.0)]
        dataSet.setCircleColor(UIColor(red: 245.0/255.0, green: 125.0/255.0, blue: 44.0/255.0, alpha: 1.0))
        
        dataSet.lineWidth = 1.0
        dataSet.circleRadius = 3.0
        dataSet.mode = .horizontalBezier
        dataSet.drawValuesEnabled = false
        
        let gradientColors = [UIColor(rgb: 0x20ACF2).cgColor, UIColor.clear.cgColor] as CFArray
        let colorLocations:[CGFloat] = [1.0, 0.0]
        let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocations)
        dataSet.fill = Fill.fillWithLinearGradient(gradient!, angle: 90.0)
        dataSet.drawFilledEnabled = false
        
        
        let chartData = LineChartData(dataSets: data)
        
        let valueFormatter = NumberFormatter()
        valueFormatter.numberStyle = .none
        valueFormatter.multiplier = 1
        chartData.setValueFormatter(DefaultValueFormatter(formatter: valueFormatter))
        
        let yAxis = chart.leftAxis
        yAxis.labelFont = UIFont(name: "Avenir-Book", size:10)!
        yAxis.setLabelCount(6, force: false)
        yAxis.labelTextColor = UIColor(rgb: 0x7F7F7F)
        yAxis.labelPosition = .outsideChart
        yAxis.drawAxisLineEnabled = true
        yAxis.gridLineDashLengths = [2, 2]
        
        let xAxis = chart.xAxis
        xAxis.drawGridLinesEnabled = true
        xAxis.gridLineDashLengths = [2, 2]
        //xAxis.gridLineDashPhase = 0
        
        chart.legend.enabled = false
        chart.rightAxis.enabled = false
        chart.xAxis.setLabelCount(6, force: true)
        chart.xAxis.labelCount = 6
        chart.xAxis.labelPosition = .bottom
        chart.xAxis.labelFont = UIFont(name: "Avenir-Book", size:7)!
        chart.xAxis.labelTextColor = UIColor(rgb: 0x7F7F7F)
        
        
        chart.xAxis.avoidFirstLastClippingEnabled = false
        chart.xAxis.forceLabelsEnabled = true
        chart.xAxis.valueFormatter = ChartXAxisFormatter()
        chart.xAxis.enabled = true
        chart.leftAxis.enabled = true
        
        chart.data = chartData
        chart.notifyDataSetChanged()
        
        //XY Value
        
//        let marker = XYMarkerView(color: UIColor(white: 180/250, alpha: 1),
//                                  font: .systemFont(ofSize: 12),
//                                  textColor: .white,
//                                  insets: UIEdgeInsets(top: 8, left: 8, bottom: 20, right: 8),
//                                  xAxisValueFormatter: chart.xAxis.valueFormatter!)
//        marker.chartView = chart
//        marker.minimumSize = CGSize(width: 80, height: 40)
//        chart.marker = marker
        
        
        chart.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
        selectedChartView.addSubview(chart)
        
    }
    // MARK: - Chart Methods
        func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {

            guard let dataSet = chartView.data?.dataSets[highlight.dataSetIndex] else {
                return
                
            }
           
            let date = Date(timeIntervalSince1970: entry.x)
            let xAxisValue = convertDateToString(date: date)
            let entryIndex = dataSet.entryIndex(entry: entry)
            print(entryIndex)

            customMarkerView.xValue.text = xAxisValue
            customMarkerView.yValue.text = "\(entry.y)"
//            customMarkerView.lbCountry.text = items[entryIndex].country

        }
    
    func convertDateToString(date: Date) -> String {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let myString = formatter.string(from: date)
        let yourDate: Date? = formatter.date(from: myString)
        formatter.dateFormat = "MMMM dd"
        let updatedString = formatter.string(from: yourDate!)
        
        return updatedString
    }
        
    
	
}
