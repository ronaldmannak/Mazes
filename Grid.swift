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

protocol Linkable {

    typealias T
    init(coordinate: Coordinate)
    var coordinate: Coordinate {get}
    var neighbors: [Accessor: T] {get}
    func link(cell: T, bidirectional: Bool)
    func unlink(accessor: Accessor, bidirectional: Bool)
    func unlink(cell: T, bidirectional: Bool)
}

class Grid<T where T: Printable, T:Equatable, T:Hashable, T:Linkable> {
    
    let columns: Column
    let rows: Row
    
    private var array: [T?]
//    private static let zobristKeys: [[Int]]
    
    convenience init(columns: Column, rows: Row) {
        self.init(columns: columns, rows: rows, repeatedValue: nil)
    }
    
    init(columns: Column, rows: Row, repeatedValue: T?) {
        self.columns = columns
        self.rows = rows
        
        array = Array<T?>(count: columns * rows, repeatedValue: repeatedValue)
    }
    
    subscript(column: Column, row: Row) -> T? {
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
    
    func prepare(cell: T.Type) {
        for r in 0 ..< rows {
            for c in 0 ..< columns {
                self[c, r] = cell(coordinate: Coordinate(column: c, row: r))
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

func == <T where T:Equatable, T:Printable> (left: Grid<T>, right: Grid<T>) -> Bool {

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