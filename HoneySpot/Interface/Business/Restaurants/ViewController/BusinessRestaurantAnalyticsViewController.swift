//
//  BusinessRestaurantAnalyticsViewController.swift
//  HoneySpot
//
//  Created by Kaan Baris BAYRAK on 2.07.2020.
//  Copyright © 2020 HoneySpot. All rights reserved.
//

import UIKit
import Charts

class BusinessRestaurantAnalyticsViewController: UIViewController {

	@IBOutlet var analyticsTableView: UITableView!
	
	var spotModel :SpotModel!
	var engagements = [Date:Int]()
	var saves = [Date:Int]()
	var audience = [String:Int]()
	
	override func viewDidLoad() {
        super.viewDidLoad()
		if #available(iOS 13.0, *) {
			overrideUserInterfaceStyle = .light
		}
		getData()
    }
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
	
	func getData(){
		self.showLoadingHud()
		let group = DispatchGroup()
		
		var sDate = Date()
		sDate.changeDays(by: -2)
		var eDate = Date()
		eDate.changeDays(by: 2)
		
//		group.enter()
//		BusinessAnalyticsDataSource().getEngagement(spotId: spotModel.id, startDate: sDate, endDate: eDate, completion: { (result) in
//			self.hideAllHuds()
//			switch(result){
//			case .success(let eng):
//				self.engagements = eng
//			case .failure(let err):
//				print(err.errorMessage)
//			}
//			group.leave()
//		})
//
//		group.enter()
//		BusinessAnalyticsDataSource().getSaves(spotId: spotModel.id, startDate: sDate, endDate: eDate) { (result) in
//			self.hideAllHuds()
//			switch(result){
//			case .success(let sav):
//				self.saves = sav
//			case .failure(let err):
//				print(err.errorMessage)
//			}
//			group.leave()
//		}
//
//		group.enter()
//		BusinessAnalyticsDataSource().getAudience(spotId: spotModel.id) { (result) in
//			self.hideAllHuds()
//			switch(result){
//			case .success(let aud):
//				self.audience = aud
//			case .failure(let err):
//				print(err.errorMessage)
//			}
//			group.leave()
//		}
		
		group.notify(queue: DispatchQueue.global(qos: DispatchQoS.QoSClass.default), execute: {
			DispatchQueue.main.async {
				self.analyticsTableView.reloadData()
			}
		})
	}
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }

}

