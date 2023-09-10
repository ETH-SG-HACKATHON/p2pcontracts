// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Dispute {
    //state variables
    struct DisputeDetail {
        address buyer;
        address seller;
        uint256 amount;
        string paymentMethod;
        State state;
        uint256 votingPeriod;
        uint256 votesForBuyer;
        uint256 votesForSeller;
    }

    enum State {
        open,
        closed
    }

    DisputeDetail[] public disputes;

    //errors
    error DisputeAlreadyClosed();
    error OnlyBuyerOrSellerCanOpenDispute();

    function createDispute(
        address _buyer,
        address _seller,
        uint256 _amount,
        string calldata _paymentMethod
    ) public {
        DisputeDetail memory newDispute = DisputeDetail({
            buyer: _buyer,
            seller: _seller,
            amount: _amount,
            paymentMethod: _paymentMethod,
            state: State.open,
            votingPeriod: block.timestamp + 1 minutes,
            votesForBuyer: 0,
            votesForSeller: 0
        });

        disputes.push(newDispute);
    }

    function closeDispute(uint256 disputeIndex) public {
        require(
            disputes[disputeIndex].state == State.open,
            "Dispute is already closed"
        );
        require(
            msg.sender == disputes[disputeIndex].buyer ||
                msg.sender == disputes[disputeIndex].seller,
            "Only the buyer or seller can close the dispute"
        );

        // Update the state
        disputes[disputeIndex].state = State.closed;
    }

    function getDisputeCount() public view returns (uint256) {
        return disputes.length;
    }

    function getDispute(
        uint256 disputeIndex
    ) public view returns (address, address, uint256, string memory, State) {
        return (
            disputes[disputeIndex].buyer,
            disputes[disputeIndex].seller,
            disputes[disputeIndex].amount,
            disputes[disputeIndex].paymentMethod,
            disputes[disputeIndex].state
        );
    }

    function updateDisputeState(uint256 disputeIndex, State newState) public {
        require(
            disputes[disputeIndex].state == State.open,
            "Dispute is already closed"
        );
        require(
            msg.sender == disputes[disputeIndex].buyer ||
                msg.sender == disputes[disputeIndex].seller,
            "Only the buyer or seller can close the dispute"
        );

        // Update the state
        disputes[disputeIndex].state = newState;
    }

    function voteDispute(uint256 disputeIndex, State newState) public {
        //check that the dispute is open, revert with an error if not
        //check that the voting period has not ended, revert with an error if not
    }

    //b: buyer, s: seller
    function executeDispute(
        uint256 disputeIndex,
        string memory receiver
    ) public {
        //check that the dispute is open, revert with an error if not
        //check that the voting period has ended, revert with an error if not

        if (
            disputes[disputeIndex].votesForBuyer >
            disputes[disputeIndex].votesForSeller
        ) {
            receiver = "b";
        }
        if (
            disputes[disputeIndex].votesForBuyer <
            disputes[disputeIndex].votesForSeller
        ) {
            receiver = "s";
        }
    }
}
