import SwiftUI

enum CellType {
    case available
    case blocked
    case barrier
    case enemy
    case sticky
    case doubleStep
    case teleport1  // teleport1_1 (blue)
    case teleport2  // teleport1_2 (orange)
}

struct GameCell {
    let row: Int
    let col: Int
    var type: CellType
    var isVisited: Bool
    var teleportPairCoords: (row: Int, col: Int)?  // For teleport cells, stores paired teleport location
}

struct GameLevel {
    let levelNumber: Int
    let maxMoves: Int
    var cells: [[GameCell]]
    var playerPosition: (row: Int, col: Int)
    var movesUsed: Int
    
    mutating func visitCell(row: Int, col: Int) {
        cells[row][col].isVisited = true
    }
    
    func isAllVisited() -> Bool {
        for row in cells {
            for cell in row {
                if cell.type == .available && !cell.isVisited {
                    return false
                }
            }
        }
        return true
    }
    
    static func createLevel(number: Int) -> GameLevel {
        var cells: [[GameCell]] = []
        var startRow = 3
        var startCol = 1
        var maxMoves = 30
        
        if number == 1 {
            for row in 0..<7 {
                var rowCells: [GameCell] = []
                for col in 0..<8 {
                    if row == 3 && col >= 1 && col <= 6 {
                        rowCells.append(GameCell(row: row, col: col, type: .available, isVisited: false, teleportPairCoords: nil))
                    } else {
                        rowCells.append(GameCell(row: row, col: col, type: .blocked, isVisited: false, teleportPairCoords: nil))
                    }
                }
                cells.append(rowCells)
            }
            startRow = 3
            startCol = 1
            maxMoves = 1
        } else if number == 2 {
            for row in 0..<7 {
                var rowCells: [GameCell] = []
                for col in 0..<8 {
                    var cellType: CellType = .blocked
                    
                    if row == 0 || row == 6 {
                        cellType = .blocked
                    } else if row == 1 {
                        if col >= 1 && col <= 6 {
                            cellType = .available
                        }
                    } else if row == 2 {
                        if col == 1 || col == 6 {
                            cellType = .available
                        }
                    } else if row == 3 {
                        if col == 6 {
                            cellType = .available
                        } else if col == 1 {
                            cellType = .barrier
                        }
                    } else if row == 4 {
                        if col == 1 || col == 6 {
                            cellType = .available
                        }
                    } else if row == 5 {
                        if col >= 1 && col <= 6 {
                            cellType = .available
                        }
                    }
                    
                    rowCells.append(GameCell(row: row, col: col, type: cellType, isVisited: false, teleportPairCoords: nil))
                }
                cells.append(rowCells)
            }
            startRow = 2
            startCol = 1
            maxMoves = 5
        } else if number == 3 {
            for row in 0..<7 {
                var rowCells: [GameCell] = []
                for col in 0..<8 {
                    var cellType: CellType = .blocked
                    
                    if row == 0 || row == 6 {
                        cellType = .available
                    } else if row == 1 {
                        if col == 0 || col == 7 {
                            cellType = .available
                        }
                    } else if row == 2 {
                        if col == 0 || col == 7 {
                            cellType = .available
                        }
                    } else if row == 3 {
                        if col == 6 {
                            cellType = .available
                        } else if col == 0 {
                            cellType = .barrier
                        }
                    } else if row == 4 {
                        if col == 0 || col == 7 {
                            cellType = .available
                        }
                    } else if row == 5 {
                        if col == 0 || col == 7 {
                            cellType = .available
                        }
                    }
                    
                    if row == 3 && col == 7 {
                        cellType = .enemy
                    }
                    
                    rowCells.append(GameCell(row: row, col: col, type: cellType, isVisited: false, teleportPairCoords: nil))
                }
                cells.append(rowCells)
            }
            startRow = 2
            startCol = 0
            maxMoves = 8
        } else if number == 4 {
            for row in 0..<7 {
                var rowCells: [GameCell] = []
                for col in 0..<8 {
                    var cellType: CellType = .blocked
                    
                    if row == 1 {
                        if col >= 2 && col <= 5 {
                            cellType = .available
                        }
                    } else if row == 2 {
                        if col == 2 || col == 5 {
                            cellType = .available
                        }
                    } else if row == 3 {
                        if col == 2 || col >= 5 && col <= 7 {
                            cellType = .available
                        }
                    } else if row == 4 {
                        if col == 1 || col == 2 || col == 4 || col == 5 {
                            cellType = .available
                        }
                    } else if row == 5 {
                        if col == 2 {
                            cellType = .available
                        }
                    }
                    
                    if (row == 3 && col == 5) || (row == 4 && col == 2) {
                        cellType = .enemy
                    }
                    
                    rowCells.append(GameCell(row: row, col: col, type: cellType, isVisited: false, teleportPairCoords: nil))
                }
                cells.append(rowCells)
            }
            startRow = 1
            startCol = 3
            maxMoves = 12
        } else if number == 5 {
            for row in 0..<7 {
                var rowCells: [GameCell] = []
                for col in 0..<8 {
                    var cellType: CellType = .blocked
                    
                    if row == 1 {
                        if col >= 1 && col <= 6 {
                            cellType = .available
                        }
                    } else if row == 2 {
                        if col == 1 || col == 4 || col == 6 {
                            cellType = .available
                        }
                    } else if row == 3 {
                        if col == 1 || col == 6 {
                            cellType = .available
                        }
                    } else if row == 4 {
                        if col == 1 || col == 3 || col == 6 {
                            cellType = .available
                        }
                    } else if row == 5 {
                        if col >= 1 && col <= 6 {
                            cellType = .available
                        }
                    }
                    
                    if row == 1 && col == 3 {
                        cellType = .sticky
                    }
                    
                    if row == 5 && col == 5 {
                        cellType = .doubleStep
                    }
                    
                    if row == 5 && col == 3 {
                        cellType = .enemy
                    }
                    
                    rowCells.append(GameCell(row: row, col: col, type: cellType, isVisited: false, teleportPairCoords: nil))
                }
                cells.append(rowCells)
            }
            startRow = 1
            startCol = 1
            maxMoves = 12
        } else if number == 6 {
            for row in 0..<7 {
                var rowCells: [GameCell] = []
                for col in 0..<8 {
                    var cellType: CellType = .blocked
                    
                    if row == 1 {
                        if col == 2 || col == 3 {
                            cellType = .available
                        }
                    } else if row == 2 {
                        if col >= 2 && col <= 6 {
                            cellType = .available
                        }
                    } else if row == 3 {
                        if col == 1 || col == 2 || col == 4 {
                            cellType = .available
                        }
                    } else if row == 4 {
                        if col == 2 || col == 3 || col == 4 {
                            cellType = .available
                        }
                    } else if row == 5 {
                        if col == 3 {
                            cellType = .available
                        }
                    }
                    
                    if row == 2 && col == 4 {
                        cellType = .sticky
                    }
                    
                    if row == 4 && col == 3 {
                        cellType = .enemy
                    }
                    
                    rowCells.append(GameCell(row: row, col: col, type: cellType, isVisited: false, teleportPairCoords: nil))
                }
                cells.append(rowCells)
            }
            startRow = 3
            startCol = 1
            maxMoves = 12
        } else if number == 7 {
            for row in 0..<7 {
                var rowCells: [GameCell] = []
                for col in 0..<8 {
                    var cellType: CellType = .blocked
                    var teleportPair: (row: Int, col: Int)? = nil
                    
                    if row == 0 {
                        if col >= 1 && col <= 6 {
                            cellType = .available
                        }
                    } else if row == 1 {
                        if col == 1 || col == 6 {
                            cellType = .available
                        }
                    } else if row == 2 {
                        if col == 1 || col == 6 {
                            cellType = .available
                        }
                    } else if row == 3 {
                        if col >= 1 && col <= 6 {
                            cellType = .available
                        }
                    } else if row == 4 {
                        if col == 1 || col >= 3 && col <= 6 {
                            cellType = .available
                        }
                    } else if row == 5 {
                        if col == 1 || col == 6 {
                            cellType = .available
                        }
                    } else if row == 6 {
                        if col >= 1 && col <= 6 {
                            cellType = .available
                        }
                    }
                    
                    // Sticky cells
                    if (row == 0 && col == 5) || (row == 2 && col == 6) || (row == 3 && col == 4) || (row == 4 && col == 3) {
                        cellType = .sticky
                    }
                    
                    // Teleport pair 1 (blue) - teleport1_1
                    if (row == 3 && col == 3) {
                        cellType = .teleport1
                        teleportPair = (row: 6, col: 6)
                    }
                    if (row == 6 && col == 6) {
                        cellType = .teleport1
                        teleportPair = (row: 3, col: 3)
                    }
                    
                    // Teleport pair 2 (orange) - teleport1_2
                    if (row == 0 && col == 1) {
                        cellType = .teleport2
                        teleportPair = (row: 4, col: 4)
                    }
                    if (row == 4 && col == 4) {
                        cellType = .teleport2
                        teleportPair = (row: 0, col: 1)
                    }
                    
                    rowCells.append(GameCell(row: row, col: col, type: cellType, isVisited: false, teleportPairCoords: teleportPair))
                }
                cells.append(rowCells)
            }
            startRow = 0
            startCol = 3
            maxMoves = 12
        } else if number == 8 {
            for row in 0..<7 {
                var rowCells: [GameCell] = []
                for col in 0..<8 {
                    var cellType: CellType = .blocked
                    
                    if row == 1 {
                        if col >= 1 && col <= 6 {
                            cellType = .available
                        }
                    } else if row == 2 {
                        if col >= 2 && col <= 5 {
                            cellType = .available
                        }
                    } else if row == 3 {
                        if col >= 2 && col <= 5 {
                            cellType = .available
                        }
                    } else if row == 4 {
                        if col == 1 || col >= 2 && col <= 6 {
                            cellType = .available
                        }
                    }
                    
                    // Sticky cells
                    if (row == 1 && (col == 1 || col == 2 || col == 3 || col == 4)) ||
                       (row == 2 && (col == 3 || col == 5)) ||
                       (row == 3 && (col == 2 || col == 4 || col == 5)) ||
                       (row == 4 && (col == 3 || col == 4)) {
                        cellType = .sticky
                    }
                    
                    // Enemies
                    if (row == 1 && col == 5) ||
                       (row == 2 && (col == 2 || col == 4)) ||
                       (row == 3 && col == 3) ||
                       (row == 4 && (col == 2 || col == 5)) {
                        cellType = .enemy
                    }
                    
                    rowCells.append(GameCell(row: row, col: col, type: cellType, isVisited: false, teleportPairCoords: nil))
                }
                cells.append(rowCells)
            }
            startRow = 1
            startCol = 1
            maxMoves = 12
        } else if number == 9 {
            for row in 0..<7 {
                var rowCells: [GameCell] = []
                for col in 0..<8 {
                    var cellType: CellType = .blocked
                    
                    if row == 0 {
                        if col >= 1 && col <= 3 {
                            cellType = .available
                        }
                    } else if row == 1 {
                        if col == 1 || col == 3 {
                            cellType = .available
                        }
                    } else if row == 2 {
                        if col >= 1 && col <= 4 {
                            cellType = .available
                        }
                    } else if row == 3 {
                        if col == 1 || col >= 3 && col <= 6 {
                            cellType = .available
                        }
                    } else if row == 4 {
                        if col == 1 || col == 4 || col == 6 {
                            cellType = .available
                        }
                    } else if row == 5 {
                        if col >= 1 && col <= 6 {
                            cellType = .available
                        }
                    }
                    
                    // Sticky cells
                    if (row == 0 && col == 1) ||
                       (row == 2 && col == 4) ||
                       (row == 3 && (col == 3 || col == 5)) ||
                       (row == 4 && col == 4) {
                        cellType = .sticky
                    }
                    
                    // Enemies
                    if (row == 1 && col == 3) ||
                       (row == 2 && col == 2) ||
                       (row == 4 && col == 6) ||
                       (row == 5 && col == 6) {
                        cellType = .enemy
                    }
                    
                    rowCells.append(GameCell(row: row, col: col, type: cellType, isVisited: false, teleportPairCoords: nil))
                }
                cells.append(rowCells)
            }
            startRow = 0
            startCol = 1
            maxMoves = 12
        } else if number == 10 {
            for row in 0..<7 {
                var rowCells: [GameCell] = []
                for col in 0..<8 {
                    var cellType: CellType = .blocked
                    var teleportPair: (row: Int, col: Int)? = nil
                    
                    if row == 0 {
                        if col == 0 || col >= 2 && col <= 7 {
                            cellType = .available
                        }
                    } else if row == 1 {
                        if col == 0 || col == 2 || col == 7 {
                            cellType = .available
                        }
                    } else if row == 2 {
                        if col == 0 || col == 2 || col == 7 {
                            cellType = .available
                        }
                    } else if row == 3 {
                        if col == 0 || col >= 2 && col <= 7 {
                            cellType = .available
                        }
                    } else if row == 5 {
                        if col >= 1 && col <= 6 {
                            cellType = .available
                        }
                    }
                    
                    // Teleport pair (orange) - teleport1_2
                    if (row == 2 && col == 2) {
                        cellType = .teleport2
                        teleportPair = (row: 3, col: 0)
                    }
                    if (row == 3 && col == 0) {
                        cellType = .teleport2
                        teleportPair = (row: 2, col: 2)
                    }
                    
                    // Teleport pair (blue) - teleport1_1
                    if (row == 1 && col == 7) {
                        cellType = .teleport1
                        teleportPair = (row: 5, col: 6)
                    }
                    if (row == 5 && col == 6) {
                        cellType = .teleport1
                        teleportPair = (row: 1, col: 7)
                    }
                    
                    rowCells.append(GameCell(row: row, col: col, type: cellType, isVisited: false, teleportPairCoords: teleportPair))
                }
                cells.append(rowCells)
            }
            startRow = 0
            startCol = 0
            maxMoves = 12
        } else if number == 11 {
            // Level 11: Cross pattern with enemies and teleports
            for row in 0..<7 {
                var rowCells: [GameCell] = []
                for col in 0..<8 {
                    var cellType: CellType = .blocked
                    var teleportPair: (row: Int, col: Int)? = nil
                    
                    // Vertical line (col 3)
                    if col == 3 && row >= 0 && row <= 6 {
                        cellType = .available
                    }
                    // Horizontal line (row 3)
                    if row == 3 && col >= 0 && col <= 7 {
                        cellType = .available
                    }
                    
                    // Enemies at corners of cross
                    if (row == 0 && col == 3) || (row == 6 && col == 3) {
                        cellType = .enemy
                    }
                    
                    // Teleport pair 1 (blue)
                    if (row == 3 && col == 0) {
                        cellType = .teleport1
                        teleportPair = (row: 3, col: 7)
                    }
                    if (row == 3 && col == 7) {
                        cellType = .teleport1
                        teleportPair = (row: 3, col: 0)
                    }
                    
                    // Sticky cells
                    if (row == 1 && col == 3) || (row == 5 && col == 3) {
                        cellType = .sticky
                    }
                    
                    rowCells.append(GameCell(row: row, col: col, type: cellType, isVisited: false, teleportPairCoords: teleportPair))
                }
                cells.append(rowCells)
            }
            startRow = 3
            startCol = 3
            maxMoves = 12
        } else if number == 12 {
            // Level 12: Spiral pattern with sticky floors and double steps
            for row in 0..<7 {
                var rowCells: [GameCell] = []
                for col in 0..<8 {
                    var cellType: CellType = .blocked
                    
                    // Outer spiral
                    if row == 0 && col >= 1 && col <= 6 {
                        cellType = .available
                    } else if row >= 1 && row <= 5 && col == 6 {
                        cellType = .available
                    } else if row == 5 && col >= 1 && col <= 5 {
                        cellType = .available
                    } else if row >= 2 && row <= 4 && col == 1 {
                        cellType = .available
                    } else if row == 2 && col >= 2 && col <= 4 {
                        cellType = .available
                    } else if row >= 3 && row <= 4 && col == 4 {
                        cellType = .available
                    }
                    
                    // Sticky cells at turns
                    if (row == 0 && col == 6) || (row == 5 && col == 1) {
                        cellType = .sticky
                    }
                    
                    // Double step in middle
                    if (row == 2 && col == 4) || (row == 4 && col == 4) {
                        cellType = .doubleStep
                    }
                    
                    // Enemies
                    if (row == 3 && col == 1) || (row == 2 && col == 2) {
                        cellType = .enemy
                    }
                    
                    rowCells.append(GameCell(row: row, col: col, type: cellType, isVisited: false, teleportPairCoords: nil))
                }
                cells.append(rowCells)
            }
            startRow = 0
            startCol = 1
            maxMoves = 12
        } else if number == 13 {
            // Level 13: Diamond shape with multiple teleports
            for row in 0..<7 {
                var rowCells: [GameCell] = []
                for col in 0..<8 {
                    var cellType: CellType = .blocked
                    var teleportPair: (row: Int, col: Int)? = nil
                    
                    // Diamond pattern
                    if row == 0 && col == 3 {
                        cellType = .available
                    } else if row == 1 && (col >= 2 && col <= 4) {
                        cellType = .available
                    } else if row == 2 && (col >= 1 && col <= 5) {
                        cellType = .available
                    } else if row == 3 && (col >= 0 && col <= 6) {
                        cellType = .available
                    } else if row == 4 && (col >= 1 && col <= 5) {
                        cellType = .available
                    } else if row == 5 && (col >= 2 && col <= 4) {
                        cellType = .available
                    } else if row == 6 && col == 3 {
                        cellType = .available
                    }
                    
                    // Teleport pair 1 (blue)
                    if (row == 1 && col == 2) {
                        cellType = .teleport1
                        teleportPair = (row: 5, col: 4)
                    }
                    if (row == 5 && col == 4) {
                        cellType = .teleport1
                        teleportPair = (row: 1, col: 2)
                    }
                    
                    // Teleport pair 2 (orange)
                    if (row == 1 && col == 4) {
                        cellType = .teleport2
                        teleportPair = (row: 5, col: 2)
                    }
                    if (row == 5 && col == 2) {
                        cellType = .teleport2
                        teleportPair = (row: 1, col: 4)
                    }
                    
                    // Sticky cells
                    if (row == 2 && col == 3) || (row == 4 && col == 3) {
                        cellType = .sticky
                    }
                    
                    // Enemies
                    if (row == 3 && col == 0) || (row == 3 && col == 6) {
                        cellType = .enemy
                    }
                    
                    rowCells.append(GameCell(row: row, col: col, type: cellType, isVisited: false, teleportPairCoords: teleportPair))
                }
                cells.append(rowCells)
            }
            startRow = 0
            startCol = 3
            maxMoves = 12
        } else if number == 14 {
            // Level 14: Maze with all mechanics
            for row in 0..<7 {
                var rowCells: [GameCell] = []
                for col in 0..<8 {
                    var cellType: CellType = .blocked
                    var teleportPair: (row: Int, col: Int)? = nil
                    
                    // Complex maze pattern
                    if row == 0 && (col >= 0 && col <= 3) {
                        cellType = .available
                    } else if row == 1 && col == 3 {
                        cellType = .available
                    } else if row == 2 && (col >= 1 && col <= 7) {
                        cellType = .available
                    } else if row == 3 && (col == 1 || col == 5 || col == 7) {
                        cellType = .available
                    } else if row == 4 && (col >= 1 && col <= 5) {
                        cellType = .available
                    } else if row == 5 && (col == 1 || col == 5) {
                        cellType = .available
                    } else if row == 6 && (col >= 1 && col <= 5) {
                        cellType = .available
                    }
                    
                    // Barriers
                    if (row == 2 && col == 4) {
                        cellType = .barrier
                    }
                    
                    // Enemies
                    if (row == 2 && col == 7) || (row == 4 && col == 1) {
                        cellType = .enemy
                    }
                    
                    // Sticky cells
                    if (row == 0 && col == 3) || (row == 6 && col == 5) {
                        cellType = .sticky
                    }
                    
                    // Double steps
                    if (row == 2 && col == 2) || (row == 4 && col == 4) {
                        cellType = .doubleStep
                    }
                    
                    // Teleport pair (blue)
                    if (row == 3 && col == 5) {
                        cellType = .teleport1
                        teleportPair = (row: 5, col: 1)
                    }
                    if (row == 5 && col == 1) {
                        cellType = .teleport1
                        teleportPair = (row: 3, col: 5)
                    }
                    
                    rowCells.append(GameCell(row: row, col: col, type: cellType, isVisited: false, teleportPairCoords: teleportPair))
                }
                cells.append(rowCells)
            }
            startRow = 0
            startCol = 0
            maxMoves = 12
        } else if number == 15 {
            // Level 15: Final challenge - Complex grid with all mechanics
            for row in 0..<7 {
                var rowCells: [GameCell] = []
                for col in 0..<8 {
                    var cellType: CellType = .blocked
                    var teleportPair: (row: Int, col: Int)? = nil
                    
                    // Large complex path
                    if row == 0 && (col >= 0 && col <= 7) {
                        cellType = .available
                    } else if row == 1 && (col == 0 || col == 4 || col == 7) {
                        cellType = .available
                    } else if row == 2 && (col >= 0 && col <= 7) {
                        cellType = .available
                    } else if row == 3 && (col == 0 || col == 2 || col == 4 || col == 6) {
                        cellType = .available
                    } else if row == 4 && (col >= 0 && col <= 7) {
                        cellType = .available
                    } else if row == 5 && (col == 0 || col == 3 || col == 7) {
                        cellType = .available
                    } else if row == 6 && (col >= 0 && col <= 7) {
                        cellType = .available
                    }
                    
                    // Multiple barriers
                    if (row == 2 && col == 3) || (row == 4 && col == 5) {
                        cellType = .barrier
                    }
                    
                    // Multiple enemies
                    if (row == 1 && col == 0) || (row == 3 && col == 6) || (row == 5 && col == 7) {
                        cellType = .enemy
                    }
                    
                    // Sticky cells
                    if (row == 0 && col == 3) || (row == 2 && col == 6) || (row == 6 && col == 2) {
                        cellType = .sticky
                    }
                    
                    // Double steps
                    if (row == 2 && col == 1) || (row == 4 && col == 7) {
                        cellType = .doubleStep
                    }
                    
                    // Teleport pair 1 (blue)
                    if (row == 1 && col == 4) {
                        cellType = .teleport1
                        teleportPair = (row: 5, col: 3)
                    }
                    if (row == 5 && col == 3) {
                        cellType = .teleport1
                        teleportPair = (row: 1, col: 4)
                    }
                    
                    // Teleport pair 2 (orange)
                    if (row == 3 && col == 0) {
                        cellType = .teleport2
                        teleportPair = (row: 3, col: 4)
                    }
                    if (row == 3 && col == 4) {
                        cellType = .teleport2
                        teleportPair = (row: 3, col: 0)
                    }
                    
                    rowCells.append(GameCell(row: row, col: col, type: cellType, isVisited: false, teleportPairCoords: teleportPair))
                }
                cells.append(rowCells)
            }
            startRow = 0
            startCol = 0
            maxMoves = 12
        } else {
            // Default level (same as level 1)
            for row in 0..<7 {
                var rowCells: [GameCell] = []
                for col in 0..<8 {
                    if row == 3 && col >= 1 && col <= 6 {
                        rowCells.append(GameCell(row: row, col: col, type: .available, isVisited: false, teleportPairCoords: nil))
                    } else {
                        rowCells.append(GameCell(row: row, col: col, type: .blocked, isVisited: false, teleportPairCoords: nil))
                    }
                }
                cells.append(rowCells)
            }
            startRow = 3
            startCol = 1
            maxMoves = 12
        }
        
        var level = GameLevel(
            levelNumber: number,
            maxMoves: maxMoves,
            cells: cells,
            playerPosition: (row: startRow, col: startCol),
            movesUsed: 0
        )
        
        level.visitCell(row: startRow, col: startCol)
        
        return level
    }
}

