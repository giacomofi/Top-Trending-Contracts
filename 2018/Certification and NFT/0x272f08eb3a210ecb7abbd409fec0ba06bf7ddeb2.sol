['pragma solidity 0.4.25;\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that revert on error\n', ' */\n', 'library SafeMath {\n', '  /**\n', '  * @dev Multiplies two numbers, reverts on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "    // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "    // benefit is lost if 'b' is also tested.\n", '    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    require(c / a == b);\n', '    return c;\n', '  }\n', '  /**\n', '  * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b > 0); // Solidity only automatically asserts when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '  /**\n', '  * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b <= a);\n', '    uint256 c = a - b;\n', '    return c;\n', '  }\n', '  /**\n', '  * @dev Adds two numbers, reverts on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    require(c >= a);\n', '    return c;\n', '  }\n', '  /**\n', '  * @dev Divides two numbers and returns the remainder (unsigned integer modulo),\n', '  * reverts when dividing by zero.\n', '  */\n', '  function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b != 0);\n', '    return a % b;\n', '  }\n', '}\n', 'contract Token {\n', '  /// @return total amount of tokens\n', '  function totalSupply() pure public returns (uint256 supply);\n', '  /// @param _owner The address from which the balance will be retrieved\n', '  /// @return The balance\n', '  function balanceOf(address _owner) pure public returns (uint256 balance);\n', '  /// @notice send `_value` token to `_to` from `msg.sender`\n', '  /// @param _to The address of the recipient\n', '  /// @param _value The amount of token to be transferred\n', '  /// @return Whether the transfer was successful or not\n', '  function transfer(address _to, uint256 _value) public returns (bool success);\n', '  /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`\n', '  /// @param _from The address of the sender\n', '  /// @param _to The address of the recipient\n', '  /// @param _value The amount of token to be transferred\n', '  /// @return Whether the transfer was successful or not\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);\n', '  /// @notice `msg.sender` approves `_addr` to spend `_value` tokens\n', '  /// @param _spender The address of the account able to transfer the tokens\n', '  /// @param _value The amount of wei to be approved for transfer\n', '  /// @return Whether the approval was successful or not\n', '  function approve(address _spender, uint256 _value) public returns (bool success);\n', '  /// @param _owner The address of the account owning tokens\n', '  /// @param _spender The address of the account able to transfer the tokens\n', '  /// @return Amount of remaining tokens allowed to spent\n', '  function allowance(address _owner, address _spender) pure public returns (uint256 remaining);\n', '  event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '  event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '  uint public decimals;\n', '  string public name;\n', '}\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address private _owner;\n', '  event OwnershipTransferred(\n', '    address indexed previousOwner,\n', '    address indexed newOwner\n', '  );\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  constructor() internal {\n', '    _owner = msg.sender;\n', '    emit OwnershipTransferred(address(0), _owner);\n', '  }\n', '  /**\n', '   * @return the address of the owner.\n', '   */\n', '  function owner() public view returns(address) {\n', '    return _owner;\n', '  }\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(isOwner());\n', '    _;\n', '  }\n', '  /**\n', '   * @return true if `msg.sender` is the owner of the contract.\n', '   */\n', '  function isOwner() public view returns(bool) {\n', '    return msg.sender == _owner;\n', '  }\n', '  /**\n', '   * @dev Allows the current owner to relinquish control of the contract.\n', '   * @notice Renouncing to ownership will leave the contract without an owner.\n', '   * It will not be possible to call the functions with the `onlyOwner`\n', '   * modifier anymore.\n', '   */\n', '  function renounceOwnership() public onlyOwner {\n', '    emit OwnershipTransferred(_owner, address(0));\n', '    _owner = address(0);\n', '  }\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    _transferOwnership(newOwner);\n', '  }\n', '  /**\n', '   * @dev Transfers control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function _transferOwnership(address newOwner) internal {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(_owner, newOwner);\n', '    _owner = newOwner;\n', '  }\n', '}\n', 'contract AirDrop is Ownable {\n', '  address public tokenAddress;\n', '  Token public token;\n', '  uint256 public valueAirDrop;\n', '  mapping (address => uint8) public payedAddress; \n', '  constructor() public{\n', '    valueAirDrop = 1 * 1 ether;\n', '  } \n', '  function setValueAirDrop(uint256 _valueAirDrop) public onlyOwner{\n', '    valueAirDrop = _valueAirDrop;\n', '  } \n', '  function setTokenAddress(address _address) onlyOwner public{\n', '    tokenAddress = _address;\n', '    token = Token(tokenAddress);  \n', '  }\n', '  function refund() onlyOwner public{\n', '    token.transfer(owner(), token.balanceOf(this));  \n', '  }\n', '  function () external payable {\n', '    require(msg.value == 0);\n', '    require(payedAddress[msg.sender] == 0);  \n', '    payedAddress[msg.sender] = 1;  \n', '    token.transfer(msg.sender, valueAirDrop);\n', '  }\n', '  function multisend(address[] _addressDestination)\n', '    onlyOwner\n', '    public {\n', '        uint256 i = 0;\n', '        while (i < _addressDestination.length) {\n', '           token.transfer(_addressDestination[i], valueAirDrop);\n', '           i += 1;\n', '        }\n', '    }  \n', '}']