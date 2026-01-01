// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract WstETH is ERC20 {
    IERC20 public immutable stETH;
    
    event Wrap(address indexed user, uint256 stETHAmount, uint256 wstETHAmount);
    event Unwrap(address indexed user, uint256 wstETHAmount, uint256 stETHAmount);
    
    constructor(address _stETH) ERC20("Wrapped liquid staked Ether 2.0", "wstETH") {
        require(_stETH != address(0), "Invalid stETH address");
        stETH = IERC20(_stETH);
    }
    
    /// @notice Wrap stETH to wstETH
    function wrap(uint256 _stETHAmount) external returns (uint256) {
        require(_stETHAmount > 0, "Cannot wrap 0");
        
        // Transfer stETH from user
        stETH.transferFrom(msg.sender, address(this), _stETHAmount);
        
        // Mint wstETH 1:1 (simplified, real wstETH uses share-based calculation)
        _mint(msg.sender, _stETHAmount);
        
        emit Wrap(msg.sender, _stETHAmount, _stETHAmount);
        return _stETHAmount;
    }
    
    /// @notice Unwrap wstETH back to stETH
    function unwrap(uint256 _wstETHAmount) external returns (uint256) {
        require(_wstETHAmount > 0, "Cannot unwrap 0");
        require(balanceOf(msg.sender) >= _wstETHAmount, "Insufficient balance");
        
        // Burn wstETH
        _burn(msg.sender, _wstETHAmount);
        
        // Return stETH to user
        stETH.transfer(msg.sender, _wstETHAmount);
        
        emit Unwrap(msg.sender, _wstETHAmount, _wstETHAmount);
        return _wstETHAmount;
    }
}
