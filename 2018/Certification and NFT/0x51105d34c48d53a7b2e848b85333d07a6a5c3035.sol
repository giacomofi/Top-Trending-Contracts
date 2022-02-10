['pragma solidity ^0.4.24;\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Interface for ERC223\n', ' */\n', 'interface ERC223 {\n', '    function balanceOf(address _owner) external constant returns (uint256);\n', '    \n', '    \n', '    function name() external constant returns  (string _name);\n', '    function symbol() external constant returns  (string _symbol);\n', '    function decimals() external constant returns (uint8 _decimals);\n', '    function totalSupply() external constant returns (uint256 _totalSupply);\n', '    \n', '    \n', '    function transfer(address _to, uint256 _value) external returns (bool ok);\n', '    function transfer(address _to, uint256 _value, bytes _data) public returns (bool ok);\n', '    function sell(uint256 _value) external returns (bool);\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event ERC223Transfer(address indexed _from, address indexed _to, uint256 _value, bytes _data);\n', '    event Sell(address indexed from, uint value);\n', '}\n', '\n', '\n', '/**\n', ' * @title ERC223ReceivingContract\n', ' * @dev Contract for ERC223 fallback\n', ' */\n', 'contract ERC223ReceivingContract {\n', '    function tokenFallback(address _from, uint _value, bytes _data) public;\n', '}\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipRenounced(address indexed previousOwner);\n', '  event OwnershipTransferred(\n', '    address indexed previousOwner,\n', '    address indexed newOwner\n', '  );\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to relinquish control of the contract.\n', '   * @notice Renouncing to ownership will leave the contract without an owner.\n', '   * It will not be possible to call the functions with the `onlyOwner`\n', '   * modifier anymore.\n', '   */\n', '  function renounceOwnership() public onlyOwner {\n', '    emit OwnershipRenounced(owner);\n', '    owner = address(0);\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param _newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address _newOwner) public onlyOwner {\n', '    _transferOwnership(_newOwner);\n', '  }\n', '\n', '  /**\n', '   * @dev Transfers control of the contract to a newOwner.\n', '   * @param _newOwner The address to transfer ownership to.\n', '   */\n', '  function _transferOwnership(address _newOwner) internal {\n', '    require(_newOwner != address(0));\n', '    emit OwnershipTransferred(owner, _newOwner);\n', '    owner = _newOwner;\n', '  }\n', '}\n', '\n', '\n', 'contract C3Coin is ERC223, Ownable {\n', '    using SafeMath for uint;\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals;\n', '    uint256 public totalSupply;\n', '    \n', '    constructor() public {\n', '        name = "C3 Coin";\n', '        symbol = "CCC";\n', '        decimals = 18;\n', '        totalSupply = 100000000000000000000000000000;\n', '        balances[msg.sender] = totalSupply;\n', '    } \n', '    \n', '    mapping (address => uint256) internal balances;\n', '    \n', '    address public icoContract;\n', '\n', '\n', '    /**\n', '    * @dev Getters\n', '    */ \n', '    // Function to access name of token .\n', '    function name() external constant returns (string _name) {\n', '      return name;\n', '    }\n', '    // Function to access symbol of token .\n', '    function symbol() external constant returns (string _symbol) {\n', '        return symbol;\n', '    }\n', '    // Function to access decimals of token .\n', '    function decimals() external constant returns (uint8 _decimals) {\n', '        return decimals;\n', '    }\n', '    // Function to access total supply of tokens .\n', '    function totalSupply() external constant returns (uint256 _totalSupply) {\n', '        return totalSupply;\n', '    }\n', '\n', '    \n', '\n', '\n', '   /**\n', '   * @notice This function is modified for erc223 standard\n', '   * @dev ERC20 transfer function added for backward compatibility.\n', '   * @param _to Address of token receiver\n', '   * @param _value Number of tokens to send\n', '   */\n', '   function transfer(address _to, uint256 _value) external returns (bool) {\n', '     require(_to != address(0));\n', '     require(_value <= balances[msg.sender] && balances[_to] + _value >= balances[_to]);\n', '     require(!isContract(_to));\n', '     balances[msg.sender] = balances[msg.sender].sub(_value);\n', '     balances[_to] = balances[_to].add(_value);\n', '     emit Transfer(msg.sender, _to, _value);\n', '     return true;\n', '   }\n', '   \n', '   \n', '  /**\n', '   * @dev Get balance of a token owner\n', '   * @param _owner address The address which one owns tokens\n', '   */\n', '  function balanceOf(address _owner) external constant returns (uint256 balance) {\n', '    return balances[_owner];\n', '   }\n', '  \n', '  /**\n', '   * @notice Instead of sending byte string for the transaction data, string type is used for more detailed description.\n', '   * @dev ERC223 transfer function \n', '   * @param _to Address of token receiver\n', '   * @param _value Number of tokens to send\n', '   * @param _data information for the transaction\n', '   */ \n', '  function transfer(address _to, uint _value, bytes _data) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[msg.sender] && balances[_to] + _value >= balances[_to]);\n', '    if(isContract(_to)) {\n', '        ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);\n', '        receiver.tokenFallback(msg.sender, _value, _data);\n', '    }\n', '        \n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    emit ERC223Transfer(msg.sender, _to, _value, _data);\n', '    return true;\n', '    }\n', '  \n', '  /**\n', '   * @dev Check if the given address is non-user\n', '   * @param _addr address to check\n', '   */   \n', '  function isContract(address _addr) private returns (bool is_contract) {\n', '      uint length;\n', '      assembly {\n', '            //retrieve the size of the code on target address, this needs assembly\n', '            length := extcodesize(_addr)\n', '      }\n', '      return (length>0);\n', '  }\n', '  \n', '  \n', '  /**\n', '   * @dev Set ICO contract address to supply tokens\n', '   * @param _icoContract address of an ICO smart contract\n', '   */   \n', '  function setIcoContract(address _icoContract) public onlyOwner {\n', '    if (_icoContract != address(0)) {\n', '      icoContract = _icoContract;\n', '    }\n', '  }\n', '  \n', '  /**\n', '   * @dev Supply tokens to ICO contract\n', '   * @param _value uint256 amount of tokens to sell\n', '   */\n', '  function sell(uint256 _value) public onlyOwner returns (bool) {\n', '    require(icoContract != address(0));\n', '    require(_value <= balances[msg.sender] && balances[icoContract] + _value >= balances[icoContract]); \n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[icoContract] = balances[icoContract].add(_value);\n', '    emit Sell(msg.sender, _value);\n', '    return true;\n', '  }\n', '  \n', '  /**\n', '   * @dev default payable function executed after receiving ether\n', '   */ \n', '  function () public payable {\n', '        // contract does not accept ether\n', '        revert();\n', '  }\n', '}']