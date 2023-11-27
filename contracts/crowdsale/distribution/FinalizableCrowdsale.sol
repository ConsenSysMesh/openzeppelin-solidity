// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

import "https://github.com/vclcash123/openzeppelin-solidity/blob/patch-2/contracts/crowdsale/validation/TimedCrowdsale.sol";
import "https://github.com/vclcash123/openzeppelin-solidity/blob/patch-2/contracts/ownership/Ownable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/SafeMath.sol";

/**
 * title FinalizableCrowdsale
 * dev Extension of Crowdsale where an owner can do extra work after finishing.
 */
contract FinalizableCrowdsale is TimedCrowdsale, Ownable {
  bool public isFinalized = false;
  event Finalized();
  using SafeMath for uint256;
  
  /**
   * @dev Must be called after crowdsale ends, to do some extra finalization
   * work. Calls the contract's finalization function.
   */
  function finalize() onlyOwner public {
    require(!isFinalized);
    require(hasClosed());

    finalization();
    emit Finalized();

    isFinalized = true;
  }

  /**
   * @dev Can be overridden to add finalization logic. The overriding function
   * should call super.finalization() to ensure the chain of finalization is
   * executed entirely.
   */
  function finalization() internal {
  }

}
