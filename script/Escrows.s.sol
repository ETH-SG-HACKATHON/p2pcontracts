// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console2} from "forge-std/Script.sol";
import {EscrowFactoryContract} from "../src/EscrowFactory.sol";

contract Deploy is Script {
    function run() external {
        address DISPUTE_CONTRACT_ADDRESS = address(0);
        address LISTING_CONTRACT_ADDRESS = 0xABC39C8550e42eF9bA6aaFAE47A27a2774977a5D;

        bytes32 ESCROWS_SALT = bytes32(
            abi.encode(0x44325032505f457363726f777333)
        ); // ~ "D2P2P_Escrows"

        // set up deployer
        uint256 privKey = vm.envUint("PRIVATE_KEY");
        address deployer = vm.rememberKey(privKey);
        // log deployer data
        console2.log("Deployer: ", deployer);
        console2.log("Deployer Nonce: ", vm.getNonce(deployer));

        vm.startBroadcast(deployer);

        // deploy AttestRecipient contract
        EscrowFactoryContract escrowFactory = new EscrowFactoryContract{
            salt: ESCROWS_SALT
        }(DISPUTE_CONTRACT_ADDRESS, LISTING_CONTRACT_ADDRESS);

        vm.stopBroadcast();

        // log deployment data
        console2.log(
            "Escrow Factory Contract Address: ",
            address(escrowFactory)
        );
    }
}
