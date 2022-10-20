//
//  BusinessAnalyticsEngagementTableViewCell.swift
//  HoneySpot
//
//  Created by Kaan Baris BAYRAK on 25.02.2021.
//  Copyright © 2021 HoneySpot. All rights reserved.
//

import UIKit
import Charts

class BusinessAnalyticsEngagementTableViewCell: UITableViewCell {

	@IBOutlet var titleLabel: UILabel!
	@IBOutlet var selectTimePeriod: UIButton!
	@IBOutlet var chartView: UIView!
	@IBOutlet var emptyView: UIView!
	@IBOutlet var chartCircleView: UIView!
	@IBOutlet var optionsTableView: UITableView!
    
    //Count Label
    @IBOutlet var honeySpotCountLabel: UILabel!
    @IBOutlet var commentsCountLabel: UILabel!
    @IBOutlet var sharesCountLabel: UILabel!
    @IBOutlet var likesCountLabel: UILabel!
	
	var engagementArr = [EngagementType]()
	var engagementCompareArr = [EngagementType]()
	
	var honeyspotCount = 0
	var honeyspotCompareCount = 0
	
	var sharesCount = 0
	var sharesCompareCount = 0
	
	var commentsCount = 0
	var commentsCompareCount = 0
	
	var likesCount = 0
	var likesCompareCount = 0
    let chart = PieChartView()
    
    
	
	func prepareCell(){
        
        chart.data = nil
		self.honeyspotCount = 0
		self.honeyspotCompareCount = 10
		self.sharesCount = 0
		self.sharesCompareCount = 10
		self.commentsCount = 0
		self.commentsCompareCount = 10
		self.likesCount = 0
		self.likesCompareCount = 10
        
        let normalFont = UIFont(name: "Helvetica Neue", size: CGFloat(12))!
        let boldFont = UIFont(descriptor: normalFont.fontDescriptor.withSymbolicTraits(.traitBold)!, size: normalFont.pointSize)
        
        var data = [PieChartDataEntry]()
        
		for i in engagementArr {
			if(i.eventName == "spotAdd"){
                honeyspotCount = i.honeySpotCount
                data.append(PieChartDataEntry(value: Double(honeyspotCount), label: "HoneySpots"))
			}else if(i.eventName == "share"){
                sharesCount = i.shareCount
                data.append(PieChartDataEntry(value: Double(sharesCount), label: "Shares"))
			}else if(i.eventName == "comment"){
                commentsCount = i.commentCount
                data.append(PieChartDataEntry(value: Double(commentsCount), label: "Comments"))
			}else if(i.eventName == "like"){
                likesCount = i.likeCount
                data.append(PieChartDataEntry(value: Double(likesCount), label: "Likes"))
			}
		}
        if honeyspotCount == 0 && sharesCount == 0 && likesCount == 0 && commentsCount == 0 {
             
            emptyView.isHidden = false
            chartView.isHidden = true
        }
        else
        {
            emptyView.isHidden = true
            chartView.isHidden = false
            
            chart.frame = CGRect(x: 0, y: 0, width: chartCircleView.frame.width, height: chartCircleView.frame.height)
            chartCircleView.addSubview(chart)
            chart.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.setup(pieChartView: chart)
            
            let chartDataset = PieChartDataSet(entries: data, label: "Test")
            chartDataset.sliceSpace = 0
            var  colors: [UIColor] = []
            
            for i in engagementArr {
                if(i.eventName == "spotAdd"){
                    colors.append(UIColor.init(red: 47.0/255.0, green: 197.0/255.0, blue: 197.0/255.0, alpha: 1.0))
                }else if(i.eventName == "share"){
                    colors.append(UIColor.init(red: 255.0/255.0, green: 185.0/255.0, blue: 94.0/255.0, alpha: 1.0))
                }else if(i.eventName == "comment"){
                    colors.append(UIColor.init(red: 251.0/255.0, green: 117/255.0, blue: 147.0/255.0, alpha: 1.0))
                }else if(i.eventName == "like"){
                    colors.append(UIColor.init(red: 156.0/255, green: 143.0/255, blue: 254.0/255.0, alpha: 1.0))
                }
            }
            
            chartDataset.colors = colors
            
            chartDataset.valueLinePart1OffsetPercentage = 1.0
            chartDataset.valueLinePart1Length = 0.4
            chartDataset.valueLinePart2Length = 0.9
            chartDataset.yValuePosition = .outsideSlice
            
            
            let l = chart.legend
            l.horizontalAlignment = .left
            l.verticalAlignment = .bottom
            l.orientation = .horizontal
            l.drawInside = false
            l.form = .circle
            l.formSize = 9
            l.font = UIFont(name: "HelveticaNeue-Light", size: 11)!
            l.xEntrySpace = 4
            chart.legend.form = .line
            
            let chartData = PieChartData(dataSet: chartDataset)
            
            let percentageFormatter = NumberFormatter()
            percentageFormatter.numberStyle = .percent
            percentageFormatter.maximumFractionDigits = 1
            percentageFormatter.percentSymbol = ""
            percentageFormatter.multiplier = 1
            chartData.setValueFormatter(DefaultValueFormatter(formatter: percentageFormatter))
            chartData.setValueFont(boldFont)
            chartData.setValueTextColor(.black)

            chart.drawEntryLabelsEnabled = false
            chart.legend.enabled = false
            chart.data = chartData
            chart.highlightValues(nil)
            //chart.animate(xAxisDuration: 1.5, yAxisDuration: 1.5)
            
            updateLabelCount()
            DispatchQueue.main.async {
                self.optionsTableView.reloadData()
            }
        }

		
		
	}
	
