// // SPDX-License-Identifier: UNLICENSED
// pragma solidity ^0.8.13;

// import {Counters} from "@openzeppelin/contracts/utils/Counters.sol";
// import {Listings} from "../src/Listings.sol";

// contract Dispute {
//     Listings public listings;
//     string receiver;

//     //state variables
//     struct DisputeDetail {
//         uint256 adId;
//         State state;
//         uint256 votingPeriod;
//         uint256 votesForBuyer;
//         uint256 votesForSeller;
//     }

//     enum State {
//         open,
//         closed
//     }

//     using Counters for Counters.Counter;
//     Counters.Counter private _disputeIds;

//     mapping(uint256 => DisputeDetail) public disputes;

//     //errors
//     error DisputeAlreadyClosed();
//     error OnlyBuyerOrSellerCanOpenDispute();

//     //constructor
//     constructor(address _listings) {
//         listings = Listings(_listings);
//     }

//     function createDispute(uint256 _adId) public {
//         DisputeDetail memory newDispute = DisputeDetail({
//             adId: _adId,
//             state: State.open,
//             votingPeriod: block.timestamp + 1 minutes,
//             votesForBuyer: 0,
//             votesForSeller: 0
//         });

//         _disputeIds.increment();
//         uint256 adId = _disputeIds.current();

//         disputes[adId] = newDispute;
//     }

//     function closeDispute(uint256 disputeIndex) public {
//         require(
//             disputes[disputeIndex].state == State.open,
//             "Dispute is already closed"
//         );

//         // Update the state
//         disputes[disputeIndex].state = State.closed;
//     }

//     function getDisputeCount() public view returns (uint256) {
//         return _disputeIds.current();
//     }

//     function getDispute(
//         uint256 disputeIndex
//     ) public view returns (DisputeDetail memory) {
//         return (disputes[disputeIndex]);
//     }

//     function updateDisputeState(uint256 disputeIndex, State newState) public {
//         require(
//             disputes[disputeIndex].state == State.open,
//             "Dispute is already closed"
//         );

//         // Update the state
//         disputes[disputeIndex].state = newState;
//     }

//     function voteDispute(uint256 disputeIndex, State newState) public {
//         //check that the dispute is open, revert with an error if not
//         //check that the voting period has not ended, revert with an error if not
//     }

//     //b: buyer, s: seller
//     function executeDispute(uint256 disputeIndex, uint256 adId) public {
//         //check that the dispute is open, revert with an error if not
//         //check that the voting period has ended, revert with an error if not

//         if (
//             disputes[disputeIndex].votesForBuyer >
//             disputes[disputeIndex].votesForSeller
//         ) {
//             receiver = "b";
//         }
//         if (
//             disputes[disputeIndex].votesForBuyer <
//             disputes[disputeIndex].votesForSeller
//         ) {
//             receiver = "s";
//         }

//         //with the updated receiver value, call the disputeTransfer function on the intended escrow contract
//     }

//     //set listings
//     function setListings(address _listings) public {
//         listings = Listings(_listings);
//     }
// }
