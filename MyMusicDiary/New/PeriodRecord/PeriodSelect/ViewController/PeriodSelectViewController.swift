//
//  PeriodSelectViewController.swift
//  MyMusicDiary
//
//  Created by 임승섭 on 1/4/25.
//

import UIKit

class PeriodSelectViewController: BaseViewController {
    
    
    let mainView = PeriodSelectView()
    let arr = generatePeriods()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTableView()
        
        
        print(arr)
    }
    
    
    
}

// tableView
extension PeriodSelectViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PeriodSelectTableViewCell.description()) as? PeriodSelectTableViewCell else { return UITableViewCell() }
        cell.dateLabel.text = arr[indexPath.row].description
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = SummaryPeriodViewController()
        navigationController?.pushViewController(vc, animated: true )
    }
}

// private func
extension PeriodSelectViewController {
    private func setTableView() {
        mainView.tableView.dataSource = self
        mainView.tableView.delegate = self
    }
    
}




// Enum for Period
enum Period: CustomStringConvertible {
    case week(year: Int, month: Int, weekNumber: Int)
    case month(year: Int, month: Int)
    case year(year: Int)
    
    var description: String {
        switch self {
        case .week(let year, let month, let weekNumber):
            return "\(year)년 \(month)월 \(ordinalWeekText(weekNumber)) 주"
        case .month(let year, let month):
            return "\(year)년 \(month)월"
        case .year(let year):
            return "\(year)년"
        }
    }
}

// Function to generate periods
func generatePeriods() -> [Period] {
    var result: [Period] = []
    
    let calendar = Calendar(identifier: .gregorian)
    let startDate = calendar.date(from: DateComponents(year: 2023, month: 1, day: 1))!
    let today = Date()
    
    var currentDate = startDate
    var currentYear = calendar.component(.year, from: currentDate)
    var currentMonth = calendar.component(.month, from: currentDate)
    var currentYearPeriods: [Period] = []
    var allYearPeriods: [Period] = []
    
    while currentDate <= today {
        // Generate weeks for the current month
        let daysInMonth = calendar.range(of: .day, in: .month, for: currentDate)!
        var weekNumber = 1
        for day in daysInMonth {
            let date = calendar.date(from: DateComponents(year: currentYear, month: currentMonth, day: day))!
            let weekday = calendar.component(.weekday, from: date)
            
            // Check if the date is a Monday and within the current month
            if weekday == 2 { // Monday is represented by 2 in the Gregorian calendar
                let isFirstMondayInNextMonth = calendar.component(.month, from: date) != currentMonth
                if isFirstMondayInNextMonth {
                    break
                }
                currentYearPeriods.append(.week(year: currentYear, month: currentMonth, weekNumber: weekNumber))
                weekNumber += 1
            }
        }
        
        // Add the month
        currentYearPeriods.append(.month(year: currentYear, month: currentMonth))
        
        // Move to the next month
        if currentMonth == 12 {
            // If it's the last month, save the current year's periods
            allYearPeriods.append(contentsOf: currentYearPeriods)
            allYearPeriods.append(.year(year: currentYear))
            currentYearPeriods.removeAll()
            currentYear += 1
            currentMonth = 1
        } else {
            currentMonth += 1
        }
        currentDate = calendar.date(from: DateComponents(year: currentYear, month: currentMonth, day: 1))!
    }
    
    // Add remaining periods for the current year
    allYearPeriods.append(contentsOf: currentYearPeriods)
    allYearPeriods.append(.year(year: currentYear))
    
    // Combine all data
    result.append(contentsOf: allYearPeriods)
    
    return result
}

// Helper to convert week numbers to ordinal strings
func ordinalWeekText(_ weekNumber: Int) -> String {
    switch weekNumber {
    case 1: return "첫째"
    case 2: return "둘째"
    case 3: return "셋째"
    case 4: return "넷째"
    case 5: return "다섯째"
    default: return "\(weekNumber)번째"
    }
}