enum SwipeDirection {
    case up, down, left, right
}

enum GameState {
    case playing
    case victory
    case defeat
}

// MARK: - Game Screen
struct GameScreen: View {
    @Binding var currentMenu: MenuState
    @Binding var selectedLevel: Int
    @ObservedObject private var nav: NavGuard = NavGuard.shared
    @State private var gameLevel: GameLevel = GameLevel.createLevel(number: 1)
    @State private var showSettings: Bool = false
    @State private var gameState: GameState = .playing
    @State private var currentLevelNumber: Int = 1
    @State private var isFirstCompletion: Bool = false
    @State private var isMoving: Bool = false
    
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
            
            GameTopBar(
                movesUsed: gameLevel.movesUsed,
                maxMoves: gameLevel.maxMoves,
                onSettings: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        showSettings = true
                    }
                },
                onRestart: { restartLevel() },
                onHome: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        currentMenu = .game
                    }
                }
            )
            .ignoresSafeArea()
            .frame(maxHeight: .infinity, alignment: .top)
            
            GameFieldView(
                gameLevel: $gameLevel, 
                showSettings: $showSettings, 
                gameState: $gameState,
                isFirstCompletion: isFirstCompletion,
                onSwipe: handleSwipe
            )
            .offset(y: screenWidth * 0.01)
            
            // Arrow back button for settings in game
            if showSettings {
                HStack {
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            showSettings = false
                        }
                    }) {
                        Image("arrowBack")
                            .resizable()
                            .scaledToFit()
                            .frame(width: screenWidth * 0.04)
                    }
                    .offset(x: screenWidth * 0.155, y: screenWidth * 0.195)
                    
                    Spacer()
                }
            }
            
            // Next level button for victory (positioned separately)
            if gameState == .victory && !showSettings {
                Button(action: {
                    goToNextLevel()
                }) {
                    Image("arrowBack")
                        .resizable()
                        .scaledToFit()
                        .frame(width: screenWidth * 0.04)
                        .scaleEffect(x: -1, y: 1)
                }
                .offset(x: screenWidth * 0.25, y: screenWidth * 0.19)
            }
        }
        .onChange(of: selectedLevel) { newLevel in
            if newLevel != currentLevelNumber {
                gameLevel = GameLevel.createLevel(number: newLevel)
                currentLevelNumber = newLevel
                gameState = .playing
                showSettings = false
                isFirstCompletion = false
            }
        }
        .onAppear {
            if currentLevelNumber != selectedLevel {
                gameLevel = GameLevel.createLevel(number: selectedLevel)
                currentLevelNumber = selectedLevel
                isFirstCompletion = false
                isMoving = false
            }
        }
    }
    
    func restartLevel() {
        // Restart current level using the level number from current game level
        let currentLevelNumber = gameLevel.levelNumber
        gameLevel = GameLevel.createLevel(number: currentLevelNumber)
        gameState = .playing
        showSettings = false
        isFirstCompletion = false
        isMoving = false
    }
    
    func goToNextLevel() {
        let nextLevelNumber = gameLevel.levelNumber + 1
        
        // Check if next level exists (currently we have levels 1-15)
        if nextLevelNumber <= 15 {
            // Load next level
            selectedLevel = nextLevelNumber
            let nextLevel = GameLevel.createLevel(number: nextLevelNumber)
            gameLevel = nextLevel
            gameState = .playing
            showSettings = false
            isFirstCompletion = false
            isMoving = false
        } else {
            // No more levels, return to level selection
            withAnimation(.easeInOut(duration: 0.3)) {
                currentMenu = .levelSelection
            }
        }
    }
    
    func handleSwipe(direction: SwipeDirection) {
        // Prevent swipes during movement
        if isMoving {
            return
        }
        
        let path = calculatePath(from: gameLevel.playerPosition, direction: direction)
        
        if path.isEmpty {
            // No valid moves in this direction - DEFEAT
            gameState = .defeat
            return
        }
        
        // Block swipes during movement
        isMoving = true
        
        // Animate movement through each cell in path
        animateMovement(through: path, direction: direction)
    }
    
    func animateMovement(through path: [(row: Int, col: Int)], direction: SwipeDirection) {
        guard !path.isEmpty else { return }
        
        var currentIndex = 0
        let stepDuration = 0.3
        var hasDoubleStep = false
        var stickyPosition: (row: Int, col: Int)? = nil
        
        func moveToNextCell() {
            guard currentIndex < path.count else {
                // Movement complete
                
                // Check if sticky couldn't throw player further
                if let stickyPos = stickyPosition {
                    var canThrow = false
                    
                    switch direction {
                    case .up:
                        if stickyPos.row > 0 {
                            let nextCell = gameLevel.cells[stickyPos.row - 1][stickyPos.col]
                            canThrow = nextCell.type != .blocked && nextCell.type != .barrier
                        }
                    case .down:
                        if stickyPos.row < 6 {
                            let nextCell = gameLevel.cells[stickyPos.row + 1][stickyPos.col]
                            canThrow = nextCell.type != .blocked && nextCell.type != .barrier
                        }
                    case .left:
                        if stickyPos.col > 0 {
                            let nextCell = gameLevel.cells[stickyPos.row][stickyPos.col - 1]
                            canThrow = nextCell.type != .blocked && nextCell.type != .barrier
                        }
                    case .right:
                        if stickyPos.col < 7 {
                            let nextCell = gameLevel.cells[stickyPos.row][stickyPos.col + 1]
                            canThrow = nextCell.type != .blocked && nextCell.type != .barrier
                        }
                    }
                    
                    if !canThrow {
                        // Sticky cannot throw player - DEFEAT
                        gameState = .defeat
                        // Unlock swipes after 0.5 seconds
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            isMoving = false
                        }
                        return
                    }
                }
                
                // Increment moves
                gameLevel.movesUsed += hasDoubleStep ? 2 : 1
                
                // Check win/lose conditions
                if gameLevel.isAllVisited() {
                    isFirstCompletion = nav.completeLevel(gameLevel.levelNumber)
                    gameState = .victory
                } else if gameLevel.movesUsed >= gameLevel.maxMoves {
                    gameState = .defeat
                }
                
                // Unlock swipes after 0.5 seconds
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    isMoving = false
                }
                return
            }
            
            let nextPosition = path[currentIndex]
            let cellType = gameLevel.cells[nextPosition.row][nextPosition.col].type
            
            withAnimation(.easeInOut(duration: stepDuration)) {
                gameLevel.playerPosition = nextPosition
                gameLevel.visitCell(row: nextPosition.row, col: nextPosition.col)
                
                // If enemy, destroy it (change to available)
                if cellType == .enemy {
                    gameLevel.cells[nextPosition.row][nextPosition.col].type = .available
                }
                
                // If sticky, destroy it and save position for check
                if cellType == .sticky {
                    gameLevel.cells[nextPosition.row][nextPosition.col].type = .available
                    stickyPosition = nextPosition
                }
                
                // Check for doubleStep
                if cellType == .doubleStep {
                    hasDoubleStep = true
                }
            }
            
            currentIndex += 1
            
            DispatchQueue.main.asyncAfter(deadline: .now() + stepDuration) {
                moveToNextCell()
            }
        }
        
        moveToNextCell()
    }
    
    func calculatePath(from position: (row: Int, col: Int), direction: SwipeDirection) -> [(row: Int, col: Int)] {
        var path: [(row: Int, col: Int)] = []
        var currentRow = position.row
        var currentCol = position.col
        
        switch direction {
        case .up:
            while currentRow > 0 {
                let nextRow = currentRow - 1
                let nextCell = gameLevel.cells[nextRow][currentCol]
                if nextCell.type == .blocked || nextCell.type == .barrier {
                    break
                }
                currentRow = nextRow
                path.append((row: currentRow, col: currentCol))
                
                // Check for teleport
                if nextCell.type == .teleport1 || nextCell.type == .teleport2 {
                    if let pairCoords = gameLevel.cells[currentRow][currentCol].teleportPairCoords {
                        currentRow = pairCoords.row
                        currentCol = pairCoords.col
                        path.append((row: currentRow, col: currentCol))
                        // Continue moving in same direction after teleport
                        continue
                    }
                }
                
                if nextCell.type == .sticky {
                    // Sticky must throw player to next cell
                    if currentRow > 0 {
                        let afterStickyRow = currentRow - 1
                        let afterStickyCell = gameLevel.cells[afterStickyRow][currentCol]
                        if afterStickyCell.type != .blocked && afterStickyCell.type != .barrier {
                            // Valid next cell after sticky
                            currentRow = afterStickyRow
                            path.append((row: currentRow, col: currentCol))
                            
                            // Check if landed on teleport after sticky
                            if afterStickyCell.type == .teleport1 || afterStickyCell.type == .teleport2 {
                                if let pairCoords = gameLevel.cells[currentRow][currentCol].teleportPairCoords {
                                    currentRow = pairCoords.row
                                    currentCol = pairCoords.col
                                    path.append((row: currentRow, col: currentCol))
                                    // Continue moving after teleport
                                    continue
                                }
                            }
                            
                            // Check if landed on another sticky
                            if afterStickyCell.type == .sticky {
                                // Will be processed in next iteration
                                continue
                            }
                            
                            // Check if landed on enemy/doubleStep - stop here
                            if afterStickyCell.type == .enemy || afterStickyCell.type == .doubleStep {
                                break
                            }
                        }
                        // If blocked, path ends at sticky (will be checked in animateMovement)
                    }
                    // If at boundary, path ends at sticky (will be checked in animateMovement)
                    break
                }
                
                if nextCell.type == .enemy || nextCell.type == .doubleStep {
                    break
                }
            }
        case .down:
            while currentRow < 6 {
                let nextRow = currentRow + 1
                let nextCell = gameLevel.cells[nextRow][currentCol]
                if nextCell.type == .blocked || nextCell.type == .barrier {
                    break
                }
                currentRow = nextRow
                path.append((row: currentRow, col: currentCol))
                
                // Check for teleport
                if nextCell.type == .teleport1 || nextCell.type == .teleport2 {
                    if let pairCoords = gameLevel.cells[currentRow][currentCol].teleportPairCoords {
                        currentRow = pairCoords.row
                        currentCol = pairCoords.col
                        path.append((row: currentRow, col: currentCol))
                        // Continue moving in same direction after teleport
                        continue
                    }
                }
                
                if nextCell.type == .sticky {
                    // Sticky must throw player to next cell
                    if currentRow < 6 {
                        let afterStickyRow = currentRow + 1
                        let afterStickyCell = gameLevel.cells[afterStickyRow][currentCol]
                        if afterStickyCell.type != .blocked && afterStickyCell.type != .barrier {
                            // Valid next cell after sticky
                            currentRow = afterStickyRow
                            path.append((row: currentRow, col: currentCol))
                            
                            // Check if landed on teleport after sticky
                            if afterStickyCell.type == .teleport1 || afterStickyCell.type == .teleport2 {
                                if let pairCoords = gameLevel.cells[currentRow][currentCol].teleportPairCoords {
                                    currentRow = pairCoords.row
                                    currentCol = pairCoords.col
                                    path.append((row: currentRow, col: currentCol))
                                    // Continue moving after teleport
                                    continue
                                }
                            }
                            
                            // Check if landed on another sticky
                            if afterStickyCell.type == .sticky {
                                // Will be processed in next iteration
                                continue
                            }
                            
                            // Check if landed on enemy/doubleStep - stop here
                            if afterStickyCell.type == .enemy || afterStickyCell.type == .doubleStep {
                                break
                            }
                        }
                        // If blocked, path ends at sticky (will be checked in animateMovement)
                    }
                    // If at boundary, path ends at sticky (will be checked in animateMovement)
                    break
                }
                
                if nextCell.type == .enemy || nextCell.type == .doubleStep {
                    break
                }
            }
        case .left:
            while currentCol > 0 {
                let nextCol = currentCol - 1
                let nextCell = gameLevel.cells[currentRow][nextCol]
                if nextCell.type == .blocked || nextCell.type == .barrier {
                    break
                }
                currentCol = nextCol
                path.append((row: currentRow, col: currentCol))
                
                // Check for teleport
                if nextCell.type == .teleport1 || nextCell.type == .teleport2 {
                    if let pairCoords = gameLevel.cells[currentRow][currentCol].teleportPairCoords {
                        currentRow = pairCoords.row
                        currentCol = pairCoords.col
                        path.append((row: currentRow, col: currentCol))
                        // Continue moving in same direction after teleport
                        continue
                    }
                }
                
                if nextCell.type == .sticky {
                    // Sticky must throw player to next cell
                    if currentCol > 0 {
                        let afterStickyCol = currentCol - 1
                        let afterStickyCell = gameLevel.cells[currentRow][afterStickyCol]
                        if afterStickyCell.type != .blocked && afterStickyCell.type != .barrier {
                            // Valid next cell after sticky
                            currentCol = afterStickyCol
                            path.append((row: currentRow, col: currentCol))
                            
                            // Check if landed on teleport after sticky
                            if afterStickyCell.type == .teleport1 || afterStickyCell.type == .teleport2 {
                                if let pairCoords = gameLevel.cells[currentRow][currentCol].teleportPairCoords {
                                    currentRow = pairCoords.row
                                    currentCol = pairCoords.col
                                    path.append((row: currentRow, col: currentCol))
                                    // Continue moving after teleport
                                    continue
                                }
                            }
                            
                            // Check if landed on another sticky
                            if afterStickyCell.type == .sticky {
                                // Will be processed in next iteration
                                continue
                            }
                            
                            // Check if landed on enemy/doubleStep - stop here
                            if afterStickyCell.type == .enemy || afterStickyCell.type == .doubleStep {
                                break
                            }
                        }
                        // If blocked, path ends at sticky (will be checked in animateMovement)
                    }
                    // If at boundary, path ends at sticky (will be checked in animateMovement)
                    break
                }
                
                if nextCell.type == .enemy || nextCell.type == .doubleStep {
                    break
                }
            }
        case .right:
            while currentCol < 7 {
                let nextCol = currentCol + 1
                let nextCell = gameLevel.cells[currentRow][nextCol]
                if nextCell.type == .blocked || nextCell.type == .barrier {
                    break
                }
                currentCol = nextCol
                path.append((row: currentRow, col: currentCol))
                
                // Check for teleport
                if nextCell.type == .teleport1 || nextCell.type == .teleport2 {
                    if let pairCoords = gameLevel.cells[currentRow][currentCol].teleportPairCoords {
                        currentRow = pairCoords.row
                        currentCol = pairCoords.col
                        path.append((row: currentRow, col: currentCol))
                        // Continue moving in same direction after teleport
                        continue
                    }
                }
                
                if nextCell.type == .sticky {
                    // Sticky must throw player to next cell
                    if currentCol < 7 {
                        let afterStickyCol = currentCol + 1
                        let afterStickyCell = gameLevel.cells[currentRow][afterStickyCol]
                        if afterStickyCell.type != .blocked && afterStickyCell.type != .barrier {
                            // Valid next cell after sticky
                            currentCol = afterStickyCol
                            path.append((row: currentRow, col: currentCol))
                            
                            // Check if landed on teleport after sticky
                            if afterStickyCell.type == .teleport1 || afterStickyCell.type == .teleport2 {
                                if let pairCoords = gameLevel.cells[currentRow][currentCol].teleportPairCoords {
                                    currentRow = pairCoords.row
                                    currentCol = pairCoords.col
                                    path.append((row: currentRow, col: currentCol))
                                    // Continue moving after teleport
                                    continue
                                }
                            }
                            
                            // Check if landed on another sticky
                            if afterStickyCell.type == .sticky {
                                // Will be processed in next iteration
                                continue
                            }
                            
                            // Check if landed on enemy/doubleStep - stop here
                            if afterStickyCell.type == .enemy || afterStickyCell.type == .doubleStep {
                                break
                            }
                        }
                        // If blocked, path ends at sticky (will be checked in animateMovement)
                    }
                    // If at boundary, path ends at sticky (will be checked in animateMovement)
                    break
                }
                
                if nextCell.type == .enemy || nextCell.type == .doubleStep {
                    break
                }
            }
        }
        
        return path
    }
}

