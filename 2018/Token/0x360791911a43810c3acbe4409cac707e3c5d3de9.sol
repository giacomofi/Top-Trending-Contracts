['pragma solidity ^0.4.24;\n', '\n', 'contract ERC20Basic {\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title SafeERC20\n', ' * @dev Wrappers around ERC20 operations that throw on failure.\n', ' * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,\n', ' * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.\n', ' */\n', 'library SafeERC20 {\n', '  function safeTransfer(ERC20Basic token, address to, uint256 value) internal {\n', '    assert(token.transfer(to, value));\n', '  }\n', '}\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipRenounced(address indexed previousOwner);\n', '  event OwnershipTransferred(\n', '    address indexed previousOwner,\n', '    address indexed newOwner\n', '  );\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to relinquish control of the contract.\n', '   */\n', '  function renounceOwnership() public onlyOwner {\n', '    emit OwnershipRenounced(owner);\n', '    owner = address(0);\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param _newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address _newOwner) public onlyOwner {\n', '    _transferOwnership(_newOwner);\n', '  }\n', '\n', '  /**\n', '   * @dev Transfers control of the contract to a newOwner.\n', '   * @param _newOwner The address to transfer ownership to.\n', '   */\n', '  function _transferOwnership(address _newOwner) internal {\n', '    require(_newOwner != address(0));\n', '    emit OwnershipTransferred(owner, _newOwner);\n', '    owner = _newOwner;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title DragonAdvisors\n', ' * @dev DragonAdvisors works like a tap and release tokens periodically\n', ' * to advisors on the owners permission \n', ' */\n', 'contract DragonAdvisors is Ownable{\n', '  using SafeERC20 for ERC20Basic;\n', '  using SafeMath for uint256;\n', '\n', '  // ERC20 basic token contract being held\n', '  ERC20Basic public token;\n', '\n', '  // advisor address\n', '  address public advisor;\n', '\n', '  // amount of tokens available for release\n', '  uint256 public releasedTokens;\n', '  \n', '  event TokenTapAdjusted(uint256 released);\n', '\n', '  constructor() public {\n', '    token = ERC20Basic(0x814F67fA286f7572B041D041b1D99b432c9155Ee);\n', '    owner = address(0xA5101498679Fa973c5cF4c391BfF991249934E73);      // overriding owner\n', '\n', '    advisor = address(0xf1fE5972d7C16b56AD0b0a64ACE738801bC6356d);\n', '    \n', '    releasedTokens = 0;\n', '  }\n', '\n', '  /**\n', '   * @notice release tokens held by the contract to advisor.\n', '   */\n', '  function release(uint256 _amount) public {\n', '    require(_amount > 0);\n', '    require(releasedTokens >= _amount);\n', '    releasedTokens = releasedTokens.sub(_amount);\n', '    \n', '    uint256 balance = token.balanceOf(this);\n', '    require(balance >= _amount);\n', '    \n', '\n', '    token.safeTransfer(advisor, _amount);\n', '  }\n', '  \n', '  /**\n', '   * @notice Owner can move tokens to any address\n', '   */\n', '  function transferTokens(address _to, uint256 _amount) external {\n', '    require(_to != address(0x00));\n', '    require(_amount > 0);\n', '\n', '    uint256 balance = token.balanceOf(this);\n', '    require(balance >= _amount);\n', '\n', '    token.safeTransfer(_to, _amount);\n', '  }\n', '  \n', '  function adjustTap(uint256 _amount) external onlyOwner{\n', '      require(_amount > 0);\n', '      uint256 balance = token.balanceOf(this);\n', '      require(_amount <= balance);\n', '      releasedTokens = _amount;\n', '      emit TokenTapAdjusted(_amount);\n', '  }\n', '  \n', '  function () public payable {\n', '      revert();\n', '  }\n', '}']