//
//  Util.swift
//  uno
//
//  Created by Clayton Herendeen on 12/21/15.
//  Copyright © 2015 Clayton Herendeen. All rights reserved.
//

import UIKit
import Socket_IO_Client_Swift
import SwiftyJSON

class UNOUtil {
    
    static let socket = SocketIOClient(socketURL: "uno-server.herokuapp.com", options: [ "Nsp":"/login"])
//    static let socket = SocketIOClient(socketURL: "localhost:3000", options:["log": true, "Nsp":"/login"])
//    static var chatMsgArray: JSON = []
    static var chatMsgArray: [ChatMsg] = []
    static var activeUsers:[JSON] = []
    static var sentChallenges:[Challenge] = []
    static var receivedChallenges:[Challenge] = []
    static var usersToChallenge:Array<String> = []
    static var loggedIn:Bool = false
    static var currChallengeId:String = ""
    static var currGameId:String = ""
    static var preGameLobbyMsg:String = ""
    static var currGame:Game = Game()
    static var currGameJSON:JSON = []
    static var tempGameJSON:JSON = []
    
    static var inGameOrGameLobby:Bool = false
    static var currUserIsChallenger:Bool = false
    
    static var lobbyVC:LobbyVC?
    static var gameVC:GameVC?
    static var canSayUno:Bool = false
    
    // intervals
    static var getCurrChallengeInterval:NSTimer?
    static var checkPlayersInGameRoomInterval:NSTimer?
    static var getChatInterval:NSTimer?
    static var getReceivedChallengesInterval:NSTimer?
    static var getSentChallengesInterval:NSTimer?
    static var getOnlineUsersInterval:NSTimer?
    static var getCurrGameInterval:NSTimer?
    static var getCurrGameChatInterval:NSTimer?
    
    static func initSocketHandler(){
        socket.on("connect") {data, ack in
            print("socket connected")
            
            let token = NSUserDefaults.standardUserDefaults().stringForKey("token")
            if(token != nil){
                let tokenPacket = ["token":token!]
                socket.emitWithAck("validateToken", tokenPacket)(timeoutAfter: 0) {data in
                    var res = JSON(data[0])
                    let user = res["user"]
                    let valid = res["valid"]
                    let token:String = (user["token"].stringValue as AnyObject? as? String)!

                    if(valid == true){
                        // valid login
                        print("TOKEN VALID")
                        NSUserDefaults.standardUserDefaults().setObject(token, forKey: "token")
                    }else{
                        // invalid login
                        
                    }
                }
            }
        }
        socket.onAny {print("Got event: \($0.event), with items: \($0.items)")}
        socket.connect()
    }
    
