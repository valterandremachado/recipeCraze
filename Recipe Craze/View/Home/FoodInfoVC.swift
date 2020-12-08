//
//  FoodInfoVC.swift
//  Recipe Craze
//
//  Created by Valter A. Machado on 6/17/20.
//  Copyright © 2020 Machado Dev. All rights reserved.
//

import UIKit
import Charts

class FoodInfoVC: UIViewController {
    
    // MARK: - ViewModel
    var recipeViewModels = [RecipeViewModel2]()
    var categoryViewModel = [CategoryViewModel]()
    
    lazy var nutritionArray = recipeViewModels.first?.nutrientArray
    lazy var categNutritionArray = categoryViewModel.first?.nutritionArray
    
    var faveIsVisible = false
    var categIsVisible = false
    
    var nutriCDArray: [Any] = []
    
    // MARK: - Properties    
    var numberOfNutrients = [PieChartDataEntry]()
    var nutrientEntryLabels: [String] = []  //["Ozil", "Ramsey", "Laca", "Auba", "Xhaka", "Torreira"]
    var nutrientEntryValues: [Double] = [] //[6, 8, 26, 30, 8, 10]
    
    var pieChartView = PieChartView()
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor(named: "backgroundAppearance")
        
        setupNavBar()
        setupViews()
        
        switch false {
        case !faveIsVisible:
            print("faveIsVisible")
            fillChartEntryWithCDData()
        case !categIsVisible:
            print("categIsVisible")
            fillChartEntryWithCategVCData(value: categNutritionArray!)
        default:
            print("homeIsVisible")
            fillChartEntryWithHomeVCData(value: nutritionArray!)
            break
        }
        
        
        customizeChart(dataPoints: nutrientEntryLabels, values: nutrientEntryValues.map{ Double($0) })
    }
    
    func customizeChart(dataPoints: [String], values: [Double]) {

//        print("dataPoints: \(dataPoints)")
        // 1. Set ChartDataEntry
        var dataEntries: [ChartDataEntry] = []
        for i in 0..<dataPoints.count {
            let dataEntry = PieChartDataEntry(value: values[i], label: dataPoints[i], data: dataPoints[i] as AnyObject)
            dataEntries.append(dataEntry)
        }

        // 2. Set ChartDataSet
        let pieChartDataSet = PieChartDataSet(entries: dataEntries, label: nil)
        pieChartDataSet.colors = colorsOfCharts(numbersOfColor: dataPoints.count)
        pieChartDataSet.sliceSpace = 20

        // 3. Set ChartData
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        let format = NumberFormatter()
        format.numberStyle = .none
        format.numberStyle = .percent
        format.maximumFractionDigits = 1
        format.multiplier = 1
        format.percentSymbol = "%"

        let formatter = DefaultValueFormatter(formatter: format)

        pieChartData.setValueFormatter(formatter)
        pieChartData.setValueFormatter(DefaultValueFormatter(formatter: format))
        pieChartData.setValueFont(.systemFont(ofSize: 11, weight: .light))
        pieChartData.setValueTextColor(UIColor(named: "labelAppearance")!)

        // 4. Setup pieChartView
        pieChartView.drawEntryLabelsEnabled = false
        pieChartView.drawHoleEnabled = false
        //        pieChartView.usePercentValuesEnabled = true
        //        pieChartView.entryLabelColor = .black

        // 5. Assign it to the chart’s data
        pieChartView.data = pieChartData
    }
    
    fileprivate func colorsOfCharts(numbersOfColor: Int) -> [UIColor] {
        var colors: [UIColor] = []
        for _ in 0..<numbersOfColor {
            let red = Double(arc4random_uniform(256))
            let green = Double(arc4random_uniform(256))
            let blue = Double(arc4random_uniform(256))
            let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
            colors.append(color)
        }
        return colors
    }
    
    // MARK: - Functions/Methods
    fileprivate func setupViews() {
        [pieChartView,].forEach({view.addSubview($0)})
        
        pieChartView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15), size: CGSize(width: 0, height: 0))
        /// Check device size (iPhone SE 2nd Gen)
        if UIScreen.main.bounds.height <= 667 {
            pieChartView.withHeight(300)
        } else { // (iPhone 11)
            pieChartView.withHeight(400)
        }
        
    }
    
    fileprivate func setupNavBar(){
        guard let nav = navigationController?.navigationBar else { return }
        nav.prefersLargeTitles = true
        
        navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneBtnPressed)), animated: true)
        navigationItem.rightBarButtonItem?.tintColor = .systemPink
    }
    
    // MARK: - Selectors
    @objc func doneBtnPressed() {
        dismiss(animated: true, completion: nil)
    }
    
}



