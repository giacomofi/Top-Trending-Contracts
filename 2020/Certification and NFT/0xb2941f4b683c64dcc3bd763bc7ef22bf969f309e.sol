['pragma solidity 0.6.8;\n', '\n', 'library SafeMath {\n', '  /**\n', '  * @dev Multiplies two unsigned integers, reverts on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "    // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "    // benefit is lost if 'b' is also tested.\n", '    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '    if (a == 0) {\n', '        return 0;\n', '    }\n', '\n', '    uint256 c = a * b;\n', '    require(c / a == b);\n', '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // Solidity only automatically asserts when dividing by 0\n', '    require(b > 0);\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b <= a);\n', '    uint256 c = a - b;\n', '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two unsigned integers, reverts on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    require(c >= a);\n', '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),\n', '  * reverts when dividing by zero.\n', '  */\n', '  function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b != 0);\n', '    return a % b;\n', '  }\n', '}\n', '\n', 'interface ERC20 {\n', '  function balanceOf(address who) external view returns (uint256);\n', '  function allowance(address owner, address spender) external  view returns (uint256);\n', '  function transfer(address to, uint value) external  returns (bool success);\n', '  function transferFrom(address from, address to, uint256 value) external returns (bool success);\n', '  function approve(address spender, uint value) external returns (bool success);\n', '}\n', '\n', 'contract yRiseTokenSale {\n', '  using SafeMath for uint256;\n', '\n', '  uint256 public totalSold;\n', '  ERC20 public yRiseToken;\n', '  address payable public owner;\n', '  uint256 public collectedETH;\n', '  uint256 public startDate;\n', '  bool public softCapMet;\n', '  bool private presaleClosed = false;\n', '  uint256 private ethWithdrawals = 0;\n', '  uint256 private lastWithdrawal;\n', '\n', '  // tracks all contributors.\n', '  mapping(address => uint256) internal _contributions;\n', '  // adjusts for different conversion rates.\n', '  mapping(address => uint256) internal _averagePurchaseRate;\n', '  // total contributions from wallet.\n', '  mapping(address => uint256) internal _numberOfContributions;\n', '\n', '  constructor(address _wallet) public {\n', '    owner = msg.sender;\n', '    yRiseToken = ERC20(_wallet);\n', '  }\n', '\n', '  uint256 amount;\n', '  uint256 rateDay1 = 20;\n', '  uint256 rateDay2 = 16;\n', '  uint256 rateDay3 = 13;\n', '  uint256 rateDay4 = 10;\n', '  uint256 rateDay5 = 8;\n', ' \n', '  // Converts ETH to yRise and sends new yRise to the sender\n', '  receive () external payable {\n', '    require(startDate > 0 && now.sub(startDate) <= 7 days);\n', '    require(yRiseToken.balanceOf(address(this)) > 0);\n', '    require(msg.value >= 0.1 ether && msg.value <= 3 ether);\n', '    require(!presaleClosed);\n', '     \n', '    if (now.sub(startDate) <= 1 days) {\n', '       amount = msg.value.mul(20);\n', '       _averagePurchaseRate[msg.sender] = _averagePurchaseRate[msg.sender].add(rateDay1.mul(10));\n', '    } else if(now.sub(startDate) > 1 days && now.sub(startDate) <= 2 days) {\n', '       amount = msg.value.mul(16);\n', '       _averagePurchaseRate[msg.sender] = _averagePurchaseRate[msg.sender].add(rateDay2.mul(10));\n', '    } else if(now.sub(startDate) > 2 days && now.sub(startDate) <= 3 days) {\n', '       amount = msg.value.mul(13);\n', '       _averagePurchaseRate[msg.sender] = _averagePurchaseRate[msg.sender].add(rateDay3.mul(10));\n', '    } else if(now.sub(startDate) > 3 days && now.sub(startDate) <= 4 days) {\n', '       amount = msg.value.mul(10);\n', '       _averagePurchaseRate[msg.sender] = _averagePurchaseRate[msg.sender].add(rateDay4.mul(10));\n', '    } else if(now.sub(startDate) > 4 days) {\n', '       amount = msg.value.mul(8);\n', '       _averagePurchaseRate[msg.sender] = _averagePurchaseRate[msg.sender].add(rateDay5.mul(10));\n', '    }\n', '    \n', '    require(amount <= yRiseToken.balanceOf(address(this)));\n', '    // update constants.\n', '    totalSold = totalSold.add(amount);\n', '    collectedETH = collectedETH.add(msg.value);\n', '    // update address contribution + total contributions.\n', '    _contributions[msg.sender] = _contributions[msg.sender].add(amount);\n', '    _numberOfContributions[msg.sender] = _numberOfContributions[msg.sender].add(1);\n', '    // transfer the tokens.\n', '    yRiseToken.transfer(msg.sender, amount);\n', '    // check if soft cap is met.\n', '    if (!softCapMet && collectedETH >= 100 ether) {\n', '      softCapMet = true;\n', '    }\n', '  }\n', '\n', '  // Converts ETH to yRise and sends new yRise to the sender\n', '  function contribute() external payable {\n', '    require(startDate > 0 && now.sub(startDate) <= 7 days);\n', '    require(yRiseToken.balanceOf(address(this)) > 0);\n', '    require(msg.value >= 0.1 ether && msg.value <= 3 ether);\n', '    require(!presaleClosed);\n', '\n', '    if (now.sub(startDate) <= 1 days) {\n', '       amount = msg.value.mul(20);\n', '       _averagePurchaseRate[msg.sender] = _averagePurchaseRate[msg.sender].add(rateDay1.mul(10));\n', '    } else if(now.sub(startDate) > 1 days && now.sub(startDate) <= 2 days) {\n', '       amount = msg.value.mul(16);\n', '       _averagePurchaseRate[msg.sender] = _averagePurchaseRate[msg.sender].add(rateDay2.mul(10));\n', '    } else if(now.sub(startDate) > 2 days && now.sub(startDate) <= 3 days) {\n', '       amount = msg.value.mul(13);\n', '       _averagePurchaseRate[msg.sender] = _averagePurchaseRate[msg.sender].add(rateDay3.mul(10));\n', '    } else if(now.sub(startDate) > 3 days && now.sub(startDate) <= 4 days) {\n', '       amount = msg.value.mul(10);\n', '       _averagePurchaseRate[msg.sender] = _averagePurchaseRate[msg.sender].add(rateDay4.mul(10));\n', '    } else if(now.sub(startDate) > 4 days) {\n', '       amount = msg.value.mul(8);\n', '       _averagePurchaseRate[msg.sender] = _averagePurchaseRate[msg.sender].add(rateDay5.mul(10));\n', '    }\n', '        \n', '    require(amount <= yRiseToken.balanceOf(address(this)));\n', '    // update constants.\n', '    totalSold = totalSold.add(amount);\n', '    collectedETH = collectedETH.add(msg.value);\n', '    // update address contribution + total contributions.\n', '    _contributions[msg.sender] = _contributions[msg.sender].add(amount);\n', '    _numberOfContributions[msg.sender] = _numberOfContributions[msg.sender].add(1);\n', '    // transfer the tokens.\n', '    yRiseToken.transfer(msg.sender, amount);\n', '    // check if soft cap is met.\n', '    if (!softCapMet && collectedETH >= 100 ether) {\n', '      softCapMet = true;\n', '    }\n', '  }\n', '\n', '  function numberOfContributions(address from) public view returns(uint256) {\n', '    return _numberOfContributions[address(from)]; \n', '  }\n', '\n', '  function contributions(address from) public view returns(uint256) {\n', '    return _contributions[address(from)];\n', '  }\n', '\n', '  function averagePurchaseRate(address from) public view returns(uint256) {\n', '    return _averagePurchaseRate[address(from)];\n', '  }\n', '\n', "  // if the soft cap isn't met and the presale period ends (7 days) enable\n", '  // users to buy back their ether.\n', '  function buyBackETH(address payable from) public {\n', '    require(now.sub(startDate) > 7 days && !softCapMet);\n', '    require(_contributions[from] > 0);\n', '    uint256 exchangeRate = _averagePurchaseRate[from].div(10).div(_numberOfContributions[from]);\n', '    uint256 contribution = _contributions[from];\n', '    // remove funds from users contributions.\n', '    _contributions[from] = 0;\n', '    // transfer funds back to user.\n', '    from.transfer(contribution.div(exchangeRate));\n', '  }\n', '\n', '  // Function to withdraw raised ETH (staggered withdrawals)\n', '  // Only the contract owner can call this function\n', '  function withdrawETH() public {\n', '    require(msg.sender == owner && address(this).balance > 0);\n', '    require(softCapMet == true && presaleClosed == true);\n', '    uint256 withdrawAmount;\n', '    // first ether withdrawal (max 150 ETH)\n', '    if (ethWithdrawals == 0) {\n', '      if (collectedETH <= 150 ether) {\n', '        withdrawAmount = collectedETH;\n', '      } else {\n', '        withdrawAmount = 150 ether;\n', '      }\n', '    } else {\n', '      // remaining ether withdrawal (max 150 ETH per withdrawal)\n', '      // staggered in 7 day periods.\n', '      uint256 currDate = now;\n', '      // ensure that it has been at least 7 days.\n', '      require(currDate.sub(lastWithdrawal) >= 7 days);\n', '      if (collectedETH <= 150 ether) {\n', '        withdrawAmount = collectedETH;\n', '      } else {\n', '        withdrawAmount = 150 ether;\n', '      }\n', '    }\n', '    lastWithdrawal = now;\n', '    ethWithdrawals = ethWithdrawals.add(1);\n', '    collectedETH = collectedETH.sub(withdrawAmount);\n', '    owner.transfer(withdrawAmount);\n', '  }\n', '\n', '  function endPresale() public {\n', '    require(msg.sender == owner);\n', '    presaleClosed = true;\n', '  }\n', '\n', '  // Function to burn remaining yRise (sale must be over to call)\n', '  // Only the contract owner can call this function\n', '  function burnyRise() public {\n', '    require(msg.sender == owner && yRiseToken.balanceOf(address(this)) > 0 && now.sub(startDate) > 7 days);\n', '    // burn the left over.\n', '    yRiseToken.transfer(address(0), yRiseToken.balanceOf(address(this)));\n', '  }\n', '  \n', '  //Starts the sale\n', '  //Only the contract owner can call this function\n', '  function startSale() public {\n', '    require(msg.sender == owner && startDate==0);\n', '    startDate=now;\n', '  }\n', '  \n', '  //Function to query the supply of yRise in the contract\n', '  function availableyRise() public view returns(uint256) {\n', '    return yRiseToken.balanceOf(address(this));\n', '  }\n', '}']