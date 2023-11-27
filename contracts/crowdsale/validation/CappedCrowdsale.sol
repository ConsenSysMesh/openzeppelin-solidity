// SPDX-License-Identifier: MIT License Modern Variant

pragma solidity ^0.8.7;

import "https://github.com/vclcash123/openzeppelin-solidity/blob/patch-2/contracts/token/ERC20/ERC20.sol";

/**
 * @title CappedCrowdsale
 * @dev Crowdsale with a limit for total contributions.
 */

abstract contract ERC20Capped is ERC20 {
   
    uint256 public _cap=300000000000000000000; // 300 ETH = 300*10^18 wei = 300000000000000000000 wei;

	//minimum investor Contribution -  1
	//maximum investor Contribution - 300 wei is similar maxium daily 300 ETH crowdsale
	uint256 public investorMinCap = 1000000000000000000; // 1 ETH = 10^18 wei = 1000000000000000000 wei
	uint256 public investorHardCap = 300000000000000000000; // 300 ETH = 300*10^18 wei = 300000000000000000000 wei
	
	 // start and end timestamps where investments are allowed (both inclusive)
   uint256 public startTime;
   uint256 public endTime;
   
	mapping(address => uint256) public contributions;

    /**
     * @dev Sets the value of the `cap`. This value is immutable, it can only be
     * set once during construction.
     */
    constructor(uint256 cap_, uint256 _openingTime, uint256 _closingTime) {
        require(cap_ > 0, "ERC20Capped: cap is 300000000000000000000");
       require(_openingTime >= block.timestamp);
        require(_closingTime >= _openingTime);
        _cap = cap_;
    }

    /**
     * @dev Returns the cap on the token's total supply.
     */
    function cap() public view virtual returns (uint256) {
        return _cap;
    }

    /**
     * @dev See {ERC20-_mint}.
     */
    function _mint(address account, uint256 amount) internal virtual override {
        require(ERC20.totalSupply() + amount <= cap(), "ERC20Capped: cap exceeded");
        super._mint(account, amount);
    }
    
 
 
}