extension FoodInfoVC {
    
    func fillChartEntryWithHomeVCData(value: [Nutrition]) {
        if !value.isEmpty {
            
            if value.first?.nutrientAmount != 0 {
                switch value.count {
                case 14:
                    nutrientEntryValues = [value[0].percentDailyValue, value[1].percentDailyValue,value[2].percentDailyValue, value[3].percentDailyValue, value[4].percentDailyValue, value[5].percentDailyValue, value[6].percentDailyValue, value[7].percentDailyValue, value[8].percentDailyValue, value[9].percentDailyValue, value[10].percentDailyValue, value[11].percentDailyValue, value[12].percentDailyValue, value[13].percentDailyValue]
                    
                    nutrientEntryLabels = [value[0].nutrientName, value[1].nutrientName, value[2].nutrientName, value[3].nutrientName, value[4].nutrientName, value[5].nutrientName, value[6].nutrientName, value[7].nutrientName, value[8].nutrientName, value[9].nutrientName, value[10].nutrientName, value[11].nutrientName, value[12].nutrientName, value[13].nutrientName]
                case 15:
                    nutrientEntryValues = [value[0].percentDailyValue, value[1].percentDailyValue,value[2].percentDailyValue, value[3].percentDailyValue, value[4].percentDailyValue, value[5].percentDailyValue, value[6].percentDailyValue, value[7].percentDailyValue, value[8].percentDailyValue, value[9].percentDailyValue, value[10].percentDailyValue, value[11].percentDailyValue, value[12].percentDailyValue, value[13].percentDailyValue, value[14].percentDailyValue]
                    
                    nutrientEntryLabels = [value[0].nutrientName, value[1].nutrientName, value[2].nutrientName, value[3].nutrientName, value[4].nutrientName, value[5].nutrientName, value[6].nutrientName, value[7].nutrientName, value[8].nutrientName, value[9].nutrientName, value[10].nutrientName, value[11].nutrientName, value[12].nutrientName, value[13].nutrientName, value[14].nutrientName]
                case 16:
                    nutrientEntryValues = [value[0].percentDailyValue, value[1].percentDailyValue,value[2].percentDailyValue, value[3].percentDailyValue, value[4].percentDailyValue, value[5].percentDailyValue, value[6].percentDailyValue, value[7].percentDailyValue, value[8].percentDailyValue, value[9].percentDailyValue, value[10].percentDailyValue, value[11].percentDailyValue, value[12].percentDailyValue, value[13].percentDailyValue, value[14].percentDailyValue, value[15].percentDailyValue]
                    
                    nutrientEntryLabels = [value[0].nutrientName, value[1].nutrientName, value[2].nutrientName, value[3].nutrientName, value[4].nutrientName, value[5].nutrientName, value[6].nutrientName, value[7].nutrientName, value[8].nutrientName, value[9].nutrientName, value[10].nutrientName, value[11].nutrientName, value[12].nutrientName, value[13].nutrientName, value[14].nutrientName, value[15].nutrientName]
                default:
                    break
                }
                
                
            } else {
                print("Value is 0")
            }
            
            
        } else {
            pieChartView.noDataText = "No data available"
        }
        
    }
    
    func fillChartEntryWithCategVCData(value: [NutritionArray]) {
        if !value.isEmpty {
            
            if value.first?.amount != 0 {
                
                nutrientEntryValues = [value[0].amount, value[1].amount,value[2].amount, value[3].amount, value[4].amount, value[5].amount, value[6].amount, value[7].amount, value[8].amount, value[9].amount, value[10].amount, value[11].amount, value[12].amount, value[13].amount]
                
                nutrientEntryLabels = [value[0].title, value[1].title, value[2].title, value[3].title, value[4].title, value[5].title, value[6].title, value[7].title, value[8].title, value[9].title, value[10].title, value[11].title, value[12].title, value[13].title]
                
            } else {
                print("Value is 0")
            }
            
            
        } else {
            pieChartView.noDataText = "No data available"
        }
        
    }
    
