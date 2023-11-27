// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

import "https://github.com/vclcash123/openzeppelin-solidity/blob/patch-2/contracts/token/ERC20/ERC20.sol";


contract DetailedERC20 is ERC20 {
  string public name;
  string public symbol;
  uint8 public decimals;

  constructor(string _name, string _symbol, uint8 _decimals) public {
    name = _name;
    symbol = _symbol;
    decimals = _decimals;
  }
}
