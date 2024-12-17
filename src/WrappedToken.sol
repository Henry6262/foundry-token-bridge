// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import "openzeppelin-contracts/contracts/token/ERC20/extensions/ERC20Permit.sol";

contract TokenWrapper is ERC20, ERC20Permit {

    address owner;
    mapping (address => bool) public allowedIssuers;
   
    constructor(string memory _name, string memory _symbol) ERC20(_name, _symbol) ERC20Permit(_name) payable {
        owner = msg.sender;
    }

    error NotTheOwner();
    modifier OnlyOwner(address msgSender) {
        if (msgSender != owner) {
            revert NotTheOwner();
         }
         _;
    }

    error NotIssuer();
    modifier IsAdmin(address adr) {
        if (!allowedIssuers[adr]) {
            revert NotIssuer();
        }
        _;
    }

    function manageAdmins(address newAdmin) OnlyOwner(msg.sender) external {
        if (!allowedIssuers[newAdmin]) {
            allowedIssuers[newAdmin] = true;
        } else {
            allowedIssuers[newAdmin] = false;
        }
    }

    function issueTokens(address receiver, uint256 amount) IsAdmin(msg.sender) public {
        _mint(receiver, amount);
    }

    function releaseTokens(address receiver, uint256 amount) IsAdmin(msg.sender) public {
        _burn(receiver, amount);
    }

    event receivedThemMoneyssss(address indexed sender, uint256 amount);
    fallback() external payable  {
        emit receivedThemMoneyssss(msg.sender, msg.value);
    }

    receive() external payable {
        emit receivedThemMoneyssss(msg.sender, msg.value);
    }

    
}