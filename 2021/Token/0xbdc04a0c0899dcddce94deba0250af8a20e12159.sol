['/**\n', ' *Submitted for verification at Etherscan.io on 2021-05-04\n', '*/\n', '\n', 'pragma solidity ^0.6.12;\n', '\n', '// SPDX-License-Identifier: GPL-3.0\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '    address public owner;\n', '\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '    /**\n', '     * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '     * account.\n', '     */\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner, "Not authorized operation");\n', '        _;\n', '    }\n', '\n', '\n', '    /**\n', '     * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '     * @param newOwner The address to transfer ownership to.\n', '     */\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        require(newOwner != address(0), "Address shouldn\'t be zero");\n', '        emit OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '    }\n', '\n', '}\n', '\n', '\n', '/**\n', " * @dev Wrappers over Solidity's arithmetic operations with added overflow\n", ' * checks.\n', ' *\n', ' * Arithmetic operations in Solidity wrap on overflow. This can easily result\n', ' * in bugs, because programmers usually assume that an overflow raises an\n', ' * error, which is the standard behavior in high level programming languages.\n', ' * `SafeMath` restores this intuition by reverting the transaction when an\n', ' * operation overflows.\n', ' *\n', ' * Using this library instead of the unchecked operations eliminates an entire\n', " * class of bugs, so it's recommended to use it always.\n", ' */\n', 'library SafeMath {\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `+` operator.\n", '     *\n', '     * Requirements:\n', '     * - Addition cannot overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b <= a, "SafeMath: subtraction overflow");\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `*` operator.\n", '     *\n', '     * Requirements:\n', '     * - Multiplication cannot overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // Solidity only automatically asserts when dividing by 0\n', '        require(b > 0, "SafeMath: division by zero");\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b != 0, "SafeMath: modulo by zero");\n', '        return a % b;\n', '    }\n', '}\n', '\n', 'interface IERC20 {\n', '    /**\n', '     * @dev Returns the amount of tokens in existence.\n', '     */\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    /**\n', '     * @dev Returns the amount of tokens owned by `account`.\n', '     */\n', '    function balanceOf(address _owner) external view returns (uint256);\n', '\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    /**\n', '     * @dev Emitted when the allowance of a `spender` for an `owner` is set by\n', '     * a call to `approve`. `value` is the new allowance.\n', '     */\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '\n', '/**\n', ' * @dev Simple ERC20 Token example, with mintable token creation only during the deployement of the token contract */\n', '\n', 'contract TokenContract is Ownable{\n', '  using SafeMath for uint256;\n', '\n', '  string public name;\n', '  string public symbol;\n', '  uint8 public decimals;\n', '  uint256 public totalSupply;\n', '  address public tokenOwner;\n', '  address private ico;\n', '\n', '  mapping(address => uint256) balances;\n', '  mapping (address => mapping (address => uint256)) internal allowed;\n', '  mapping(address => bool) public vestedlist;\n', '\n', '  event SetICO(address indexed _ico);\n', '  event Mint(address indexed to, uint256 amount);\n', '  event MintFinished();\n', '  event UnlockToken();\n', '  event LockToken();\n', '  event Burn();\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '  event addedToVestedlist(address indexed _vestedAddress);\n', '  event removedFromVestedlist(address indexed _vestedAddress);\n', '\n', '  \n', '  bool public mintingFinished = false;\n', '  bool public locked = true;\n', '\n', '  modifier canMint() {\n', '    require(!mintingFinished);\n', '    _;\n', '  }\n', '  \n', '  modifier canTransfer() {\n', '    require(!locked || msg.sender == owner || msg.sender == ico);\n', '    _;\n', '  }\n', '  \n', '  modifier onlyAuthorized() {\n', '    require(msg.sender == owner || msg.sender == ico);\n', '    _;\n', '  }\n', '\n', '\n', '  constructor(string memory _name, string memory  _symbol, uint8 _decimals) public {\n', '    require (_decimals != 0);\n', '    name = _name;\n', '    symbol = _symbol;\n', '    decimals = _decimals;\n', '    totalSupply = 1000000000000;\n', '    balances[msg.sender] = totalSupply;\n', '    emit Transfer(address(0), msg.sender, totalSupply);\n', '\n', '\n', '  }\n', '\n', '  /**\n', '   * @dev Function to mint tokens\n', '   * @param _to The address that will receive the minted tokens.\n', '   * @param _amount The amount of tokens to mint.\n', '   * @return A boolean that indicates if the operation was successful.\n', '   */\n', '  function mint(address _to, uint256 _amount) public onlyAuthorized canMint returns (bool) {\n', '    totalSupply = totalSupply.add(_amount);\n', '    balances[_to] = balances[_to].add(_amount);\n', '    emit Mint(_to, _amount);\n', '    emit Transfer(address(this), _to, _amount);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to stop minting new tokens.\n', '   * @return True if the operation was successful.\n', '   */\n', '  function finishMinting() public onlyAuthorized canMint returns (bool) {\n', '    mintingFinished = true;\n', '    emit MintFinished();\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) public canTransfer returns (bool) {\n', '    require(_to != address(0));\n', '\trequire (!isVestedlisted(msg.sender));\n', '    require(_value <= balances[msg.sender]);\n', '    require (msg.sender != address(this));\n', '\n', '    // SafeMath.sub will throw if there is not enough balance.\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    emit Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '\n', '  function burn(address _who, uint256 _value) onlyAuthorized public returns (bool){\n', '    require(_who != address(0));\n', '    \n', '    totalSupply = totalSupply.sub(_value);\n', '    balances[_who] = balances[_who].sub(_value);\n', '    emit Burn();\n', '    emit Transfer(_who, address(0), _value);\n', '    return true;\n', '  }\n', '  \n', '\n', '  function balanceOf(address _owner) public view returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '  \n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amount of tokens to be transferred\n', '   */\n', '  function transferFrom(address _from, address _to, uint256 _value) public canTransfer returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[_from]);\n', '    require(_value <= allowed[_from][msg.sender]);\n', '\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '    emit Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  function transferFromERC20Contract(address _to, uint256 _value) public onlyOwner returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[address(this)]);\n', '    balances[address(this)] = balances[address(this)].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    emit Transfer(address(this), _to, _value);\n', '    return true;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   *\n', '   * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', "   * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:\n", '   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    emit Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifying the amount of tokens still available for the spender.\n', '   */\n', '  function allowance(address _owner, address _spender) public view returns (uint256) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  /**\n', '   * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '   *\n', '   * approve should be called when allowed[_spender] == 0. To increment\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _addedValue The amount of tokens to increase the allowance by.\n', '   */\n', '  function increaseApproval(address _spender, uint _addedValue) public returns (bool) {\n', '    allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '   *\n', '   * approve should be called when allowed[_spender] == 0. To decrement\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _subtractedValue The amount of tokens to decrease the allowance by.\n', '   */\n', '  function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {\n', '    uint oldValue = allowed[msg.sender][_spender];\n', '    if (_subtractedValue > oldValue) {\n', '      allowed[msg.sender][_spender] = 0;\n', '    } else {\n', '      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '    }\n', '    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '  function unlockToken() public onlyAuthorized returns (bool) {\n', '    locked = false;\n', '    emit UnlockToken();\n', '    return true;\n', '  }\n', '\n', '  function lockToken() public onlyAuthorized returns (bool) {\n', '    locked = true;\n', '    emit LockToken();\n', '    return true;\n', '  }\n', '  \n', '  function setICO(address _icocontract) public onlyOwner returns (bool) {\n', '    require(_icocontract != address(0));\n', '    ico = _icocontract;\n', '    emit SetICO(_icocontract);\n', '    return true;\n', '  }\n', '\n', '    /**\n', '     * @dev Adds list of addresses to Vestedlist. Not overloaded due to limitations with truffle testing.\n', '     * @param _vestedAddress Addresses to be added to the Vestedlist\n', '     */\n', '    function addToVestedlist(address[] memory _vestedAddress) public onlyOwner {\n', '        for (uint256 i = 0; i < _vestedAddress.length; i++) {\n', '            if (vestedlist[_vestedAddress[i]]) continue;\n', '            vestedlist[_vestedAddress[i]] = true;\n', '        }\n', '    }\n', '\n', '\n', '    /**\n', '     * @dev Removes single address from Vestedlist.\n', '     * @param _vestedAddress Address to be removed to the Vestedlist\n', '     */\n', '    function removeFromVestedlist(address[] memory _vestedAddress) public onlyOwner {\n', '        for (uint256 i = 0; i < _vestedAddress.length; i++) {\n', '            if (!vestedlist[_vestedAddress[i]]) continue;\n', '            vestedlist[_vestedAddress[i]] = false;\n', '        }\n', '    }\n', '\n', '\n', '    function isVestedlisted(address _vestedAddress) internal view returns (bool) {\n', '      return (vestedlist[_vestedAddress]);\n', '    }\n', '\n', '}']