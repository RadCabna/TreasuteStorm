import SwiftUI

enum TaskStatus {
    case incomplete
    case completed
    case claimed
}

struct DailyTask {
    let id: Int
    let title: String
    var status: TaskStatus
}

// MARK: - Daily Tasks Content
struct DailyTaskContent: View {
    @Binding var currentMenu: MenuState
    @ObservedObject private var nav: NavGuard = NavGuard.shared
    @ObservedObject private var localization = LocalizationManager.shared
    @State private var tasks: [DailyTask] = []
    
    var body: some View {
        DailyTaskGrid(tasks: $tasks, nav: nav)
            .onAppear {
                updateTasks()
            }
            .onChange(of: localization.currentLanguage) { _ in
                updateTasks()
            }
    }
    
    func updateTasks() {
        tasks = [
            DailyTask(id: 1, title: localization.localized("Complete one level"), status: .completed),
            DailyTask(id: 2, title: localization.localized("Defeat 10 opponents"), status: .incomplete)
        ]
    }
}

struct DailyTaskGrid: View {
    @Binding var tasks: [DailyTask]
    var nav: NavGuard
    let rows = 7
    let columns = 8
    let cellWidth = UIScreen.main.bounds.width * 0.035
    let cellHeight = UIScreen.main.bounds.width * 0.04
    let cellSpacing = UIScreen.main.bounds.width * 0.001
    let rowSpacing = UIScreen.main.bounds.width * 0.005
    
    var body: some View {
        ZStack {
            // Background grid (all cells)
            VStack(spacing: rowSpacing) {
                ForEach(0..<rows, id: \.self) { row in
                    HStack(spacing: cellSpacing) {
                        ForEach(0..<columns, id: \.self) { column in
                            Image("gameRect")
                                .resizable()
                                .scaledToFit()
                                .frame(width: cellWidth, height: cellHeight)
                                .opacity(0.3)
                        }
                    }
                }
            }
            
            // Content overlay
            VStack(spacing: rowSpacing) {
                // Row 0 - Empty
                Color.clear.frame(height: cellHeight)
                
                // Row 1 - Task 1 title
                if tasks.count > 0 {
                    TaskTitleRow(title: tasks[0].title)
                } else {
                    Color.clear.frame(height: cellHeight)
                }
                
                // Row 2 - Task 1 reward buttons
                if tasks.count > 0 {
                    TaskRewardRow(taskIndex: 0, tasks: $tasks, nav: nav)
                } else {
                    Color.clear.frame(height: cellHeight)
                }
                
                // Row 3 - Empty
                Color.clear.frame(height: cellHeight)
                
                // Row 4 - Task 2 title
                if tasks.count > 1 {
                    TaskTitleRow(title: tasks[1].title)
                } else {
                    Color.clear.frame(height: cellHeight)
                }
                
                // Row 5 - Task 2 reward buttons
                if tasks.count > 1 {
                    TaskRewardRow(taskIndex: 1, tasks: $tasks, nav: nav)
                } else {
                    Color.clear.frame(height: cellHeight)
                }
                
                // Row 6 - Empty
                Color.clear.frame(height: cellHeight)
            }
        }
    }
}

struct TaskTitleRow: View {
    let title: String
    let cellWidth = UIScreen.main.bounds.width * 0.035
    let cellHeight = UIScreen.main.bounds.width * 0.04
    let cellSpacing = UIScreen.main.bounds.width * 0.001
    
    var body: some View {
        HStack {
            Text(title)
                .font(.custom("JosefinSans-Bold", size: screenWidth * 0.02))
                .foregroundColor(.black)
                .padding(.leading, screenWidth * 0.015)
            Spacer()
        }
        .frame(width: cellWidth * 8 + cellSpacing * 7, height: cellHeight)
    }
}

struct TaskRewardRow: View {
    let taskIndex: Int
    @Binding var tasks: [DailyTask]
    var nav: NavGuard
    let cellWidth = UIScreen.main.bounds.width * 0.035
    let cellHeight = UIScreen.main.bounds.width * 0.04
    let cellSpacing = UIScreen.main.bounds.width * 0.001
    
    var body: some View {
        HStack(spacing: cellSpacing) {
            // Empty space (5 cells)
            Color.clear
                .frame(width: cellWidth * 5 + cellSpacing * 4, height: cellHeight)
            
            // Reward button (last 3 cells width, 1.75x height)
            if taskIndex < tasks.count {
                if tasks[taskIndex].status == .completed {
                    Button(action: {
                        claimReward(taskIndex: taskIndex)
                    }) {
                        Image("task10")
                            .resizable()
                            .frame(width: cellWidth * 3 + cellSpacing * 2, height: cellHeight * 1.75)
                            .offset(y: screenWidth*0.005)
                    }
                } else if tasks[taskIndex].status == .incomplete {
                    Image("task10")
                        .resizable()
                        .frame(width: cellWidth * 3 + cellSpacing * 2, height: cellHeight * 1.75)
                        .opacity(0.5)
                        .offset(y: screenWidth*0.005)
                }
            }
        }
        .frame(width: cellWidth * 8 + cellSpacing * 7, height: cellHeight)
    }
    
    func claimReward(taskIndex: Int) {
        guard taskIndex < tasks.count else { return }
        nav.coins += 10
        nav.saveCoins()
        tasks[taskIndex].status = .claimed
    }
}
