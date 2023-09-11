// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console2} from "forge-std/Script.sol";
import {Listings} from "../src/Listings.sol";

contract Deploy is Script {
    function run() external {
        address ESCROW_FACTORY_CONTRACT_ADDRESS = address(0);

        bytes32 POST_SALT = bytes32(abi.encode(0x44325032505f4c697374696e6773)); // ~ "D2P2P_Listings"

        // set up deployer
        uint256 privKey = vm.envUint("PRIVATE_KEY");
        address deployer = vm.rememberKey(privKey);
        // log deployer data
        console2.log("Deployer: ", deployer);
        console2.log("Deployer Nonce: ", vm.getNonce(deployer));

        vm.startBroadcast(deployer);

        // deploy AttestRecipient contract
        Listings listings = new Listings(ESCROW_FACTORY_CONTRACT_ADDRESS);

        vm.stopBroadcast();

        // log deployment data
        console2.log("Listings Contract Address: ", address(listings));
    }
}
