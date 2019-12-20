import UIKit
class firstWordViewController: UIViewController {
    @IBOutlet var wordInformation: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        wordInformation.text = wordList[firstDisplayIndex]
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Learn", style: .plain, target: self, action: #selector(learnWord))
        let separated = wordList[firstDisplayIndex].components(separatedBy: "-")
        let title = separated[0].trimmingCharacters(in: .whitespacesAndNewlines)
        self.navigationItem.title = title
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @objc func learnWord () {
        learnedWords.insert(wordList[firstDisplayIndex], at: 0)
        defaults.set(learnedWords, forKey: "learnedWords")
        self.navigationController?.popToRootViewController(animated: true)
    }
}
