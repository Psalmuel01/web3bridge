// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

// import "openzeppelin-contracts/contracts/token/ERC721/IERC721.sol";
// import "openzeppelin-contracts/contracts/utils/cryptography/ECDSA.sol";
// import "openzeppelin-contracts/contracts/utils/Address.sol";

// contract Marketplace {
//     struct Listing {
//         address token;
//         uint256 tokenId;
//         uint256 price;
//         bytes sig;
//         //slot3
//         uint256 deadline; //uint88?
//         address lister;
//         bool active;
//     }

//     error NotOwner();
//     error NotApproved();
//     error AddressZero();
//     error NoCode();
//     error MinPricedTooLow();
//     error DeadlineTooSoon();
//     error MinDurationNotMet();
//     error InvalidSignature();

//     error ListingNotExistent();
//     error ListingNotActive();
//     error PriceNotMet(uint256 difference);
//     error PriceMismatch(originalPrice); //why?
//     error ListingExpired();

//     mapping(uint256 => Listing) public listings;
//     address public admin;
//     uint256 public listingId;

//     constructor() {
//         admin = msg.sender;
//     }

//     function createListing(Listing calldata l) public {
//         //made returns(uint256 lid)
//         if (IERC721(l.token).ownerOf(l.tokenId) != msg.sender)
//             revert NotOwner();
//         if (!IERC721(l.token).isApprovedForAll(msg.sender, address(this)))
//             //confirm!
//             revert NotApproved();
//         if (l.token == address(0)) revert AddressZero();
//         if (l.price < 0.01 ether) revert MinPricedTooLow();
//         if (l.token.code.length == 0) revert NoCode();
//         if (l.deadline < block.timestamp) revert DeadlineTooSoon();
//         if (l.deadline - block.timestamp < 1 days) revert MinDurationNotMet();

//         //assert signature
//         bytes32 hash = keccak256(
//             abi.encodePacked(
//                 l.token,
//                 l.tokenId,
//                 l.price,
//                 msg.sender,
//                 l.deadline
//             )
//         );
//         if (!ECDSA.recover(hash, l.sig) != l.lister) revert InvalidSignature();

//         //append to storage
//         Listing storage listing = listings[listingId];
//         listing = Listing(
//             l.lister,
//             l.token,
//             l.tokenId,
//             l.price,
//             l.sig,
//             l.deadline
//         );
//         listingId++;
//     }

//     function executeListing(uint256 _listingId) public payable {
//         if (_listingId >= listingId) revert ListingNotExistent();
//         Listing storage listing = listings[_listingId];
//         if (listing.deadline < block.timestamp) revert ListingExpired();
//         if (!listing.active) revert ListingNotActive();
//         if (listing.price > msg.value)
//             revert PriceNotMet(listing.price - msg.value);
//         if (listing.price != msg.value) revert PriceMismatch(listing.price);
//         //update state
//         listing.active = false;
//         //transfer
//         IERC721(listing.token).transferFrom(
//             listing.lister,
//             msg.sender,
//             listing.tokenId
//         );
//         //transferETH
//         payable(listing.lister).transfer(listing.price);
//     }

//     function editListing(uint256 _listingId, uint256 newPrice) public {
//         if (_listingId >= listingId) revert ListingNotExistent();
//         Listing storage listing = listings[_listingId];
//         if (listing.lister != msg.sender) revert NotOwner();
//         listing.price = newPrice;
//         listing.active = true;
//     }

//     function getListing(
//         uint256 _listingId
//     ) public view returns (Listing memory) {
//         if (_listingId >= listingId) return listings[_listingId];
//     }

//     // function cancelListing(uint256 _listingId) public {
//     //     if (_listingId >= listingId) revert ListingNotExistent();
//     //     Listing storage listing = listings[_listingId];
//     //     if (listing.seller != msg.sender) revert NotOwner();
//     //     listing.active = false;
//     // }
// }

// // uint256 public listingCount;
// // event ListingCreated(
// //     address seller,
// //     address token,
// //     uint256 tokenId,
// //     uint256 price
// // );
// // event ListingExecuted(uint256 listingId, address buyer, address seller);

// // function createListing(_token, uint256 _tokenId, uint256 _price, bytes _sig, uint256 _deadline) public {
// // Checks
// // require(IERC721(l.token).ownerOf(l.tokenId) == msg.sender, "Not owner");
// // require(
// //     IERC721(l.token).isApprovedForAll(msg.sender, address(this)),
// //     "Not approved"
// // );
// // require(l.token != address(0), "Zero address, not valid");
// // require(Address.isContract(l.token), "Not contract");
// // require(_price > 0, "Price must be greater than zero");
// // require(_deadline > block.timestamp, "Deadline must be in the future");
// // Sign
// // bytes32 hash = keccak256(
// //     abi.encodePacked(_token, _tokenId, _price, msg.sender, _deadline)
// // );
// // require(ECDSA.recover(hash, _sig) == msg.sender, "Invalid sig");
// // Transfer NFT ownership to contract
// // IERC721(_token).safeTransferFrom(msg.sender, address(this), _tokenId);
// // Create listing
// // listingCount++;
// // listings[listingCount] = Listing(
// //     msg.sender,
// //     _token,
// //     _tokenId,
// //     _price,
// //     _sig,
// //     _deadline
// // );
// // Emit event
// // emit ListingCreated(msg.sender, _token, _tokenId, _price);
// // }

// //     function executeListing(uint256 _listingId) external payable {
// //         // Get listing
// //         Listing storage listing = listings[_listingId];

// //         // Listing must exist
// //         require(_listingId <= listingCount, "Invalid listing");

// //         // Check price
// //         require(msg.value == listing.price, "Incorrect price");

// //         // Check deadline
// //         require(block.timestamp <= listing.deadline, "Deadline passed");

// //         // Verify sig
// //         bytes32 hash = keccak256(
// //             abi.encodePacked(
// //                 listing.token,
// //                 listing.tokenId,
// //                 listing.price,
// //                 listing.seller,
// //                 listing.deadline
// //             )
// //         );
// //         require(
// //             ECDSA.recover(hash, listing.sig) == listing.seller,
// //             "Invalid sig"
// //         );

// //         // Transfer NFT ownership to buyer
// //         IERC721(listing.token).safeTransferFrom(
// //             address(this),
// //             msg.sender,
// //             listing.tokenId
// //         );

// //         // Pay seller
// //         listing.seller.transfer(msg.value);

// //         // Emit event
// //         emit ListingExecuted(_listingId, msg.sender, listing.seller);

// //         // Delete listing
// //         delete listings[_listingId];
// //     }
