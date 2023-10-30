//
//  CommentModel.swift
//  Gap_International
//
//  Created by Vaibhav Rajani on 10/23/23.
//

import Foundation

struct Comment: Identifiable, Codable {
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
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(chapterName, forKey: .chapterName)
        try container.encode(comment, forKey: .comment)
        try container.encode(level, forKey: .level)
        try container.encode(date, forKey: .date)
    }
    
}
