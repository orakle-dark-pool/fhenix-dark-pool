// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.13 <0.9.0;

import "@fhenixprotocol/contracts/FHE.sol";
import {Permissioned, Permission} from "@fhenixprotocol/contracts/access/Permissioned.sol";

// This will be used to store all the storage variables & will be inherited by all of the other contracts
// every library should be imported here
contract FugaziStorageLayout is Permissioned {
    // import FHE library
    using FHE for euint32;

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                       Account Facet                        */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    // errors

    // events - we do not emit amount to keep the confidentiality
    event Deposit(address recipient, address token);
    event Withdraw(address recipient, address token);

    // storage variables
    mapping(address => mapping(address => euint32)) internal balanceOf; // owner => token => balance

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                    Pool Registry Facet                     */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    // errors
    error PoolAlreadyExists();

    // events
    event PoolCreated(address tokenX, address tokenY, bytes32 poolId);

    // storage variables
    struct poolCreationInputStruct {
        address tokenX;
        address tokenY;
        euint32 initialReserves;
    }

    mapping(address => mapping(address => bytes32)) internal poolIdMapping;

    struct poolStateStruct {
        // pool info
        address tokenX;
        address tokenY;
        uint32 currentBatch;
        // protocol account
        euint32 protocolX;
        euint32 protocolY;
        // information of each batch
        mapping(uint32 => batchStruct) batch; // batchStruct is defined in the Pool Action Facet section
    }

    mapping(bytes32 => poolStateStruct) internal poolState;

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                     Pool Action Facet                      */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    // errors

    // events

    // storage variables
    struct batchStruct {
        // initial pool state
        euint32 reserveX0;
        euint32 reserveY0;
        // sum of swap orders
        euint32 swapX;
        euint32 swapY;
        // sum of mint orders
        euint32 mintX;
        euint32 mintY;
        // final pool state
        euint32 reserveX1;
        euint32 reserveY1;
        // mapping of each individual swap order
        mapping(address => swapOrderStruct) swapOrder;
        // mapping of each individual mint order
        mapping(address => mintOrderStruct) mintOrder;
    }

    struct swapOrderStruct {
        euint32 swapX;
        euint32 swapY;
        ebool claimed;
    }

    struct mintOrderStruct {
        euint32 mintX;
        euint32 mintY;
        ebool claimed;
    }

    // numbers that will be used in claim()
    // TBD

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                           Diamond                          */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    // errors

    // events

    // storage variables
    mapping(bytes4 => address) internal selectorTofacet;
}
