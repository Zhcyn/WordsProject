import UIKit
class thirdWordViewController: UIViewController {
    @IBOutlet var wordInformation: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        if(filtering) {
            wordInformation.text = filteredDictionary[sections[thirdDisplaySection]]?[thirdDisplayIndex]
            if(!learnedWords.contains(filteredDictionary[sections[thirdDisplaySection]]![thirdDisplayIndex])) {
                navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Learn", style: .plain, target: self, action: #selector(learnWord))
            }
            else {
                navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Unlearn", style: .plain, target: self, action: #selector(unlearnWord))
            }
            let separated = filteredDictionary[sections[thirdDisplaySection]]![thirdDisplayIndex].components(separatedBy: "-")
            let title = separated[0].trimmingCharacters(in: .whitespacesAndNewlines)
            self.navigationItem.title = title
        }
        else {
            wordInformation.text = dictionary[sections[thirdDisplaySection]]?[thirdDisplayIndex]
            if(!learnedWords.contains(dictionary[sections[thirdDisplaySection]]![thirdDisplayIndex])) {
                navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Learn", style: .plain, target: self, action: #selector(learnWord))
            }
            else {
                navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Unlearn", style: .plain, target: self, action: #selector(unlearnWord))
            }
            let separated = dictionary[sections[thirdDisplaySection]]![thirdDisplayIndex].components(separatedBy: "-")
            let title = separated[0].trimmingCharacters(in: .whitespacesAndNewlines)
            self.navigationItem.title = title
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @objc func learnWord () {
        if(filtering) {
            learnedWords.insert(filteredDictionary[sections[thirdDisplaySection]]![thirdDisplayIndex], at: 0)
        }
        else {
            learnedWords.insert(dictionary[sections[thirdDisplaySection]]![thirdDisplayIndex], at: 0)
        }
        defaults.set(learnedWords, forKey: "learnedWords")
        self.navigationController?.popToRootViewController(animated: true)
    }
    @objc func unlearnWord () {
        if(filtering) {
            if let index = learnedWords.index(of: filteredDictionary[sections[thirdDisplaySection]]![thirdDisplayIndex]) {
                learnedWords.remove(at: index)
            }
        }
        else {
            if let index = learnedWords.index(of: dictionary[sections[thirdDisplaySection]]![thirdDisplayIndex]) {
                learnedWords.remove(at: index)
            }
        }
        defaults.set(learnedWords, forKey: "learnedWords")
        self.navigationController?.popToRootViewController(animated: true)
    }
}