    static func showAlert(title: String, msg: String, vc: UIViewController){
        let alertController = UIAlertController(title: title, message:
            msg, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        
        vc.presentViewController(alertController, animated: true, completion: nil)
    }
    
    static func makeLoggedIn(username: String, uid: String, token:String){
        NSUserDefaults.standardUserDefaults().setObject("true", forKey: "userLoggedIn")
        NSUserDefaults.standardUserDefaults().setObject(token, forKey: "token")
        
        // store the username and user id
        NSUserDefaults.standardUserDefaults().setObject(username, forKey: "username")
        NSUserDefaults.standardUserDefaults().setObject(uid, forKey: "uid")
    }
    
    static func checkLoggedIn(vc:UIViewController) ->Bool{
        let token = NSUserDefaults.standardUserDefaults().stringForKey("token")
        if(loggedIn){
            return true
        }else{
            if(token != nil){
                UNOUtil.popUser()
                loggedIn = true
                validateToken(token!, vc:vc);
                return true
            }else{
                return false
            }
        }
    }
    
    static func popUser(){
        CurrUser.sharedInstance.username = NSUserDefaults.standardUserDefaults().stringForKey("username")!
        CurrUser.sharedInstance.uid = NSUserDefaults.standardUserDefaults().stringForKey("uid")!
    }
    
    static func attemptLogin(credentials :[String: String], vc: UIViewController){
        // check logged in
        socket.emitWithAck("validateLogin", credentials)(timeoutAfter: 0) {data in
            var res = JSON(data[0])
            let user = res["user"]
            let valid = res["valid"]
            let username:String = (user["username"].stringValue as AnyObject? as? String)!
            let uid:String = (user["id"].stringValue as AnyObject? as? String)!
            let token:String = (user["token"].stringValue as AnyObject? as? String)!
            
            if(valid == true){
                // valid login
                UNOUtil.makeLoggedIn(username, uid: uid, token:token)
                vc.dismissViewControllerAnimated(true, completion: nil) // go back to LobbyVC
            }else{
                // invalid login
                UNOUtil.showAlert("Login", msg:"Invalid login", vc: vc)
            }
        }
    }
    
    static func clearUserDefaults(){
        let appDomain = NSBundle.mainBundle().bundleIdentifier!
        NSUserDefaults.standardUserDefaults().removePersistentDomainForName(appDomain)
    }
    
    static func validateToken(token:String, vc:UIViewController){
        let tokenPacket = ["token":token]
        
        socket.emitWithAck("validateToken", tokenPacket)(timeoutAfter: 0) {data in
            var res = JSON(data[0])
            let msg:JSON = res["msg"]
            
            if(msg == "success"){
                let newToken:String = (res["user"]["token"].stringValue as AnyObject? as? String)!
                NSUserDefaults.standardUserDefaults().setObject(newToken, forKey: "token")
            }else{
                print("ERROR VALIDATING TOKEN")
                vc.performSegueWithIdentifier("goto-login", sender: vc);
            }
        }
    }
    
    static func sayUno(){
        
        if(currGame.currPlayer.hand.count <= 2){
            let sayUnoPacket = ["gameId":currGameId, "userId":CurrUser.sharedInstance.uid]
            
            socket.emitWithAck("sayUno", sayUnoPacket)(timeoutAfter: 0) {data in
                var res = JSON(data[0])
                let msg:JSON = res["msg"]
                
                if(msg == "success"){
                    setCurrGame(res["data"])
                }else{
                    print("ERROR: sayUno error!")
                }
            }
        }

    }
    
    static func challengeUno(){
        let challengeUnoPacket = ["gameId":currGameId, "userId":CurrUser.sharedInstance.uid]
        
        socket.emitWithAck("challengeUno", challengeUnoPacket)(timeoutAfter: 0) {data in
            var res = JSON(data[0])
            let msg:JSON = res["msg"]
            
            if(msg == "success"){
                setCurrGame(res["data"])
            }else{
                print("ERROR: challengeUno error!")
            }
        }

    }
    
    static func displayWildCardChoices(vc:UIViewController, callback:(color:String)->Void){
        let alertController = UIAlertController(title: "Wild Card Color", message: "please choose which color you wish to set", preferredStyle: .Alert)
        
        // Create the actions
        let makeRedAction = UIAlertAction(title: "Red", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            // make card red
            callback(color:"red")
        }
        let makeBlueAction = UIAlertAction(title: "Blue", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            // make card blue
            callback(color:"blue")
        }
        let makeGreenAction = UIAlertAction(title: "Green", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            // make card green
            callback(color:"green")
        }
        let makeYellowAction = UIAlertAction(title: "Yellow", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            // make card yellow
            callback(color:"yellow")
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) {
            UIAlertAction in
            NSLog("Cancel Pressed")
        }
        
        // Add the actions
        alertController.addAction(makeRedAction)
        alertController.addAction(makeBlueAction)
        alertController.addAction(makeGreenAction)
        alertController.addAction(makeYellowAction)
        alertController.addAction(cancelAction)
        
        // Present the controller
        vc.presentViewController(alertController, animated: true, completion: nil)
    }
    
    static func showExitGameModal(vc: UIViewController){
        let alertController = UIAlertController(title: "Quit Game", message: "Are you sure you want to quit this game", preferredStyle: .Alert)
        
        // Create the actions
        let quitGameAction = UIAlertAction(title: "Quit Game", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            // quit game socket call here
//            vc.dismissViewControllerAnimated(true, completion: nil)
            vc.performSegueWithIdentifier("game-to-lobby", sender: vc)
            
            quitGame()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) {
            UIAlertAction in
            NSLog("Cancel Pressed")
        }
        
        // Add the actions
        alertController.addAction(quitGameAction)
        alertController.addAction(cancelAction)
        
        // Present the controller
        vc.presentViewController(alertController, animated: true, completion: nil)
    }
    
    static func startGame(vc:UIViewController){
        let createGamePacket = ["challengeId":currChallengeId, "userId":CurrUser.sharedInstance.uid]
        
        socket.emitWithAck("createGame", createGamePacket)(timeoutAfter: 0) {data in
            var res = JSON(data[0])
            let msg:JSON = res["msg"]
            
            if(msg == "success"){
                getCurrChallengeInterval?.invalidate()
                // show pregame lobby and poll for challenge to make sure everyone has joined and that nobody cancelled
                currUserIsChallenger = true
                
                print("CURRGAME \(res["data"])")
                currGameId = res["data"]["_id"].stringValue
                setCurrGame(res["data"])
                
                inGameOrGameLobby = true
                preGameLobbyMsg = "Please wait for everyone to join the game."
                vc.performSegueWithIdentifier("lobby-pregamelobby", sender: vc);
                
            }else{
                print("ERROR: create game error!")
            }
        }

    }
    
    static func quitGame(){
        let quitGamePacket = ["gameId":currGameId, "userId":CurrUser.sharedInstance.uid]
        
        socket.emitWithAck("quitGame", quitGamePacket)(timeoutAfter: 0) {data in
            var res = JSON(data[0])
            let msg:JSON = res["msg"]
            
            if(msg == "success"){
                // send back to lobby
                
                UNOUtil.inGameOrGameLobby = false // no longer in game or game lobby
                
                getCurrGameInterval?.invalidate() // clear get game interval
                getCurrGameChatInterval?.invalidate() // clear get game chat interval

            }else{
                print("ERROR: quitGame error!")
            }
        }
        
    }
    
    static func getGameByChallengeId(vc:UIViewController){
        // create game
        let getGameByChallengeIdPacket = ["challengeId":currChallengeId, "userId":CurrUser.sharedInstance.uid]
        
        socket.emitWithAck("getGameByChallengeId", getGameByChallengeIdPacket)(timeoutAfter: 0) {data in
            var res = JSON(data[0])
            let msg:JSON = res["msg"]
            
            if(msg == "success"){
                // open gamevc
//                callback()
                setPlayerInGame()
                currGameId = res["data"]["_id"].stringValue
                setCurrGame(res["data"])
                vc.performSegueWithIdentifier("pregame-lobby-game", sender: vc); // opens gameVC
            }else{
                print("ERROR: getGameByChallengeId error!")
            }
        }
    }
    
    static func getCurrGame(){
        let getGameByGameIdPacket = ["gameId":currGameId, "userId":CurrUser.sharedInstance.uid]
        
        socket.emitWithAck("getGameByGameId", getGameByGameIdPacket)(timeoutAfter: 0) {data in
            var res = JSON(data[0])
            let msg:JSON = res["msg"]
            
            if(msg == "success"){
                tempGameJSON = res["data"]
                var tempGame:Game = Game()
                tempGame.initGameData(tempGameJSON)
                ////
                var allPlayersInGame:Bool = true;
                // ensure all players are still in game
                for(var i = 0, j = tempGame.players.count; i<j; i++){
                    // if player is not inGame
                    if( !tempGame.players[i].inGame ){
                        getCurrGameInterval?.invalidate() // clear get game interval
                        getCurrGameChatInterval?.invalidate() // clear get game chat interval
                        
                        allPlayersInGame = false // for local logic
                        UNOUtil.inGameOrGameLobby = false
//                        Materialize.toast(_gameObj.players[i].username + " has left the game so the game must end!", 3000);
                        // FIND TOAST LIKE MSG TO SHOW HERE
                        // due to materialize toast callback issue
                        quitGame()
                    }
                }
                // if everyone is still here
                if(allPlayersInGame){
                    // if something has changed
                    if(currGameJSON != tempGameJSON){
                        
                        // if its not my turn update stuff so i know whats going on
                        if( ( !currGame.currPlayer.isMyTurn ) ||
                            ( currGame.currPlayer.hand.count == 0 ) ){
                                
                                setCurrGame(tempGameJSON)
                                gameVC!.refreshView()
                                
                                // if there is a winner
                                checkWinner(tempGame)
                        }else{
                            // it is my turn just check for if someone said uno
                            
                            // update my hand if the length differs from before
                            if(tempGame.currPlayer.hand.count != currGame.currPlayer.hand.count){
                                setCurrGame(tempGameJSON)
                                gameVC!.refreshView();
                            }
                        }
                    }
                    // nothing changed in the new game object
                    else{
                        // check if there is a winner
                        checkWinner(tempGame);
                    }
                }
                // end of success code
            }else{
                print("ERROR: getCurrGame error!")
            }
        }
    }
    static func setCurrGame(gameObj:JSON){
        currGameJSON = gameObj
        currGame = Game() // re initialize
        currGame.initGameData(gameObj)
    }
    
    static func checkWinner(newGame:Game){
        print("winner: \(newGame.winner)")
        if(newGame.winner != ""){
            getCurrGameInterval?.invalidate() // clear get game interval
            getCurrGameChatInterval?.invalidate() // clear get game chat interval
            UNOUtil.inGameOrGameLobby = false
            currGame = Game() // reset game
            gameVC!.performSegueWithIdentifier("game-to-lobby", sender: gameVC!)
        }
    }
    
    static func getCurrGameChat(){
        // IMPLEMENT LATER
    }
    
    /* GAME FUNCTIONS */
    
    static func drawCard(){
        if (currGame.currPlayer.isMyTurn) {
            let drawCardPacket = ["gameId":currGameId, "userId":CurrUser.sharedInstance.uid]
            
            socket.emitWithAck("drawCard", drawCardPacket)(timeoutAfter: 0) {data in
                var res = JSON(data[0])
                let msg:JSON = res["msg"]
                
                if(msg == "success"){
                    setCurrGame(res["data"])
                    gameVC?.refreshView()
                }else{
                    print("ERROR: drawing card error!")
                }
            }
        }else{
//            Materialize.toast("Its not your turn", 3000);
        }
    }
    
    // validates card is good to play
    static func playCard(card:Card){
        if (currGame.currPlayer.isMyTurn) {
            // if it is wild or wild draw4
            if(card.svgName == "ww" || card.svgName == "wd"){
                displayWildCardChoices(gameVC!, callback: { (color) -> Void in
                    handleValidateMove(card.svgName, chosenColor:color);
                })

            }else{
                // regular card - play it
                handleValidateMove(card.svgName);
            }
        }else{
            print("not your turn")
//            Materialize.toast("Its not your turn", 3000);
        }
    }
    
    static func handleValidateMove(svgName:String, chosenColor:String?=""){
        var reqPacket = ["gameId":currGameId, "userId":CurrUser.sharedInstance.uid, "svgName":svgName]
        if(chosenColor != ""){
            reqPacket["chosenColor"] = chosenColor
        }
        
        socket.emitWithAck("validateMove", reqPacket)(timeoutAfter: 0) {data in
            var res = JSON(data[0])
            let msg:JSON = res["msg"]
            
            if(msg == "success"){
                print("validate move ")
                gameVC!.refreshView()
                let tempGame:Game = Game()
                tempGame.initGameData(res["data"])
                checkWinner(tempGame)
            }else{
                print("ERROR: validate move error!")
                // display msg in toast
                print(msg) // probably cant play card
            }
        }
    }
    
    static func setPlayerInGame(){
        let setPlayerInGamePacket = ["challengeId":currChallengeId, "userId":CurrUser.sharedInstance.uid]
        
        socket.emitWithAck("setPlayerInGame", setPlayerInGamePacket)(timeoutAfter: 0) {data in
            var res = JSON(data[0])
            let msg:JSON = res["msg"]
            
            if(msg == "success"){
                
            }else{
                print("ERROR: setPlayerInGame error!")
            }
        }
    }
    
    static func getStatusIndicatorColor(status:String) -> UIColor{
        
        var color:UIColor = UIColor.blackColor()
        
        switch(status){
            case "all responded":
                color = UIColor.greenColor()
                break
            case "accepted":
                color = UIColor.greenColor()
                break
            case "declined":
                color = UIColor.orangeColor()
                break
            case "cancelled":
                color = UIColor.redColor()
                break
            default:
                color = UIColor.blackColor()
                break
        }
        
        return color
    }
    
    static func sendChat(msg: String, vc: UIViewController){
        let senderId = CurrUser.sharedInstance.uid
        let msgPacket = ["senderId":senderId, "roomId":"1", "message":msg]
        
        socket.emitWithAck("chatMsg", msgPacket)(timeoutAfter: 0) {data in
            var res = JSON(data[0])
            let msg:JSON = res["msg"]
            
            if(msg != "success"){
                // failed to send chat
                UNOUtil.showAlert("Send Chat", msg:"Failed to send chat", vc: vc)
            }else{
                
            }
        }
    }
    
    static func getChat(chatRoomId: String){
        let getChatPacket = ["roomId":chatRoomId]
        
        socket.emitWithAck("getChat", getChatPacket)(timeoutAfter: 0) {data in
            var res = JSON(data[0])
            let msg:JSON = res["msg"]
            if(msg == "success"){
//                chatMsgArray = res["data"]
                if(res["data"].count != chatMsgArray.count){
                    chatMsgArray.removeAll()
                    for (index, element) in res["data"].enumerate(){
                        chatMsgArray.append( ChatMsg(chatMsg: res["data"][index]) )
                    }
                }
            }else{
                print("Error: cannot get chat")
            }
        }
    }
    
    static func getOnlineUsers(){
        socket.emitWithAck("getOnlineUsers", "")(timeoutAfter: 0) {data in
            var res = JSON(data[0])
            let msg:JSON = res["msg"]
            if(msg == "success"){
                if(res["data"].count != activeUsers.count){
                    activeUsers.removeAll()
                    for (index, element) in res["data"].enumerate(){
                        if(res["data"][index]["username"].stringValue != CurrUser.sharedInstance.username){
                            activeUsers.append( res["data"][index] )
                        }
                    }
                }
            }else{
                print("Error: cannot get online users")
            }
        }
    }
    
    static func getSentChallenges(){
        let getSentChallengesPacket = ["id":CurrUser.sharedInstance.uid]
        socket.emitWithAck("getSentChallenges", getSentChallengesPacket)(timeoutAfter: 0) {data in
            var res = JSON(data[0])
            let msg:JSON = res["msg"]
            if(msg == "success"){
                popChallenges(res["data"] as JSON, sentOrReceived: "s")
            }else{
                print("Error: cannot get sent challenges")
            }
        }
    }
    
    static func getReceivedChallenges(){
        let getReceivedChallengePacket = ["id":CurrUser.sharedInstance.uid]
        socket.emitWithAck("getChallenges", getReceivedChallengePacket)(timeoutAfter: 0) {data in
            var res = JSON(data[0])
            let msg:JSON = res["msg"]
            if(msg == "success"){
                popChallenges(res["data"] as JSON, sentOrReceived: "r")
            }else{
                print("Error: cannot get received challenges")
            }
        }
    }
    
    static func getChallenge(vc:UIViewController, currUserIsChallenger:Bool){
        let getChallengePacket = ["challengeId":currChallengeId]
        socket.emitWithAck("getChallenge", getChallengePacket)(timeoutAfter: 0) {data in
            var res = JSON(data[0])
            let msg:JSON = res["msg"]
            if(msg == "success"){
                getCurrChallengeInterval?.invalidate()
                getCurrChallengeInterval = nil
                
                var currChallenge = res["data"]
                
                if(currChallenge["status"] == "cancelled"){
                    // dissmissviewcontroller here :. go back to lobby
                    vc.dismissViewControllerAnimated(true, completion: nil)
                    // show message saying "Sorry someone has cancelled this challenge"
                }
                
                if(!currUserIsChallenger){
                    getGameByChallengeId(vc)
                }else{
                    // they accepted the challenge
                    // set player in game 
                    // the join game
                }
                
            }else{
                print("Error: cannot get challenge")
            }
        }
    }
    
    
    static func checkPlayersInGameRoom(vc:UIViewController){
        let checkPlayersInGameRoomPacket = ["gameId":currGameId, "userId":CurrUser.sharedInstance.uid]
        socket.emitWithAck("checkPlayersInGameRoom", checkPlayersInGameRoomPacket)(timeoutAfter: 0) {data in
            var res = JSON(data[0])
            let msg:JSON = res["msg"]
            if(msg == "success"){
                //clear interval for checking players in game room
                checkPlayersInGameRoomInterval?.invalidate()
                
                // go to game via segue
                setCurrGame(res["data"])
                vc.performSegueWithIdentifier("pregame-lobby-game", sender: vc);
                
            }else{
                print("Error: checkPlayersInGameRoom error")
            }
        }
    }
    
    static func popChallenges(challenges:JSON, sentOrReceived:String){
        
        if(sentOrReceived == "s"){
            sentChallenges.removeAll()
        }else{
            receivedChallenges.removeAll()
        }
        for (index, element) in challenges.enumerate(){
            if(sentOrReceived == "s"){
                sentChallenges.append(Challenge(challenge: challenges[index]))
            }else{
                receivedChallenges.append(Challenge(challenge: challenges[index]))
            }
        }
    }
    
    static func sendChallenge(){
        let sendChallengePacket = NSDictionary(dictionary: ["challengerId":CurrUser.sharedInstance.uid, "usersChallenged":NSArray(array: self.usersToChallenge)])
        socket.emitWithAck("sendChallenge", sendChallengePacket)(timeoutAfter: 0) {data in
            var res = JSON(data[0])
            let msg:JSON = res["msg"]
            if(msg == "success"){
                
            }else{
                print("Error: cannot send challenge")
            }
        }
    }
    
    static func buildUsersChallengedArray(usersChallenged:JSON) -> [String]{
        var usernames:[String] = []
        for (index, element) in usersChallenged.enumerate(){
            usernames.append( usersChallenged[index]["username"].stringValue )
        }
        return usernames
    }
    
    static func showChallengeResponseAlert(title:String, msg:String, sentChallenge:Bool){
        // Create the alert controller
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .Alert)
        
        if(sentChallenge){
            // Create the actions
            let cancelChallengeAction = UIAlertAction(title: "Cancel Challenge", style: UIAlertActionStyle.Default) {
                UIAlertAction in
                handleChallenge(0){
                    (result: String) in
                }
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) {
                UIAlertAction in
                NSLog("Cancel Pressed")
            }
            
            // Add the actions
            alertController.addAction(cancelChallengeAction)
            alertController.addAction(cancelAction)
        }else{
            // received challenge
            // Create the actions
            let acceptChallengeAction = UIAlertAction(title: "Accept", style: UIAlertActionStyle.Default) {
                UIAlertAction in
                handleChallenge(1){
                    (result: String) in
                    if(result == "success"){
                        // challenge successfully accepted
                        currUserIsChallenger = false
                        inGameOrGameLobby = true
                        preGameLobbyMsg = "Please wait for the host to start the game."
                        lobbyVC!.performSegueWithIdentifier("lobby-pregamelobby", sender: lobbyVC!);
                    }
                }
                
            }
            let declineChallengeAction = UIAlertAction(title: "Decline", style: UIAlertActionStyle.Default) {
                UIAlertAction in
                handleChallenge(2){
                    (result: String) in
                }
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) {
                UIAlertAction in
            }
            
            // Add the actions
            alertController.addAction(acceptChallengeAction)
            alertController.addAction(declineChallengeAction)
            alertController.addAction(cancelAction)
        }
        
        // Present the controller
        lobbyVC!.presentViewController(alertController, animated: true, completion: nil)
    }
    
    static func handleChallenge(choice:Int, completion: (result: String) -> Void){
        print("currChallengeId \(currChallengeId)")
        let handleChallengePacket = ["id":currChallengeId ,"userId":CurrUser.sharedInstance.uid, "choice":choice]
        socket.emitWithAck("handleChallenge", handleChallengePacket)(timeoutAfter: 0) {data in
            var res = JSON(data[0])
            let msg:JSON = res["msg"]
            if(msg == "success"){
                print("success handling challenge")
            }else{
                print("Error: handleChallenge error")
            }
            completion(result: msg.stringValue)
        }
    }
    
    static func formatTime(time:String)->String{
        return time
    }
}
