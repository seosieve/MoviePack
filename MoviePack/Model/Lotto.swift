//
//  Lotto.swift
//  MoviePack
//
//  Created by 서충원 on 6/5/24.
//

import Foundation

struct Lotto: Decodable {
    //Date
    let drwNoDate: String
    //Round
    let drwNo: Int
    //Numbers
    let drwtNo1: Int
    let drwtNo2: Int
    let drwtNo3: Int
    let drwtNo4: Int
    let drwtNo5: Int
    let drwtNo6: Int
    let bnusNo: Int
    //Computed Property
    var drawDateString: String {
        return drwNoDate + " 추첨"
    }
    var drawNoString: String {
        return String(drwNo) + "회"
    }
}
