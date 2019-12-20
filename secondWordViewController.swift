import UIKit
class secondWordViewController: UIViewController {
    @IBOutlet weak var wordInformation: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Unlearn", style: .plain, target: self, action: #selector(unlearnWord))
        wordInformation.text = learnedWords[secondDisplayIndex]
        let separated = learnedWords[secondDisplayIndex].components(separatedBy: "-")
        let title = separated[0].trimmingCharacters(in: .whitespacesAndNewlines)
        self.navigationItem.title = title
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()   
    }
    @objc func unlearnWord () {
        if let index = learnedWords.index(of: learnedWords[secondDisplayIndex]) {
            learnedWords.remove(at: index)
            defaults.set(learnedWords, forKey: "learnedWords")
        }
        self.navigationController?.popToRootViewController(animated: true)
     }
}
