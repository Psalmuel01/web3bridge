// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract PackedUint {
    uint128 public packedUint;

    function assignValues(uint128 value1, uint128 value2) public {
        packedUint = (value1 << 128) | value2;
    }
}


// contract Counter {
//     uint256 public number;

//     function setNumber(uint256 newNumber) public {
//         number = newNumber;
//     }

//     function packed(uint128 a, uint128 b) public {
//         a = 5;
//         b = 7;
//         packedValueA = a;
//         packedValueB = b;
//     }

//     function increment() public {
//         number++;
//     }
// }
