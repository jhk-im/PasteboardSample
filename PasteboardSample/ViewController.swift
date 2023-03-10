//
//  ViewController.swift
//  PasteboardSample
//
//  Created by HUN on 2023/03/10.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textlLabel: UILabel!
    @IBOutlet weak var urlLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let pasteboard = UIPasteboard.general
        
        if pasteboard.image != nil {
            guard let url = URL(string: pasteboard.string ?? "") else { return }
            imageView.load(url: url) {
                
            }
        } else if pasteboard.url != nil {
            urlLabel.text = pasteboard.string ?? ""
        } else {
            textlLabel.text = pasteboard.string ?? ""
        }
        
        //print("numberOfItems -> \(pasteboard.numberOfItems)")
        //print("types -> \(pasteboard.types)")
        //print("itemSet -> \(pasteboard.itemSet(withPasteboardTypes: pasteboard.types) ?? [])")
        //print("string -> \(pasteboard.string ?? "")")
        //print("url -> \(pasteboard.url ?? URL(string: ""))")
        //print("image -> \(String(describing: pasteboard.image))")
        
    }
}

extension UIImageView {
    func load(url: URL, _ callback: @escaping() -> Void) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                        callback()
                    }
                }
            }
        }
    }
}
