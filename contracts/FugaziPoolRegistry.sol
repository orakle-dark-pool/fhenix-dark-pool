// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.13 <0.9.0;

import "contracts/FugaziBase.sol";
import "contracts/FugaziLPToken.sol";

contract FugaziPoolRegistry is FugaziBase {
    // errors
    error poolAlreadyExists();

    // create pool and update registry
    function createPool(address tokenX, address tokenY, inEuint32 tokenReserves) external {
        require(getPoolId(tokenX, tokenY) != bytes32(0), poolAlreadyExists());
    }

    function getPoolId(address tokenX, address tokenY) public pure returns (bytes32) {
        return tokenX < tokenY ? keccak256(abi.encode(tokenX, tokenY)) : keccak256(abi.encode(tokenY, tokenX));
    }
}
