// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./Lido.sol";
import "./WstETH.sol";
import "./Aave.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract RestakeManager {
    Lido public immutable lido;
    WstETH public immutable wstETH;
    Aave public immutable aave;
    
    event Restaked(address indexed user, uint256 ethAmount, uint256 finalAmount);
    
    constructor(address _lido, address _wstETH, address _aave) {
        require(_lido != address(0), "Invalid Lido address");
        require(_wstETH != address(0), "Invalid WstETH address");
        require(_aave != address(0), "Invalid Aave address");
        
        lido = Lido(payable(_lido));
        wstETH = WstETH(_wstETH);
        aave = Aave(_aave);
    }
    
    /// @notice Execute full restaking flow: ETH -> stETH -> wstETH -> Aave
    function restake() external payable returns (uint256) {
        require(msg.value > 0, "Must send ETH");
        
        // Step 1: Stake ETH in Lido to get stETH
        uint256 stETHAmount = lido.submit{value: msg.value}(address(0));
        
        // Step 2: Approve and wrap stETH to wstETH
        IERC20(address(lido)).approve(address(wstETH), stETHAmount);
        uint256 wstETHAmount = wstETH.wrap(stETHAmount);
        
        // Step 3: Approve and supply wstETH to Aave on behalf of msg.sender
        IERC20(address(wstETH)).approve(address(aave), wstETHAmount);
        aave.supply(address(wstETH), wstETHAmount, msg.sender);  // <- FIX: Tambah msg.sender
        
        emit Restaked(msg.sender, msg.value, wstETHAmount);
        return wstETHAmount;
    }
    
    /// @notice Get user's restaked balance in Aave
    function getRestakeBalance(address user) external view returns (uint256) {
        return aave.getSupplied(user, address(wstETH));
    }
}