struct GameTopBar: View {
    let movesUsed: Int
    let maxMoves: Int
    let onSettings: () -> Void
    let onRestart: () -> Void
    let onHome: () -> Void
    @ObservedObject private var localization = LocalizationManager.shared
    
    var body: some View {
        ZStack {
            Color("gameColor_2")
                .frame(height: screenWidth * 0.08)
            
            HStack {
                Text("\(localization.localized("Moves")): \(movesUsed)/\(maxMoves)")
                    .font(.custom("JosefinSans-Bold", size: screenWidth * 0.03))
                    .foregroundColor(.white)
                    .padding(.leading, screenWidth * 0.03)
                
                Spacer()
                
                HStack(spacing: screenWidth * 0.01) {
                    Button(action: onSettings) {
                        Image("settingsGameButton")
                            .resizable()
                            .scaledToFit()
                            .frame(width: screenWidth * 0.04)
                    }
                    
                    Button(action: onRestart) {
                        Image("restartButton")
                            .resizable()
                            .scaledToFit()
                            .frame(width: screenWidth * 0.04)
                    }
                    
                    Button(action: onHome) {
                        Image("homeButton")
                            .resizable()
                            .scaledToFit()
                            .frame(width: screenWidth * 0.04)
                    }
                }
                .padding(.trailing, screenWidth * 0.03)
            }
            .offset(y: screenWidth * 0.01)
        }
    }
}

