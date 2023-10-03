// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {PackedUint} from "../src/Counter.sol";

contract PackedUintTest is Test {
    PackedUint packedUint;

    function setUp() public {
        packedUint = new PackedUint();
        packedUint.assignValues(123456789, 987654321);
    }

    function testAssignValues() public {
        packedUint.assignValues(123456789, 987654321);
    }

    function testPacked() public {
        bytes32 res = vm.load(address(packedUint));
        uint128 a;
        uint128 b;
        a = uint128(uint256(res));
        b = uint128(uint256(res) >> 128);
        console2.logUint(a);
        console2.logUint(b);
        assertEq(packedUint.b(), b);
        assertEq(packedUint.a(), a);
    }
}

