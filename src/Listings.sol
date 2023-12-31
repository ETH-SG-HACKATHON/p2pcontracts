// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "./EscrowFactory.sol";
import {Counters} from "@openzeppelin/contracts/utils/Counters.sol";

// //This contract is used to track ads for selling crypto to fiat
contract Listings {
    EscrowFactoryContract public escrowFactory;

    //enum to track the ad status
    enum State {
        // Following are the data members
        openForTrade,
        adInProgress,
        bankTransferVerified,
        adClosed
    }

    //     //state variables, to reconfirm what data we need
    struct SellAd {
        address seller;
        string token;
        uint256 amount;
        uint256 price;
        uint256 duration;
        string paymentMethod;
        string name;
        string accountNumber;
        State state;
        address deployedEscrow;
    }

    using Counters for Counters.Counter;
    Counters.Counter private _adIds;

    //list of ads
    mapping(uint256 => SellAd) public ads;

    error AmountLessThanZero();
    error NotSeller();
    error NotBuyer();
    error TradeNotOpen();
    error TradeInProgress();
    error TradeNotInProgress();
    error BankTransferNotVerified();

    //constructor
    constructor(address _escrowFactory) {
        escrowFactory = EscrowFactoryContract(_escrowFactory);
    }

    function createAd(
        string memory _token,
        uint _amount,
        uint _price,
        uint256 _duration,
        string memory _paymentMethod,
        string memory _name,
        string memory _accountNumber
    ) public {
        //TODO: add modifier to check if the address has value
        //include require statements to check if the amount is greater than 0
        if (_amount <= 0) {
            revert AmountLessThanZero();
        }

        _adIds.increment();
        uint256 postId = _adIds.current();

        //create a new ad
        SellAd memory newAd = SellAd({
            seller: msg.sender,
            token: _token,
            amount: _amount,
            price: _price,
            duration: _duration,
            paymentMethod: _paymentMethod,
            name: _name,
            accountNumber: _accountNumber,
            state: State.openForTrade,
            deployedEscrow: address(0)
        });

        //add the ad to the mapping
        ads[postId] = newAd;
    }

    //can only be called by the buyer
    function startTrade(uint256 adIndex) public {
        if (ads[adIndex].state == State.adInProgress) {
            revert TradeInProgress();
        }

        if (msg.sender == ads[adIndex].seller) {
            revert NotBuyer();
        }

        //Call the deployEscrow function here
        address newEscrow = escrowFactory.createEscrow(
            ads[adIndex].amount,
            payable(ads[adIndex].seller),
            payable(msg.sender),
            adIndex
        );

        //update the deployedEscrow address in the ad
        ads[adIndex].deployedEscrow = newEscrow;

        // Update the state
        ads[adIndex].state = State.adInProgress;
    }

    function verifyBankTransfer(uint256 adIndex) public {
        if (ads[adIndex].state != State.adInProgress) {
            revert TradeNotInProgress();
        }
        if (msg.sender != ads[adIndex].seller) {
            revert NotSeller();
        }

        // Update the state
        ads[adIndex].state = State.bankTransferVerified;

        //call the transfer function on escrow contract by detecting the address of the escrow contract
        address escrowContractAddr = escrowFactory.getDeployedEscrowByAdId(
            adIndex
        );
        EscrowContract escrowContract = EscrowContract(escrowContractAddr);
        escrowContract.transferBuyer();

        //update the state here to adClosed
        ads[adIndex].state = State.adClosed;
    }

    function closeAd(uint256 adIndex) public {
        if (ads[adIndex].state == State.bankTransferVerified) {
            revert BankTransferNotVerified();
        }
        if (msg.sender != ads[adIndex].seller) {
            revert NotSeller();
        }

        // Update the state
        ads[adIndex].state = State.adClosed;
    }

    function getAdCount() public view returns (uint256) {
        return _adIds.current();
    }

    function getAd(uint256 adIndex) public view returns (SellAd memory) {
        return ads[adIndex];
    }

    // Get all posts with pagination
    function getAds(
        uint256 page,
        uint256 perPage
    ) public view returns (SellAd[] memory) {
        uint256 offset = page * perPage;
        uint256 size = perPage;
        if (offset + perPage > _adIds.current()) {
            size = _adIds.current() - offset;
        }
        SellAd[] memory result = new SellAd[](size);
        for (uint256 i = 0; i < size; i++) {
            result[i] = ads[offset + i + 1];
        }
        return result;
    }

    function setEscrowFactory(address _escrowFactory) public {
        escrowFactory = EscrowFactoryContract(_escrowFactory);
    }
}
