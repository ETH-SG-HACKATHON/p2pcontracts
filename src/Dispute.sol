// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Counters} from "@openzeppelin/contracts/utils/Counters.sol";
import {Listings} from "../src/Listings.sol";
import {EscrowContract} from "../src/Escrow.sol";

contract Dispute {
    Listings public listings;
    EscrowContract public escrow;
    string receiver;

    //state variables
    struct DisputeDetail {
        uint256 adId;
        State state;
        uint256 votingPeriod;
        uint256 votesForBuyer;
        uint256 votesForSeller;
    }

    enum State {
        open,
        closed
    }

    using Counters for Counters.Counter;
    Counters.Counter private _disputeIds;

    mapping(uint256 => DisputeDetail) public disputes;

    //errors
    error DisputeAlreadyClosed();
    error OnlyBuyerOrSellerCanOpenDispute();

    //constructor
    constructor(address _listings) {
        listings = Listings(_listings);
    }

    function createDispute(uint256 _adId) public {
        DisputeDetail memory newDispute = DisputeDetail({
            adId: _adId,
            state: State.open,
            votingPeriod: block.timestamp + 15 minutes,
            votesForBuyer: 0,
            votesForSeller: 0
        });

        _disputeIds.increment();
        uint256 adId = _disputeIds.current();

        disputes[adId] = newDispute;
    }

    function closeDispute(uint256 disputeIndex) public {
        require(
            disputes[disputeIndex].state == State.open,
            "Dispute is already closed"
        );

        // Update the state
        disputes[disputeIndex].state = State.closed;
    }

    function getDisputeCount() public view returns (uint256) {
        return _disputeIds.current();
    }

    function getDispute(
        uint256 disputeIndex
    ) public view returns (DisputeDetail memory) {
        return (disputes[disputeIndex]);
    }

    // Get all posts with pagination
    function getDisputes(
        uint256 page,
        uint256 perPage
    ) public view returns (DisputeDetail[] memory) {
        uint256 offset = page * perPage;
        uint256 size = perPage;
        if (offset + perPage > _disputeIds.current()) {
            size = _disputeIds.current() - offset;
        }
        DisputeDetail[] memory result = new DisputeDetail[](size);
        for (uint256 i = 0; i < size; i++) {
            result[i] = disputes[offset + i + 1];
        }
        return result;
    }

    // function updateDisputeState(uint256 disputeIndex, State newState) public {
    //     require(
    //         disputes[disputeIndex].state == State.open,
    //         "Dispute is already closed"
    //     );
    //     require(
    //         msg.sender == disputes[disputeIndex].buyer ||
    //             msg.sender == disputes[disputeIndex].seller,
    //         "Only the buyer or seller can close the dispute"
    //     );

    //     // Update the state
    //     disputes[disputeIndex].state = newState;
    // }

    function voteDispute(uint256 disputeIndex, string calldata choice) public {
        //check that the dispute is open, revert with an error if not
        if (disputes[disputeIndex].state != State.open) {
            revert DisputeAlreadyClosed();
        }
        //check that the voting period has not ended, revert with an error if not
        if (block.timestamp > disputes[disputeIndex].votingPeriod) {
            revert DisputeAlreadyClosed();
        }
        //get buyer and seller details from the ads mapping in listing
        address seller = listings.getAd(disputes[disputeIndex].adId).seller;

        //get escrow contract address from the ads mapping in listing
        address adEscrow = listings
            .getAd(disputes[disputeIndex].adId)
            .deployedEscrow;

        //get the buyer address from the escrow
        address buyer = EscrowContract(adEscrow).buyer();

        //check that the sender is not the buyer or seller, revert with an error if not
        if (msg.sender == buyer || msg.sender == seller) {
            revert OnlyBuyerOrSellerCanOpenDispute();
        }

        //increment the votesForBuyer or votesForSeller based on the sender
        if (keccak256(abi.encodePacked(choice)) == keccak256("b")) {
            disputes[disputeIndex].votesForBuyer++;
        }

        if (keccak256(abi.encodePacked(choice)) == keccak256("s")) {
            disputes[disputeIndex].votesForSeller++;
        }
    }

    //b: buyer, s: seller
    function executeDispute(uint256 disputeIndex) public {
        //check that the dispute is open, revert with an error if not
        if (disputes[disputeIndex].state != State.open) {
            revert DisputeAlreadyClosed();
        }
        //check that the voting period has ended, revert with an error if not
        if (block.timestamp < disputes[disputeIndex].votingPeriod) {
            revert DisputeAlreadyClosed();
        }

        //get escrow contract address from the ads mapping in listing
        address adEscrow = listings
            .getAd(disputes[disputeIndex].adId)
            .deployedEscrow;

        EscrowContract escrowTransfer = EscrowContract(adEscrow);

        if (
            disputes[disputeIndex].votesForBuyer >
            disputes[disputeIndex].votesForSeller
        ) {
            escrowTransfer.disputeTransfer("b");
        }
        if (
            disputes[disputeIndex].votesForBuyer <
            disputes[disputeIndex].votesForSeller
        ) {
            escrowTransfer.disputeTransfer("s");
        }
    }

    //set listings
    function setListings(address _listings) public {
        listings = Listings(_listings);
    }
}
