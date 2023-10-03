pragma solidity ^0.8.0;


import {Test, console2} from "forge-std/Test.sol";
import {Marketplace} from "../src/Marketplace.sol";

contract TestMarketplace is Test {
    Marketplace marketplace;

    function beforeEach() public {
        marketplace = new Marketplace();
    }

    function testCreateOrder() public {
        address creator = address(0x123);
        address tokenAddress = address(0x456);
        uint256 tokenId = 123;
        uint256 price = 100;
        bytes32 signature = bytes32(0x789);
        uint256 deadline = block.timestamp + 3600;

        marketplace.createOrder(
            creator,
            tokenAddress,
            tokenId,
            price,
            signature,
            deadline
        );

        Marketplace.Order memory order = marketplace.orders(tokenId);

        assertEq(order.creator, msg.sender, "Creator should be the caller");
        assertEq(
            order.tokenAddress,
            tokenAddress,
            "Token address should match"
        );
        assertEq(order.tokenId, tokenId, "Token ID should match");
        assertEq(order.price, price, "Price should match");
        assertEq(order.signature, signature, "Signature should match");
        assertEq(order.deadline, deadline, "Deadline should match");
    }

    function testExecuteOrder() public {
        address creator = address(0x123);
        address buyer = address(0x456);
        address tokenAddress = address(0x789);
        uint256 tokenId = 123;
        uint256 price = 100;
        bytes32 signature = bytes32(0xabc);
        uint256 deadline = block.timestamp + 3600;

        // Create the order
        marketplace.createOrder(
            creator,
            tokenAddress,
            tokenId,
            price,
            signature,
            deadline
        );

        // Execute the order
        execute{value: price}(tokenId);

        // Check that the order was executed correctly
        Marketplace.Order memory order = marketplace.orders(tokenId);

        assertEq(order.creator, buyer, "Buyer should be the new owner");
        assertEq(
            order.tokenAddress,
            tokenAddress,
            "Token address should match"
        );
        assertEq(order.tokenId, tokenId, "Token ID should match");
        assertEq(order.price, 0, "Price should be zero");
        assertEq(order.signature, bytes32(0), "Signature should be empty");
        assertEq(order.deadline, 0, "Deadline should be zero");
    }

    function execute(uint256 tokenId) public {
        marketplace.executeOrder{value: marketplace.orders(tokenId).price}(
            tokenId
        );
    }
}