    func fillChartEntryWithCDData() {
        let value = nutriCDArray[0] as? [NSDictionary]
        //        let nutrientNameValue = value.map {$0.first?.value(forKey: "percentDailyValue")} as? Int
        
        if !value!.isEmpty {
            //            if nutrientNameValue != 0 {
//            print("value: \(value!.count)")
            if value!.count < 14 {
                
                nutrientEntryValues = [value![0]["amount"], value![1]["amount"],value![2]["amount"], value![3]["amount"], value![4]["amount"], value![5]["amount"], value![6]["amount"], value![7]["amount"], value![8]["amount"], value![9]["amount"], value![10]["amount"], value![11]["amount"], value![12]["amount"], value![13]["amount"]] as? [Double] ?? []
                
                nutrientEntryLabels = [value![0]["title"], value![1]["title"],value![2]["title"], value![3]["title"], value![4]["title"], value![5]["title"], value![6]["title"], value![7]["title"], value![8]["title"], value![9]["title"], value![10]["title"], value![11]["title"], value![12]["title"], value![13]["title"]] as? [String] ?? ["N/A"]
                
            } else {
                switch value!.count {
                case 14:
                    nutrientEntryValues = [value![0]["percentDailyValue"], value![1]["percentDailyValue"],value![2]["percentDailyValue"], value![3]["percentDailyValue"], value![4]["percentDailyValue"], value![5]["percentDailyValue"], value![6]["percentDailyValue"], value![7]["percentDailyValue"], value![8]["percentDailyValue"], value![9]["percentDailyValue"], value![10]["percentDailyValue"], value![11]["percentDailyValue"], value![12]["percentDailyValue"], value![13]["percentDailyValue"]] as? [Double] ?? []
                    
                    nutrientEntryLabels = [value![0]["nutrientName"], value![1]["nutrientName"],value![2]["nutrientName"], value![3]["nutrientName"], value![4]["nutrientName"], value![5]["nutrientName"], value![6]["nutrientName"], value![7]["nutrientName"], value![8]["nutrientName"], value![9]["nutrientName"], value![10]["nutrientName"], value![11]["nutrientName"], value![12]["nutrientName"], value![13]["nutrientName"]] as? [String] ?? ["N/A"]
                    
                case 15:
                    nutrientEntryValues = [value![0]["percentDailyValue"], value![1]["percentDailyValue"],value![2]["percentDailyValue"], value![3]["percentDailyValue"], value![4]["percentDailyValue"], value![5]["percentDailyValue"], value![6]["percentDailyValue"], value![7]["percentDailyValue"], value![8]["percentDailyValue"], value![9]["percentDailyValue"], value![10]["percentDailyValue"], value![11]["percentDailyValue"], value![12]["percentDailyValue"], value![13]["percentDailyValue"], value![14]["percentDailyValue"]] as? [Double] ?? []
                    
                    nutrientEntryLabels = [value![0]["nutrientName"], value![1]["nutrientName"],value![2]["nutrientName"], value![3]["nutrientName"], value![4]["nutrientName"], value![5]["nutrientName"], value![6]["nutrientName"], value![7]["nutrientName"], value![8]["nutrientName"], value![9]["nutrientName"], value![10]["nutrientName"], value![11]["nutrientName"], value![12]["nutrientName"], value![13]["nutrientName"], value![14]["nutrientName"]] as? [String] ?? ["N/A"]
                    
                case 16:
                    nutrientEntryValues = [value![0]["percentDailyValue"], value![1]["percentDailyValue"],value![2]["percentDailyValue"], value![3]["percentDailyValue"], value![4]["percentDailyValue"], value![5]["percentDailyValue"], value![6]["percentDailyValue"], value![7]["percentDailyValue"], value![8]["percentDailyValue"], value![9]["percentDailyValue"], value![10]["percentDailyValue"], value![11]["percentDailyValue"], value![12]["percentDailyValue"], value![13]["percentDailyValue"], value![14]["percentDailyValue"], value![15]["percentDailyValue"]] as? [Double] ?? []
                    
                    nutrientEntryLabels = [value![0]["nutrientName"], value![1]["nutrientName"],value![2]["nutrientName"], value![3]["nutrientName"], value![4]["nutrientName"], value![5]["nutrientName"], value![6]["nutrientName"], value![7]["nutrientName"], value![8]["nutrientName"], value![9]["nutrientName"], value![10]["nutrientName"], value![11]["nutrientName"], value![12]["nutrientName"], value![13]["nutrientName"], value![14]["nutrientName"], value![15]["nutrientName"]] as? [String] ?? ["N/A"]
                default:
                    break
                }
            }
            
            //            } else {
            //                print("Value is 0")
            //            }
            
            
        } else {
            pieChartView.noDataText = "No data available"
        }
        
    }
    
}
