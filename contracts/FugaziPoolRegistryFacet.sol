// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.13 <0.9.0;

import "./FugaziStorageLayout.sol";

// This facet will handle pool registry operations
contract FugaziPoolRegistryFacet is FugaziStorageLayout {
    // create pool
    function createPool(address tokenX, address tokenY, inEuint32 calldata initialReserves) external {
        poolCreationInputStruct memory poolCreationInput =
            poolCreationInputStruct({tokenX: tokenX, tokenY: tokenY, initialReserves: FHE.asEuint32(initialReserves)});

        _createPool(poolCreationInput);
    }

    function _createPool(poolCreationInputStruct memory i) internal {
        // check if pool already exists
        bytes32 poolId = getPoolId(i.tokenX, i.tokenY);
        if (poolId != bytes32(0)) {
            revert PoolAlreadyExists();
        }

        // update pool id mapping
        poolIdMapping[i.tokenX][i.tokenY] = i.tokenX < i.tokenY
            ? keccak256(abi.encodePacked(i.tokenX, i.tokenY))
            : keccak256(abi.encodePacked(i.tokenY, i.tokenX));

        // create pool
        poolStateStruct storage $ = poolState[poolId];
        _initializePool($, i);

        // emit event
        emit PoolCreated(i.tokenX, i.tokenY, poolId);
    }

    function _initializePool(poolStateStruct storage $, poolCreationInputStruct memory i) internal {
        // set pool info

        // set initial reserves

        // deduct sender balances
    }

    // get pool id
    function getPoolId(address tokenX, address tokenY) public view returns (bytes32) {
        return tokenX < tokenY ? poolIdMapping[tokenX][tokenY] : poolIdMapping[tokenY][tokenX];
    }
}
