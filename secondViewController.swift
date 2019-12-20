import UIKit
var learnedWords = [String]()
let defaults = UserDefaults.standard
var secondDisplayIndex = 0
class secondViewController: UIViewController,  UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var secondTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        secondTableView.delegate = self
        secondTableView.dataSource = self
        if(defaults.object(forKey: "learnedWords") == nil) {
            learnedWords = [""]
            learnedWords.remove(at: 0)
        }
        else {
            learnedWords = defaults.object(forKey: "learnedWords") as! [String]
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("wordList: " + String(wordList.count))
        print("defaults count:" + String(defaults.object(forKey: "count") as! Int))
        var percentage = String(format: "%.2f", Float(learnedWords.count)/Float((defaults.object(forKey: "count") as! Int)))
        navigationItem.title = "Learned Words (\(String(learnedWords.count))/\(defaults.object(forKey: "count") as! Int), \(percentage)%)"
        let selectedRow: IndexPath? = secondTableView.indexPathForSelectedRow
        if let selectedRowNotNill = selectedRow {
            secondTableView.deselectRow(at: selectedRowNotNill, animated: true)
        }
        secondTableView.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return learnedWords.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = self.secondTableView.dequeueReusableCell(withIdentifier: "cellSecond") as UITableViewCell!
        cell.textLabel?.text = learnedWords[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        secondDisplayIndex = indexPath.row
        performSegue(withIdentifier: "secondSegue", sender: self)
    }
}