struct GameFieldView: View {
    @Binding var gameLevel: GameLevel
    @Binding var showSettings: Bool
    @Binding var gameState: GameState
    let isFirstCompletion: Bool
    let onSwipe: (SwipeDirection) -> Void
    @ObservedObject private var localization = LocalizationManager.shared
    
    var body: some View {
        ZStack {
                RoundedRectangle(cornerRadius: screenWidth * 0.015)
                    .fill(Color.white.opacity(0.95))
                    .frame(width: screenWidth * 0.4, height: screenWidth * 0.4)
                    .shadow(color: Color("bgColor_2"), radius: screenWidth * 0.02, x: 0, y: 0)
                
                if showSettings {
                    // Show settings inside game
                    VStack(spacing: screenWidth * 0.0) {
                        VStack(spacing: screenWidth*0.005) {
                            // Empty space for menu icons area
                            Color.clear
                                .frame(height: screenWidth * 0.04)
                            
                            Rectangle()
                                .fill(Color("gameColor_1"))
                                .frame(width: screenWidth * 0.4, height: screenWidth*0.006)
                        }
                        .offset(y: -screenWidth*0.015)
                        
                        SettingsContent(currentMenu: .constant(.playing))
                            .transition(.opacity)
                    }
                } else if gameState == .victory {
                    // Victory screen
                    VictoryView(movesUsed: gameLevel.movesUsed, maxMoves: gameLevel.maxMoves, isFirstCompletion: isFirstCompletion)
                } else if gameState == .defeat {
                    // Defeat screen
                    DefeatView()
                } else {
                    // Show game field
                        VStack(spacing: screenWidth * 0.0) {
                            HStack {
                                
                                ZStack {
                                    RoundedRectangle(cornerRadius: screenWidth * 0.005)
                                        .fill(Color("activeCellColor"))
                                        .frame(width: screenWidth * 0.12, height: screenWidth * 0.035)
                                    
                                    Text("\(localization.localized("Level")) \(gameLevel.levelNumber)")
                                        .font(.custom("JosefinSans-Bold", size: screenWidth * 0.018))
                                        .foregroundColor(.white)
                                }
                                .offset(x: screenWidth * 0.12, y: -screenWidth * 0.005)
                            }
                            
                            Rectangle()
                                .fill(Color("gameColor_1"))
                                .frame(width: screenWidth * 0.4, height: screenWidth * 0.006)
                            
                            GameGrid(gameLevel: $gameLevel)
                                .offset(y: screenWidth*0.005)
                                .padding(screenWidth*0.01)
                        }
                        .gesture(
                            DragGesture(minimumDistance: 20)
                                .onEnded { value in
                                    let horizontalAmount = value.translation.width
                                    let verticalAmount = value.translation.height
                                    
                                    if abs(horizontalAmount) > abs(verticalAmount) {
                                        if horizontalAmount > 0 {
                                            onSwipe(.right)
                                        } else {
                                            onSwipe(.left)
                                        }
                                    } else {
                                        if verticalAmount > 0 {
                                            onSwipe(.down)
                                        } else {
                                            onSwipe(.up)
                                        }
                                    }
                                }
                        )
                }
            }
        }
    }