	@IBAction func selectTimePeriodTapped(_ sender: Any) {
	}
    
    
    func updateLabelCount()
    {
        honeySpotCountLabel.text = "\(honeyspotCount)"
        commentsCountLabel.text = "\(commentsCount)"
        sharesCountLabel.text = "\(sharesCount)"
        likesCountLabel.text = "\(likesCount)"
    }
    
    func setup(pieChartView chartView: PieChartView) {
        chartView.drawSlicesUnderHoleEnabled = false
        chartView.holeRadiusPercent = 0.58
        chartView.transparentCircleRadiusPercent = 0.61
        chartView.chartDescription?.enabled = false
        chartView.setExtraOffsets(left: 5, top: 10, right: 5, bottom: 5)
        
        chartView.drawHoleEnabled = true
        chartView.rotationAngle = 0
        chartView.rotationEnabled = true
        chartView.highlightPerTapEnabled = true
        
     
    }
    
	
}

extension BusinessAnalyticsEngagementTableViewCell : UITableViewDelegate , UITableViewDataSource {
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 4
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 30
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "listCellId") as! BusinessAnalyticsEngagementListTableViewCell
		cell.colorView.backgroundColor = colors[indexPath.row]
		if(indexPath.row == 0){
			cell.name.text = "HoneySpots"
			cell.count.text = self.honeyspotCount.description
			let percentageHoneyspot = percentageDifference(from: Double(((honeyspotCompareCount == 0) ? 1 : honeyspotCompareCount)), x2: Double(((honeyspotCount == 0) ? 1 : honeyspotCount)))
//			if(percentageHoneyspot >= 0){
//				cell.percentageLabel.text = percentageHoneyspot.description + "%"
//				cell.percentageImage.image = UIImage(named: "businessPercentageUp")
//			}else{
//				cell.percentageLabel.text = "-" + percentageHoneyspot.description + "%"
//				cell.percentageImage.image = UIImage(named: "businessPercentageDown")
//			}
		}else if(indexPath.row == 1){
			cell.name.text = "Shares"
			cell.count.text = self.sharesCount.description
			let percentageHoneyspot = percentageDifference(from: Double(((sharesCompareCount == 0) ? 1 : sharesCompareCount)), x2: Double(((sharesCount == 0) ? 1 : sharesCount)))
//			if(percentageHoneyspot >= 0){
//				cell.percentageLabel.text = percentageHoneyspot.description + "%"
//				cell.percentageImage.image = UIImage(named: "businessPercentageUp")
//			}else{
//				cell.percentageLabel.text = "-" + percentageHoneyspot.description + "%"
//				cell.percentageImage.image = UIImage(named: "businessPercentageDown")
//			}
		}else if(indexPath.row == 2){
			cell.name.text = "Comments"
			cell.count.text = self.commentsCount.description
			let percentageHoneyspot = percentageDifference(from: Double(((commentsCompareCount == 0) ? 1 : commentsCompareCount)), x2: Double(((commentsCount == 0) ? 1 : commentsCount)))
//			if(percentageHoneyspot >= 0){
//				cell.percentageLabel.text = percentageHoneyspot.description + "%"
//				cell.percentageImage.image = UIImage(named: "businessPercentageUp")
//			}else{
//				cell.percentageLabel.text = "-" + percentageHoneyspot.description + "%"
//				cell.percentageImage.image = UIImage(named: "businessPercentageDown")
//			}
		}else if(indexPath.row == 3){
			cell.name.text = "Likes"
			cell.count.text = self.likesCount.description
			let percentageHoneyspot = percentageDifference(from: Double(((likesCompareCount == 0) ? 1 : likesCompareCount)), x2: Double(((likesCount == 0) ? 1 : likesCount)))
//			if(percentageHoneyspot >= 0){
//				cell.percentageLabel.text = percentageHoneyspot.description + "%"
//				cell.percentageImage.image = UIImage(named: "businessPercentageUp")
//			}else{
//				cell.percentageLabel.text = "-" + percentageHoneyspot.description + "%"
//				cell.percentageImage.image = UIImage(named: "businessPercentageDown")
//			}
		}
		return cell
	}
	
	func percentageDifference(from x1: Double, x2: Double) -> Double {
			let diff = (x2 - x1) / x1
			return Double(round(100 * (diff * 100)) / 100)
	}
	
}
