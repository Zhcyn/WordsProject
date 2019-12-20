import UIKit
import Alamofire
import SwiftSoup
var wordList = [String]()
var onlyWords = [String]()
var sections = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
var dictionary = [String: [String]]()
var filteredDictionary = [String: [String]]()
var thirdDisplayIndex = 0
var thirdDisplaySection = 0
let searchController = UISearchController(searchResultsController: nil)
var filtering = false
var loading = false
var count = defaults.object(forKey: "count") as! Int 
class thirdViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {
    @IBOutlet var thirdTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        thirdTableView.delegate = self
        thirdTableView.dataSource = self
        if(defaults.object(forKey: "launchedBefore") == nil) {
            print("first launch")
            defaults.set(true, forKey: "launchedBefore")
            loading = true
            self.scrape() 
        }
        if(loading) {
            let alert = UIAlertController(title: nil, message: "Loading...", preferredStyle: .alert)
            let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
            loadingIndicator.hidesWhenStopped = true
            loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
            loadingIndicator.startAnimating();
            alert.view.addSubview(loadingIndicator)
            present(alert, animated: true, completion: nil)
            dismiss(animated: false, completion: nil)
        }
        if(!loading) {
            dictionary = defaults.object(forKey: "dictionary") as! [String : [String]]
            wordList = defaults.object(forKey: "wordList") as! [String]
        }
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        definesPresentationContext = true
        thirdTableView.tableHeaderView = searchController.searchBar
        self.thirdTableView.tableFooterView = UIView()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let selectedRow: IndexPath? = thirdTableView.indexPathForSelectedRow
        if let selectedRowNotNill = selectedRow {
            thirdTableView.deselectRow(at: selectedRowNotNill, animated: true)
        }
        thirdTableView.reloadData()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(loading) {
            return 1
        }
        if(filtering) {
            if(filteredDictionary[sections[section]] == nil) {
                return 0
            }
            return filteredDictionary[sections[section]]!.count
        }
        return dictionary[sections[section]]!.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {   
        let cell:UITableViewCell = self.thirdTableView.dequeueReusableCell(withIdentifier: "cellThird") as UITableViewCell!
        if(loading) {
            cell.textLabel?.text = "Loading..."
        }
        if(filtering) {
            cell.textLabel?.text = filteredDictionary[sections[indexPath.section]]?[indexPath.row]
            if(learnedWords.contains(filteredDictionary[sections[indexPath.section]]![indexPath.row])) {
                cell.accessoryType = UITableViewCellAccessoryType.checkmark
            }
            else {
                cell.accessoryType = UITableViewCellAccessoryType.none
            }
        }
        else {
            cell.textLabel?.text = dictionary[sections[indexPath.section]]?[indexPath.row]
            if(loading == false && learnedWords.contains(dictionary[sections[indexPath.section]]![indexPath.row])) {
                cell.accessoryType = UITableViewCellAccessoryType.checkmark
            }
            else {
                cell.accessoryType = UITableViewCellAccessoryType.none
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        thirdDisplayIndex = indexPath.row
        thirdDisplaySection = indexPath.section
        performSegue(withIdentifier: "thirdSegue", sender: self)
    }
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return sections
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 26
    }
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return index
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(loading) {
            return nil
        }
        if(filtering) {
            if (filteredDictionary[sections[section]] == nil) {
                return nil
            }
        }
        return sections[section]
    }
    func updateSearchResults(for searchController: UISearchController) {
        var searchText = searchController.searchBar.text!.lowercased()
        if searchText == "" {
            filtering = false
            filteredDictionary = dictionary
        }
        else {
            filtering = true
            filteredDictionary = dictionary.mapValues { $0.filter { $0.contains(searchText) } }.filter { !$0.value.isEmpty }
        }
        self.thirdTableView.reloadData()
    }
    func scrape() {
        Alamofire.request("https://www.vocabulary.com/lists/191545").responseString { response in
            if let vocabularycom = response.result.value {
                self.vocabularycomParse(html: vocabularycom)
            }
        }
        Alamofire.request("https://www.satvocabulary.us/").responseString { response in
            if let satvocabulary = response.result.value {
                self.satvocabularyParse(html: satvocabulary)
            }
        }
        Alamofire.request("http://www.majortests.com/sat/wordlist-01").responseString { response in
            if let wordlist01 = response.result.value {
                self.majortestsParse(html: wordlist01)
            }
        }
        Alamofire.request("http://www.majortests.com/sat/wordlist-02").responseString { response in
            if let wordlist02 = response.result.value {
                self.majortestsParse(html: wordlist02)
            }
        }
        Alamofire.request("http://www.majortests.com/sat/wordlist-03").responseString { response in
            if let wordlist03 = response.result.value {
                self.majortestsParse(html: wordlist03)
            }
        }
        Alamofire.request("http://www.majortests.com/sat/wordlist-04").responseString { response in
            if let wordlist04 = response.result.value {
                self.majortestsParse(html: wordlist04)
            }
        }
        Alamofire.request("http://www.majortests.com/sat/wordlist-05").responseString { response in
            if let wordlist05 = response.result.value {
                self.majortestsParse(html: wordlist05)
            }
        }
        Alamofire.request("http://www.majortests.com/sat/wordlist-06").responseString { response in
            if let wordlist06 = response.result.value {
                self.majortestsParse(html: wordlist06)
            }
        }
        Alamofire.request("http://www.majortests.com/sat/wordlist-07").responseString { response in
            if let wordlist07 = response.result.value {
                self.majortestsParse(html: wordlist07)
            }
        }
        Alamofire.request("http://www.majortests.com/sat/wordlist-08").responseString { response in
            if let wordlist08 = response.result.value {
                self.majortestsParse(html: wordlist08)
            }
        }
        Alamofire.request("http://www.majortests.com/sat/wordlist-09").responseString { response in
            if let wordlist09 = response.result.value {
                self.majortestsParse(html: wordlist09)
            }
        }
        Alamofire.request("http://www.majortests.com/sat/wordlist-10").responseString { response in
            if let wordlist10 = response.result.value {
                self.majortestsParse(html: wordlist10)
            }
        }
        Alamofire.request("http://www.majortests.com/sat/wordlist-16").responseString { response in
            if let wordsfromtest01 = response.result.value {
                self.majortestsParse(html: wordsfromtest01)
            }
        }
        Alamofire.request("http://www.majortests.com/sat/wordlist-17").responseString { response in
            if let wordsfromtest02 = response.result.value {
                self.majortestsParse(html: wordsfromtest02)
            }
        }
        Alamofire.request("http://www.majortests.com/sat/wordlist-18").responseString { response in
            if let wordsfromtest03 = response.result.value {
                self.majortestsParse(html: wordsfromtest03)
            }
        }
        Alamofire.request("http://www.majortests.com/sat/wordlist-19").responseString { response in
            if let wordsfromtest04 = response.result.value {
                self.majortestsParse(html: wordsfromtest04)
            }
        }
        Alamofire.request("http://www.majortests.com/sat/wordlist-20").responseString { response in
            if let wordsfromtest05 = response.result.value {
                self.majortestsParse(html: wordsfromtest05)
            }
        }
        Alamofire.request("http://www.majortests.com/sat/wordlist-21").responseString { response in
            if let wordsfromtest06 = response.result.value {
                self.majortestsParse(html: wordsfromtest06)
            }
        }
        Alamofire.request("http://www.majortests.com/sat/wordlist-22").responseString { response in
            if let wordsfromtest07 = response.result.value {
                self.majortestsParse(html: wordsfromtest07)
            }
        }
        Alamofire.request("http://www.majortests.com/sat/wordlist-23").responseString { response in
            if let wordsfromtest08 = response.result.value {
                self.majortestsParse(html: wordsfromtest08)
            }
        }
        Alamofire.request("http://www.majortests.com/sat/wordlist-24").responseString { response in
            if let wordsfromtest09 = response.result.value {
                self.majortestsParse(html: wordsfromtest09)
            }
        }
        Alamofire.request("http://www.majortests.com/sat/wordlist-25").responseString { response in
            if let wordsfromtest10 = response.result.value {
                self.majortestsParse(html: wordsfromtest10)
            }
        }
    }
    func vocabularycomParse(html: String) -> Void {
        do {
            let doc = try SwiftSoup.parse(html)
            let orderedList = try doc.select("ol")
            let everything = try orderedList.select("li")
            for li in everything {
                let word = try li.select("a").text().lowercased()
                let definition = try li.select("div.definition").text().lowercased()
                let item = word + " - " + definition
                if(!onlyWords.contains(word)) {
                    onlyWords.append(word)
                    wordList.append(item)
                }
                else {
                    for element in wordList {
                        if element.starts(with: word) { 
                            let index = wordList.index(of: element)! 
                            if(!element.hasSuffix(definition)) {
                                wordList[index] = wordList[index] + "; " + definition
                            }
                        }
                    }
                }
            }
            self.cleanUp()
        } catch Exception.Error(let type, let message) {
            print(message)
        } catch {
            print("wtf")
        }
    }
    func satvocabularyParse(html: String) -> Void {
        do {
            let doc = try SwiftSoup.parse(html)
            let table = try doc.select("table") 
            var everything = try table.select("tr").array() 
            everything.remove(at: 0)
            everything.remove(at: 0) 
            for tr in everything {
                let word = try tr.select("b").text().lowercased()
                let td = try tr.select("td")
                let definition = try td.get(2).text().lowercased()
                let item = word + " - " + definition
                if(!onlyWords.contains(word)) {
                    onlyWords.append(word)
                    wordList.append(item)
                }
                else {
                    for element in wordList {
                        if element.starts(with: word) {
                            let index = wordList.index(of: element)!
                            if(!element.hasSuffix(definition)) {
                                wordList[index] = wordList[index] + "; " + definition
                            }
                        }
                    }
                }
            }
            self.cleanUp()
        } catch Exception.Error(let type, let message) {
            print(message)
        } catch {
            print("wtf")
        }
    }
    func majortestsParse(html: String) -> Void {
        do {
            let doc = try SwiftSoup.parse(html)
            let table = try doc.select("table.wordlist") 
            let everything = try table.select("tr")
            for tr in everything {
                let word = try tr.select("th").text().lowercased()
                let definition = try tr.select("td").text().lowercased()
                let item = word + " - " + definition
                if(!onlyWords.contains(word)) {
                    onlyWords.append(word)
                    wordList.append(item)
                }
                else {
                    for element in wordList {
                        if element.starts(with: word) { 
                            let index = wordList.index(of: element)! 
                            if(!element.hasSuffix(definition)) {
                                wordList[index] = wordList[index] + "; " + definition
                            }
                        }
                    }
                }
            }
            self.cleanUp()
        } catch Exception.Error(let type, let message) {
            print(message)
        } catch {
            print("wtf")
        }
    }
    func cleanUp () {
        wordList.sort()
        wordList = wordList.removeDuplicates()
        for letter in sections {
            dictionary[letter] = []
            let matches = wordList.filter({ $0.hasPrefix(letter) })
            if !matches.isEmpty {
            for word in matches {
                    dictionary[letter]?.append(word)
                }
            }
        }
        defaults.set(dictionary, forKey: "dictionary")
        wordList.shuffle()
        defaults.set(wordList, forKey: "wordList")
        defaults.set((defaults.object(forKey: "wordList") as! [String]).count, forKey: "count")
        loading = false
        self.thirdTableView.reloadData()
    }
}
