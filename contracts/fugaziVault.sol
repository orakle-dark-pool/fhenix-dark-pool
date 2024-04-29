// SPDX-License-Identifier: MIT

pragma solidity >=0.8.13 <0.9.0;

import "@fhenixprotocol/contracts/FHE.sol";

contract FugaziVault {
    // owner => token address => balance
    mapping(address => mapping(address => euint32)) public balances;

    
}