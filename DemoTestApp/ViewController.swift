//
//  ViewController.swift
//  DemoTestApp
//
//  Created by Dimpy Patel on 19/06/25.
//

//https://fakestoreapi.com/products

import UIKit
import Alamofire

class ViewController: UIViewController {
    
    @IBOutlet weak var storeTableView: UITableView!
    
    // MARK: - Variables
    var storeDataArray = [StoreData]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialDetails()
    }

    // MARK: - Initial Details
    func initialDetails() {
        self.setUpTableView()
        self.fetchStoreData()
    }
    
    // MARK: - Set Up TableView
    func setUpTableView() {
        self.storeTableView.delegate = self
        self.storeTableView.dataSource = self
        self.storeTableView.register(UINib(nibName: "StoreTableViewCell", bundle: nil), forCellReuseIdentifier: "StoreTableViewCell")
    }

    // MARK: - API Call
    func fetchStoreData() {
        let url = "https://fakestoreapi.com/products"
        
        AF.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil, interceptor: nil)
          .response{ resp in
              switch resp.result{
                case .success(let data):
                  do{
                    let jsonData = try JSONDecoder().decode([StoreData].self, from: data!)
                    print(jsonData)
                      self.storeDataArray = jsonData
                      DispatchQueue.main.async {
                          self.storeTableView.reloadData()
                      }
                 } catch {
                    print(error.localizedDescription)
                 }
               case .failure(let error):
                 print(error.localizedDescription)
               }
          }
    }
    
}

// MARK: - UITableView Delegate and DataSource
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.storeDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "StoreTableViewCell", for: indexPath) as? StoreTableViewCell {
            cell.titleLabel.text = self.storeDataArray[indexPath.row].title
            return cell
        }
        
        return UITableViewCell()
    }
}


