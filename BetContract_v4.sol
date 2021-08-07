pragma solidity ^0.4.24;

import './Resolution_Referree.sol';

contract BetList is RefBased {

  struct Bet {
    uint32 event_id;
    uint32 bet_id;
    uint256 event_date;
    address betInitiator;
    address betAcceptor;
    uint32 teamH_id;
    uint32 teamA_id;
    uint32 home_wins;    //// Use 0 for event creation, '1' for betInitiator Home wins, '2' for for betInitiator away wins
    uint32 bet_result;  //// Use 0 for Event in the future, '1' for Home wins, '2' for away wins
    uint256 bet_balance;
  }

  mapping (uint => Bet) public bets;
  uint32 betCounter;
  uint32 eventCounter;


  event LogPublishBet(
    uint32 indexed event_id,
    uint32 bet_id,
    uint256 event_date,
    address indexed betInitiator,
    uint32 home_team, 
    uint32 away_team,
    uint32 home_wins,
    uint256 bet_balance
    );

  event LogOpenBet(
    uint32 indexed event_id,
    uint32 bet_id,
    address indexed betInitiator,
    address indexed betAcceptor,
    uint256 accept_date,
    uint32 home_wins,
    uint32 teamID_wins,
    uint256 bet_balance
  );

  // Publish a new Event
  function publishEvent(uint32 _event_id, uint256 _event_date, uint32 _home_team, uint32 _away_team) payable public {
    // The challenger must deposit his bet
    // require(_bet_balance > 0 && msg.value == _bet_balance);
    // require(_event_id != 0);
    // // require(_home_wins == true || _home_wins == false);
    // require(_home_team != 0);
    // require(_away_team != 0);

    // A new bet
    betCounter++;
    eventCounter++;
    uint32 home_wins = 0;

    // int bet_win = 0;
    // Store this bet into the contract
    bets[betCounter] = Bet(
      _event_id,
      betCounter,
      _event_date,
      0x0,
      0x0,
      _home_team,
      _away_team,
      home_wins,
      0,
      0
    );

    // Trigger a log event
    emit LogPublishBet( _event_id, betCounter, _event_date, 0x0, _home_team, _away_team, home_wins, 0);

  }

  // Fetch and return all bet IDs for bets that are still available
  function getAvailableEvents() public view returns (uint[]) {
    uint[] memory eventIds = new uint[](eventCounter);
    uint numberOfAvailableEvents = 0;

    // Iterate over all Events
    for(uint i = 1; i <= eventCounter; i++) {
      // Keep the ID if the bet is still available
      if(bets[i].betAcceptor == 0x0) {
        eventIds[numberOfAvailableEvents] = bets[i].event_id;
        numberOfAvailableEvents++;
      }
    }

    uint[] memory availableEvents = new uint[](numberOfAvailableEvents);

    // Copy the betIds array into a smaller availableBets array to get rid of empty indexes
    for(uint j = 0; j < numberOfAvailableEvents; j++) {
      availableEvents[j] = eventIds[j];
    }

    return availableEvents;
  }

  // Fetch and return all bet IDs for bets that are still available
  function getAvailableBets() public view returns (uint[]) {
    uint[] memory betIds = new uint[](betCounter);
    uint numberOfAvailablebets = 0;

    // Iterate over all bets
    for(uint i = 1; i <= betCounter; i++) {
      // Keep the ID if the bet is still available
      if(bets[i].betAcceptor == 0x0) {
        betIds[numberOfAvailablebets] = bets[i].bet_id;
        numberOfAvailablebets++;
      }
    }

    uint[] memory availableBets = new uint[](numberOfAvailablebets);

    // Copy the betIds array into a smaller availableBets array to get rid of empty indexes
    for(uint j = 0; j < numberOfAvailablebets; j++) {
      availableBets[j] = betIds[j];
    }
    
    return availableBets;
   }
   
  function getAcceptedBets() public view returns (uint[]) {
    uint[] memory betIds = new uint[](betCounter);
    uint numberOfClosedBets = 0;

    // Iterate over all bets
    for(uint i = 1; i <= betCounter; i++) {
      // Keep the ID if the bet is still available
      if(bets[i].betAcceptor != 0x0) {
        betIds[numberOfClosedBets] = bets[i].bet_id;
        numberOfClosedBets++;
      }
    }

    uint[] memory closedBets = new uint[](numberOfClosedBets);

    // Copy the betIds array into a smaller availableBets array to get rid of empty indexes
    for(uint j = 0; j < numberOfClosedBets; j++) {
      closedBets[j] = betIds[j];
    }
    
    return closedBets;
   }

  // Open a bet with event_id
  function OpenBet(uint32 _event_id, uint32 _home_wins, uint256 _bet_balance) payable public {
    // Check whether there is a bet published
    require(betCounter > 0);
    
    // Check that bet is higher than 0
    require(_bet_balance > 0);
    
    // Check that the bet exists
    require(_event_id > 0);

    // Retrieve the bet
    Bet storage bet = bets[_event_id];

    // Check that the bet has not been accepted yet
    require(bet.betAcceptor == 0x0);

    // // Don't allow the challenger to accept his own bet
    // require(msg.sender != bet.challenger);

    // The accepter must deposit his bet
    require(msg.value == bet.bet_balance);

    bet.betInitiator = msg.sender;
    bet.event_id = bet.event_id;
    betCounter++;
    
    uint32 teamID;
    
    if (_home_wins == 1) {
        teamID = bet.teamH_id;
    }
    
    if (_home_wins == 2) {
        teamID = bet.teamA_id;
    }

    // Trigger a log event
    emit LogOpenBet(_event_id, betCounter, bet.betInitiator, 0x0, now, _home_wins, teamID, msg.value);
  }

} 
