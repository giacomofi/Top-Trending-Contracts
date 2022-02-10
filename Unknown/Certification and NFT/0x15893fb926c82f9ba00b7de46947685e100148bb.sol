['pragma solidity ^0.4.13;\n', '\n', '/**\n', ' * Math operations with safety checks\n', ' */\n', 'library SafeMath {\n', '  function mul(uint a, uint b) internal returns (uint) {\n', '    uint c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint a, uint b) internal returns (uint) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  function sub(uint a, uint b) internal returns (uint) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint a, uint b) internal returns (uint) {\n', '    uint c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '\n', '  function max64(uint64 a, uint64 b) internal constant returns (uint64) {\n', '    return a >= b ? a : b;\n', '  }\n', '\n', '  function min64(uint64 a, uint64 b) internal constant returns (uint64) {\n', '    return a < b ? a : b;\n', '  }\n', '\n', '  function max256(uint a, uint b) internal constant returns (uint) {\n', '    return a >= b ? a : b;\n', '  }\n', '\n', '  function min256(uint a, uint b) internal constant returns (uint) {\n', '    return a < b ? a : b;\n', '  }\n', '}\n', '\n', '/**\n', ' * Interface for defining crowdsale pricing.\n', ' */\n', 'contract PricingStrategy {\n', '\n', '  /** Interface declaration. */\n', '  function isPricingStrategy() public constant returns (bool) {\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * When somebody tries to buy tokens for X eth, calculate how many tokens they get.\n', '   *\n', '   *\n', '   * @param value - What is the value of the transaction sent in as wei\n', '   * @param weiRaised - how much money has been raised this far\n', '   * @param tokensSold - how many tokens have been sold this far\n', '   * @param msgSender - who is the investor of this transaction\n', '   * @param decimals - how many decimal units the token has\n', '   * @return Amount of tokens the investor receives\n', '   */\n', '  function calculatePrice(uint value, uint weiRaised, uint tokensSold, address msgSender, uint decimals) public constant returns (uint tokenAmount);\n', '}\n', '\n', '/**\n', ' * Fixed crowdsale pricing - everybody gets the same price.\n', ' */\n', 'contract FlatPricing is PricingStrategy {\n', '\n', '  using SafeMath for uint;\n', '\n', '  /* How many weis one token costs */\n', '  uint public oneTokenInWei;\n', '\n', '  function FlatPricing(uint _oneTokenInWei) {\n', '    oneTokenInWei = _oneTokenInWei;\n', '  }\n', '\n', '  /**\n', '   * Calculate the current price for buy in amount.\n', '   *\n', '   * @ param  {uint value} Buy-in value in wei.\n', '   * @ param\n', '   * @ param\n', '   * @ param\n', '   * @ param  {uint decimals} The decimals used by the token representation (e.g. given by FractionalERC20).\n', '   */\n', '  function calculatePrice(uint value, uint, uint, address, uint decimals) public constant returns (uint) {\n', '    uint multiplier = 10 ** decimals;\n', '    return value.mul(multiplier).div(oneTokenInWei);\n', '  }\n', '\n', '}']