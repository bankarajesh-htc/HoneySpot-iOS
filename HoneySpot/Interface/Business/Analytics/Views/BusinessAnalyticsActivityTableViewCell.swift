//
//  BusinessAnalyticsActivityTableViewCell.swift
//  HoneySpot
//
//  Created by Kaan Baris BAYRAK on 25.02.2021.
//  Copyright © 2021 HoneySpot. All rights reserved.
//

import UIKit
import Charts

class BusinessAnalyticsActivityTableViewCell: UITableViewCell,ChartViewDelegate {

	@IBOutlet var titleLabel: UILabel!
	@IBOutlet var emptyView: UIView!
	@IBOutlet var chartView: UIView!
	@IBOutlet var selectTimePeriod: UIButton!
	
	@IBOutlet var impressionsView: UIView!
	@IBOutlet var pageViewsView: UIView!
	@IBOutlet var honeyspottedView: UIView!
	
	@IBOutlet var impressionCountLabel: UILabel!
	@IBOutlet var impressionPercentageLabel: UILabel!
	@IBOutlet var impressionPercentageImage: UIImageView!
	
	@IBOutlet var pageViewsCountLabel: UILabel!
	@IBOutlet var pageViewsPercentageLabel: UILabel!
	@IBOutlet var pageViewsPercentageImage: UIImageView!
	
	@IBOutlet var honeyspottedCountLabel: UILabel!
	@IBOutlet var honeyspottedPercentageLabel: UILabel!
	@IBOutlet var honeyspottedPercentageImage: UIImageView!
	
	@IBOutlet var selectedChartView: UIView!
    
    
    @IBOutlet weak var impressionSelectedView: UIView!
    @IBOutlet weak var pageViewsSelectedView: UIView!
    @IBOutlet weak var honeySpottedSelectedView: UIView!
    
	var activityArr = [ActivityDate]()
	var activityRange = 0
	
	var selectedType = "impressions"
    
    let customMarkerView = CustomMarkerView()
	
	func prepareCell(){
		DispatchQueue.main.async {
			self.configureView()
		}
	}
	
	@IBAction func selectTimePeriodTapped(_ sender: Any) {
		
	}
	
	@IBAction func impressionsTapped(_ sender: Any) {
		selectedType = "impressions"
		configureView()
        
	}
	
	@IBAction func pageViewsTapped(_ sender: Any) {
		selectedType = "pageviews"
		configureView()
        
	}
	
	@IBAction func honeyspottedTapped(_ sender: Any) {
		selectedType = "honeyspotted"
		configureView()
        
	}
	
	func configureView(){
		if(selectedType == "impressions"){
            impressionSelectedView.isHidden = false
            pageViewsSelectedView.isHidden = true
            honeySpottedSelectedView.isHidden = true
            
//			impressionsView.alpha = 1.0
//			pageViewsView.alpha = 0.5
//			honeyspottedView.alpha = 0.5
//			impressionsView.backgroundColor = UIColor(rgb: 0xF9F9F9)
//			pageViewsView.backgroundColor = UIColor.clear
//			honeyspottedView.backgroundColor = UIColor.clear
		}else if(selectedType == "pageviews"){
            impressionSelectedView.isHidden = true
            pageViewsSelectedView.isHidden = false
            honeySpottedSelectedView.isHidden = true
            
//			impressionsView.alpha = 0.5
//			pageViewsView.alpha = 1.0
//			honeyspottedView.alpha = 0.5
//			impressionsView.backgroundColor = UIColor.clear
//			pageViewsView.backgroundColor = UIColor(rgb: 0xF9F9F9)
//			honeyspottedView.backgroundColor = UIColor.clear
		}else if(selectedType == "honeyspotted"){
            impressionSelectedView.isHidden = true
            pageViewsSelectedView.isHidden = true
            honeySpottedSelectedView.isHidden = false
            
//			impressionsView.alpha = 0.5
//			pageViewsView.alpha = 0.5
//			honeyspottedView.alpha = 1.0
//			impressionsView.backgroundColor = UIColor.clear
//			pageViewsView.backgroundColor = UIColor.clear
//			honeyspottedView.backgroundColor = UIColor(rgb: 0xF9F9F9)
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
		for i in 1 ... self.activityRange {
			let day = cal.component(.day, from: date)
			days.append(day)
			date = cal.date(byAdding: .day, value: -1, to: date)!
			dataKeyArray.append(dateFormatterPrint.string(from: date))
			dataDateValuesArray.append(date.timeIntervalSince1970)
		}
        
		
		dataKeyArray.reverse()
		dataDateValuesArray.reverse()
		
		for i in dataKeyArray{
			var val = 0
			for j in self.activityArr {
				if (i == dateFormatterPrint.string(from:j.date)){
					if(selectedType == "impressions"){
						val = j.impressionCount
					}else if(selectedType == "pageviews"){
						val = j.pageviewCount
					}else if(selectedType == "honeyspotted"){
						val = j.honeyspotCount
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
        if(selectedType == "impressions"){
            
            dataSet.colors = [UIColor(red: 255.0/255.0, green: 185.0/255.0, blue: 94.0/255.0, alpha: 1.0)]
            dataSet.setCircleColor(UIColor(red: 255.0/255.0, green: 185.0/255.0, blue: 94.0/255.0, alpha: 1.0))
        }
        else if(selectedType == "pageviews"){
            
            dataSet.colors = [UIColor(red: 231.0/255.0, green: 108.0/255.0, blue: 66.0/255.0, alpha: 1.0)]
            dataSet.setCircleColor(UIColor(red: 231.0/255.0, green: 108.0/255.0, blue: 66.0/255.0, alpha: 1.0))
 
        }
        else if(selectedType == "honeyspotted"){
            
            dataSet.colors = [UIColor(red: 125.0/255.0, green: 164.0/255.0, blue: 138.0/255.0, alpha: 1.0)]
            dataSet.setCircleColor(UIColor(red: 125.0/255.0, green: 164.0/255.0, blue: 138.0/255.0, alpha: 1.0))

        }
		
		dataSet.lineWidth = 1.5
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

class ChartXAxisFormatter: NSObject, IAxisValueFormatter {

	func stringForValue(_ value: Double, axis: AxisBase?) -> String {
		
		let dateFormatterPrint = DateFormatter()
		dateFormatterPrint.dateFormat = "MMM d"

		let date = Date(timeIntervalSince1970: value)
		let time = dateFormatterPrint.string(from: date)

		return time
		
	}
	
}
