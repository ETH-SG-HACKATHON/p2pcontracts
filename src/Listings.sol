// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "./EscrowFactory.sol";
import {Counters} from "@openzeppelin/contracts/utils/Counters.sol";

//This contract is used to track ads for selling crypto to fiat
contract Listings {
    EscrowFactoryContract public escrowFactory;

    //TODO: modifier to check that the address has value

    //enum to track the ad status
    enum State {
        // Following are the data members
        openForTrade,
        adInProgress,
        bankTransferVerified,
        adClosed
    }

    //state variables, to reconfirm what data we need
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
    }

    using Counters for Counters.Counter;
    Counters.Counter private _adIds;

    //list of ads
    mapping(uint256 => SellAd) public ads;

    //mapping of ad Ids to confirmed buyers
    mapping(uint256 => address) public confirmedBuyer;

    //mapping of adIds to interested buyers
    mapping(uint256 => address[]) public interestedBuyers;

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
        uint256 _amount,
        uint256 _price,
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
            state: State.openForTrade
        });

        //add the ad to the mapping
        ads[postId] = newAd;
    }

    //function where a buyer can show interest in an ad
    function showInterest(uint256 adIndex) public {
        if (ads[adIndex].state != State.openForTrade) {
            revert TradeNotOpen();
        }

        //buyer cannot be seller
        if (msg.sender == ads[adIndex].seller) {
            revert NotBuyer();
        }

        //add the buyer to the mapping
        interestedBuyers[adIndex].push(msg.sender);
    }

    //function where the seller confirms the buyer
    function confirmBuyer(uint256 adIndex, address buyer) public {
        if (msg.sender == ads[adIndex].seller) {
            revert NotBuyer();
        }

        //check if the buyer is in the interestedBuyers mapping
        bool isInterested = false;
        for (uint256 i = 0; i < interestedBuyers[adIndex].length; i++) {
            if (interestedBuyers[adIndex][i] == buyer) {
                isInterested = true;
                break;
            }
        }

        if (!isInterested) {
            revert NotBuyer();
        }

        //add the buyer to the mapping
        confirmedBuyer[adIndex] = buyer;
    }

    //can only be called by the buyer
    function startTrade(uint256 adIndex) public {
        if (ads[adIndex].state == State.adInProgress) {
            revert TradeInProgress();
        }

        if (msg.sender == ads[adIndex].seller) {
            revert NotBuyer();
        }

        //check if the buyer is in the interestedBuyers mapping
        if (msg.sender != confirmedBuyer[adIndex]) {
            revert NotBuyer();
        }

        //Call the deployEscrow function here
        escrowFactory.createEscrow(
            ads[adIndex].amount,
            payable(ads[adIndex].seller),
            payable(confirmedBuyer[adIndex]),
            adIndex
        );

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
        address escrowContractAddr = payable(
            escrowFactory.getDeployedEscrowByAdId(adIndex)
        );
        EscrowContract escrowContract = EscrowContract(escrowContractAddr);
        escrowContract.buyerTransfer();

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

    function getInterestedBuyers(
        uint256 adIndex
    ) public view returns (address[] memory) {
        return interestedBuyers[adIndex];
    }

    function getConfirmedBuyer(uint256 adIndex) public view returns (address) {
        return confirmedBuyer[adIndex];
    }

    function setEscrowFactory(address _escrowFactory) public {
        escrowFactory = EscrowFactoryContract(_escrowFactory);
    }
}
