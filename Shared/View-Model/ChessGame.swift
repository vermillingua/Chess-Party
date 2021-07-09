//
//  ChessGame.swift
//  Chess Party
//
//  Created by Robert Swanson on 1/9/21.
//

import SwiftUI

struct RenderablePiece: Identifiable {
    let piece: Piece
    var id: Int { piece.id }
    var position: Position
}

class ChessGame: ObservableObject, CustomStringConvertible, Identifiable, Codable {
    // MARK: - Board Identity
    let gameType: ChessGameType
    private(set) var id: UUID
    private(set) var players: [Player]
    private(set) var history: [ChessBoard]
    private(set) var playersInCheck: Set<PlayerID>
    
    @Published private(set) var chessBoard: ChessBoard
    @Published  var gameState: GameState
    @EnvironmentObject var settings: AppSettings
    let animationDuration = 0.1
    
    @Published var pieceShowingPromotionView: Int? = nil
    @Published var promotionPieceTypes: [PieceType] = []
    var potentialPromotionFromPosition: Position? = nil
    var potentialPromotionDestination: Position? = nil

    var currentPlayer: Player? {
        if let id = gameState.getCurrentPlayer() {
            return playerWithID(id: id)
        } else {
            return nil
        }
    }
    var nextPlayer: Player? {
        if let nextPlayerIndex = currentPlayer?.nextPlayer.index {
            return players[nextPlayerIndex]
        } else { return nil }
    }
    var playersStillInGame: [PlayerID] {
        var identities: [PlayerID] = []
        players.filter { !$0.hasBeenEliminated }
            .forEach { player in identities.append(player.identity)}
        return identities
    }
    func playersInTeam(_ team: TeamID) -> [Player] {
        players.filter({player in player.team == team})
    }
    func playerWithID(id: PlayerID) -> Player? {
        return players.filter(){player in player.identity == id}.first
    }

    var renderedChessPieces: [RenderablePiece] {
        var pieces = [RenderablePiece]()
        chessBoard.board.keys.forEach { position in
            pieces.append(RenderablePiece(piece: chessBoard.board[position]!, position: position))
        }
        return pieces
    }
    
    init(type: ChessGameType, playerBuilders: [PlayerBuilder], id: UUID = UUID()) {
        self.id = id
        history = []
        potentialMoveDestinations = []
        warningPositions = []
        lastMoves = []
        playersInCheck = Set<PlayerID>()
        gameType = type
        gameState = .paused
        
        switch type.associatedBoardType {
        case .ChessBoard1v1:
            chessBoard = ChessBoard1v1()
        case .ChessBoard2v2:
            chessBoard = ChessBoard2v2()
        case .ChessBoard1v1v1v1:
            chessBoard = ChessBoard1v1v1v1()
        }
        
        // Initialize Players
        players = []
        let playerCount = playerBuilders.count
        var i = 0

        for builder in playerBuilders {
            assert(builder.team == gameType.expectedTeamIDs[i], "Incorrect team ID's for game type \(gameType) for game: \(self)")
            i+=1

            let nextPlayer = (players.count == playerCount-1) ? 0 : players.count+1
            let previousPlayer = players.isEmpty ? playerCount-1 : players.count-1
            let responseHandler: PlayerResponseHandler = {move in self.handleMove(move)}
            players.append(builder.buildPlayer(atIndex: players.count, previousPlayer: previousPlayer, nextPlayerIndex: nextPlayer, withResponseHandler: responseHandler))
        }
        
        // Set game state and start game
        self.players.first!.startMove(withBoard: chessBoard)
        gameState = .waitingOnPlayer(player: self.players.first!.identity)
    }
    
    enum ChessGameCodingKeys: String, CodingKey {
        case gameType
        case id
        case players
        case history
        case playersInCheck
        case chessBoard
        case gameState
        case settings
        case lastMoves
        case warningPositions
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ChessGameCodingKeys.self)
        
        gameType = try container.decode(ChessGameType.self, forKey: .gameType)
        id = try container.decode(UUID.self, forKey: .id)
        
        var historyContainer = try container.nestedUnkeyedContainer(forKey: .history)
        history = try ChessBoardCoder.decodeChessBoardList(container: &historyContainer, gameType: gameType)
        
        players = []
        gameState = .paused
       
        playersInCheck = try container.decode(Set<PlayerID>.self, forKey: .playersInCheck)
        chessBoard = try ChessBoardCoder.decodeKeyed(container: container, key: .chessBoard, gameType: gameType)
//        settings
        lastMoves = try container.decode(Set<Position>.self, forKey: .lastMoves)
        warningPositions = try container.decode(Set<Position>.self, forKey: .warningPositions)
        potentialMoveDestinations = []
        
