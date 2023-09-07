//SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;
import "./multisig.sol";

contract MultiSigFactory {
    MultiSig[] public multiSigs;
    event Create(address addr);

    //external returns
    function createMultiSig(address[] memory _admins) external payable {
        MultiSig newMultiSig = new MultiSig(_admins);
        multiSigs.push(newMultiSig);
        emit Create(address(newMultiSig));
    }

    function getMultiSigs() public view returns (MultiSig[] memory) {
        return multiSigs;
    }
}
