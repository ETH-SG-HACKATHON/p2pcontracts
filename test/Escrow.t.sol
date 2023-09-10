// // SPDX-License-Identifier: UNLICENSED
// pragma solidity ^0.8.13;

// import "forge-std/Test.sol";
// import {Post} from "../src/Post.sol";

// contract PostTest is Test {
//     Post post;

//     //define constants

//     function setUp() public {
//         post = new Post();
//     }

//     // Test case 1: Test Post Creation
//     function testCreatePost() public {
//         string memory content = "This is a test post!";
//         uint256 date = 1677645600; // some arbitrary date
//         string memory sector = "Tech";

//         post.createPost(content, date, sector);

//         Post.PostStruct memory retrievedPost = post.getPost(1);

//         assertEq(retrievedPost.postContent, content);
//         assertEq(retrievedPost.postDate, date);
//         assertEq(retrievedPost.postCreator, address(this));
//         assertEq(retrievedPost.postSector, sector);
//     }

//     // Test case 2: Test Multiple Post Retrieval
//     function testMultiplePosts() public {
//         string memory content1 = "First test post!";
//         uint256 date1 = 1677645600; // some arbitrary date
//         string memory sector1 = "Tech";

//         string memory content2 = "Second test post!";
//         uint256 date2 = 1677646700; // another arbitrary date
//         string memory sector2 = "Finance";

//         post.createPost(content1, date1, sector1);
//         post.createPost(content2, date2, sector2);

//         Post.PostStruct memory retrievedPost1 = post.getPost(1);
//         Post.PostStruct memory retrievedPost2 = post.getPost(2);

//         assertEq(retrievedPost1.postContent, content1);
//         assertEq(retrievedPost1.postDate, date1);
//         assertEq(retrievedPost1.postSector, sector1);

//         assertEq(retrievedPost2.postContent, content2);
//         assertEq(retrievedPost2.postDate, date2);
//         assertEq(retrievedPost2.postSector, sector2);
//     }

//     // Test case 3: Test Post Validation
//     function testFailInvalidPostContent() public {
//         string memory content = "";
//         uint256 date = 1677645600; // some arbitrary date
//         string memory sector = "Tech";

//         post.createPost(content, date, sector);
//     }

//     function testFailInvalidPostDate() public {
//         string memory content = "Invalid Date Post!";
//         uint256 date = 0;
//         string memory sector = "Tech";

//         post.createPost(content, date, sector);
//     }
// }