['pragma solidity ^0.4.24;\n', '\n', '// File: contracts/math/SafeMath.sol\n', '\n', '/**\n', ' * Copyright (c) 2016 Smart Contract Solutions, Inc.\n', ' * Released under the MIT license.\n', ' * https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/LICENSE\n', '*/\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    // uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return a / b;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '// File: contracts/token/ERC20/ERC20Interface.sol\n', '\n', '/**\n', ' * Copyright (c) 2016 Smart Contract Solutions, Inc.\n', ' * Released under the MIT license.\n', ' * https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/LICENSE\n', '*/\n', '\n', '/**\n', ' * @title \n', ' * @dev \n', ' */\n', 'contract ERC20Interface {\n', '  function totalSupply() external view returns (uint256);\n', '  function balanceOf(address who) external view returns (uint256);\n', '  function transfer(address to, uint256 value) external returns (bool);\n', '  function allowance(address owner, address spender) external view returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) external returns (bool);\n', '  function approve(address spender, uint256 value) external returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '// File: contracts/token/ERC20/ERC20Standard.sol\n', '\n', '/**\n', ' * Copyright (c) 2016 Smart Contract Solutions, Inc.\n', ' * Released under the MIT license.\n', ' * https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/LICENSE\n', '*/\n', '\n', '\n', '\n', '/**\n', ' * @title \n', ' * @dev \n', ' */\n', 'contract ERC20Standard is ERC20Interface {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '  mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '  uint256 totalSupply_;\n', '\n', '  /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) external returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[msg.sender]);\n', '\n', '    // SafeMath.sub will throw if there is not enough balance.\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    emit Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amount of tokens to be transferred\n', '   */\n', '  function transferFrom(address _from, address _to, uint256 _value) external returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[_from]);\n', '    require(_value <= allowed[_from][msg.sender]);\n', '\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '    emit Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   *\n', '   * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', "   * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:\n", '   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   * \n', '   * To avoid this issue, allowances are only allowed to be changed between zero and non-zero.\n', '   *\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _value) external returns (bool) {\n', '    require(allowed[msg.sender][_spender] == 0 || _value == 0);\n', '    allowed[msg.sender][_spender] = _value;\n', '    emit Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev total number of tokens in existence\n', '  */\n', '  function totalSupply() external view returns (uint256) {\n', '    return totalSupply_;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) external view returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifying the amount of tokens still available for the spender.\n', '   */\n', '  function allowance(address _owner, address _spender) external view returns (uint256) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  /**\n', '   * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '   *\n', '   * approve should be called when allowed[_spender] == 0. To increment\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _addedValue The amount of tokens to increase the allowance by.\n', '   */\n', '  function increaseApproval(address _spender, uint _addedValue) external returns (bool) {\n', '    allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '   *\n', '   * approve should be called when allowed[_spender] == 0. To decrement\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _subtractedValue The amount of tokens to decrease the allowance by.\n', '   */\n', '  function decreaseApproval(address _spender, uint _subtractedValue) external returns (bool) {\n', '    uint oldValue = allowed[msg.sender][_spender];\n', '    if (_subtractedValue > oldValue) {\n', '      allowed[msg.sender][_spender] = 0;\n', '    } else {\n', '      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '    }\n', '    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '}\n', '\n', '// File: contracts/token/ERC223/ERC223ReceivingContract.sol\n', '\n', '/**\n', ' * Released under the MIT license.\n', ' * https://github.com/Dexaran/ERC223-token-standard/blob/master/LICENSE\n', '*/\n', '\n', '\n', '/**\n', ' * @title Contract that will work with ERC223 tokens.\n', ' */\n', ' \n', 'contract ERC223ReceivingContract { \n', '/**\n', ' * @dev Standard ERC223 function that will handle incoming token transfers.\n', ' *\n', ' * @param _from  Token sender address.\n', ' * @param _value Amount of tokens.\n', ' * @param _data  Transaction metadata.\n', ' */\n', '    function tokenFallback(address _from, uint _value, bytes _data) public;\n', '}\n', '\n', '// File: contracts/token/ERC223/ERC223Interface.sol\n', '\n', '/**\n', ' * Released under the MIT license.\n', ' * https://github.com/Dexaran/ERC223-token-standard/blob/master/LICENSE\n', '*/\n', '\n', 'contract ERC223Interface {\n', '    function totalSupply() external view returns (uint256);\n', '    function balanceOf(address who) external view returns (uint256);\n', '    function transfer(address to, uint256 value) external returns (bool);\n', '    function transfer(address to, uint256 value, bytes data) external returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '// File: contracts/token/ERC223/ERC223Standard.sol\n', '\n', '/**\n', ' * Released under the MIT license.\n', ' * https://github.com/Dexaran/ERC223-token-standard/blob/master/LICENSE\n', '*/\n', '\n', '\n', '\n', '\n', '\n', '/**\n', ' * @title Reference implementation of the ERC223 standard token.\n', ' */\n', 'contract ERC223Standard is ERC223Interface, ERC20Standard {\n', '    using SafeMath for uint256;\n', '\n', '    /**\n', '     * @dev Transfer the specified amount of tokens to the specified address.\n', '     *      Invokes the `tokenFallback` function if the recipient is a contract.\n', '     *      The token transfer fails if the recipient is a contract\n', '     *      but does not implement the `tokenFallback` function\n', '     *      or the fallback function to receive funds.\n', '     *\n', '     * @param _to    Receiver address.\n', '     * @param _value Amount of tokens that will be transferred.\n', '     * @param _data  Transaction metadata.\n', '     */\n', '    function transfer(address _to, uint256 _value, bytes _data) external returns(bool){\n', '        // Standard function transfer similar to ERC20 transfer with no _data .\n', '        // Added due to backwards compatibility reasons .\n', '        uint256 codeLength;\n', '\n', '        assembly {\n', '            // Retrieve the size of the code on target address, this needs assembly .\n', '            codeLength := extcodesize(_to)\n', '        }\n', '\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        if(codeLength>0) {\n', '            ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);\n', '            receiver.tokenFallback(msg.sender, _value, _data);\n', '        }\n', '        emit Transfer(msg.sender, _to, _value);\n', '    }\n', '    \n', '    /**\n', '     * @dev Transfer the specified amount of tokens to the specified address.\n', '     *      This function works the same with the previous one\n', "     *      but doesn't contain `_data` param.\n", '     *      Added due to backwards compatibility reasons.\n', '     *\n', '     * @param _to    Receiver address.\n', '     * @param _value Amount of tokens that will be transferred.\n', '     */\n', '    function transfer(address _to, uint256 _value) external returns(bool){\n', '        uint256 codeLength;\n', '        bytes memory empty;\n', '\n', '        assembly {\n', '            // Retrieve the size of the code on target address, this needs assembly .\n', '            codeLength := extcodesize(_to)\n', '        }\n', '\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        if(codeLength>0) {\n', '            ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);\n', '            receiver.tokenFallback(msg.sender, _value, empty);\n', '        }\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', ' \n', '}\n', '\n', '// File: contracts/ownership/Ownable.sol\n', '\n', '/**\n', ' * Copyright (c) 2016 Smart Contract Solutions, Inc.\n', ' * Released under the MIT license.\n', ' * https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/LICENSE\n', '*/\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', '// File: contracts/token/extentions/MintableToken.sol\n', '\n', '/**\n', ' * Copyright (c) 2016 Smart Contract Solutions, Inc.\n', ' * Released under the MIT license.\n', ' * https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/LICENSE\n', '*/\n', '\n', '\n', '\n', '\n', '/**\n', ' * @title Mintable token\n', ' * @dev Simple ERC20 Token example, with mintable token creation\n', ' * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120\n', ' * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol\n', ' */\n', 'contract MintableToken is ERC223Standard, Ownable {\n', '  event Mint(address indexed to, uint256 amount);\n', '  event MintFinished();\n', '\n', '  bool public mintingFinished = false;\n', '\n', '  modifier canMint() {\n', '    require(!mintingFinished);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to mint tokens\n', '   * @param _to The address that will receive the minted tokens.\n', '   * @param _amount The amount of tokens to mint.\n', '   * @return A boolean that indicates if the operation was successful.\n', '   */\n', '  function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {\n', '    totalSupply_ = totalSupply_.add(_amount);\n', '    balances[_to] = balances[_to].add(_amount);\n', '    emit Mint(_to, _amount);\n', '    emit Transfer(address(0), _to, _amount);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to stop minting new tokens.\n', '   * @return True if the operation was successful.\n', '   */\n', '  function finishMinting() onlyOwner canMint public returns (bool) {\n', '    mintingFinished = true;\n', '    emit MintFinished();\n', '    return true;\n', '  }\n', '}\n', '\n', '// File: contracts/DAICOVO/DaicovoStandardToken.sol\n', '\n', '/**\n', ' * @title DAICOVO standard ERC20, ERC223 compliant token\n', ' * @dev Inherited ERC20 and ERC223 token functionalities.\n', ' * @dev Extended with forceTransfer() function to support compatibility\n', " * @dev with exisiting apps which expects ERC20 token's transfer function berhavior.\n", ' */\n', 'contract DaicovoStandardToken is ERC20Standard, ERC223Standard, MintableToken {\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals;\n', '\n', '    constructor(string _name, string _symbol, uint8 _decimals) public {\n', '        name = _name;\n', '        symbol = _symbol;\n', '        decimals = _decimals;\n', '    }\n', '\n', '    /**\n', '     * @dev It provides an ERC20 compatible transfer function without checking of\n', "     * @dev target address whether it's contract or EOA address.\n", '     * @param _to    Receiver address.\n', '     * @param _value Amount of tokens that will be transferred.\n', '     */\n', '    function forceTransfer(address _to, uint _value) external returns(bool) {\n', '        require(_to != address(0x0));\n', '        require(_value <= balances[msg.sender]);\n', '\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '}\n', '\n', '// File: contracts/token/extentions/BurnableToken.sol\n', '\n', '/**\n', ' * Copyright (c) 2016 Smart Contract Solutions, Inc.\n', ' * Released under the MIT license.\n', ' * https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/LICENSE\n', '*/\n', '\n', '\n', '\n', '/**\n', ' * @title Burnable Token\n', ' * @dev Token that can be irreversibly burned (destroyed).\n', ' */\n', 'contract BurnableToken is ERC223Standard {\n', '\n', '  event Burn(address indexed burner, uint256 value);\n', '\n', '  /**\n', '   * @dev Burns a specific amount of tokens.\n', '   * @param _value The amount of token to be burned.\n', '   */\n', '  function burn(uint256 _value) public {\n', '    _burn(msg.sender, _value);\n', '  }\n', '\n', '  function _burn(address _who, uint256 _value) internal {\n', '    require(_value <= balances[_who]);\n', '    // no need to require value <= totalSupply, since that would imply the\n', "    // sender's balance is greater than the totalSupply, which *should* be an assertion failure\n", '\n', '    balances[_who] = balances[_who].sub(_value);\n', '    totalSupply_ = totalSupply_.sub(_value);\n', '    emit Burn(_who, _value);\n', '    emit Transfer(_who, address(0), _value);\n', '  }\n', '}\n', '\n', '/**\n', ' * @title Capped token\n', ' * @dev Mintable token with a token cap.\n', ' */\n', 'contract CappedToken is MintableToken {\n', '\n', '  uint256 public cap;\n', '\n', '  constructor(uint256 _cap) public {\n', '    require(_cap > 0);\n', '    cap = _cap;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to mint tokens\n', '   * @param _to The address that will receive the minted tokens.\n', '   * @param _amount The amount of tokens to mint.\n', '   * @return A boolean that indicates if the operation was successful.\n', '   */\n', '  function mint(address _to, uint256 _amount) public returns (bool) {\n', '    require(totalSupply_.add(_amount) <= cap);\n', '    return super.mint(_to, _amount);\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * @title HWG Live Token\n', ' * @dev ERC20, ERC223 compliant mintable, burnable token.\n', ' */\n', 'contract HWGL is DaicovoStandardToken, BurnableToken, CappedToken {\n', '    constructor () public DaicovoStandardToken("HWG Live", "HWGL", 8) CappedToken(1000000000000000000) {\n', '    }\n', '}']