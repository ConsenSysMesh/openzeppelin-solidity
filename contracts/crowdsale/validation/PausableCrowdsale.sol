// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

import "https://github.com/vclcash123/openzeppelin-solidity/blob/patch-2/contracts/crowdsale/Crowdsale.sol";
import "https://github.com/vclcash123/openzeppelin-solidity/blob/patch-2/contracts/token/ERC20/Pausable.sol";

/**
 * @title PausableCrowdsale
 * @dev Extension of Crowdsale contract where purchases can be paused and unpaused by the pauser role.
 */
contract PausableCrowdsale is Crowdsale, Pausable {
    /**
     * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met.
     * Use super to concatenate validations.
     * Adds the validation that the crowdsale must not be paused.
     * @param _beneficiary Address performing the token purchase
     * @param _weiAmount Value in wei involved in the purchase
     */
    function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal view whenNotPaused {
        return super._preValidatePurchase(_beneficiary, _weiAmount);
    }
}