//  HomeScreenDelegate.swift
//import Foundation
//import UIKit
//extension HomeScreen: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return self.mainViewModel.homeDataResponse?.popularItems?.count ?? 0
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = self.mainView.popularItemCollectionView.dequeueReusableCell(withReuseIdentifier: "RecipesCell", for: indexPath) as! RecipesCell
//        cell.popularItemObject = self.mainViewModel.homeDataResponse?.popularItems?[indexPath.row]
//        return cell
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let leftSpace = (collectionView.collectionViewLayout as! UICollectionViewFlowLayout).sectionInset.left
//        let rightSpace = (collectionView.collectionViewLayout as! UICollectionViewFlowLayout).sectionInset.right
//        let cellSpacing = (collectionView.collectionViewLayout as! UICollectionViewFlowLayout).minimumInteritemSpacing
//        let numberOFRows : CGFloat = 2.0
//        let scWidth : CGFloat = (collectionView.frame.width) - (leftSpace + rightSpace)
//        let totalSpace : CGFloat = cellSpacing * (numberOFRows - 1)
//        let width = floor((scWidth - totalSpace) / numberOFRows)
//        return CGSize(width: width, height: 162)
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        switch self.mainViewModel.homeDataResponse?.popularItems?[indexPath.row].type{
//        case SearchType.program.rawValue:
//            if let programId = self.mainViewModel.homeDataResponse?.popularItems?[indexPath.row].programId{
//                self.mainViewModel.theController.navigateToViewProgramScreen(programId: programId)
//            }
//        case SearchType.recipe.rawValue:
//            if let recipeId = self.mainViewModel.homeDataResponse?.popularItems?[indexPath.row].Id{
//                self.mainViewModel.theController.navigateToViewRecipeScreen(recipeId: recipeId)
//            }
//        default:
//            break
//        }
//    }
//}

//
//import UIKit
//
//class HomeViewModel: NSObject {
//    
//    // MARK: - Variables
//    var theController = HomeScreen()
//    
//    init(theController: HomeScreen) {
//        self.theController = theController
//    }
//    var homeDataResponse : HomeDataResponse?
//    let refreshControl = UIRefreshControl()
//    
//    // MARK: - API
//    // Get Home Data API
//    func homeApi(isShowIndicator: Bool = true, completion: @escaping () -> Void){
//        if Utility.isInternetAvailable(){
//            if isShowIndicator{
//                ScreenIndicatorLoader.shared.showLoader(view: self.theController.view)
//            }
//            HomeServices.shared.homeData{ [weak self] statusCode, response in
//                guard let self = self else{return}
//                ScreenIndicatorLoader.shared.hideLoader()
//                if let response = response.homeDataResponse{
//                    self.homeDataResponse = response
//                }
//                self.theController.mainViewModel.refreshControl.endRefreshing()
//                completion()
//            } failure: { [weak self] error in
//                guard let self = self else{return}
//                ScreenIndicatorLoader.shared.hideLoader()
//                self.theController.mainViewModel.refreshControl.endRefreshing()
//                Utility.showAlert(message: error)
//            }
//        }else{
//            Utility.showNoInternetConnectionAlertDialog()
//        }
//    }
//}


//import Foundation
//import UIKit
//import DGCharts
//class HomeView: UIView, ChartViewDelegate{
//    
//    // MARK: - Outlets
//    // MARK: - ImageViews
//    @IBOutlet weak var profileImageView: UIImageView!
//    @IBOutlet weak var pinItemImageView: UIImageView!
//    @IBOutlet weak var firstGoalImageView: UIImageView!
//    @IBOutlet weak var secondGoalImageView: UIImageView!
//    
//    // MARK: - Labels
//    @IBOutlet weak var userNameLabel: UILabel!
//    @IBOutlet weak var stepsCountLabel: UILabel!
//    @IBOutlet weak var workoutCountLabel: UILabel!
//    @IBOutlet weak var caloriesCountLabel: UILabel!
//    @IBOutlet weak var pinItemNameLabel: UILabel!
//    @IBOutlet weak var pinItemTimeLabel: UILabel!
//    @IBOutlet weak var pinitemCalorieLabel: UILabel!
//    @IBOutlet weak var firstGoalTextLabel: UILabel!
//    @IBOutlet weak var secondGoalTextLabel: UILabel!
//    @IBOutlet weak var pinRecipeNameLabel: UILabel!
//    
//    // MARK: - CollectionView
//    @IBOutlet weak var popularItemCollectionView: UICollectionView!{
//        didSet{
//            self.popularItemCollectionView.register(UINib(nibName: "RecipesCell", bundle: nil), forCellWithReuseIdentifier: "RecipesCell")
////            self.popularItemCollectionView.contentInset.left = 20
//        }
//    }
//    
//    // MARK: - Views
//    @IBOutlet weak var pinRecipeDetailsView: UIView!
//    @IBOutlet weak var pinProgramDetailsView: UIView!
//    @IBOutlet weak var pinDataView: UIView!
//    @IBOutlet weak var chartNoStateView: UIView!
//    @IBOutlet weak var firstNoStateView: UIView!
//    @IBOutlet weak var firstGoalView: UIView!
//    @IBOutlet weak var secondNoStateView: UIView!
//    @IBOutlet weak var secondGoalView: UIView!
//    
//    // MARK: - CircularProgressView
//    @IBOutlet weak var stepsProgressView: CircularProgressView!
//    @IBOutlet weak var workoutProgressView: CircularProgressView!
//    
//    // MARK: - ScrollView
//    @IBOutlet weak var scrollView: UIScrollView!
//    
//    // MARK: - BarChartView
//    @IBOutlet weak var chartView: BarChartView!
//    
//    // MARK: - Functions
//    func configuration(viewController: HomeScreen){
//        self.scrollView.contentInset.bottom = 98
//        self.stepsProgressView.progressClr = #colorLiteral(red: 0.3490196078, green: 0.8392156863, blue: 0.8745098039, alpha: 1)
//        self.stepsProgressView.trackClr = #colorLiteral(red: 0.3490196078, green: 0.8392156863, blue: 0.8745098039, alpha: 0.200000003)
//        self.workoutProgressView.progressClr = #colorLiteral(red: 0.3490196078, green: 0.8392156863, blue: 0.8745098039, alpha: 1)
//        self.workoutProgressView.trackClr = #colorLiteral(red: 0.3490196078, green: 0.8392156863, blue: 0.8745098039, alpha: 0.200000003)
//        self.setUpChartView()
//    }
//    
//    // Calculate Progress
//    func calculateProgress(currentCount: Float, totalCount: Float) -> Float{
//        let progress: Float = currentCount / totalCount
//        return progress
//    }
//    
//    // Set Chart View
//    func setUpChartView(){
//        self.chartView.delegate = self
//        self.chartView.center = self.center
//        self.chartView.doubleTapToZoomEnabled = false
//        self.chartView.noDataText = "No data available."
//        self.chartView.xAxis.labelPosition = .bottom
//        self.chartView.xAxis.drawGridLinesEnabled = false
//        self.chartView.leftAxis.drawGridLinesEnabled = false
//        self.chartView.xAxis.drawAxisLineEnabled = false
//        self.chartView.rightAxis.enabled = false // Hide the right axis
//        self.chartView.leftAxis.enabled = false
//        self.chartView.legend.enabled = false
//        self.chartView.layer.cornerRadius = 16
//        // Set custom formatter for x-axis labels
////        self.chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: Date().last7daysDate(days: -7).reversed())
//        self.chartView.xAxis.granularity = 1 // Ensures the labels are displayed at each index
//        self.chartView.xAxis.labelTextColor = .white
//        self.chartView.xAxis.labelFont = UIFont(name: "Outfit-SemiBold", size: 6) ?? UIFont.systemFont(ofSize: 6)
//    }
//}
//


//import UIKit
//import DGCharts
//
//class HomeScreen: UIViewController {
//    
//    // MARK: - Variables
//    lazy var mainView: HomeView = {[weak self] in
//        return self?.view as! HomeView
//    }()
//    
//    lazy var mainViewModel: HomeViewModel = {[weak self] in
//        return HomeViewModel(theController: self!)
//    }()
//    
//    // MARK: - Methods
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.initialDetails()
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        let isRefresh: Bool = UserDefaults.standard.bool(forKey: UserDefaultsStrings.shouldHomeScreenRefresh)
//        if isRefresh{
//            UserDefaults.standard.set(false, forKey: UserDefaultsStrings.shouldHomeScreenRefresh)
//            self.homeApi(isShowIndicator: false)
//        }
//    }
//    
//    // MARK: - Functions
//    func initialDetails(){
//        self.mainView.configuration(viewController: self)
//        self.mainView.popularItemCollectionView.delegate = self
//        self.mainView.popularItemCollectionView.dataSource = self
//        self.mainViewModel.refreshControl.tintColor = #colorLiteral(red: 0.1450980392, green: 0.1450980392, blue: 0.1450980392, alpha: 0.5)
//        self.mainViewModel.refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
//        self.mainView.scrollView.refreshControl = self.mainViewModel.refreshControl
//        self.homeApi(isShowIndicator: true)
//    }
//    
//    // Pull To Refresh
//    @objc func pullToRefresh() {
//        self.homeApi(isShowIndicator: false)
//    }
//    
//    // Home API integration
//    func homeApi(isShowIndicator: Bool){
//        self.mainViewModel.homeApi(isShowIndicator: isShowIndicator) {[weak self] in
//            guard let self = self else{return}
//            self.setUpData()
//        }
//    }
//    
//    // Set Up Data After API integration
//    func setUpData(){
//        self.mainView.userNameLabel.text = "Hey \(Utility.getUserData()?.firstName ?? ""),"
//        if Utility.getUserData()?.profileImage == nil ||  Utility.getUserData()?.profileImage == ""{
//            self.mainView.profileImageView.image = UIImage(named: "ic_profile_placeholder")
//        }else{
//            Utility.setImage(Utility.getUserData()?.profileImage, imageView: self.mainView.profileImageView)
//        }
//        Utility.setUpNSMutableAttributedText(textLabel: self.mainView.caloriesCountLabel, firstTextValue: "\(self.mainViewModel.homeDataResponse?.goalLogs?.footer?.total ?? 0)", secondTextValue: self.mainViewModel.homeDataResponse?.goalLogs?.footer?.unit ?? "KCL", firstTextFont: UIFont(name: "Outfit-SemiBold", size: 12) ?? UIFont.systemFont(ofSize: 12), secondTextFont: UIFont(name: "Outfit-SemiBold", size: 6) ?? UIFont.systemFont(ofSize: 6), isSecondTextInNewLine: false)
//        self.managePinData()
//        self.manageChartView()
//        self.manageSpecificGoals()
//        self.mainView.popularItemCollectionView.reloadData()
//    }
//    
//    // Manage Chart View
//    func manageChartView(){
//        if let goalLogs = self.mainViewModel.homeDataResponse?.goalLogs{
//            self.mainView.chartView.isHidden = false
//            self.mainView.chartNoStateView.isHidden = true
//            self.setChartData()
//            let dateValues = self.mainViewModel.homeDataResponse?.goalLogs?.chartData?.compactMap { data -> String? in
//                guard let timestamp = data.date else { return nil }
//                return Utility.convertTimestampToDateStringForChart(timestamp)
//            } ?? []
//            self.mainView.chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: dateValues)
//        }else{
//            self.mainView.chartView.isHidden = true
//            self.mainView.chartNoStateView.isHidden = false
//        }
//    }
//    
//    // Set Up Chart Data
//    func setChartData() {
//        guard let chartData = self.mainViewModel.homeDataResponse?.goalLogs?.chartData else {
//            return
//        }
//        let maxValue = chartData.compactMap { $0.value }.max() ?? 0
//        // Create the entries array using the yValues
//        let entries = chartData.enumerated().map { (index, data) in
//            BarChartDataEntry(x: Double(index), y: Double(data.value ?? 0))
//        }
//        // Create a dataset with the entries
//        let dataSet = BarChartDataSet(entries: entries, label: "")
//        dataSet.colors = [#colorLiteral(red: 0.3490196078, green: 0.8392156863, blue: 0.8745098039, alpha: 1)] // Set bar color
//        dataSet.drawValuesEnabled = false
//        dataSet.highlightEnabled = false
//        // Create chart data with the dataset
//        let data = BarChartData(dataSet: dataSet)
//        data.barWidth = 0.5
//        // Assign the data to the chart
//        self.mainView.chartView.data = data
//        self.mainView.chartView.animate(yAxisDuration: 1.0, easingOption: .easeInOutQuad)
//    }
//    
//    // Manage Pin Item Data
//    func managePinData(){
//        if let pinData = self.mainViewModel.homeDataResponse?.pinData{
//            self.mainView.pinDataView.isHidden = false
//            if self.mainViewModel.homeDataResponse?.pinData?.type == PinItemType.program.rawValue{
//                self.mainView.pinProgramDetailsView.isHidden = false
//                self.mainView.pinRecipeDetailsView.isHidden = true
//                self.mainView.pinItemNameLabel.text = pinData.name
//                self.mainView.pinitemCalorieLabel.text = "\(pinData.kcal ?? "") KCL"
//                self.mainView.pinItemTimeLabel.text = pinData.days
//                Utility.setImage(pinData.image, imageView: self.mainView.pinItemImageView)
//            }else if self.mainViewModel.homeDataResponse?.pinData?.type == PinItemType.recipe.rawValue{
//                self.mainView.pinProgramDetailsView.isHidden = true
//                self.mainView.pinRecipeDetailsView.isHidden = false
//                Utility.setImage(pinData.image, imageView: self.mainView.pinItemImageView)
//                self.mainView.pinRecipeNameLabel.text = pinData.name
//            }
//        }else{
//            self.mainView.pinDataView.isHidden = true
//        }
//    }
//    
//    // Manage Specific Goal data
//    func manageSpecificGoals(){
//        if let specificGoals = self.mainViewModel.homeDataResponse?.specificGoals,!specificGoals.isEmpty{
//            if specificGoals.count == 1{
//                [self.mainView.firstGoalView, self.mainView.secondNoStateView].forEach{$0?.isHidden = false}
//                [self.mainView.firstNoStateView, self.mainView.secondGoalView].forEach{$0?.isHidden = true}
//                
//                let value = specificGoals[0].totalLogValue ?? 0
//                let totalValue = specificGoals[0].value ?? 0
//                
//                switch specificGoals[0].type{
//                case GoalType.sleep.rawValue, GoalType.exercise.rawValue:
//                    Utility.setUpNSMutableAttributedWithSlashLabel(textLabel: self.mainView.stepsCountLabel, firstTextValue: "\(Utility.convertSecondsToString(seconds: Int(value)))", secondTextValue: "\(totalValue)", firstTextFont: UIFont(name: "Outfit-Bold", size: 14) ?? UIFont.systemFont(ofSize: 14), secondTextFont: UIFont(name: "Outfit-SemiBold", size: 8) ?? UIFont.systemFont(ofSize: 14), isSecondTextInNewLine: true)
//                default:
//                    Utility.setUpNSMutableAttributedWithSlashLabel(textLabel: self.mainView.stepsCountLabel, firstTextValue: "\(value)", secondTextValue: "\(totalValue)", firstTextFont: UIFont(name: "Outfit-Bold", size: 14) ?? UIFont.systemFont(ofSize: 14), secondTextFont: UIFont(name: "Outfit-SemiBold", size: 8) ?? UIFont.systemFont(ofSize: 14), isSecondTextInNewLine: true)
//                }
//                
//                self.mainView.stepsProgressView.setProgressWithAnimation(duration: 1.0, value: self.mainView.calculateProgress(currentCount: Float(value), totalCount: Float(totalValue)))
//                
//                self.mainView.firstGoalTextLabel.text = self.setGoalTypeText(index: 0)
//                self.mainView.firstGoalImageView.image = UIImage(named: self.setGoalTypeImage(index: 0))
//                
//            }else if specificGoals.count == 2{
//                [self.mainView.firstGoalView, self.mainView.secondGoalView].forEach{$0?.isHidden = false}
//                [self.mainView.firstNoStateView, self.mainView.secondNoStateView].forEach{$0?.isHidden = true}
//                var firstValue = specificGoals[0].totalLogValue ?? 0
//                let firstTotalValue = specificGoals[0].value ?? 0
//                let secondValue = specificGoals[1].totalLogValue ?? 0
//                let secondTotalValue = specificGoals[1].value ?? 0
//                var formattedFirstValue: String
//                var formattedSecondValue: String
//                
//                switch specificGoals[0].type{
//                case GoalType.sleep.rawValue, GoalType.exercise.rawValue:
//                    formattedFirstValue = "\(Utility.convertSecondsToString(seconds: firstValue))"
//                default:
//                    formattedFirstValue = "\(firstValue)"
//                }
//                
//                switch specificGoals[1].type{
//                case GoalType.sleep.rawValue, GoalType.exercise.rawValue:
//                    formattedSecondValue = "\(Utility.convertSecondsToString(seconds: secondValue))"
//                default:
//                    formattedSecondValue = "\(secondValue)"
//                }
//                
//                Utility.setUpNSMutableAttributedWithSlashLabel(textLabel: self.mainView.stepsCountLabel, firstTextValue: formattedFirstValue, secondTextValue: "\(firstTotalValue)", firstTextFont: UIFont(name: "Outfit-Bold", size: 14) ?? UIFont.systemFont(ofSize: 14), secondTextFont: UIFont(name: "Outfit-SemiBold", size: 8) ?? UIFont.systemFont(ofSize: 14), isSecondTextInNewLine: true)
//                
//                Utility.setUpNSMutableAttributedWithSlashLabel(textLabel: self.mainView.workoutCountLabel, firstTextValue: "\(formattedSecondValue)", secondTextValue: "\(secondTotalValue)", firstTextFont: UIFont(name: "Outfit-Bold", size: 14) ?? UIFont.systemFont(ofSize: 14), secondTextFont: UIFont(name: "Outfit-SemiBold", size: 8) ?? UIFont.systemFont(ofSize: 14), isSecondTextInNewLine: true)
//                
//                self.mainView.stepsProgressView.setProgressWithAnimation(duration: 1.0, value: self.mainView.calculateProgress(currentCount: Float(firstValue), totalCount: Float(firstTotalValue)))
//                self.mainView.workoutProgressView.setProgressWithAnimation(duration: 1.0, value: self.mainView.calculateProgress(currentCount: Float(secondValue), totalCount: Float(secondTotalValue)))
//                self.mainView.firstGoalTextLabel.text = self.setGoalTypeText(index: 0)
//                self.mainView.secondGoalTextLabel.text = self.setGoalTypeText(index: 1)
//                self.mainView.firstGoalImageView.image = UIImage(named: self.setGoalTypeImage(index: 0))
//                self.mainView.secondGoalImageView.image = UIImage(named: self.setGoalTypeImage(index: 1))
//            }
//        }else{
//            [self.mainView.firstNoStateView, self.mainView.secondNoStateView].forEach{$0?.isHidden = false}
//            [self.mainView.firstGoalView, self.mainView.secondGoalView].forEach{$0?.isHidden = true }
//        }
//    }
//    
//    // Set Goal Type Name
//    func setGoalTypeText(index : Int) -> String{
//        switch self.mainViewModel.homeDataResponse?.specificGoals?[index].type{
//        case GoalType.calories.rawValue:
//            return "Calories"
//        case GoalType.water.rawValue:
//            return "Water"
//        case GoalType.sleep.rawValue:
//            return "Sleep"
//        case GoalType.protein.rawValue:
//            return "Protein"
//        case GoalType.steps.rawValue:
//            return "Steps"
//        case GoalType.exercise.rawValue:
//            return "Exercise"
//        case GoalType.weight.rawValue:
//            return "Weight"
//        default:
//            return ""
//        }
//    }
//    
//    // Set Goal Type Image
//    func setGoalTypeImage(index : Int) -> String{
//        switch self.mainViewModel.homeDataResponse?.specificGoals?[index].type{
//        case GoalType.calories.rawValue:
//            return "ic_calorie"
//        case GoalType.water.rawValue:
//            return "ic_water"
//        case GoalType.sleep.rawValue:
//            return "ic_sleep"
//        case GoalType.protein.rawValue:
//            return "ic_protein"
//        case GoalType.steps.rawValue:
//            return "ic_steps"
//        case GoalType.exercise.rawValue:
//            return "ic_workout"
//        case GoalType.weight.rawValue:
//            return "ic_protein"
//        default:
//            return ""
//        }
//    }
//    
//    // MARK: - Button Actions
//    @IBAction func onProfile(_ sender: UIButton) {
//        if let vc = STORYBOARD.profile.instantiateViewController(withIdentifier: "ProfileScreen") as? ProfileScreen{
//            self.tabBarController?.navigationController?.pushViewController(vc, animated: true)
//        }
//    }
//    
//    @IBAction func onPinItem(_ sender: UIButton) {
//        switch self.mainViewModel.homeDataResponse?.pinData?.type{
//        case PinItemType.program.rawValue:
//            if let id = self.mainViewModel.homeDataResponse?.pinData?.Id{
//                self.navigateToViewProgramScreen(programId: id)
//            }
//        case PinItemType.recipe.rawValue:
//            if let id = self.mainViewModel.homeDataResponse?.pinData?.Id{
//                self.navigateToViewRecipeScreen(recipeId: id)
//            }
//        default:
//            break
//        }
//    }
//    
//    // MARK: - Helper functions
//    // Navigate to View Program Screen
//    func navigateToViewProgramScreen(programId: String){
//        if let vc = STORYBOARD.programs.instantiateViewController(withIdentifier: "ViewProgramScreen") as? ViewProgramScreen{
//        vc.mainViewModel.programId = programId
//        self.navigationController?.pushViewController(vc, animated: true)
//    }}
//    
//    // Navigate To Recipe Screen
//    func navigateToViewRecipeScreen(recipeId: String){
//        if let vc = STORYBOARD.programs.instantiateViewController(withIdentifier: "ViewRecipesScreen") as? ViewRecipesScreen{
//            vc.mainViewModel.recipeId = recipeId
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
//    }
//}


//import UIKit
//
//enum GameMode {
//    case task1
//    case task2
//}
//
//class ViewController: UIViewController {
//    // MARK: - IBOutlets
//    //UILabel
//    @IBOutlet weak var selectedGridLabel: UILabel!
//    
//    //UIStepper
//    @IBOutlet weak var stepper: UIStepper!
//    
//    //UICollectionView
//    @IBOutlet weak var gridCollectionView: UICollectionView!
//    
//    //UIButton
//    @IBOutlet weak var newGameButton: UIButton!
//    @IBOutlet weak var switchToAnotherTaskButton: UIButton!
//    @IBOutlet weak var resetGridButton: UIButton!
//    
//    // MARK: - Variables
//    var gridSize: Int = 5 {
//        didSet {
//            selectedGridLabel.text = "\(gridSize)x\(gridSize)"
//            gridCollectionView.reloadData()
//        }
//    }
//    
//    let minGridSize = 3
//    let maxGridSize = 10
//    var gridColors: [[UIColor]] = []
//    let colorOptions: [UIColor] = [.red, .blue, .green, .yellow, .orange, .purple]
//    var currentGameMode: GameMode = .task1
//    
//    // MARK: - Methods
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.setUpInitialDetails()
//        self.startNewGame()
//    }
//    
//    // MARK: - Functions
//    func setUpInitialDetails() {
//        self.gridCollectionView.delegate = self
//        self.gridCollectionView.dataSource = self
//        self.gridCollectionView.register(ColorGridCollectionViewCell.self, forCellWithReuseIdentifier: "ColorGridCollectionViewCell")
//        
//        self.stepper.minimumValue = Double(self.minGridSize)
//        self.stepper.maximumValue = Double(self.maxGridSize)
//        self.stepper.value = Double(self.gridSize)
//    }
//    
//    func startNewGame() {
//        self.gridColors = (0..<self.gridSize).map { _ in
//            (0..<self.gridSize).map { _ in self.colorOptions.randomElement()! }
//        }
//        self.gridCollectionView.reloadData()
//    }
//    
//    func isGameOver() -> Bool {
//        let firstColor = gridColors.first?.first
//        for row in gridColors {
//            for color in row {
//                if color != firstColor {
//                    return false
//                }
//            }
//        }
//        return true
//    }
//    
//    func showGameOverAlert() {
//        let alert = UIAlertController(title: "Game Over!", message: "All cells are filled with the same color.", preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "New Game", style: .default, handler: { _ in
//            self.startNewGame()
//        }))
//        present(alert, animated: true)
//    }
//    
//    
//    // MARK: - IBActions
//    @IBAction func onStepper(_ sender: UIStepper) {
//        self.gridSize = Int(sender.value)
//        self.startNewGame()
//    }
//    @IBAction func onNewGame(_ sender: UIButton) {
//        self.startNewGame()
//    }
//    
//    @IBAction func onSwitchToTaskTwo(_ sender: UIButton) {
//        currentGameMode = .task2
//        resetGridForTask2()
//        
//        // UI updates
//        sender.isHidden = true
//        resetGridButton.isHidden = false
//        newGameButton.isHidden = true
//    }
//    
//    @IBAction func onResetGrid(_ sender: UIButton) {
//        resetGridForTask2()
//    }
//    
//    func resetGridForTask2() {
//        gridColors = Array(repeating: Array(repeating: .lightGray, count: gridSize), count: gridSize)
//        gridCollectionView.reloadData()
//        selectedGridLabel.text = "\(gridSize)x\(gridSize)"
//    }
//    
//}
//
//extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return gridSize
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return gridSize
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorGridCollectionViewCell", for: indexPath)
//        cell.backgroundColor = gridColors[indexPath.section][indexPath.item]
//        cell.layer.cornerRadius = 4
//        cell.layer.borderColor = UIColor.systemGray4.cgColor
//        cell.layer.borderWidth = 1
//        return cell
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        switch currentGameMode {
//        case .task1:
//            // Use the original flood fill logic
//            let targetColor = gridColors[indexPath.section][indexPath.item]
//            var newColor = colorOptions.randomElement()!
//            while newColor == targetColor {
//                newColor = colorOptions.randomElement()!
//            }
//            floodFill(from: indexPath.section, column: indexPath.item, targetColor: targetColor, replacementColor: newColor)
//            collectionView.reloadData()
//            if isGameOver() {
//                showGameOverAlert()
//            }
//            
//        case .task2:
//            highlightCrossGrid(at: indexPath)
//        }
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let spacing: CGFloat = 2
//        let totalSpacing = spacing * CGFloat(gridSize - 1)
//        let width = (collectionView.frame.width - totalSpacing) / CGFloat(gridSize)
//        return CGSize(width: width, height: width)
//    }
//    
//    func floodFill(from row: Int, column: Int, targetColor: UIColor, replacementColor: UIColor) {
//        guard targetColor != replacementColor else { return }
//        
//        var visited = Array(repeating: Array(repeating: false, count: gridSize), count: gridSize)
//        
//        func dfs(r: Int, c: Int) {
//            guard r >= 0, r < gridSize, c >= 0, c < gridSize else { return }
//            guard !visited[r][c], gridColors[r][c] == targetColor else { return }
//            
//            visited[r][c] = true
//            gridColors[r][c] = replacementColor
//            
//            dfs(r: r + 1, c: c)
//            dfs(r: r - 1, c: c)
//            dfs(r: r, c: c + 1)
//            dfs(r: r, c: c - 1)
//        }
//        
//        dfs(r: row, c: column)
//    }
//    
//    func highlightCrossGrid(at indexPath: IndexPath) {
//        let row = indexPath.section
//        let col = indexPath.item
//        resetGridForTask2()
//        
//        gridColors[row][col] = .red
//        
//        for i in 0..<gridSize {
//            if i != col { gridColors[row][i] = .yellow }      // horizontal
//            if i != row { gridColors[i][col] = .yellow }      // vertical
//            if row - i >= 0, col - i >= 0, row - i != row { gridColors[row - i][col - i] = .yellow }   // ↖
//            if row + i < gridSize, col + i < gridSize, row + i != row { gridColors[row + i][col + i] = .yellow } // ↘
//            if row - i >= 0, col + i < gridSize, row - i != row { gridColors[row - i][col + i] = .yellow } // ↗
//            if row + i < gridSize, col - i >= 0, row + i != row { gridColors[row + i][col - i] = .yellow } // ↙
//        }
//        
//        gridCollectionView.reloadData()
//    }
//    
//    
//}
//
//
//// MARK: - Color Grid CollectionView Cell
//class ColorGridCollectionViewCell: UICollectionViewCell {
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        self.setUpCell()
//    }
//    
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        self.setUpCell()
//    }
//    
//    func setUpCell() {
//        layer.cornerRadius = 4.0
//        layer.borderWidth = 1.0
//        layer.borderColor = UIColor.systemGray4.cgColor
//    }
//    
//    override var isHighlighted: Bool {
//        didSet {
//            UIView.animate(withDuration: 0.1) {
//                self.transform = self.isHighlighted ? CGAffineTransform(scaleX: 0.95, y: 0.95) : .identity
//            }
//        }
//    }
//}
