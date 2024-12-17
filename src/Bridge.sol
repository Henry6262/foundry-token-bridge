// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

contract bridge {

    address public hotWallet;
    IERC20 public myToken;

    mapping (address => uint256) public lockedTokens;

    constructor(address tokenAddress) payable {
        hotWallet = msg.sender;
        myToken = IERC20(tokenAddress);
    }

    event TokensLocked(address to, uint256 amount);
    event TokensClaimed(address claimer, uint256 amount);

    error NotTheOwner();
    modifier OnlyHotWallet (address sender) {
        if (sender != hotWallet) {
            revert NotTheOwner();
        }
        _;
    }

    function lock(address to, uint256 amount) OnlyHotWallet(msg.sender) public {
        lockedTokens[to] += amount;
    }

    error EmptyAllowance();
    function claim (address claimer) OnlyHotWallet(msg.sender) public {

        uint256 claimerAllowance = lockedTokens[claimer];
        
        if (claimerAllowance <= 0 ) {
            revert EmptyAllowance();
        }

        claimerAllowance  = 0;
        myToken.approve(claimer, claimerAllowance);
        myToken.transferFrom(hotWallet, claimer, claimerAllowance); //use safe transfer
    }

    event receivedThemMoneyssss(address indexed sender, uint256 amount);

    fallback() external payable  {
        emit receivedThemMoneyssss(msg.sender, msg.value);
    }

    receive() external payable {
        emit receivedThemMoneyssss(msg.sender, msg.value);
    }



}