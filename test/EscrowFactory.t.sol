// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import {EscrowFactoryContract} from "../src/EscrowFactory.sol";
//import console log
import "forge-std/console.sol";

contract EscrowFactoryTest is Test {
    EscrowFactoryContract escrowFac;
    address payable public someAdd =
        payable(0xCA35b7d915458EF540aDe6068dFe2F44E8fa733c);

    function setUp() public {
        escrowFac = new EscrowFactoryContract(someAdd, someAdd);
    }

    //Test case 1: Create Escrow
    function testCreateEscrow() public {
        uint256 _value = 100;
        address payable _seller = someAdd;
        address payable _buyer = payable(
            0x14723A09ACff6D2A60DcdF7aA4AFf308FDDC160C
        );
        uint256 _adId = 2;

        escrowFac.createEscrow(_value, _seller, _buyer, _adId);
        // assertNotEq(escrowFac.deployedEscrows, address(0));
        console.logAddress(escrowFac.deployedEscrows(0));
        console.logAddress(escrowFac.adToEscrow(1));
        // assertEq(escrowFac.adToEscrow(1), escrowFac.deployedEscrows(0));
    }

    // // Test case 1: Test Post Creation
    // function testCreatePost() public {
    //     string memory content = "This is a test post!";
    //     uint256 date = 1677645600; // some arbitrary date
    //     string memory sector = "Tech";

    //     post.createPost(content, date, sector);

    //     Post.PostStruct memory retrievedPost = post.getPost(1);

    //     assertEq(retrievedPost.postContent, content);
    //     assertEq(retrievedPost.postDate, date);
    //     assertEq(retrievedPost.postCreator, address(this));
    //     assertEq(retrievedPost.postSector, sector);
    // }

    // //P2P Test case 1: escrow contract recieve funds from buyer
    // function testCreatePost() public {
    //     string memory content = "This is a test post!";
    //     uint256 date = 1677645600; // some arbitrary date
    //     string memory sector = "Tech";

    //     post.createPost(content, date, sector);

    //     Post.PostStruct memory retrievedPost = post.getPost(1);

    //     assertEq(retrievedPost.postContent, content);
    //     assertEq(retrievedPost.postDate, date);
    //     assertEq(retrievedPost.postCreator, address(this));
    //     assertEq(retrievedPost.postSector, sector);
    // }

    // // Test case 2: Test Multiple Post Retrieval
    // function testMultiplePosts() public {
    //     string memory content1 = "First test post!";
    //     uint256 date1 = 1677645600; // some arbitrary date
    //     string memory sector1 = "Tech";

    //     string memory content2 = "Second test post!";
    //     uint256 date2 = 1677646700; // another arbitrary date
    //     string memory sector2 = "Finance";

    //     post.createPost(content1, date1, sector1);
    //     post.createPost(content2, date2, sector2);

    //     Post.PostStruct memory retrievedPost1 = post.getPost(1);
    //     Post.PostStruct memory retrievedPost2 = post.getPost(2);

    //     assertEq(retrievedPost1.postContent, content1);
    //     assertEq(retrievedPost1.postDate, date1);
    //     assertEq(retrievedPost1.postSector, sector1);

    //     assertEq(retrievedPost2.postContent, content2);
    //     assertEq(retrievedPost2.postDate, date2);
    //     assertEq(retrievedPost2.postSector, sector2);
    // }

    // // Test case 3: Test Post Validation
    // function testFailInvalidPostContent() public {
    //     string memory content = "";
    //     uint256 date = 1677645600; // some arbitrary date
    //     string memory sector = "Tech";

    //     post.createPost(content, date, sector);
    // }

    // function testFailInvalidPostDate() public {
    //     string memory content = "Invalid Date Post!";
    //     uint256 date = 0;
    //     string memory sector = "Tech";

    //     post.createPost(content, date, sector);
    // }
}
