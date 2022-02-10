['pragma solidity ^0.4.24;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that revert on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, reverts on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "    // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "    // benefit is lost if 'b' is also tested.\n", '    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '\n', '    uint256 c = a * b;\n', '    require(c / a == b);\n', '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b > 0); // Solidity only automatically asserts when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b <= a);\n', '    uint256 c = a - b;\n', '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, reverts on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    require(c >= a);\n', '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Divides two numbers and returns the remainder (unsigned integer modulo),\n', '  * reverts when dividing by zero.\n', '  */\n', '  function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b != 0);\n', '    return a % b;\n', '  }\n', '}\n', '\n', 'contract Project424_2 {\n', '  using SafeMath for uint256;\n', '\n', '  address constant MARKETING_ADDRESS = 0xcc1B012Dc66f51E6cE77122711A8F730eF5a97fa;\n', '  address constant TEAM_ADDRESS = 0x155a3c1Ab0Ac924cB3079804f3784d4d13cF3a45;\n', '  address constant REFUND_ADDRESS = 0x732445bfB4F9541ba4A295d31Fb830B2ffdA80F8;\n', '\n', '  uint256 constant ONE_HUNDREDS_PERCENTS = 10000;      // 100%\n', '  uint256 constant INCOME_MAX_PERCENT = 5000;          // 50%\n', '  uint256 constant MARKETING_FEE = 1000;               // 10%\n', '  uint256 constant WITHDRAWAL_PERCENT = 1500;          // 15%\n', '  uint256 constant TEAM_FEE = 300;                     // 3%\n', '  uint256 constant REFUND_FEE = 200;                   // 2%\n', '  uint256 constant INCOME_PERCENT = 150;               // 1.5%\n', '  uint256 constant BALANCE_WITHDRAWAL_PERCENT = 10;    // 0.1%\n', '  uint256 constant BALANCE_INCOME_PERCENT = 1;         // 0.01%\n', '\n', '  uint256 constant DAY = 86400;                        // 1 day\n', '\n', '  uint256 constant SPECIAL_NUMBER = 4240 szabo;        // 0.00424 eth\n', '  \n', '  event AddInvestor(address indexed investor, uint256 amount);\n', '\n', '  struct User {\n', '    uint256 firstTime;\n', '    uint256 deposit;\n', '  }\n', '  mapping(address => User) public users;\n', '\n', '  function () payable external {\n', '    User storage user = users[msg.sender];\n', '\n', '    // deposits\n', '    if ( msg.value != 0 && user.firstTime == 0 ) {\n', '      user.firstTime = now;\n', '      user.deposit = msg.value;\n', '      AddInvestor(msg.sender, msg.value);\n', '      \n', '      MARKETING_ADDRESS.send(msg.value.mul(MARKETING_FEE).div(ONE_HUNDREDS_PERCENTS));\n', '      TEAM_ADDRESS.send(msg.value.mul(TEAM_FEE).div(ONE_HUNDREDS_PERCENTS));\n', '      REFUND_ADDRESS.send(msg.value.mul(REFUND_FEE).div(ONE_HUNDREDS_PERCENTS));\n', '\n', '    } else if ( msg.value == SPECIAL_NUMBER && user.firstTime != 0 ) { // withdrawal\n', '      uint256 withdrawalSum = userWithdrawalSum(msg.sender).add(SPECIAL_NUMBER);\n', '\n', '      // check all funds\n', '      if (withdrawalSum >= address(this).balance) {\n', '        withdrawalSum = address(this).balance;\n', '      }\n', '\n', '      // deleting\n', '      user.firstTime = 0;\n', '      user.deposit = 0;\n', '\n', '      msg.sender.send(withdrawalSum);\n', '    } else {\n', '      revert();\n', '    }\n', '  }\n', '\n', '  function userWithdrawalSum(address wallet) public view returns(uint256) {\n', '    User storage user = users[wallet];\n', '    uint256 daysDuration = getDays(wallet);\n', '    uint256 withdrawal = user.deposit;\n', '\n', '\n', '    (uint256 getBalanceWithdrawalPercent, uint256 getBalanceIncomePercent) = getBalancePercents();\n', '    uint currentDeposit = user.deposit;\n', '    \n', '    if (daysDuration == 0) {\n', '      return withdrawal.sub(withdrawal.mul(WITHDRAWAL_PERCENT.add(getBalanceWithdrawalPercent)).div(ONE_HUNDREDS_PERCENTS));\n', '    }\n', '\n', '    for (uint256 i = 0; i < daysDuration; i++) {\n', '      currentDeposit = currentDeposit.add(currentDeposit.mul(INCOME_PERCENT.add(getBalanceIncomePercent)).div(ONE_HUNDREDS_PERCENTS));\n', '\n', '      if (currentDeposit >= user.deposit.add(user.deposit.mul(INCOME_MAX_PERCENT).div(ONE_HUNDREDS_PERCENTS))) {\n', '        withdrawal = user.deposit.add(user.deposit.mul(INCOME_MAX_PERCENT).div(ONE_HUNDREDS_PERCENTS));\n', '\n', '        break;\n', '      } else {\n', '        withdrawal = currentDeposit.sub(currentDeposit.mul(WITHDRAWAL_PERCENT.add(getBalanceWithdrawalPercent)).div(ONE_HUNDREDS_PERCENTS));\n', '      }\n', '    }\n', '    \n', '    return withdrawal;\n', '  }\n', '  \n', '  function getDays(address wallet) public view returns(uint256) {\n', '    User storage user = users[wallet];\n', '    if (user.firstTime == 0) {\n', '        return 0;\n', '    } else {\n', '        return (now.sub(user.firstTime)).div(DAY);\n', '    }\n', '  }\n', '\n', '  function getBalancePercents() public view returns(uint256 withdrawalRate, uint256 incomeRate) {\n', '    if (address(this).balance >= 100 ether) {\n', '      if (address(this).balance >= 5000 ether) {\n', '        withdrawalRate = 500;\n', '        incomeRate = 50;\n', '      } else {\n', '        uint256 steps = (address(this).balance).div(100 ether);\n', '        uint256 withdrawalUtility = 0;\n', '        uint256 incomeUtility = 0;\n', '\n', '        for (uint i = 0; i < steps; i++) {\n', '          withdrawalUtility = withdrawalUtility.add(BALANCE_WITHDRAWAL_PERCENT);\n', '          incomeUtility = incomeUtility.add(BALANCE_INCOME_PERCENT);\n', '        }\n', '        \n', '        withdrawalRate = withdrawalUtility;\n', '        incomeRate = incomeUtility;\n', '      }\n', '    } else {\n', '      withdrawalRate = 0;\n', '      incomeRate = 0;\n', '    }\n', '  }\n', '}']