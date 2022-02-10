['pragma solidity ^0.4.17;\n', '\n', 'contract Ownable {\n', '  address public owner;\n', '  \n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  function Ownable() internal {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  function transferOwnership(address newOwner) onlyOwner public {\n', '    require(newOwner != address(0));\n', '    OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '}\n', '\n', 'contract ERC20Basic {\n', '  function balanceOf(address who) public constant returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '}\n', '\n', 'library SafeERC20 {\n', '  function safeTransfer(ERC20Basic token, address to, uint256 value) internal {\n', '    assert(token.transfer(to, value));\n', '  }\n', '}\n', '\n', '/**\n', ' * @title TokenTimelock\n', ' * @dev TokenTimelock is a token holder contract that will allow a\n', ' * beneficiary to extract the tokens after a given release time\n', ' */\n', 'contract TokenTimelock is Ownable{\n', '  using SafeERC20 for ERC20Basic;\n', '  ERC20Basic public token;   // ERC20 basic token contract being held\n', '  uint64 public releaseTime; // timestamp when token claim is enabled\n', '\n', '  function TokenTimelock(ERC20Basic _token, uint64 _releaseTime) public {\n', '    require(_releaseTime > now);\n', '    token = _token;\n', '    owner = msg.sender;\n', '    releaseTime = _releaseTime;\n', '  }\n', '\n', '  /**\n', '   * @notice Transfers tokens held by timelock to owner.\n', '   */\n', '  function claim() public onlyOwner {\n', '    require(now >= releaseTime);\n', '\n', '    uint256 amount = token.balanceOf(this);\n', '    require(amount > 0);\n', '\n', '    token.safeTransfer(owner, amount);\n', '  }\n', '}']