['pragma solidity ^0.4.19;\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public view returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract LockingContract is Ownable {\n', '  using SafeMath for uint256;\n', '\n', '  event NotedTokens(address indexed _beneficiary, uint256 _tokenAmount);\n', '  event ReleasedTokens(address indexed _beneficiary);\n', '  event ReducedLockingTime(uint256 _newUnlockTime);\n', '\n', '  ERC20 public tokenContract;\n', '  mapping(address => uint256) public tokens;\n', '  uint256 public totalTokens;\n', '  uint256 public unlockTime;\n', '\n', '  function isLocked() public view returns(bool) {\n', '    return now < unlockTime;\n', '  }\n', '\n', '  modifier onlyWhenUnlocked() {\n', '    require(!isLocked());\n', '    _;\n', '  }\n', '\n', '  modifier onlyWhenLocked() {\n', '    require(isLocked());\n', '    _;\n', '  }\n', '\n', '  function LockingContract(ERC20 _tokenContract, uint256 _unlockTime) public {\n', '    require(_unlockTime > 0);\n', '    unlockTime = _unlockTime;\n', '    tokenContract = _tokenContract;\n', '  }\n', '\n', '  function balanceOf(address _owner) public view returns (uint256 balance) {\n', '    return tokens[_owner];\n', '  }\n', '\n', '  // Should only be done from another contract.\n', '  // To ensure that the LockingContract can release all noted tokens later,\n', '  // one should mint/transfer tokens to the LockingContract&#39;s account prior to noting\n', '  function noteTokens(address _beneficiary, uint256 _tokenAmount) external onlyOwner onlyWhenLocked {\n', '    uint256 tokenBalance = tokenContract.balanceOf(this);\n', '    require(tokenBalance == totalTokens.add(_tokenAmount));\n', '\n', '    tokens[_beneficiary] = tokens[_beneficiary].add(_tokenAmount);\n', '    totalTokens = totalTokens.add(_tokenAmount);\n', '    NotedTokens(_beneficiary, _tokenAmount);\n', '  }\n', '\n', '  function releaseTokens(address _beneficiary) public onlyWhenUnlocked {\n', '    uint256 amount = tokens[_beneficiary];\n', '    tokens[_beneficiary] = 0;\n', '    require(tokenContract.transfer(_beneficiary, amount)); \n', '    totalTokens = totalTokens.sub(amount);\n', '    ReleasedTokens(_beneficiary);\n', '  }\n', '\n', '  function reduceLockingTime(uint256 _newUnlockTime) public onlyOwner onlyWhenLocked {\n', '    require(_newUnlockTime >= now);\n', '    require(_newUnlockTime < unlockTime);\n', '    unlockTime = _newUnlockTime;\n', '    ReducedLockingTime(_newUnlockTime);\n', '  }\n', '}']