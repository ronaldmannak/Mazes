//
//  Coordinate.swift
//  Mazes
//
//  Created by Ronald Mannak on 2/23/15.
//  Copyright (c) 2015 Ronald Mannak. All rights reserved.
//

import Foundation


struct Coordinate {
    let column: Column
    let row: Row
}

func == (left: Coordinate, right: Coordinate) -> Bool {
    return left.column == right.column && left.row == right.row
}

func != (left: Coordinate, right: Coordinate) -> Bool {
    return !(left == right)
}

func - (left: Coordinate, right: Coordinate) -> Coordinate {
    return Coordinate(column: left.column - right.column, row: left.row - right.row)
}

func + (left: Coordinate, right: Coordinate) -> Coordinate {
    return Coordinate(column: left.column + right.column, row: left.row + right.row)
}

func ~= (left: Coordinate, right: Coordinate) -> Bool {
    return left == right
}
