// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.13 <0.9.0;

import "./FugaziStorageLayout.sol";

// This facet contains all the viewer functions
contract FugaziViewerFacet is FugaziStorageLayout {
    // get balance
    function getBalance(address token, Permission memory permission)
        external
        view
        onlySender(permission)
        returns (bytes memory)
    {
        // reencrypt and return
        return FHE.sealoutput(balanceOf[msg.sender][token], permission.publicKey);
    }
}
