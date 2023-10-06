// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

// import {Test, console2} from "forge-std/Test.sol";
// import {Marketplace} from "../src/Marketplace.sol";
// import "openzeppelin-contracts/contracts/token/ERC721/IERC721.sol";

// contract TestMarketplace {
//     Marketplace marketplace;

//     function setUp() public {
//         marketplace = new Marketplace();
//     }

//     function testCreateListing() public {
//         // Create a new listing
//         address tokenAddress = address(this);
//         uint256 tokenId = 1;
//         uint256 price = 100;
//         bytes memory signature = "test";
//         uint256 deadline = block.timestamp + 3600;
//         marketplace.createListing(
//             tokenAddress,
//             tokenId,
//             price,
//             signature,
//             deadline
//         );

//         // Check that the listing was created
//         uint256 listingCount = marketplace.listingCount();
//         assertEq(listingCount, 1, "Listing count should be 1");

//         Marketplace.Listing memory listing = marketplace.listings(listingCount);
//         assertEq(
//             listing.seller,
//             address(this),
//             "Seller should be this contract"
//         );
//         assertEq(
//             listing.tokenAddress,
//             tokenAddress,
//             "Token address should be correct"
//         );
//         assertEq(listing.tokenId, tokenId, "Token ID should be correct");
//         assertEq(listing.price, price, "Price should be correct");
//         assertEq(listing.signature, signature, "Signature should be correct");
//         assertEq(listing.deadline, deadline, "Deadline should be correct");
//     }

//     function testExecuteListing() public payable {
//         // Create a new listing
//         address tokenAddress = address(this);
//         uint256 tokenId = 1;
//         uint256 price = 100;
//         bytes memory signature = "test";
//         uint256 deadline = block.timestamp + 3600;
//         marketplace.createListing(
//             tokenAddress,
//             tokenId,
//             price,
//             signature,
//             deadline
//         );

//         // Execute the listing
//         uint256 listingId = 1;
//         address payable buyer = payable(address(this));
//         address payable seller = payable(address(marketplace));
//         uint256 initialBalance = seller.balance;
//         marketplace.executeListing{value: price}(listingId);

//         // Check that the listing was executed
//         uint256 listingCount = marketplace.listingCount();
//         assertEq(listingCount, 0, "Listing count should be 0");

//         Marketplace.Listing memory listing = marketplace.listings(listingId);
//         assertEq(listing.seller, address(0), "Seller should be zero address");

//         // Check that the NFT ownership was transferred to the buyer
//         assertEq(
//             IERC721(tokenAddress).ownerOf(tokenId),
//             address(this),
//             "NFT ownership should be transferred to buyer"
//         );

//         // Check that the seller was paid
//         uint256 finalBalance = seller.balance;
//         assertEq(
//             finalBalance - initialBalance,
//             price,
//             "Seller should be paid the correct amount"
//         );
//     }

//     function assertEq(
//         uint256 actual,
//         uint256 expected,
//         string memory message
//     ) internal pure {
//         require(actual == expected, message);
//     }
// }
