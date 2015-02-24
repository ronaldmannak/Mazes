//
//  Grid.swift
//  Mazes
//
//  Created by Ronald Mannak on 2/23/15.
//  Copyright (c) 2015 Ronald Mannak. All rights reserved.
//

import Foundation

/*

    Origin is top left cell,
    Coordinate is (column, row)

    (0, 0) | (1, 0) | (2, 0)
    ------------------------
    (0, 1) | (1, 1) | (2, 1)
    ------------------------
    (0, 2) | (1, 2) | (2, 2)

*/

typealias Column = Int
typealias Row = Int

enum Accessor {
    case North, South, East, West
    
    func opposite() -> Accessor {
        
        switch self {
        case .North:
            return .South
        case .South:
            return .North
        case .East:
            return .West
        case .West:
            return .East
        }
    }
}

class Grid {
    
    let columns: Column
    let rows: Row
    let cellType: Cell.Type
    
    private var array: [Cell?]
//    private static let zobristKeys: [[Int]]
    
    convenience init(columns: Column, rows: Row, cellType: Cell.Type) {
        self.init(columns: columns, rows: rows, cellType: cellType, repeatedValue: nil)
    }
    
    init(columns: Column, rows: Row, cellType:Cell.Type, repeatedValue: Cell?) {
        self.columns = columns
        self.rows = rows
        self.cellType = cellType
        
        array = Array<Cell?>(count: columns * rows, repeatedValue: repeatedValue)
    }
    
    subscript(column: Column, row: Row) -> Cell? {
        get {
            return array[row * columns + column]
        }
        set {
            array[row * columns + column] = newValue
        }
    }
}

// MARK: Setup
extension Grid {
    
    func prepare() {
        for r in 0 ..< rows {
            for c in 0 ..< columns {
                self[c, r] = cellType(coordinate: Coordinate(column: c, row: r))
            }
        }
    }
    
//    func configureCells() {
//        for r in 0 ..< rows {
//            for c in 0 ..< columns {
//                if let cell = self[c, r] {
//                    if cell.coordinate.row != 0 {
//                        if let neighbor = self[c, r - 1] {
//                            cell.link(neighbor, bidirectional: false)
//                        }
//                    }
//                }
//            }
//        }
//    }
}

//extension Grid: SetGenerator {
//    
//    func next() -> T? {
//        
//    }
//    
//}

extension Grid: Printable {
    
    var description: String {
        var s = String()
        for r in 0 ..< rows {
            for c in 0 ..< columns {
                s += self[c, r]?.description ?? " "
            }
            s += "\n"
        }
        
        s += "\n   "
        for c in 0 ..< columns {
            s += "\(c)"
            s += c < 10 ? " " : ""
        }
        return s
    }
}

extension Grid: Equatable {}

func == (left: Grid, right: Grid) -> Bool {

    if left.rows != right.rows || left.columns != right.columns {
        return false
    }

    for r in 0 ..< left.rows {
        for c in 0 ..< left.columns {
            if left[c, r] != right[c, r] { // does this work for nils too?
                return false
            }
        }
    }
    return true
}