// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import "openzeppelin-contracts/contracts/token/ERC20/extensions/ERC20Permit.sol";

contract MyToken is ERC20, ERC20Permit {

    address owner;

    constructor(string memory _name, string memory _symbol) ERC20(_name, _symbol) ERC20Permit(_name) payable {
        owner = msg.sender;
        _mint(msg.sender, 1000 * 10 ** 18);
    }

    event receivedThemMoneyssss(address indexed sender, uint256 amount);
    fallback() external payable  {
        emit receivedThemMoneyssss(msg.sender, msg.value);
    }

    receive() external payable {
        emit receivedThemMoneyssss(msg.sender, msg.value);
    }

}
