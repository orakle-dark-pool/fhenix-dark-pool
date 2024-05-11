// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "node_modules/solady/src/utils/FixedPointMathLib.sol";
import "@fhenixprotocol/contracts/FHE.sol";

// library for encrypted math
// due to the FHE scheme technically it is not library but contract
contract encMath {
    using FixedPointMathLib for uint;
    
    euint32 private immutable EncOne = FHE.asEuint32(1);
}