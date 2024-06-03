// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.13 <0.9.0;

import "./FugaziStorageLayout.sol";

// This is the main diamond contract
contract FugaziDiamond is FugaziStorageLayout {
    // constructor
    constructor(facetAndSelectorStruct[] memory _facetAndSelectors) {
        owner = msg.sender;

        // set selector to facet mapping
        for (uint256 i; i < _facetAndSelectors.length; i++) {
            selectorTofacet[_facetAndSelectors[i].selector] = _facetAndSelectors[i].facet;
        }
    }

    // Find facet for function that is called and execute the
    // function if a facet is found and return any value.
    fallback() external payable {
        // get facet from function selector
        address facet = selectorTofacet[msg.sig];
        require(facet != address(0));
        // Execute external function from facet using delegatecall and return any value.
        assembly {
            // copy function selector and any arguments
            calldatacopy(0, 0, calldatasize())
            // execute function call using the facet
            let result := delegatecall(gas(), facet, 0, calldatasize(), 0, 0)
            // get any return value
            returndatacopy(0, 0, returndatasize())
            // return any return value or error back to the caller
            switch result
            case 0 { revert(0, returndatasize()) }
            default { return(0, returndatasize()) }
        }
    }

    receive() external payable {}
}
