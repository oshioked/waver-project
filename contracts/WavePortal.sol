// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import 'hardhat/console.sol';

contract WavePortal {
    uint256 totalWaves;
    uint256 private seed;

    event NewWave(address indexed from, uint256 timestamp, string message);

    struct Wave{
        address waver;
        string message;
        uint256 timestamp;
    }

    mapping(address => uint256) public lastWavedAt;
    Wave[] waves;

    constructor() payable {
        console.log("Hi I am a contract and i am smart");
    }
    function wave(string memory _message) public{
        require(lastWavedAt[msg.sender] + 15 minutes < block.timestamp, "Wait 15mins");
        lastWavedAt[msg.sender] = block.timestamp;
        
        totalWaves += 1;
        console.log("%s has waved!", msg.sender);

        waves.push(Wave(msg.sender, _message, block.timestamp));

        uint256 randomNumber = (block.timestamp + block.difficulty + seed) % 100;
        console.log("Random number generated: %s", randomNumber);
        seed = randomNumber;

        if(randomNumber < 50){
            console.log("%s won!", msg.sender);
            uint256 priceAmount = 0.0001 ether;
            require(
                priceAmount <= address(this).balance,
                "Trying to withdraw more than the contract has"
            );

            ( bool success, ) = (msg.sender).call{value: priceAmount}("");
            require(success, "Failed to send money from contract.");            
        }
        
        emit NewWave(msg.sender, block.timestamp, _message);
    }

    function getAllWaves() public view returns(Wave[] memory){
        return waves;
    }

    function getTotalWaves() public view returns(uint256){
        return totalWaves;
    }
}