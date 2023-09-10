// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

import {EscrowContract} from "../src/Escrow.sol";

contract EscrowTest is Test {
    EscrowContract escrow;
    address payable public someAdd =
        payable(0xCA35b7d915458EF540aDe6068dFe2F44E8fa733c);

    function setUp() public {
        uint256 _value = 100;
        address payable _seller = someAdd;
        address payable _buyer = payable(
            0x14723A09ACff6D2A60DcdF7aA4AFf308FDDC160C
        );

        escrow = new EscrowContract(
            _value,
            _buyer,
            _seller,
            1,
            someAdd
        );
    }

    // function testTransfer() public{
    //     escrow.deposit();
    // }


    function testDisputeTransfer() public{
        escrow.disputeTransfer("s");
        // assertEq("s", "s");

    }
}
