['pragma solidity ^0.4.24;\n', '\n', 'library SafeMath {\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    return a / b;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '\n', '}\n', '\n', 'contract ERC20Basic {\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public view returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'library SafeERC20 {\n', '  function safeTransfer(ERC20Basic token, address to, uint256 value) internal {\n', '    assert(token.transfer(to, value));\n', '  }\n', '}\n', '\n', '/**\n', ' * @title JunketLockup\n', ' * @dev JunketLockup is a token holder contract that will allow a\n', ' * beneficiary to extract the tokens after a given release time\n', ' */\n', 'contract MacauJunket2{\n', '  using SafeERC20 for ERC20Basic;\n', '  using SafeMath for uint256;\n', '\n', '  // ERC20 basic token contract being held\n', '  ERC20Basic public token;\n', '\n', '  // beneficiary of tokens after they are released\n', '  address public beneficiary;\n', '\n', '  // timestamp when token release is enabled\n', '  uint256 public releaseTime;\n', '\n', '  uint256 public unlocked = 0;\n', '  \n', '  bool public withdrawalsInitiated = false;\n', '  \n', '  uint256 public year = 365 days; // equivalent to one year\n', '\n', '  constructor() public {\n', '    token = ERC20Basic(0x814F67fA286f7572B041D041b1D99b432c9155Ee);\n', '    \n', '    beneficiary = address(0xde41bB8f5c2C158440f7B5B9D18bE9b7C832DC4a);\n', '    \n', '    releaseTime = now + year;\n', '  }\n', '\n', '  /**\n', '   * @notice Transfers tokens held by timelock to beneficiary.\n', '   */\n', '  function release(uint256 _amount) public {\n', '    \n', '    uint256 balance = token.balanceOf(address(this));\n', '    require(balance > 0);\n', '    \n', '    if(!withdrawalsInitiated){\n', '        // unlock 50% of existing balance\n', '        unlocked = balance.div(2);\n', '        withdrawalsInitiated = true;\n', '    }\n', '    \n', '    if(now >= releaseTime){\n', '        unlocked = balance;\n', '    }\n', '    \n', '    require(_amount <= unlocked);\n', '    unlocked = unlocked.sub(_amount);\n', '    \n', '    token.safeTransfer(beneficiary, _amount);\n', '    \n', '  }\n', '  \n', '  function balanceOf() external view returns(uint256){\n', '      return token.balanceOf(address(this));\n', '  }\n', '  \n', '  function currentTime() external view returns(uint256){\n', '      return now;\n', '  }\n', '}']