// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.13 <0.9.0;

import "./FugaziStorageLayout.sol";

// This facet will handle pool registry operations
contract FugaziPoolRegistryFacet is FugaziStorageLayout {
    // create pool
    function createPool(address tokenX, address tokenY, inEuint32 calldata _initialReserves) external {
        // transform the type
        euint32 initialReserves = FHE.asEuint32(_initialReserves);

        // adjust the input; we cannot create a pool with reserves more than the owner has
        euint32 availabeX = FHE.min(balanceOf[msg.sender][tokenX], FHE.shr(initialReserves, FHE.asEuint32(16)));
        euint32 availabeY = FHE.min(balanceOf[msg.sender][tokenY], FHE.and(initialReserves, FHE.asEuint32(2 ^ 16 - 1)));

        // minimum reserves: at least 1024 of each token
        FHE.req(FHE.and(FHE.gt(availabeX, FHE.asEuint32(1024)), FHE.gt(availabeY, FHE.asEuint32(1024))));

        // construct input
        poolCreationInputStruct memory poolCreationInput = poolCreationInputStruct({
            tokenX: tokenX,
            tokenY: tokenY,
            initialReserveX: availabeX,
            initialReserveY: availabeY
        });

        // create pool
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

        // initialize pool
        poolStateStruct storage $ = poolState[poolId];
        _initializePool($, i);

        // emit event
        emit PoolCreated(i.tokenX, i.tokenY, poolId);
    }

    function _initializePool(poolStateStruct storage $, poolCreationInputStruct memory i) internal {
        // set token addresses
        $.tokenX = i.tokenX;
        $.tokenY = i.tokenY;

        // set epoch
        $.epoch = 0;

        // set protocol account balances
        $.protocolX = FHE.shr(i.initialReserveX, FHE.asEuint32(10));
        $.protocolY = FHE.shr(i.initialReserveY, FHE.asEuint32(10));

        // update the first batch
        $.batch[0].reserveX0 = i.initialReserveX - $.protocolX;
        $.batch[0].reserveY0 = i.initialReserveY - $.protocolY;

        // mint LP token to the pool creator
        $.lpTotalSupply = FHE.max($.batch[0].reserveX0, $.batch[0].reserveY0);
        $.lpBalanceOf[msg.sender] = $.lpTotalSupply;
    }

    // get pool id
    function getPoolId(address tokenX, address tokenY) public view returns (bytes32) {
        return tokenX < tokenY ? poolIdMapping[tokenX][tokenY] : poolIdMapping[tokenY][tokenX];
    }
}
