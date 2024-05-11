// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.13 <0.9.0;

import "@fhenixprotocol/contracts/FHE.sol";
import "node_modules/solady/src/tokens/ERC20.sol";

// LP token for Fugazi pool
contract FugaziLPToken is ERC20 {
    constructor(string memory name_, string memory symbol_, uint8 decimals_) {
        _name = name_;
        _symbol = symbol_;
        _decimals = decimals_;
        FugaziHub = msg.sender;
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                       ERC20 METADATA                       */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/
    string private _name;
    string private _symbol;
    uint8 private _decimals;

    /// @dev Returns the name of the token.
    function name() public view virtual override returns (string memory) {
        return _name;
    }

    /// @dev Returns the symbol of the token.
    function symbol() public view virtual override returns (string memory) {
        return _symbol;
    }

    /// @dev Returns the decimals places of the token.
    function decimals() public view virtual override returns (uint8) {
        return _decimals;
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*              Mint & Burn (only from FugaziHub)             */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/
    address private immutable FugaziHub;

    error SenderIsNotFugaziHub();

    modifier onlyFugaziHub() {
        if (msg.sender != FugaziHub) revert SenderIsNotFugaziHub();
        _;
    }

    /// @dev Mint new tokens
    function encMint(address to, inEuint32 calldata _amount) external onlyFugaziHub {}

    /// @dev Burn tokens
    function encBurn(address from, inEuint32 calldata _amount) external onlyFugaziHub {}

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                       FHERC20 LOGIC                        */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    // (plain) totalSupply, balanceOf, transfer, transferFrom, approve, allowance
    // (encrypted) encTransfer, encTransferFrom, encApprove, encAllowance
    // wrap, unwrap
}