extension BusinessRestaurantAnalyticsViewController : UITableViewDelegate,UITableViewDataSource {
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 3
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "analyticsCellId") as! BusinessRestaurantAnalyticsTableViewCell
		cell.selectionStyle = .none
		if(indexPath.row == 0){
			cell.titleLabel.text = "Engagement"
			
			if(engagements.count > 0){
				cell.emptyView.isHidden = true
			}else{
				cell.emptyView.isHidden = false
			}
			
			let dataKeyArray = Array(engagements.keys)
			let dataValuesArray = Array(engagements.values)

			let chart = BarChartView()
			chart.frame = CGRect(x: 0, y: 0, width: cell.chartView.frame.width, height: cell.chartView.frame.height)
			chart.autoresizingMask = [.flexibleWidth, .flexibleHeight]

			var data = [BarChartDataSet]()
			for i in 0..<dataKeyArray.count {
				let dateFormatterPrint = DateFormatter()
				dateFormatterPrint.dateFormat = "dd-MMM-yyyy"
				let key = dateFormatterPrint.string(from: dataKeyArray[i])
				let val = dataValuesArray[i]
				let value = [BarChartDataEntry(x: Double(i), y: Double(val))]
				let dataSet = BarChartDataSet(entries: value, label: key)
				dataSet.colors = [UIColor.orange]
				data.append(dataSet)
			}

			let chartData = BarChartData(dataSets: data)

			let valueFormatter = NumberFormatter()
			valueFormatter.numberStyle = .none
			valueFormatter.multiplier = 1
			chartData.setValueFormatter(DefaultValueFormatter(formatter: valueFormatter))

			chart.data = chartData

			chart.xAxis.drawLabelsEnabled = false
			chart.xAxis.drawGridLinesEnabled = false
			chart.rightAxis.drawGridLinesEnabled = false
			chart.leftAxis.drawGridLinesEnabled = false

			chart.animate(xAxisDuration: 1.5, yAxisDuration: 1.5)
			cell.chartView.addSubview(chart)
		}else if(indexPath.row == 1){
			cell.titleLabel.text = "Saves"
			
			if(saves.count > 0){
				cell.emptyView.isHidden = true
			}else{
				cell.emptyView.isHidden = false
			}
			
			let dataKeyArray = Array(saves.keys)
			let dataValuesArray = Array(saves.values)

			let chart = BarChartView()
			chart.frame = CGRect(x: 0, y: 0, width: cell.chartView.frame.width, height: cell.chartView.frame.height)
			chart.autoresizingMask = [.flexibleWidth, .flexibleHeight]

			var data = [BarChartDataSet]()
			for i in 0..<dataKeyArray.count {
				let dateFormatterPrint = DateFormatter()
				dateFormatterPrint.dateFormat = "dd-MMM-yyyy"
				let key = dateFormatterPrint.string(from: dataKeyArray[i])
				let val = dataValuesArray[i]
				let value = [BarChartDataEntry(x: Double(i), y: Double(val))]
				let dataSet = BarChartDataSet(entries: value, label: key)
				dataSet.colors = [UIColor.orange]
				data.append(dataSet)
			}

			let chartData = BarChartData(dataSets: data)

			let valueFormatter = NumberFormatter()
			valueFormatter.numberStyle = .none
			valueFormatter.multiplier = 1
			chartData.setValueFormatter(DefaultValueFormatter(formatter: valueFormatter))

			chart.data = chartData

			chart.xAxis.drawLabelsEnabled = false
			chart.xAxis.drawGridLinesEnabled = false
			chart.rightAxis.drawGridLinesEnabled = false
			chart.leftAxis.drawGridLinesEnabled = false

			chart.animate(xAxisDuration: 1.5, yAxisDuration: 1.5)
			cell.chartView.addSubview(chart)
		}else if(indexPath.row == 2){
			cell.titleLabel.text = "Audience"
			
			if(audience.count > 0){
				cell.emptyView.isHidden = true
			}else{
				cell.emptyView.isHidden = false
			}
			
			let dataKeyArray = Array(audience.keys)
			let dataValuesArray = Array(audience.values)
			
			let chart = PieChartView()
			chart.frame = CGRect(x: 0, y: 0, width: cell.chartView.frame.width, height: cell.chartView.frame.height)
			chart.autoresizingMask = [.flexibleWidth, .flexibleHeight]
			
			var data = [PieChartDataEntry]()
			for i in 0..<dataKeyArray.count {
				data.append(PieChartDataEntry(value: Double(dataValuesArray[i]), label: dataKeyArray[i].description ))
			}
			
			let chartDataset = PieChartDataSet(entries: data, label: "")
			chartDataset.colors = [UIColor.blue,UIColor.orange,UIColor.red,UIColor.green,UIColor.purple]
			let chartData = PieChartData(dataSet: chartDataset)
			
			let percentageFormatter = NumberFormatter()
			percentageFormatter.numberStyle = .percent
			percentageFormatter.maximumFractionDigits = 1
			percentageFormatter.percentSymbol = ""
			percentageFormatter.multiplier = 1
			chartData.setValueFormatter(DefaultValueFormatter(formatter: percentageFormatter))
			
			chart.data = chartData
			chart.animate(xAxisDuration: 1.5, yAxisDuration: 1.5)
			cell.chartView.addSubview(chart)
		}
		return cell
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 300
	}
	
}

extension Date {
	mutating func changeDays(by days: Int) {
		self = Calendar.current.date(byAdding: .day, value: days, to: self)!
	}
}
