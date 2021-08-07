pragma solidity ^0.4.24;

import './Resolution_Referree.sol';

contract BetList is RefBased {

  struct Bet {
    uint32 event_id;
    uint32 bet_counter;
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
    uint32 bet_counter,
    uint256 event_date,
    address indexed betInitiator,
    uint32 _home_team, 
    uint32 _away_team,
    uint32 home_wins,
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
    uint32 _home_wins = 0;

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
      _home_wins,
      0,
      0
    );

    // Trigger a log event
    emit LogPublishBet( _event_id, betCounter, _event_date, 0x0, _home_team, _away_team, _home_wins, 0);
  }

  // Fetch and return all bet IDs for bets that are still available
  function getAvailableEvents() public view returns (uint[]) {
    uint[] memory eventIds = new uint[](eventCounter);
    // uint[] memory betIds = new uint[](betCounter);
    uint numberOfAvailableEvents = 0;
    // uint numberOfAvailableBets= 0;

    // Iterate over all Events
    for(uint i = 1; i <= eventCounter; i++) {
      // Keep the ID if the bet is still available
      if(bets[i].betAcceptor == 0x0) {
        eventIds[numberOfAvailableEvents] = bets[i].event_id;
        // betIds[numberOfAvailableEvents] = bets[i].bet_counter;
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
        betIds[numberOfAvailablebets] = bets[i].bet_counter;
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
        betIds[numberOfClosedBets] = bets[i].bet_counter;
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

}
