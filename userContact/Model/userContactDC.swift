

import Foundation
struct contactData : Codable {
    
	let username : String?
	let profile_image_url : String?
	let sid : String?
}

typealias userContact = [contactData]
