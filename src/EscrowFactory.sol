// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "./Escrow.sol";

// import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract EscrowFactoryContract {
    address[] public deployedEscrows;

    address public disputeContract;
    address public listingContract;

    constructor(address _disputeContract, address _listingContract) {
        disputeContract = _disputeContract;
        listingContract = _listingContract;
    }

    mapping(uint256 => address) public adToEscrow;

    error escrowExists(uint256 _adId);

    function createEscrow(
        uint256 _value, //amount from listing
        address payable _seller, // get from listing
        address payable _buyer, //msg.sender
        uint256 _adId //id from listing
    ) public {
        //check if sell listing is still available
        if (adToEscrow[_adId] != address(0)) {
            revert escrowExists(_adId);
        }

        // //check if seller still has the ammount of funds
        // if (addressHasValue(_seller, _value)) {
        //     revert escrowExists(_adId);
        // }

        //check if the buyer != the seller
        // if (_seller == _buyer) {
        //     revert escrowExists(_adId);
        // }

        address newEscrow = address(
            new EscrowContract(_value, _buyer, _seller, _adId, address(this))
        );

        deployedEscrows.push(newEscrow);
        adToEscrow[_adId] = newEscrow;
    }

    function getDeployedEscrows() public view returns (address[] memory) {
        return deployedEscrows;
    }

    //check if the buyer != the seller
    //check if seller still has the ammount of funds
    //DONE check if sell listing is still available

    function changeDispute(address disputeAddress) public {
        disputeContract = disputeAddress;
    }

    function changeListing(address listingAddress) public {
        listingContract = listingAddress;
    }

    function getDispute() public view returns (address) {
        return disputeContract;
    }

    function getListing() public view returns (address) {
        return listingContract;
    }
}
