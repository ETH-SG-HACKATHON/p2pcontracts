// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import {Listings} from "../src/Listings.sol";

contract ListingsTest is Test {
    Listings listings;
    address internal constant DISPUTE_CONTRACT_ADDR = address(0);

    //define constants

    function setUp() public {
        listings = new Listings(address(0));
    }

    function testCreateAd() public {
        string memory _token = "ETH";
        uint256 _amount = 100;
        uint256 _price = 100;
        uint256 _duration = 100;
        string memory _paymentMethod = "BCA";
        string memory _name = "John Doe";
        string memory _accountNumber = "1234567890";

        listings.createAd(
            _token,
            _amount,
            _price,
            _duration,
            _paymentMethod,
            _name,
            _accountNumber
        );

        Listings.SellAd memory retrievedAd = listings.getAd(0);

        assertEq(retrievedAd.amount, _amount);
        assertEq(retrievedAd.paymentMethod, _paymentMethod);
        assertEq(retrievedAd.seller, address(this));
    }

    function testGetAdCount() public {
        string memory _token = "ETH";
        uint256 _amount = 100;
        uint256 _price = 100;
        uint256 _duration = 100;
        string memory _paymentMethod = "BCA";
        string memory _name = "John Doe";
        string memory _accountNumber = "1234567890";

        listings.createAd(
            _token,
            _amount,
            _price,
            _duration,
            _paymentMethod,
            _name,
            _accountNumber
        );
        assertEq(listings.getAdCount(), 1);
    }

    function testGetAd() public {
        string memory _token = "ETH";
        uint256 _amount = 100;
        uint256 _price = 100;
        uint256 _duration = 100;
        string memory _paymentMethod = "BCA";
        string memory _name = "John Doe";
        string memory _accountNumber = "1234567890";

        listings.createAd(
            _token,
            _amount,
            _price,
            _duration,
            _paymentMethod,
            _name,
            _accountNumber
        );

        Listings.SellAd memory retrievedAd = listings.getAd(0);

        assertEq(retrievedAd.amount, _amount);
        assertEq(retrievedAd.paymentMethod, _paymentMethod);
        assertEq(retrievedAd.seller, address(this));
    }

    //function to test if the buyer can show interest in an ad
    function testShowInterest() public {
        uint256 adIndex = 0;
        listings.showInterest(adIndex);

        assertEq(listings.getInterestedBuyers(adIndex), address(this));
    }

    function testVerifyBankTransfer() public {
        string memory _token = "ETH";
        uint256 _amount = 100;
        uint256 _price = 100;
        uint256 _duration = 100;
        string memory _paymentMethod = "BCA";
        string memory _name = "John Doe";
        string memory _accountNumber = "1234567890";

        listings.createAd(
            _token,
            _amount,
            _price,
            _duration,
            _paymentMethod,
            _name,
            _accountNumber
        );

        listings.verifyBankTransfer(0);

        Listings.SellAd memory retrievedAd = listings.getAd(0);

        // assertEq(retrievedAd.state, Listings.State.bankTransferVerified);
    }

    function testFailCannotCloseAd() public {
        uint256 adIndex = 0;

        listings.closeAd(adIndex);
    }
}
