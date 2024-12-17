// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

interface IERC20V2 is IERC20 {
  function issueTokens(address receiver, uint256 amount) external;
  function releaseTokens(address receiver, uint256 amount) external;
} 

contract BaseBridge {

    address public owner;
    IERC20V2 public myWrappedToken;

    constructor(address tokenAddress) payable {
        owner = msg.sender;
        myWrappedToken = IERC20V2(tokenAddress);
    }

    mapping(address => uint256) public releasedAllocation;

    event TokensClaimed(address indexed claimer, uint256 amount);
    event TokensReleased(address indexed claimer, uint256 amount);

    error NotTheOwner();
    modifier OnlyOwner (address sender) {
        if (sender != owner) {
            revert NotTheOwner();
        }
        _;
    }

    function claim(address recipient, uint256 amount) OnlyOwner(msg.sender) external {
        myWrappedToken.issueTokens(recipient, amount);
        releasedAllocation[recipient] += amount;
        emit TokensClaimed(recipient, amount);
    }

    
    error NoAllocation();
    function release(address recipient, uint256 amount) OnlyOwner(msg.sender) external {
        uint256 allocation = releasedAllocation[recipient];
        if (allocation <= 0 ) {
            revert NoAllocation();
        }
        myWrappedToken.releaseTokens(recipient, amount);
        releasedAllocation[recipient] -= amount;
    }



}
