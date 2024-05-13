// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.13 <0.9.0;

import "@fhenixprotocol/contracts/FHE.sol";
import {Permissioned, Permission} from "@fhenixprotocol/contracts/access/Permissioned.sol";
import {IFHERC20} from "./interfaces/IFHERC20.sol";

// This contract is the base contract for all Fugazi contracts
// It contains the basic data structures and storage variables
// Lastly it contains account management functions
contract FugaziBase is Permissioned {
    using FHE for euint32;

    // errors
    error DepositFailed();
    error WithdrawalFailed();

    // events
    event Deposit(address indexed recipient, address indexed token);

    // storage variables
    // more will be added as needed
    mapping(address => mapping(address => euint32)) internal accountTokenBalance;

    struct PoolStateStruct {
        address tokenX;
        address tokenY;
        address lpToken;
        uint32 epoch;
        euint32 tokenXReserve;
        euint32 tokenYReserve;
        euint32 protocolTokenXBalance;
        euint32 protocolTokenYBalance;
    }

    mapping(bytes32 => PoolStateStruct) public poolState;

    // deposit
    function deposit(address recipient, address token, inEuint32 calldata _amount) external {
        // transferFrom
        euint32 spent = IFHERC20(token).transferFromEncrypted(msg.sender, address(this), _amount);

        // update storage
        accountTokenBalance[recipient][token] = accountTokenBalance[recipient][token] + spent;

        // emit event
        emit Deposit(recipient, token);
    }

    // withdraw
    function withdraw(address recipient, address token, inEuint32 calldata _amount) external {
        // update storage

        // transfer
    }

    // check balance
}