struct VictoryView: View {
    let movesUsed: Int
    let maxMoves: Int
    let isFirstCompletion: Bool
    @ObservedObject private var localization = LocalizationManager.shared
    
    var body: some View {
        VStack(spacing: screenWidth * 0.03) {
            Image("victoryImage")
                .resizable()
                .scaledToFit()
                .frame(width: screenWidth * 0.4 * 2 / 3)
            
            Text("\(localization.localized("Moves")): \(movesUsed)/\(maxMoves)")
                .font(.custom("JosefinSans-Bold", size: screenWidth * 0.03))
                .foregroundColor(.black)
            
            if isFirstCompletion {
                ZStack(alignment: .leading) {
                    Image("countFrame")
                        .resizable()
                        .scaledToFit()
                        .frame(height: screenWidth * 0.06)
                    
                    Text("+50")
                        .font(.custom("JosefinSans-Bold", size: screenWidth * 0.03))
                        .foregroundColor(.white)
                        .offset(x: screenWidth * 0.01)
                }
            }
        }
    }
}

struct DefeatView: View {
    var body: some View {
        Image("defeatImage")
            .resizable()
            .scaledToFit()
            .frame(width: screenWidth * 0.4 * 2 / 3)
    }
}

struct GameGrid: View {
            @Binding var gameLevel: GameLevel
            @ObservedObject private var nav: NavGuard = NavGuard.shared
            let rows = 7
            let columns = 8
            let cellWidth = UIScreen.main.bounds.width * 0.035
            let cellHeight = UIScreen.main.bounds.width * 0.04
            let cellSpacing = UIScreen.main.bounds.width * 0.001
            let rowSpacing = UIScreen.main.bounds.width * 0.005
            
