// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console2} from "forge-std/Script.sol";
import {Dispute} from "../src/Dispute.sol";
import {Listings} from "../src/Listings.sol";
import {EscrowFactoryContract} from "../src/EscrowFactory.sol";

contract Deploy is Script {
    function run() external {
        bytes32 D2P2P_SALT = bytes32(abi.encode(0x44325032503232)); // ~ "D2P2P"
        // string memory mnemonic = vm.envString("MNEMONIC");
        uint privKey = vm.envUint("PRIVATE_KEY");

        // uint256 privateKey = vm.deriveKey(mnemonic, 8);

        // set up deployer
        address deployer = vm.rememberKey(privKey);
        // log deployer data
        console2.log("Deployer: ", deployer);
        console2.log("Deployer Nonce: ", vm.getNonce(deployer));

        vm.startBroadcast(deployer);

        // deploy Listings contract
        Listings listings = new Listings(address(0));

        // deploy Dispute contract
        Dispute dispute = new Dispute(address(listings));

        // deploy EscrowFactory contract
        EscrowFactoryContract escrowFactory = new EscrowFactoryContract(
            address(dispute),
            address(listings)
        );

        // set escrowFactory address in listings contract
        listings.setEscrowFactory(address(escrowFactory));

        //create a new ad
        listings.createAd(
            "USDT",
            10000000000000000 wei,
            11,
            1694467313,
            "Bank Transfer",
            "John Doe",
            "123456789"
        );

        //use a different account to start a trade
        // uint256 privateKey2 = vm.deriveKey(mnemonic, 7);
        // address buyer = vm.rememberKey(privateKey2);
        // console2.log("Buyer: ", buyer);

        //start a trade as buyer
        // listings.startTrade(1);

        //create a new dispute
        dispute.createDispute(1);

        vm.stopBroadcast();

        // log deployment data
        console2.log("Listings Contract Address: ", address(listings));
        console2.log("Dispute Contract Address: ", address(dispute));
        console2.log(
            "EscrowFactory Contract Address: ",
            address(escrowFactory)
        );
    }
}
