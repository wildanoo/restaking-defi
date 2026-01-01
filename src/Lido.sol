// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Lido is ERC20 {
    event Submitted(address indexed sender, uint256 amount, address referral);
    
    constructor() ERC20("Liquid staked Ether 2.0", "stETH") {}
    
    /// @notice Stake ETH and receive stETH
    /// @param _referral Optional referral address
    function submit(address _referral) external payable returns (uint256) {
        require(msg.value > 0, "Cannot stake 0 ETH");
        
        // Mint stETH 1:1 with ETH (simplified, real Lido uses shares/rebase)
        _mint(msg.sender, msg.value);
        
        emit Submitted(msg.sender, msg.value, _referral);
        return msg.value;
    }
    
    /// @notice Fallback to auto-stake when receiving ETH
    receive() external payable {
        _mint(msg.sender, msg.value);
        emit Submitted(msg.sender, msg.value, address(0));
    }
}
