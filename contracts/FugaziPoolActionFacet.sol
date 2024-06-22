// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.13 <0.9.0;

import "./FugaziStorageLayout.sol";

// This facet will handle swap & addLiquidity & removeLiquidity operations
// TODO: finish the claim() function
// TODO: enable the noise order
// TODO: enable the fee charge mechanism
contract FugaziPoolActionFacet is FugaziStorageLayout {
    function submitOrder(bytes32 poolId, inEuint32 calldata _packedAmounts) external onlyValidPool(poolId) {
        // transform the type
        /*
        smallest 15 bits = amount of tokenY
        next 15 bits = amount of tokenX
        next 1 bit = isSwap
        1 left bit is unused
        */
        euint32 packedAmounts = FHE.asEuint32(_packedAmounts);

        // get the pool and epoch
        poolStateStruct storage $ = poolState[poolId];
        batchStruct storage batch = $.batch[$.epoch];

        // adjust the input; you cannot swap (or mint) more than you have currently
        euint32 availableX = FHE.min(
            account[msg.sender].balanceOf[$.tokenX],
            FHE.and(packedAmounts, FHE.asEuint32(1073709056)) // 2^30 - 1 - (2^15 - 1)
        );
        euint32 availableY = FHE.min(
            account[msg.sender].balanceOf[$.tokenY],
            FHE.and(packedAmounts, FHE.asEuint32(32767)) // 2^15 - 1
        );

        // deduct the token balance of msg.sender
        account[msg.sender].balanceOf[$.tokenX] = account[msg.sender].balanceOf[$.tokenX] - availableX;
        account[msg.sender].balanceOf[$.tokenY] = account[msg.sender].balanceOf[$.tokenY] - availableY;

        // record the order into the batch
        euint32 isSwap = FHE.and(packedAmounts, FHE.asEuint32(1073741824)); // 2^30

        batch.order[msg.sender].swapX = isSwap * availableX;
        batch.order[msg.sender].swapY = isSwap * availableY;
        batch.order[msg.sender].mintX = (FHE.asEuint32(1) - isSwap) * availableX;
        batch.order[msg.sender].mintY = (FHE.asEuint32(1) - isSwap) * availableY;
        batch.order[msg.sender].claimed = FHE.asEbool(false);

        batch.swapX = batch.swapX + batch.order[msg.sender].swapX;
        batch.swapY = batch.swapY + batch.order[msg.sender].swapY;
        batch.mintX = batch.mintX + batch.order[msg.sender].mintX;
        batch.mintY = batch.mintY + batch.order[msg.sender].mintY;

        // add the unclaimed order
        account[msg.sender].unclaimedOrders.push(unclaimedOrderStruct({poolId: poolId, epoch: $.epoch}));
    }

    function settleBatch(bytes32 poolId) external onlyValidPool(poolId) {
        _settleBatch(poolId);
    }

    function _settleBatch(bytes32 poolId) internal {
        // get the pool and epoch
        poolStateStruct storage $ = poolState[poolId];
        batchStruct storage batch = $.batch[$.epoch];

        // update the initial pool state
        batch.reserveX0 = $.reserveX;
        batch.reserveY0 = $.reserveY;

        // calculate the intermediate values
        intermidiateValuesStruct memory interMidiateValues;
        interMidiateValues.XForPricing = batch.reserveX0 + FHE.shl(batch.swapX, FHE.asEuint32(1)) + batch.mintX; // x0 + 2 * x_swap + x_mint
        interMidiateValues.YForPricing = batch.reserveY0 + FHE.shl(batch.swapY, FHE.asEuint32(1)) + batch.mintY; // y0 + 2 * y_swap + y_mint

        // calculate the output amounts
        batch.outX = FHE.div(FHE.mul(batch.swapY, interMidiateValues.XForPricing), interMidiateValues.YForPricing);
        batch.outY = FHE.div(FHE.mul(batch.swapX, interMidiateValues.YForPricing), interMidiateValues.XForPricing);

        // update the final pool state
        batch.reserveX1 = batch.reserveX0 + batch.swapX + batch.mintX - batch.outX;
        batch.reserveY1 = batch.reserveY0 + batch.swapY + batch.mintY - batch.outY;

        // mint the LP token
        euint32 lpIncrement = FHE.min(
            FHE.div(FHE.mul($.lpTotalSupply, batch.mintX), batch.reserveX0),
            FHE.div(FHE.mul($.lpTotalSupply, batch.mintY), batch.reserveY0)
        ); /*
            Although this is underestimation, it is the best we can do currently,
            since encrypted operation is too expensive to handle the muldiv without overflow.
            The correct way to calculate the LP increment is:
            t = T 
                * (x_0 * y_mint + 2 * x_swap * y_mint + x_mint * y_0 + 2 * x_mint * y_swap + 2 * x_mint * y_mint) 
                / (2 * x_0 * y_0 + 2 * x_0 * y_swap + 2 * x_swap * y_0 + x_0 * y_mint + x_mint * y_0)
            See https://github.com/kosunghun317/alternative_AMMs/blob/master/notes/FMAMM_batch_math.ipynb for derivation.
            */
        $.lpTotalSupply = $.lpTotalSupply + lpIncrement;
        $.lpBalanceOf[address(this)] = $.lpBalanceOf[address(this)] + lpIncrement;
        // increment the epoch
        $.epoch += 1;
    }

    function claim(bytes32 poolId, uint32 epoch) external onlyValidPool(poolId) {
        _claim(poolId, epoch);
    }

    function _claim(bytes32 poolId, uint32 epoch) internal {
        // get the pool and epoch
        batchStruct storage batch = poolState[poolId].batch[epoch];

        // claim the output amount from the batch

        // claim the lp token from the batch

        // mark the order as claimed
    }
}