        var playersContainer = try container.nestedUnkeyedContainer(forKey: .players)
        let responseHandler: PlayerResponseHandler = {move in self.handleMove(move)}
        players = try PlayerCoder.decodePlayerList(fromContainer: &playersContainer, handler: responseHandler)
        gameState = try container.decode(GameState.self, forKey: .gameState)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: ChessGameCodingKeys.self)
        
        try container.encode(gameType, forKey: .gameType)
        try container.encode(id, forKey: .id)
        
        var playerContainer = container.nestedUnkeyedContainer(forKey: .players)
        try PlayerCoder.encodePlayerList(container: &playerContainer, players: players)
        
        var historyContainer = container.nestedUnkeyedContainer(forKey: .history)
        try ChessBoardCoder.encodeChessBoardList(container: &historyContainer, boards: history)
        
        try container.encode(playersInCheck, forKey: .playersInCheck)
        try ChessBoardCoder.encodeKeyed(container: &container, key: .chessBoard, board: chessBoard)
        try container.encode(gameState, forKey: .gameState)
        //            try container.encode(settings, forKey: .settings)
        try container.encode(lastMoves, forKey: .lastMoves)
        try container.encode(warningPositions, forKey: .warningPositions)
    }
    
    var description: String {
        var description = ""
        var teams: [String] = []
        var teamIDs: [TeamID] = []
        for player in players {
            if let index = teamIDs.firstIndex(where: { teamID in return teamID == player.team }) {
                teams[index] += ", \(player.name)"
            } else {
                teamIDs.append(player.team)
                teams.append(player.name)
            }
        }
        
        for teamIndex in 0..<teams.count {
            description += teamIndex == 0 ? teams[teamIndex] : " vs \(teams[teamIndex])"
        }
        return description
    }
    
    // MARK: - View Events
    
    private var potentialMovesForCurrentPiece: [Move] = []
    @Published private(set) var userFocusedPosition: Position? {
        didSet {
            potentialMoveDestinations.removeAll()
            if let selectedPosition = userFocusedPosition {
                let possibleMoves = chessBoard.getMoves(from: selectedPosition)
                for move in possibleMoves {
                    potentialMoveDestinations.insert(move.primaryDestination)
                }
            }
        }
    }
    @Published private(set) var potentialMoveDestinations: Set<Position>
    @Published private(set) var warningPositions: Set<Position>
    @Published private(set) var lastMoves: Set<Position>
    
    enum SelectionType {
        case userFocus
        case potentialMove
        case warning
        case lastMove
    }
    
    func userTappedPosition(_ position: Position) {
        let animation = Animation.linear(duration: 0.1)
        if gameState.isWaitingOnUserToMakeMove(game: self) {
            if (position == userFocusedPosition) {
                withAnimation(animation) {
                    userFocusedPosition = nil
                }
            } else if (potentialMoveDestinations.contains(position)) {
                handleTappedPotentialMove(atPosition: position)
            } else {
                handleSelectedOtherPosition(position)
            }
        }
    }
    
    func handleTappedPotentialMove(atPosition position: Position) {
        let userMoves = potentialMovesForCurrentPiece.filter({ $0.primaryDestination == position})
        let onDevicePlayer = currentPlayer as! OnDevicePlayer
        
        potentialPromotionDestination = nil
        potentialPromotionFromPosition = nil
        
        if userMoves.count == 1 {
            onDevicePlayer.handleOnDeviceMove(userMoves.first!)
        } else if userMoves.count > 1 {
            pieceShowingPromotionView = chessBoard.board[userMoves.first!.primaryStart]?.id
            potentialPromotionFromPosition = userFocusedPosition
            potentialPromotionDestination = position
            
            for move in userMoves {
                if let promotionType = move.promotionType {
                    promotionPieceTypes.append(promotionType)
                }
            }
        }
            
        clearHighlights()
    }
    
    func handlePromotionSelection(pieceType: PieceType?) {
        pieceShowingPromotionView = nil
        promotionPieceTypes.removeAll()
        objectWillChange.send()
        
        if let type = pieceType {
            let promotionMoves = chessBoard.getMoves(from: potentialPromotionFromPosition!).filter({ $0.promotionType == type && $0.primaryDestination == potentialPromotionDestination!})
            let onDevicePlayer = currentPlayer as! OnDevicePlayer
            let move = promotionMoves.first!
            onDevicePlayer.handleOnDeviceMove(move)

        }
    }
    
    func clearHighlights() {
        withAnimation(.linear(duration: animationDuration)) {
            potentialMoveDestinations.removeAll()
            potentialMovesForCurrentPiece.removeAll()
            userFocusedPosition = nil
        }
    }
    
    func handleSelectedOtherPosition(_ position: Position) {
        if case .waitingOnPlayer(let currentPlayer) = gameState,
           let piece = chessBoard.board[position],
           piece.player == currentPlayer {
            withAnimation(.linear(duration: animationDuration)) {
                userFocusedPosition = position
                potentialMovesForCurrentPiece = chessBoard.getMoves(from: position)
                potentialMoveDestinations.removeAll()
                potentialMovesForCurrentPiece.forEach({potentialMoveDestinations.insert($0.primaryDestination)})
            }
        }
    }
    
    func handleMove(_ move: Move) {
        if let firstPlayer = currentPlayer {
            // Make this move
            let _ = withAnimation(.interactiveSpring()) {
                chessBoard = chessBoard.doMove(move)
            }
            
            withAnimation(.linear(duration: animationDuration)) {
                if let oldLastMove = firstPlayer.lastMove {
                    lastMoves.remove(oldLastMove.primaryDestination)
                }
                lastMoves.insert(move.primaryDestination)
                players[firstPlayer.index].lastMove = move
                
                updateGameState()
            }

            if let nextPlayer = currentPlayer {
                nextPlayer.startMove(withBoard: chessBoard)
            }
            
            history.append(chessBoard)
            objectWillChange.send()
            ChessGameStore.saveGames()
        }

    }
    
    // MARK: - States
    
    enum GameState: Codable {
        case paused
        case waitingOnPlayer(player: PlayerID)
        case endedVictory(forTeam: TeamID)
        case endedStalemate
        
        
        func isWaitingOnUserToMakeMove(game: ChessGame) -> Bool {
            if let currentPlayer = getCurrentPlayer() {
                return game.playerWithID(id: currentPlayer)?.type == .onDevice
            } else {
                return false
            }
        }
        
        func isWaitingOnComputer(game: ChessGame) -> Bool {
            if let currentPlayer = getCurrentPlayer() {
                return game.playerWithID(id: currentPlayer)?.type == .computer
            } else {
                return false
            }
        }
        
        func getCurrentPlayer() -> PlayerID? {
            if case .waitingOnPlayer(let currentPlayer) = self {
                return currentPlayer
                
            } else {
                return nil
            }
        }
        
        var gameOver: Bool {
            switch self {
            case .endedStalemate:
                return true
            case .endedVictory(_):
                return true
            default:
                return false
            }
        }
        
        // Codability
        enum GameStateCodingKeys: CodingKey {
            case state, waitingPlayer, winningTeam
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: GameStateCodingKeys.self)
            
            let stateIndex = try container.decode(Int.self, forKey: .state)
            switch stateIndex {
            case 0:
                self = .paused
            case 1:
                self = .waitingOnPlayer(player: try container.decode(PlayerID.self, forKey: .waitingPlayer))
            case 2:
                self = .endedVictory(forTeam: try container.decode(TeamID.self, forKey: .winningTeam))
            case 3:
                self = .endedStalemate
            default:
                throw DecodingError.dataCorruptedError(forKey: .state, in: container, debugDescription: "Unrecognized game state")
            }
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: GameStateCodingKeys.self)
            switch self {
            case .paused:
                try container.encode(0, forKey: .state)
            case .waitingOnPlayer(let player):
                try container.encode(1, forKey: .state)
                try container.encode(player, forKey: .waitingPlayer)
            case .endedVictory(let forTeam):
                try container.encode(2, forKey: .state)
                try container.encode(forTeam, forKey: .winningTeam)
            case .endedStalemate:
                try container.encode(3, forKey: .state)
            }
        }
    }
    
    func updateGameState() {
        if let next = nextPlayer {
            ChessGameStore.instance.gameWillChange()
            playersInCheck.removeAll()
            warningPositions.removeAll()
            
            for player in players {
                if chessBoard.isKingInCheck(player: player.identity) {
                    playersInCheck.insert(player.identity)
                }
            }
            
            if chessBoard.canPlayerMakeMove(player: next.identity) {
                gameState = .waitingOnPlayer(player: next.identity)
            } else {
                if playersInCheck.contains(next.identity) {
//                    eliminatePlayer(playerID: next.identity)
                    eliminateTeam(teamID: next.team) // Player eliminated when can't make a move and in check
                } else {
                    if players.count == 2 {
                        gameState = .endedStalemate // 1v1 Games stalemated when player can't make move and isn't in check
                    } else {
//                        eliminatePlayer(playerID: next.identity)
                        eliminateTeam(teamID: next.team) // Non 1v1 games eliminate player when they can't make a move
                    }
                }
            }
        }
    }
    
    func eliminatePlayer(playerID: PlayerID) {
        let player = players[playerID.index]
        
        players[playerID.index].hasBeenEliminated = true
        players[player.previousPlayer.id].nextPlayer = player.nextPlayer
        players[player.nextPlayer.id].previousPlayer = player.previousPlayer
        gameState = .waitingOnPlayer(player: nextPlayer!.identity)
        
        let inGame = playersStillInGame
        if inGame.count == 1 {
            gameState = .endedVictory(forTeam: players[inGame.first!.index].team)
        } else if inGame.count == 0 {
            gameState = .endedStalemate
        } else {
            updateGameState()
        }
    }
    
    func eliminateTeam(teamID: TeamID) {
        for player in players.filter({player in player.team == teamID}) {
            if !player.hasBeenEliminated {
                eliminatePlayer(playerID: player.identity)
            }
        }
    }
    
    var hasDisplayedGameOver = false
    
   
}

