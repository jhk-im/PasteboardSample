//
//  ViewController.swift
//  PasteboardSample
//
//  Created by HUN on 2023/03/10.
//

import UIKit
import LinkPresentation

class ViewController: UIViewController {

    @IBOutlet weak var lbText: UILabel!
    @IBOutlet weak var lbUrl: UILabel!
    
    
    @IBOutlet weak var preview: UIView!
    @IBOutlet weak var ivImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let pasteboard = UIPasteboard.general
        
        if pasteboard.hasImages {
            guard let url = URL(string: pasteboard.string ?? "") else { return }
            ivImage.load(url: url) {

            }
        } else if pasteboard.hasURLs {
            lbUrl.text = pasteboard.string ?? ""
            fetchPreview(urlString: pasteboard.string ?? "")
        } else {
            lbText.text = pasteboard.string ?? ""
        }
        //print("numberOfItems -> \(pasteboard.numberOfItems)")
//        guard let itemSet = pasteboard.itemSet(withPasteboardTypes: pasteboard.types) else { return }
//
//        print("types -> \(pasteboard.types)")
//        print("contains -> \(pasteboard.contains(pasteboardTypes: pasteboard.types, inItemSet: itemSet))")
//
//        for type in pasteboard.types {
//            print("items -> \(pasteboard.data(forPasteboardType: type, inItemSet: itemSet))")
//            print("items -> \(pasteboard.value(forPasteboardType: type))")
//        }
        
//        print("string -> \(pasteboard.string ?? "")")
//        print("url -> \(pasteboard.url ?? URL(string: ""))")
//        print("image -> \(String(describing: pasteboard.image))")
    }
    
    func fetchPreview(urlString: String){
            guard let url = URL(string: urlString) else {
                return
            }
            let linkPreview = LPLinkView()
            let provider = LPMetadataProvider()
            provider.startFetchingMetadata(for: url, completionHandler: {
                [weak self] metaData, error in
                guard let data = metaData, error == nil else{
                    return
                }
                DispatchQueue.main.async {
                    linkPreview.metadata = data
                    print(linkPreview)
                    self?.preview.addSubview(linkPreview)
                    linkPreview.frame = CGRect(x: 0, y: 0, width: 360, height: 180)
                    //self?.ivPreview.image = linkPreview.largeContentImage
                }
                
            })
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
