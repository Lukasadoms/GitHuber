//
//  String+PercentEncoding.swift
//  GitHuber
//
//  Created by Lukas Adomavicius on 2021-07-04.
//

import Foundation

extension String {
  func stringByAddingPercentEncodingForRFC3986() -> String? {
    let unreserved = "&=+-._~/?"
    let allowed = NSMutableCharacterSet.alphanumeric()
    allowed.addCharacters(in: unreserved)
    return addingPercentEncoding(withAllowedCharacters: allowed as CharacterSet)
  }
}
