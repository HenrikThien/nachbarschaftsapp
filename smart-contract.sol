/*
 Smart Contract Solidity Ethereum
*/

pragma solidity ^0.5.0;

contract AppContract {
    address public owner;
    address public receiver;

    constructor() public {
        owner = msg.sender;
    }

    function kill() public {
        if (msg.sender == owner) {
            selfdestruct(msg.sender);
        }
    }
}