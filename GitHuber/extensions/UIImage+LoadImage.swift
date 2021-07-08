
import UIKit

extension UIImage {
    
    func downloadImage(from url: URL, completion: @escaping (UIImage) -> () ) {
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            guard let image = UIImage(data: data) else {
                DispatchQueue.main.async {
                    let image = #imageLiteral(resourceName: "appLogo")
                    completion(image)
                }
                return
            }
            DispatchQueue.main.async {
                completion(image)
            }
        }
    }
    
    private func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
}
