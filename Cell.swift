//
//  Cell.swift
//  Mazes
//
//  Created by Ronald Mannak on 2/23/15.
//  Copyright (c) 2015 Ronald Mannak. All rights reserved.
//

import Foundation

class Cell {
    
    let coordinate: Coordinate
    private(set) var neighbors = [Accessor: Cell]()
    
    required init(coordinate: Coordinate) {
        
        self.coordinate = coordinate
    }
}

extension Cell: Linkable {

    typealias T = Cell
    
    func link(cell: Cell, bidirectional: Bool = true) {
        
        let direction: Accessor
        switch cell.coordinate - self.coordinate {
        case Coordinate(column: 0, row: -1):
            // North of self
            direction = .North
        case Coordinate(column: 0, row: 1):
            // South of self
            direction = .South
        case Coordinate(column: -1, row: 0):
            // West of self
            direction = .West
        case Coordinate(column: 1, row: 0):
            // East of self
            direction = .East
        default:
            fatalError("cell at \(cell.coordinate) is not adjecent to cell at \(cell.coordinate)")
        }
        
        if let previouslyLinkedCell = neighbors[direction] {
            unlink(direction, bidirectional: bidirectional)
        }
        neighbors[direction] = cell
        
        if bidirectional == true {
            cell.link(self, bidirectional: false)
        }
    }
    
    func unlink(accessor: Accessor, bidirectional: Bool = true) {

        if let cell = self.neighbors[accessor] {
            if bidirectional == true { cell.unlink(self, bidirectional: false) }
            self.neighbors.removeValueForKey(accessor)
        }
    }
    
    func unlink(cell: Cell, bidirectional: Bool = true) {
        
        for key in neighbors.keys {
            if let linkedCell = neighbors[key] where linkedCell == cell {
                if bidirectional == true {
                    linkedCell.unlink(self, bidirectional: false)
                }
                neighbors.removeValueForKey(key)
            }
        }
    }
}

extension Cell: Hashable {
    
    // TODO: 
    var hashValue: Int {
        
        return 1
    }
}

extension Cell: Printable {
    
    var description: String {
        
        var s = String()
        s += "Coordinate: \(coordinate)\nAccessors:\(neighbors)"
        return s
    }
}

extension Cell: Equatable {}

func == (left: Cell, right: Cell) -> Bool {
    
    return left.coordinate == right.coordinate
}
