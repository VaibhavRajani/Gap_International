//
//  CommentModel.swift
//  Gap_International
//
//  Created by Vaibhav Rajani on 10/23/23.
//

import Foundation

struct Comment: Identifiable, Decodable {
    var chapterName: String
    var comment: String
    var level: Int
    var date: String

    var id: String {
        return chapterName + date
    }
    
    enum CodingKeys: String, CodingKey {
        case chapterName = "ChapterName"
        case comment = "Comment"
        case level = "Level"
        case date = "Date"
    }
}
