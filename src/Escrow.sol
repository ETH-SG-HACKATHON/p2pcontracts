// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "./EscrowFactory.sol";

contract EscrowContract {
    address public escrowFactoryAddr;
    EscrowFactoryContract public escrowFactoryContract;

    // Declaring the state variables
    address payable public buyer;
    address payable public seller;
    // address payable public arbiter;
    // Declaring the object of the enumerator
    uint256 public adId;
    uint256 public value;

    State public state;

    constructor(
        uint256 _value,
        address payable _buyer,
        address payable _seller,
        uint256 _adId,
        address _escrowFactoryAddr
    ) {
        // Assigning the values of the state variables
        //arbiter = payable(msg.sender);
        value = _value;
        buyer = _buyer;
        seller = _seller;
        adId = _adId;
        escrowFactoryAddr = _escrowFactoryAddr;

        state = State.await_deposit;
    }

    // Defining a enumerator 'State'
    enum State {
        // Following are the data members
        await_deposit,
        await_confirmation,
        await_dispute, //dispute is called by the dispute contract
        completed //means bank Transfer Verified by the seller
    }

    //user control
    // Defining function modifier 'instate'
    modifier instate(State expected_state) {
        require(state == expected_state);
        _;
    }
    modifier onlyBuyer() {
        require(msg.sender != seller);
        _;
    }
    modifier onlyDispute() {
        EscrowFactoryContract escrowF = escrowFactoryContract(
            escrowFactoryAddr
        );
        require(msg.sender == escrowF.getDispute());
        _;
    }
    modifier onlyListing() {
        EscrowFactoryContract escrowF = escrowFactoryContract(
            escrowFactoryAddr
        );
        require(msg.sender == escrowF.getListing());
        _;
    }

    //asks seller to deposit the crypto as collateral
    function deposit() public payable onlyBuyer instate(State.await_deposit) {
        //seller transfer funds to not arbiter but store the funds inside the contract itself

        //move the contract state to wait for the seller to confirm the funds payment
        state = State.await_confirmation;
    }

    // function deposit() public payable onlyBuyer inState(State.Created) {
    //     require(
    //         msg.value == value,
    //         "Deposit amount must match the escrow value."
    //     );
    //     emit FundsDeposited(msg.sender, msg.value);
    //     state = State.Locked;
    // }

    //Confirm payment function will trasnfer the crypto funds to the buyer when Seller Confirms the payment
    // from escrow contract send funds to the buyer
    function buyerTransfer()
        public
        payable
        onlyListing
        instate(State.await_confirmation)
    {
        seller.transfer(value); //transfer to buyer

        state = State.completed;
    }

    //Dispute Transfer function can only be called by the dispute contract
    //b for buyer, s for seller
    function disputeTransfer(
        string calldata winner
    ) public onlyDispute instate(State.await_confirmation) {
        if (winner == "s") {
            //send funds to seller
        } else {
            //winner is b, send funds to buyer
        }
    }
}
//how to send the funds from buyerinto the escrow contract
//how to send the funds from contract
