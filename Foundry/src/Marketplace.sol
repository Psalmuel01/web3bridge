// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "openzeppelin-contracts/contracts/token/ERC721/IERC721.sol";
import "openzeppelin-contracts/contracts/token/ERC721/IERC721Receiver.sol";
import "openzeppelin-contracts/contracts/utils/cryptography/ECDSA.sol";

contract Marketplace is IERC721Receiver {
    struct Order {
        address creator;
        address tokenAddress;
        uint256 tokenId;
        uint256 price;
        bytes32 signature;
        uint256 deadline;
    }

    mapping(bytes32 => bool) public usedSignatures;
    mapping(uint256 => Order) public orders;

    function createOrder(
        address _creator,
        address _tokenAddress,
        uint256 _tokenId,
        uint256 _price,
        bytes memory _signature,
        uint256 _deadline
    ) public {
        require(_price > 0, "Price must be greater than zero");
        require(_deadline > block.timestamp, "Deadline must be in the future");

        //Check if it's been used
        bytes32 orderId = keccak256(
            abi.encodePacked(
                _tokenAddress,
                _tokenId,
                _price,
                _creator,
                _deadline
            )
        );
        require(!usedSignatures[orderId], "Signature has already been used");

        //Verify signature
        bytes32 messageHash = keccak256(
            abi.encodePacked(
                _tokenAddress,
                _tokenId,
                _price,
                msg.sender,
                _deadline
            )
        );
        address signer = messageHash.recover(_signature);
        require(signer == msg.sender, "Invalid signature");

        //Create the order
        Order memory order = Order({
            creator: msg.sender,
            tokenAddress: _tokenAddress,
            tokenId: _tokenId,
            price: _price,
            signature: _signature,
            deadline: _deadline
        });

        orders[_tokenId] = order;
        
        usedSignatures[orderId] = true;
    }

    function executeOrder(uint256 _tokenId) public payable {
        require(
            orders[_tokenId].creator != msg.sender,
            "Creator cannot purchase their own listing"
        );
        Order storage order = orders[_tokenId];
        require(order.price == msg.value, "Incorrect amount sent");
        require(order.tokenAddress != address(0), "Order does not exist");
        require(order.deadline > block.timestamp, "Order expired");

        //Verify the signature
        bytes32 messageHash = keccak256(
            abi.encodePacked(
                order.tokenAddress,
                order.tokenId,
                order.price,
                order.creator,
                order.deadline
            )
        );
        require(
            messageHash.recover(order.signature) == order.creator,
            "Invalid signature"
        );

        //Transfer ownership of the token
        IERC721(order.tokenAddress).safeTransferFrom(
            order.creator,
            msg.sender,
            order.tokenId
        );

        //Update the token owner and remove the order
        order.creator = msg.sender;
        delete orders[_tokenId];
    }
}
