// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/Lido.sol";
import "../src/WstETH.sol";
import "../src/Aave.sol";
import "../src/RestakeManager.sol";

contract RestakeTest is Test {
    Lido public lido;
    WstETH public wstETH;
    Aave public aave;
    RestakeManager public manager;
    
    address public user = address(0x1);
    
    function setUp() public {
        // Deploy contracts
        lido = new Lido();
        wstETH = new WstETH(address(lido));
        aave = new Aave();
        manager = new RestakeManager(
            address(lido),
            address(wstETH),
            address(aave)
        );
        
        // Give user some ETH
        vm.deal(user, 100 ether);
    }
    
    function testFullRestakingFlow() public {
        uint256 stakeAmount = 1 ether;
        
        // Execute restaking as user
        vm.prank(user);
        uint256 finalAmount = manager.restake{value: stakeAmount}();
        
        // Verify final balance in Aave
        assertEq(finalAmount, stakeAmount);
        assertEq(manager.getRestakeBalance(user), stakeAmount);
    }
    
    function testStakingETHToLido() public {
        vm.prank(user);
        lido.submit{value: 1 ether}(address(0));
        
        assertEq(lido.balanceOf(user), 1 ether);
    }
    
    function testWrappingStETH() public {
        // First stake
        vm.prank(user);
        lido.submit{value: 1 ether}(address(0));
        
        // Then wrap
        vm.startPrank(user);
        lido.approve(address(wstETH), 1 ether);
        wstETH.wrap(1 ether);
        vm.stopPrank();
        
        assertEq(wstETH.balanceOf(user), 1 ether);
    }
    
    function testSupplyToAave() public {
        // Stake and wrap first
        vm.startPrank(user);
        lido.submit{value: 1 ether}(address(0));
        lido.approve(address(wstETH), 1 ether);
        wstETH.wrap(1 ether);
        
        // Supply to Aave (updated with onBehalfOf parameter)
        wstETH.approve(address(aave), 1 ether);
        aave.supply(address(wstETH), 1 ether, user);  // <- FIX: Tambah parameter user
        vm.stopPrank();
        
        assertEq(aave.getSupplied(user, address(wstETH)), 1 ether);
    }
}
