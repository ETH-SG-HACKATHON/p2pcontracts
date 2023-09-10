// // SPDX-License-Identifier: UNLICENSED
// pragma solidity ^0.8.13;

// import "forge-std/Test.sol";
// import {Listings} from "../src/Listings.sol";

// contract ListingsTest is Test {
//     Listings listings;
//     address internal constant DISPUTE_CONTRACT_ADDR = address(0);

//     //define constants

//     function setUp() public {
//         listings = new Listings();
//     }

//     function testCreateAd() public {
//         uint256 _amount = 100;
//         string memory _paymentMethod = "Bank Transfer";

//         listings.createAd(_amount, _paymentMethod);

//         Listings.SellAd memory retrievedAd = listings.getAd(0);

//         assertEq(retrievedAd.amount, _amount);
//         assertEq(retrievedAd.paymentMethod, _paymentMethod);
//         assertEq(retrievedAd.seller, address(this));
//     }

//     function testGetAdCount() public {
//         uint256 _amount = 100;
//         string memory _paymentMethod = "Bank Transfer";

//         listings.createAd(_amount, _paymentMethod);

//         assertEq(listings.getAdCount(), 1);
//     }

//     function testGetAd() public {
//         uint256 _amount = 100;
//         string memory _paymentMethod = "Bank Transfer";

//         listings.createAd(_amount, _paymentMethod);

//         Listings.SellAd memory retrievedAd = listings.getAd(0);

//         assertEq(retrievedAd.amount, _amount);
//         assertEq(retrievedAd.paymentMethod, _paymentMethod);
//         assertEq(retrievedAd.seller, address(this));
//     }

//     function testVerifyBankTransfer() public {
//         uint256 _amount = 100;
//         string memory _paymentMethod = "Bank Transfer";

//         listings.createAd(_amount, _paymentMethod);

//         listings.verifyBankTransfer(0);

//         Listings.SellAd memory retrievedAd = listings.getAd(0);

//         assertEq(retrievedAd.state, Listings.State.bankTransferVerified);
//     }

//     function testFailCannotCloseAd() public {
//         uint256 adIndex = 0;

//         listings.closeAd(adIndex);
//     }
// }
