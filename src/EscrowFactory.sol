// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "./Escrow.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract EscrowFactoryContract {
    address[] public deployedEscrows;

    address public disputeContract;
    address public listingContract;

    mapping(uint256 => address) public adToEscrow;

    error escrowExists(uint256 _adId);

    function addressHasValue(
        address _walletAddress,
        uint256 value
    ) public view returns (bool) {
        uint256 usdtBalance = usdtToken.balanceOf(_walletAddress);

        // Check if the balance is more than 100 USDT (with 6 decimal places)
        // that means that the address doesnt have that ammount
        if (usdtBalance < value) {
            return true;
        } else {
            return false;
        }
    }

    function createEscrow(
        uint256 _value,
        address _seller,
        address _buyer,
        uint256 _adId,
        address _escrowFactoryContract
    ) public {
        //check if sell listing is still available
        if (adToEscrow[_adId] != address(0)) {
            revert escrowExists(_adId);
        }

        //check if seller still has the ammount of funds
        if (addressHasValue(_seller, _value)) {
            revert escrowExists(_adId);
        }

        //check if the buyer != the seller
        if (_seller == _buyer) {
            revert escrowExists(_adId);
        }

        address newEscrow = address(
            new Escrow(_value, _buyer, _seller, _adId, _escrowFactoryContract)
        );

        deployedEscrows.push(newEscrow);
        adToescrow[_adId] = newEscrow;
    }

    function getDeployedEscrows() public view returns (address[] memory) {
        return deployedEscrows;
    }

    //check if the buyer != the seller
    //check if seller still has the ammount of funds
    //DONE check if sell listing is still available

    function changeDispute(address disputeAddress) {
        disputeContract = disputeAddress;
    }

    function getDispute() {
        return disputeContract;
    }

    function changeListing(address listingAddress) {
        listingContract = listingAddress;
    }

    function getListing() {
        return listingContract;
    }
}
