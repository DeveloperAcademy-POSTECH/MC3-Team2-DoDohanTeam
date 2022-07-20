//
//  MedicationViewController.swift
//  APillLog
//
//  Created by Yeni Hwang on 2022/07/18.
//

import UIKit

class MedicationViewController: UIViewController {

    // MARK: - IBOutlets
    // DatePicker
    @IBOutlet weak var lastDayButton: UIButton!
    @IBOutlet weak var nextDayButton: UIButton!
    @IBOutlet weak var dayLabel: UILabel!

    // Symptom Button
    @IBOutlet weak var symptomButton: UIButton!
    @IBOutlet weak var symptomButtonBackgroundView: UIView!
    
    // Primary Pill Field
    @IBOutlet weak var timeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var primaryPillTableView: UITableView!
    @IBOutlet weak var primaryPillField: UIView!
    @IBOutlet weak var primaryPillViewLinkButton: UIButton!
    
    // Secondary Pill Field
    @IBOutlet weak var secondaryPillTableView: UITableView!
    @IBOutlet weak var secondaryPillField: UIView!
    @IBOutlet weak var secondaryPillModalButton: UIButton!
    
    // MARK: - Properties
    var cellIdentifier = "medicationPillCell"

    // MARK: - DummyData
    var dummyPrimaryPills = [
        PillDummy(name: "콘서타A", time: "8:00", status: true),
        PillDummy(name: "콘서타B", time: "", status: false),
        PillDummy(name: "콘서타C", time: "", status: false)
    ]
    
    var dummySecondaryPills = [
        PillDummy(name: "타이레놀", time: "8:00", status: true),
        PillDummy(name: "인데졸", time: "", status: false)
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        setMedicationTableViews()
        setStyle()
    }
    
    private func setMedicationTableViews() {
        // Primary Pill TableView
        primaryPillTableView.delegate = self
        primaryPillTableView.dataSource = self
        
        // Secondary Pill TableView
        secondaryPillTableView.delegate = self
        secondaryPillTableView.dataSource = self
        
        // Cell register
        let nibName = UINib(nibName: "MedicationPillCell", bundle: nil)
        primaryPillTableView.register(nibName, forCellReuseIdentifier: cellIdentifier)
        secondaryPillTableView.register(nibName, forCellReuseIdentifier: cellIdentifier)
        
        // TableView Style
        primaryPillTableView.isScrollEnabled = false
        secondaryPillTableView.isScrollEnabled = false
    }
    
    private func setStyle(){
        self.view.backgroundColor = UIColor.AColor.background
        setDatePickerStyle()
        setSymptomButtonStyle()
        setPrimaryPillViewStyle()
        setSecondaryPillViewStyle()
    }
    
    private func setDatePickerStyle() {
        // image
        lastDayButton.setImage(UIImage(named: "left-black"), for: .normal)
        nextDayButton.setImage(UIImage(named: "right-gray"), for: .normal)
        
        // color
        lastDayButton.tintColor = .darkGray
        nextDayButton.tintColor = .darkGray
    }
    
    private func setSymptomButtonStyle() {
        symptomButtonBackgroundView.layer.cornerRadius = 10
    }
    
    private func setPrimaryPillViewStyle() {
        primaryPillField.layer.cornerRadius = 10
    }
    
    private func setSecondaryPillViewStyle() {
        secondaryPillField.layer.cornerRadius = 10
    }

}

extension MedicationViewController: AddSecondaryPillViewControllerDelegate {

    // MARK: AddSecondaryPillViewControllerDelegate
    func didFinishModal(selectedPill: String) {
        // TODO : 아래에 추가약 복용 추가하기 모달이 내려간 이후 수행할 함수 작성
    
    }

    @IBAction func tapAddSecondaryPillButton() {
        let storyboard: UIStoryboard = UIStoryboard(name: "AddSecondaryPillView", bundle: nil)
        let nextViewController = storyboard.instantiateViewController(withIdentifier: "AddSecondPillStoryboard") as! AddSecondaryPillViewController
        
        nextViewController.delegate = self
        
        self.present(nextViewController, animated: true)
    }
}

// MARK: - Extensions
extension MedicationViewController: UITableViewDataSource {
    
    // 셀의 갯수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableView == primaryPillTableView ?
        dummyPrimaryPills.count :
        dummySecondaryPills.count
    }

    // 셀 데이터
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! MedicationPillCell
        
        // Image
        cell.pillImageView.image = UIImage(named:
                                            tableView == primaryPillTableView ?
                                           "primaryPill" :
                                            "secondaryPill")
        // Name
        cell.pillNameLabel.text = tableView == primaryPillTableView ?
        dummyPrimaryPills[indexPath.row].pillName :
            dummySecondaryPills[indexPath.row].pillName
        cell.pillTimeLabel.font = UIFont.AFont.cardViewPillName

        // Time
        if tableView == primaryPillTableView {
            cell.pillTimeLabel.text = dummyPrimaryPills[indexPath.row].status ?
            dummyPrimaryPills[indexPath.row].time :
            "아직 복약 전이에요"
        } else {
            cell.pillTimeLabel.text = dummySecondaryPills[indexPath.row].status ?
            dummyPrimaryPills[indexPath.row].time :
            "아직 복약 전이에요"
        }
        cell.pillTimeLabel.font = UIFont.AFont.caption

        return cell

    }
}

extension MedicationViewController: UITableViewDelegate {

}

// MARK: - Dummy Data
struct PillDummy {
    var pillName: String
    var time: String
    var status: Bool
    
    init (name: String, time: String, status: Bool) {
        self.pillName = name
        self.time = time + "에 복약했어요."
        self.status = status
    }
}
