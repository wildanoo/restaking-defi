// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Aave {
    // user => token => supplied amount
    mapping(address => mapping(address => uint256)) public supplied;
    
    event Supply(address indexed user, address indexed token, uint256 amount);
    event Withdraw(address indexed user, address indexed token, uint256 amount);
    
    /// @notice Supply tokens as collateral to Aave on behalf of someone
    /// @param token The token address to supply
    /// @param amount The amount to supply
    /// @param onBehalfOf The address that will receive the credit
    function supply(address token, uint256 amount, address onBehalfOf) external {
        require(amount > 0, "Cannot supply 0");
        require(token != address(0), "Invalid token");
        require(onBehalfOf != address(0), "Invalid beneficiary");
        
        // Transfer tokens from msg.sender to this contract
        IERC20(token).transferFrom(msg.sender, address(this), amount);
        
        // Track balance for the beneficiary (onBehalfOf)
        supplied[onBehalfOf][token] += amount;
        
        emit Supply(onBehalfOf, token, amount);
    }
    
    /// @notice Withdraw supplied tokens
    function withdraw(address token, uint256 amount) external {
        require(amount > 0, "Cannot withdraw 0");
        require(supplied[msg.sender][token] >= amount, "Insufficient balance");
        
        // Update balance
        supplied[msg.sender][token] -= amount;
        
        // Transfer tokens back to user
        IERC20(token).transfer(msg.sender, amount);
        
        emit Withdraw(msg.sender, token, amount);
    }
    
    /// @notice Get supplied balance for a user and token
    function getSupplied(address user, address token) external view returns (uint256) {
        return supplied[user][token];
    }
}
