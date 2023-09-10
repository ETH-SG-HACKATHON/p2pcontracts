// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

//This contract is used to track ads for selling crypto to fiat
contract Listings {
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
        uint256 amount;
        string paymentMethod;
        State state;
    }

    //list of ads
    SellAd[] public ads;

    error AmountLessThanZero();
    error NotSeller();
    error TradeNotInProgress();
    error BankTransferNotVerified();

    // function addressHasValue(
    //     address _walletAddress,
    //     uint256 value
    // ) public view returns (bool) {
    //     uint256 usdtBalance = usdtToken.balanceOf(_walletAddress);

    //     // Check if the balance is more than 100 USDT (with 6 decimal places)
    //     // that means that the address doesnt have that ammount
    //     if (usdtBalance < value) {
    //         return true;
    //     } else {
    //         return false;
    //     }
    // }

    function createAd(uint256 _amount, string calldata paymentMethod) public {
        //include require statements to check if the amount is greater than 0
        if (_amount <= 0) {
            revert AmountLessThanZero();
        }

        //create a new ad
        SellAd memory newAd = SellAd({
            seller: msg.sender,
            amount: _amount,
            paymentMethod: paymentMethod,
            state: State.openForTrade
        });

        ads.push(newAd);
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
        return ads.length;
    }

    function getAd(uint256 adIndex) public view returns (SellAd memory) {
        return (ads[adIndex]);
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

        //call the transfer function on escrow contract

        //update the state here to adClosed
        ads[adIndex].state = State.adClosed;
    }
}
