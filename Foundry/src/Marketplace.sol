// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "openzeppelin-contracts/contracts/token/ERC721/IERC721.sol";
import "openzeppelin-contracts/contracts/utils/cryptography/ECDSA.sol";
import "openzeppelin-contracts/contracts/utils/Address.sol";

contract Marketplace {
    struct Listing {
        address payable seller;
        address tokenAddress;
        uint256 tokenId;
        uint256 price;
        bytes signature;
        uint256 deadline;
    }

    uint256 public listingCount;
    mapping(uint256 => Listing) public listings;

    event ListingCreated(
        address seller,
        address tokenAddress,
        uint256 tokenId,
        uint256 price
    );
    event ListingExecuted(uint256 listingId, address buyer, address seller);

    function createListing(
        address _tokenAddress,
        uint256 _tokenId,
        uint256 _price,
        bytes calldata _signature,
        uint256 _deadline
    ) external {
        // Owner checks
        require(
            IERC721(_tokenAddress).ownerOf(_tokenId) == msg.sender,
            "Not owner"
        );
        require(
            IERC721(_tokenAddress).isApprovedForAll(msg.sender, address(this)),
            "Not approved"
        );

        // Token address checks
        require(_tokenAddress != address(0), "Zero address, not valid");
        require(Address.isContract(_tokenAddress), "Not contract");

        // Price check
        require(_price > 0, "Price must be greater than zero");

        // Deadline check
        require(_deadline > block.timestamp, "Deadline must be in the future");

        // Sign
        bytes32 hash = keccak256(
            abi.encodePacked(
                _tokenAddress,
                _tokenId,
                _price,
                msg.sender,
                _deadline
            )
        );
        require(
            ECDSA.recover(hash, _signature) == msg.sender,
            "Invalid signature"
        );

        // Transfer NFT ownership to contract
        IERC721(_tokenAddress).safeTransferFrom(
            msg.sender,
            address(this),
            _tokenId
        );

        // Create listing
        listingCount++;
        listings[listingCount] = Listing(
            payable(msg.sender),
            _tokenAddress,
            _tokenId,
            _price,
            _signature,
            _deadline
        );

        // Emit event
        emit ListingCreated(msg.sender, _tokenAddress, _tokenId, _price);
    }

    function executeListing(uint256 _listingId) external payable {
        // Get listing
        Listing storage listing = listings[_listingId];

        // Listing must exist
        require(_listingId <= listingCount, "Invalid listing");

        // Check price
        require(msg.value == listing.price, "Incorrect price");

        // Check deadline
        require(block.timestamp <= listing.deadline, "Deadline passed");

        // Verify signature
        bytes32 hash = keccak256(
            abi.encodePacked(
                listing.tokenAddress,
                listing.tokenId,
                listing.price,
                listing.seller,
                listing.deadline
            )
        );
        require(
            ECDSA.recover(hash, listing.signature) == listing.seller,
            "Invalid signature"
        );

        // Transfer NFT ownership to buyer
        IERC721(listing.tokenAddress).safeTransferFrom(
            address(this),
            msg.sender,
            listing.tokenId
        );

        // Pay seller
        listing.seller.transfer(msg.value);

        // Emit event
        emit ListingExecuted(_listingId, msg.sender, listing.seller);

        // Delete listing
        delete listings[_listingId];
    }
}
