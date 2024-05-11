// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.13 <0.9.0;

import "@fhenixprotocol/contracts/FHE.sol";
import {Permissioned, Permission} from "@fhenixprotocol/contracts/access/Permissioned.sol";

// This contract is the base contract for all Fugazi contracts
// It contains the basic data structures and storage variables
// Lastly it contains account management functions
contract FugaziBase is Permissioned {
    // storage variables
    // more will be added as needed
    mapping(address => mapping(address => euint32)) internal accountTokenBalance;

    struct PoolStateStruct {
        address tokenX;
        address tokenY;
        FugaziLPToken lpToken;
        uint32 epoch;
        euint32 tokenXReserve;
        euint32 tokenYReserve;
        euint32 protocolTokenXBalance;
        euint32 protocolTokenYBalance;
    }

    mapping(bytes32 => PoolStateStruct) public poolState;

    // deposit

    // withdraw

    // check balance
}
