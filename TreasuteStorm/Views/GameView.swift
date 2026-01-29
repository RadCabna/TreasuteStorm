import SwiftUI

enum CellType {
    case available
    case blocked
    case enemy
}

struct GameCell {
    let row: Int
    let col: Int
    var type: CellType
    var isVisited: Bool
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
    @ObservedObject private var nav: NavGuard = NavGuard.shared
    @State private var gameLevel: GameLevel
    @State private var showSettings: Bool = false
    @State private var gameState: GameState = .playing
    
    init(currentMenu: Binding<MenuState>) {
        self._currentMenu = currentMenu
        
        // Initialize Level 1
        // gameRectOff - доступные клетки, gameRect - барьеры
        var cells: [[GameCell]] = []
        for row in 0..<7 {
            var rowCells: [GameCell] = []
            for col in 0..<8 {
                // Row 3 (index 3), columns 1-6 are available (gameRectOff)
                // Other cells are blocked (gameRect - barriers)
                if row == 3 && col >= 1 && col <= 6 {
                    rowCells.append(GameCell(row: row, col: col, type: .available, isVisited: false))
                } else {
                    rowCells.append(GameCell(row: row, col: col, type: .blocked, isVisited: false))
                }
            }
            cells.append(rowCells)
        }
        
        // Start at first available cell (row 3, col 1)
        var level = GameLevel(
            levelNumber: 1,
            maxMoves: 30,
            cells: cells,
            playerPosition: (row: 3, col: 1),
            movesUsed: 0
        )
        
        // Mark starting cell as visited
        level.visitCell(row: 3, col: 1)
        
        self._gameLevel = State(initialValue: level)
    }
    
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
    }
    
    func restartLevel() {
        var cells: [[GameCell]] = []
        for row in 0..<7 {
            var rowCells: [GameCell] = []
            for col in 0..<8 {
                if row == 3 && col >= 1 && col <= 6 {
                    rowCells.append(GameCell(row: row, col: col, type: .available, isVisited: false))
                } else {
                    rowCells.append(GameCell(row: row, col: col, type: .blocked, isVisited: false))
                }
            }
            cells.append(rowCells)
        }
        
        var level = GameLevel(
            levelNumber: 1,
            maxMoves: 30,
            cells: cells,
            playerPosition: (row: 3, col: 1),
            movesUsed: 0
        )
        
        // Mark starting cell as visited
        level.visitCell(row: 3, col: 1)
        
        gameLevel = level
        gameState = .playing
        showSettings = false
    }
    
    func goToNextLevel() {
        // TODO: Load next level
        print("Going to next level...")
        // For now, just return to level selection
        withAnimation(.easeInOut(duration: 0.3)) {
            currentMenu = .levelSelection
        }
    }
    
    func handleSwipe(direction: SwipeDirection) {
        let path = calculatePath(from: gameLevel.playerPosition, direction: direction)
        
        if path.isEmpty {
            // No valid moves in this direction - DEFEAT
            gameState = .defeat
            return
        }
        
        // Animate movement through each cell in path
        animateMovement(through: path)
    }
    
    func animateMovement(through path: [(row: Int, col: Int)]) {
        guard !path.isEmpty else { return }
        
        var currentIndex = 0
        let stepDuration = 0.3
        
        func moveToNextCell() {
            guard currentIndex < path.count else {
                // Movement complete, increment moves
                gameLevel.movesUsed += 1
                
                // Check win/lose conditions
                if gameLevel.isAllVisited() {
                    gameState = .victory
                } else if gameLevel.movesUsed >= gameLevel.maxMoves {
                    gameState = .defeat
                }
                return
            }
            
            let nextPosition = path[currentIndex]
            
            withAnimation(.easeInOut(duration: stepDuration)) {
                gameLevel.playerPosition = nextPosition
                gameLevel.visitCell(row: nextPosition.row, col: nextPosition.col)
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
                if gameLevel.cells[nextRow][currentCol].type == .blocked {
                    break
                }
                currentRow = nextRow
                path.append((row: currentRow, col: currentCol))
            }
        case .down:
            while currentRow < 6 {
                let nextRow = currentRow + 1
                if gameLevel.cells[nextRow][currentCol].type == .blocked {
                    break
                }
                currentRow = nextRow
                path.append((row: currentRow, col: currentCol))
            }
        case .left:
            while currentCol > 0 {
                let nextCol = currentCol - 1
                if gameLevel.cells[currentRow][nextCol].type == .blocked {
                    break
                }
                currentCol = nextCol
                path.append((row: currentRow, col: currentCol))
            }
        case .right:
            while currentCol < 7 {
                let nextCol = currentCol + 1
                if gameLevel.cells[currentRow][nextCol].type == .blocked {
                    break
                }
                currentCol = nextCol
                path.append((row: currentRow, col: currentCol))
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
    
    var body: some View {
        ZStack {
            Color("gameColor_2")
                .frame(height: screenWidth * 0.08)
            
            HStack {
                Text("Moves: \(movesUsed)/\(maxMoves)")
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
    let onSwipe: (SwipeDirection) -> Void
    
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
                    VictoryView(movesUsed: gameLevel.movesUsed, maxMoves: gameLevel.maxMoves)
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
                                    
                                    Text("Level \(gameLevel.levelNumber)")
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
    
    var body: some View {
        VStack(spacing: screenWidth * 0.03) {
            Image("victoryImage")
                .resizable()
                .scaledToFit()
                .frame(width: screenWidth * 0.4 * 2 / 3)
            
            Text("Moves: \(movesUsed)/\(maxMoves)")
                .font(.custom("JosefinSans-Bold", size: screenWidth * 0.03))
                .foregroundColor(.black)
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
                                            Image("menuPers_1")
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
        
        var body: some View {
            GameScreen(currentMenu: $currentMenu)
        }
    }
}