            var body: some View {
                ZStack {
                    VStack(spacing: rowSpacing) {
                        ForEach(0..<rows, id: \.self) { row in
                            HStack(spacing: cellSpacing) {
                                ForEach(0..<columns, id: \.self) { col in
                                    ZStack {
                                        if gameLevel.cells[row][col].type == .available {
                                            Image("gameRectOff")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: cellWidth, height: cellHeight)
                                        } else if gameLevel.cells[row][col].type == .barrier {
                                            Image("gameRectOff")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: cellWidth, height: cellHeight)
                                            
                                            Image("barier")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: cellWidth, height: cellHeight)
                                        } else if gameLevel.cells[row][col].type == .enemy {
                                            Image("gameRectOff")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: cellWidth, height: cellHeight)
                                            
                                            Image(nav.getEnemyImage())
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: cellWidth, height: cellHeight)
                                        } else if gameLevel.cells[row][col].type == .sticky {
                                            Image("gameRectOff")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: cellWidth, height: cellHeight)
                                            
                                            Image(nav.getStickyImage())
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: cellWidth, height: cellHeight)
                                        } else if gameLevel.cells[row][col].type == .doubleStep {
                                            Image("gameRectOff")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: cellWidth, height: cellHeight)
                                            
                                            Image("dubleStep")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: cellWidth, height: cellHeight)
                                                .opacity(0.5)
                                        } else if gameLevel.cells[row][col].type == .teleport1 {
                                            Image("gameRectOff")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: cellWidth, height: cellHeight)
                                            
                                            Image(nav.getTeleportImage(color: 1))
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: cellWidth, height: cellHeight)
                                        } else if gameLevel.cells[row][col].type == .teleport2 {
                                            Image("gameRectOff")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: cellWidth, height: cellHeight)
                                            
                                            Image(nav.getTeleportImage(color: 2))
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: cellWidth, height: cellHeight)
                                        } else {
                                            Image("gameRect")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: cellWidth, height: cellHeight)
                                        }
                                        
                                        if gameLevel.cells[row][col].isVisited {
                                            Color("activeCellColor")
                                                .frame(width: cellWidth, height: cellHeight)
                                                .opacity(0.5)
                                        }
                                        
                                        if gameLevel.playerPosition.row == row && gameLevel.playerPosition.col == col {
                                            Image(nav.getPlayerImage())
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: cellWidth * 0.6)
                                                .offset(y: -cellHeight * 0.1)
                                        }
                                    }
                                }
                            }
                        }
                    }
            }
        }
    }


struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameScreenWrapper()
    }
    
    struct GameScreenWrapper: View {
        @State private var currentMenu: MenuState = .playing
        @State private var selectedLevel: Int = 1
        
        var body: some View {
            GameScreen(currentMenu: $currentMenu, selectedLevel: $selectedLevel)
        }
    }
}
