// SPDX-License-Identifier: MIT License 

pragma solidity ^0.8.9;

import "https://github.com/vclcash123/openzeppelin-solidity/blob/patch-2/contracts/token/ERC20/SafeMath.sol";
import "https://github.com/vclcash123/openzeppelin-solidity/blob/patch-2/contracts/token/ERC20/IERC20.sol";


/**
 * @title Crowdsale
 * @dev Crowdsale is a base contract for managing a token crowdsale,
 * allowing investors to purchase tokens with ether. This contract implements
 * such functionality in its most fundamental form and can be extended to provide additional
 * functionality and/or custom behavior.
 * The external interface represents the basic interface for purchasing tokens, and conform
 * the base architecture for crowdsales. They are *not* intended to be modified / overriden.
 * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
 * the methods to add functionality. Consider using 'super' where appropiate to concatenate
 * behavior.
 */
contract Crowdsale {
  using SafeMath for uint256;

  // How many token units a buyer gets per wei.
  // The rate is the conversion between wei and the smallest and indivisible token unit.
  // So, if you are using a rate of 1 with a DetailedERC20 token with 3 decimals called TOK
  // 1 wei will give you 1 unit, or 0.001 TOK.
  uint256 public rate;

 // Address where funds are collected
  address payable wallet;

  // The token being sold
  address public token;

  // Amount of wei raised
  uint256 public weiRaised;

    // Public Supply
    uint256 public publicSupply;
 
  // start and end timestamps where investments are allowed (both inclusive)
   uint256 public startTime;
   uint256 public endTime;
  

  /**
   * Event for token purchase logging
   * @param purchaser who paid for the tokens
   * @param beneficiary who got the tokens
   * @param value weis paid for purchase
   * @param amount amount of tokens purchased
   */
  event TokenPurchase(
    address indexed purchaser,
    address indexed beneficiary,
    uint256 value,
    uint256 amount
  );

  /**
   * param _rate Number of token units a buyer gets per wei
   * param _wallet Address where collected funds will be forwarded to
   * param _token Address of the token being sold
   */

constructor (uint256 _startTime, uint256 _endTime, uint256 _rate, address payable _wallet, address _token) {
    require(_startTime >= block.timestamp);
    require(_endTime >= _startTime);
    require(_rate > 0);
    require(_wallet != address(0));
    require(address(token) != address(0));
    startTime = _startTime;
    endTime = _endTime;
    rate = _rate;
    wallet = _wallet;
    token = _token;
    
  }



  // -----------------------------------------
  // Crowdsale external interface
  // -----------------------------------------

  /**
   * @dev fallback function ***DO NOT OVERRIDE***
   */
     fallback ()  external payable {
    buyTokens(msg.sender);
  }
  
    receive ()  external payable {
    buyTokens(msg.sender);
  }

  
  /**
   * @dev low level token purchase ***DO NOT OVERRIDE***
   * @param _beneficiary Address performing the token purchase
   */
 function buyTokens(address _beneficiary) public payable {
    require(_beneficiary != address(0));
    uint256 weiAmount = msg.value;
  //  _preValidatePurchase(_beneficiary, weiAmount);

    // calculate token amount to be created
    uint256 tokens = _getTokenAmount(weiAmount);

    // update state
    weiRaised = weiRaised.add(weiAmount);

   // _processPurchase(_beneficiary, token);
    emit TokenPurchase(msg.sender, _beneficiary, weiAmount, tokens);

    _updatePurchasingState(_beneficiary, weiAmount);

    _forwardFunds();
    
     
  }

  // -----------------------------------------
  // Internal interface (extensible)
  // -----------------------------------------

  /**
   * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
   * @param _beneficiary Address performing the token purchase
   * @param _weiAmount Value in wei involved in the purchase
   
  function _preValidatePurchase(
    address _beneficiary,
    uint256 _weiAmount
  )
    internal
  {
    require(_beneficiary != address(0));
    require(_weiAmount != 0);
  }
  
*/

  /**
   * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
   * @param _beneficiary Address performing the token purchase
   * @param _tokenAmount Number of tokens to be emitted
  

  function _deliverTokens(
    address _beneficiary,
    uint256 _tokenAmount
  )
    internal
  {
  token.transfer(_beneficiary, _tokenAmount);
  }

   */


  /**
   * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
   * @param _beneficiary Address receiving the tokens
   * @param _tokenAmount Number of tokens to be purchased
  
  function _processPurchase(
    address _beneficiary,
    uint256 _tokenAmount
  )
    internal
  {
    _deliverTokens(_beneficiary, _tokenAmount);
  }

 */


  /**
   * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
   * @param _beneficiary Address receiving the tokens
   * @param _weiAmount Value in wei involved in the purchase
   */
  function _updatePurchasingState(
    address _beneficiary,
    uint256 _weiAmount
  )
    internal
  {
    // optional override
  }

  /**
   * @dev Override to extend the way in which ether is converted to tokens.
   * @param _weiAmount Value in wei to be converted into tokens
   * @return Number of tokens that can be purchased with the specified _weiAmount
   */
  function _getTokenAmount(uint256 _weiAmount)
    internal view returns (uint256)
  {
    return _weiAmount.mul(rate);
  }

  /**
   * @dev Determines how ETH is stored/forwarded on purchases.
   */
  function _forwardFunds() internal {
    wallet.transfer(msg.value);
  }
}
