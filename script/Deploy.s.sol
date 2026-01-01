// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/Lido.sol";
import "../src/WstETH.sol";
import "../src/Aave.sol";
import "../src/RestakeManager.sol";

contract DeployScript is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        
        vm.startBroadcast(deployerPrivateKey);
        
        console.log("Deploying contracts...");
        console.log("Deployer address:", vm.addr(deployerPrivateKey));
        
        // 1. Deploy Lido
        Lido lido = new Lido();
        console.log("Lido deployed at:", address(lido));
        
        // 2. Deploy WstETH
        WstETH wstETH = new WstETH(address(lido));
        console.log("WstETH deployed at:", address(wstETH));
        
        // 3. Deploy Aave
        Aave aave = new Aave();
        console.log("Aave deployed at:", address(aave));
        
        // 4. Deploy RestakeManager
        RestakeManager manager = new RestakeManager(
            address(lido),
            address(wstETH),
            address(aave)
        );
        console.log("RestakeManager deployed at:", address(manager));
        
        console.log("\n=== Deployment Complete ===");
        
        vm.stopBroadcast();
    }
}
