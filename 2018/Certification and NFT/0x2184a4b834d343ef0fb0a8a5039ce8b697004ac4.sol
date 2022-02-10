['pragma solidity ^0.4.18;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  uint256 public totalSupply;\n', '  function balanceOf(address who) public constant returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '\n', 'contract JoyTokenAbstract {\n', '  function unlock();\n', '}\n', '\n', '/**\n', ' * @title Crowdsale\n', ' * @dev Crowdsale is a base contract for managing a token crowdsale.\n', ' * Crowdsales have a start and end timestamps, where investors can make\n', ' * token purchases and the crowdsale will assign them tokens based\n', ' * on a token per ETH rate. Funds collected are forwarded to a wallet\n', ' * as they arrive.\n', ' */\n', 'contract JoysoCrowdsale {\n', '  using SafeMath for uint256;\n', '\n', '  // The token being sold\n', '  address constant public JOY = 0x18D0a71E1135dCb693d3F305BA9dcA720d911E86;\n', '\n', '  // start and end timestamps where investments are allowed (both inclusive)\n', '  uint256 public startTime;\n', '  uint256 public endTime;\n', '\n', '  // address where funds are collected\n', '  address public joysoWallet = 0x1CaC2d7ee5Fd2E6C349d1783B0BFC80ee4d55daD;\n', '\n', '  // how many token units a buyer gets per wei\n', '  uint256 public rate = 100000000;\n', '\n', '  // amount of raised money in wei\n', '  uint256 public weiRaised;\n', '\n', '  /**\n', '   * event for token purchase logging\n', '   * @param purchaser who paid for the tokens\n', '   * @param beneficiary who got the tokens\n', '   * @param value weis paid for purchase\n', '   * @param amount amount of tokens purchased\n', '   */\n', '  event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);\n', '\n', '  // fallback function can be used to buy tokens\n', '  function () external payable {\n', '    buyTokens(msg.sender);\n', '  }\n', '\n', '  // low level token purchase function\n', '  function buyTokens(address beneficiary) public payable {\n', '    require(beneficiary != address(0));\n', '    require(validPurchase());\n', '\n', '    // calculate token amount to be created\n', '    uint256 joyAmounts = calculateObtainedJOY(msg.value);\n', '\n', '    // update state\n', '    weiRaised = weiRaised.add(msg.value);\n', '\n', '    require(ERC20Basic(JOY).transfer(beneficiary, joyAmounts));\n', '    TokenPurchase(msg.sender, beneficiary, msg.value, joyAmounts);\n', '\n', '    forwardFunds();\n', '  }\n', '\n', '  // send ether to the fund collection wallet\n', '  // override to create custom fund forwarding mechanisms\n', '  function forwardFunds() internal {\n', '    joysoWallet.transfer(msg.value);\n', '  }\n', '\n', '  function calculateObtainedJOY(uint256 amountEtherInWei) public view returns (uint256) {\n', '    return amountEtherInWei.mul(rate).div(10 ** 12);\n', '  } \n', '\n', '  // @return true if the transaction can buy tokens\n', '  function validPurchase() internal view returns (bool) {\n', '    bool withinPeriod = now >= startTime && now <= endTime;\n', '    return withinPeriod;\n', '  }\n', '\n', '  // @return true if crowdsale event has ended\n', '  function hasEnded() public view returns (bool) {\n', '    bool isEnd = now > endTime || weiRaised == 2 * 10 ** (8+6);\n', '    return isEnd;\n', '  }\n', '\n', '  // only admin \n', '  function releaseJoyToken() public returns (bool) {\n', '    require (hasEnded() && startTime != 0);\n', '    require (msg.sender == joysoWallet || now > endTime + 10 days);\n', '    uint256 remainedJoy = ERC20Basic(JOY).balanceOf(this);\n', '    require(ERC20Basic(JOY).transfer(joysoWallet, remainedJoy));    \n', '    JoyTokenAbstract(JOY).unlock();\n', '  }\n', '\n', '  // be sure to get the joy token ownerships\n', '  function start() public returns (bool) {\n', '    require (msg.sender == joysoWallet);\n', '    startTime = now;\n', '    endTime = now + 24 hours;\n', '  }\n', '\n', '  function changeJoysoWallet(address _joysoWallet) public returns (bool) {\n', '    require (msg.sender == joysoWallet);\n', '    joysoWallet = _joysoWallet;\n', '  }\n', '}']