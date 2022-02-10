['pragma solidity ^0.4.18;\n', '\n', '\n', '/**\n', ' * https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/math/SafeMath.sol\n', ' * https://github.com/OpenZeppelin/zeppelin-solidity/commit/49b42e86963df7192e7024e0e5bd30fa9d7ccbef\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '\n', '/**\n', ' * https://raw.githubusercontent.com/OpenZeppelin/zeppelin-solidity/master/contracts/token/ERC20/ERC20Basic.sol\n', ' * https://github.com/OpenZeppelin/zeppelin-solidity/commit/370e6a882aef6b9600949594d3a3e4854260d51e\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '\n', '/**\n', ' * https://raw.githubusercontent.com/OpenZeppelin/zeppelin-solidity/master/contracts/token/ERC20/ERC20.sol\n', ' * https://github.com/OpenZeppelin/zeppelin-solidity/commit/c5d66183abcb63a90a2528b8333b2b17067629fc\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public view returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '\n', '/**\n', ' * https://raw.githubusercontent.com/OpenZeppelin/zeppelin-solidity/master/contracts/token/ERC20/SafeERC20.sol\n', ' * https://github.com/OpenZeppelin/zeppelin-solidity/commit/b67856c69d3536f28d51b75b270dfff79343bf93\n', ' * @title SafeERC20\n', ' * @dev Wrappers around ERC20 operations that throw on failure.\n', ' * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,\n', ' * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.\n', ' */\n', 'library SafeERC20 {\n', '  function safeTransfer(ERC20Basic token, address to, uint256 value) internal {\n', '    assert(token.transfer(to, value));\n', '  }\n', '\n', '  function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {\n', '    assert(token.transferFrom(from, to, value));\n', '  }\n', '\n', '  function safeApprove(ERC20 token, address spender, uint256 value) internal {\n', '    assert(token.approve(spender, value));\n', '  }\n', '}\n', '\n', '\n', '/**\n', ' * https://raw.githubusercontent.com/OpenZeppelin/zeppelin-solidity/master/contracts/token/ERC20/BasicToken.sol\n', ' * https://github.com/OpenZeppelin/zeppelin-solidity/commit/c5d66183abcb63a90a2528b8333b2b17067629fc\n', ' * @title Basic token\n', ' * @dev Basic version of StandardToken, with no allowances.\n', ' */\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '\n', '  uint256 totalSupply_;\n', '\n', '  /**\n', '  * @dev total number of tokens in existence\n', '  */\n', '  function totalSupply() public view returns (uint256) {\n', '    return totalSupply_;\n', '  }\n', '\n', '  /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[msg.sender]);\n', '\n', '    // SafeMath.sub will throw if there is not enough balance.\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) public view returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '}\n', '\n', '\n', '/**\n', ' * https://raw.githubusercontent.com/OpenZeppelin/zeppelin-solidity/master/contracts/token/ERC20/StandardToken.sol\n', ' * https://github.com/OpenZeppelin/zeppelin-solidity/commit/c5d66183abcb63a90a2528b8333b2b17067629fc\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implementation of the basic standard token.\n', ' * @dev https://github.com/ethereum/EIPs/issues/20\n', ' * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '  mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amount of tokens to be transferred\n', '   */\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[_from]);\n', '    require(_value <= allowed[_from][msg.sender]);\n', '\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '    Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   *\n', '   * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', "   * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:\n", '   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifying the amount of tokens still available for the spender.\n', '   */\n', '  function allowance(address _owner, address _spender) public view returns (uint256) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  /**\n', '   * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '   *\n', '   * approve should be called when allowed[_spender] == 0. To increment\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _addedValue The amount of tokens to increase the allowance by.\n', '   */\n', '  function increaseApproval(address _spender, uint _addedValue) public returns (bool) {\n', '    allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '   *\n', '   * approve should be called when allowed[_spender] == 0. To decrement\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _subtractedValue The amount of tokens to decrease the allowance by.\n', '   */\n', '  function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {\n', '    uint oldValue = allowed[msg.sender][_spender];\n', '    if (_subtractedValue > oldValue) {\n', '      allowed[msg.sender][_spender] = 0;\n', '    } else {\n', '      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '    }\n', '    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '}\n', '\n', '\n', '/**\n', ' * https://raw.githubusercontent.com/OpenZeppelin/zeppelin-solidity/master/contracts/ownership/Ownable.sol\n', ' * https://github.com/OpenZeppelin/zeppelin-solidity/commit/e60aee61f20d25bffa0a1f651247810a8bc8a660\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '}\n', '\n', '\n', '/**\n', ' * https://raw.githubusercontent.com/OpenZeppelin/zeppelin-solidity/master/contracts/token/ERC20/TokenVesting.sol\n', ' * https://github.com/OpenZeppelin/zeppelin-solidity/commit/c5d66183abcb63a90a2528b8333b2b17067629fc\n', ' * @title TokenVesting\n', ' * @dev A token holder contract that can release its token balance gradually like a\n', ' * typical vesting scheme, with a cliff and vesting period. Optionally revocable by the\n', ' * owner.\n', ' */\n', 'contract TokenVesting is Ownable {\n', '  using SafeMath for uint256;\n', '  using SafeERC20 for ERC20Basic;\n', '\n', '  event Released(uint256 amount);\n', '  event Revoked();\n', '\n', '  // beneficiary of tokens after they are released\n', '  address public beneficiary;\n', '\n', '  uint256 public cliff;\n', '  uint256 public start;\n', '  uint256 public duration;\n', '\n', '  bool public revocable;\n', '\n', '  mapping (address => uint256) public released;\n', '  mapping (address => bool) public revoked;\n', '\n', '  /**\n', '   * @dev Creates a vesting contract that vests its balance of any ERC20 token to the\n', '   * _beneficiary, gradually in a linear fashion until _start + _duration. By then all\n', '   * of the balance will have vested.\n', '   * @param _beneficiary address of the beneficiary to whom vested tokens are transferred\n', '   * @param _cliff duration in seconds of the cliff in which tokens will begin to vest\n', '   * @param _duration duration in seconds of the period in which the tokens will vest\n', '   * @param _revocable whether the vesting is revocable or not\n', '   */\n', '  function TokenVesting(address _beneficiary, uint256 _start, uint256 _cliff, uint256 _duration, bool _revocable) public {\n', '    require(_beneficiary != address(0));\n', '    require(_cliff <= _duration);\n', '\n', '    beneficiary = _beneficiary;\n', '    revocable = _revocable;\n', '    duration = _duration;\n', '    cliff = _start.add(_cliff);\n', '    start = _start;\n', '  }\n', '\n', '  /**\n', '   * @notice Transfers vested tokens to beneficiary.\n', '   * @param token ERC20 token which is being vested\n', '   */\n', '  function release(ERC20Basic token) public {\n', '    uint256 unreleased = releasableAmount(token);\n', '\n', '    require(unreleased > 0);\n', '\n', '    released[token] = released[token].add(unreleased);\n', '\n', '    token.safeTransfer(beneficiary, unreleased);\n', '\n', '    Released(unreleased);\n', '  }\n', '\n', '  /**\n', '   * @notice Allows the owner to revoke the vesting. Tokens already vested\n', '   * remain in the contract, the rest are returned to the owner.\n', '   * @param token ERC20 token which is being vested\n', '   */\n', '  function revoke(ERC20Basic token) public onlyOwner {\n', '    require(revocable);\n', '    require(!revoked[token]);\n', '\n', '    uint256 balance = token.balanceOf(this);\n', '\n', '    uint256 unreleased = releasableAmount(token);\n', '    uint256 refund = balance.sub(unreleased);\n', '\n', '    revoked[token] = true;\n', '\n', '    token.safeTransfer(owner, refund);\n', '\n', '    Revoked();\n', '  }\n', '\n', '  /**\n', "   * @dev Calculates the amount that has already vested but hasn't been released yet.\n", '   * @param token ERC20 token which is being vested\n', '   */\n', '  function releasableAmount(ERC20Basic token) public view returns (uint256) {\n', '    return vestedAmount(token).sub(released[token]);\n', '  }\n', '\n', '  /**\n', '   * @dev Calculates the amount that has already vested.\n', '   * @param token ERC20 token which is being vested\n', '   */\n', '  function vestedAmount(ERC20Basic token) public view returns (uint256) {\n', '    uint256 currentBalance = token.balanceOf(this);\n', '    uint256 totalBalance = currentBalance.add(released[token]);\n', '\n', '    if (now < cliff) {\n', '      return 0;\n', '    } else if (now >= start.add(duration) || revoked[token]) {\n', '      return totalBalance;\n', '    } else {\n', '      return totalBalance.mul(now.sub(start)).div(duration);\n', '    }\n', '  }\n', '}\n', '\n', '\n', 'contract CoinFiToken is StandardToken, Ownable {\n', '    string public constant name = "CoinFi";\n', '    string public constant symbol = "COFI";\n', '    uint8 public constant decimals = 18;\n', '\n', '    // 300 million tokens minted\n', '    uint256 public constant INITIAL_SUPPLY = 300000000 * (10 ** uint256(decimals));\n', '\n', '    // Indicates whether token transfer is enabled\n', '    bool public transferEnabled = false;\n', '\n', '    // Specifies airdrop contract address which can transfer tokens before unlock\n', '    address public airdropAddress;\n', '\n', '    modifier onlyWhenTransferEnabled() {\n', '        if (!transferEnabled) {\n', '            require(msg.sender == owner || msg.sender == airdropAddress);\n', '        }\n', '        _;\n', '    }\n', '\n', '    function CoinFiToken() public {\n', '        totalSupply_ = INITIAL_SUPPLY;\n', '        balances[msg.sender] = INITIAL_SUPPLY;\n', '        Transfer(0x0, msg.sender, INITIAL_SUPPLY);\n', '    }\n', '\n', '    /**\n', '     * Enables everyone to start transferring their tokens.\n', '     * This can only be called by the token owner.\n', '     */\n', '    function enableTransfer() external onlyOwner {\n', '        transferEnabled = true;\n', '    }\n', '\n', '    /**\n', '     * Disables the ability to transfer tokens except by owner.\n', '     * This can only be called by the token owner.\n', '     */\n', '    function disableTransfer() external onlyOwner {\n', '        transferEnabled = false;\n', '    }\n', '\n', '    /**\n', '     * Sets the airdrop contract address which is allowed to transfer before unlock.\n', '     * This can only be called by the token owner.\n', '     */\n', '    function setAirdropAddress(address _airdropAddress) external onlyOwner {\n', '        airdropAddress = _airdropAddress;\n', '    }\n', '\n', '    /**\n', '     * Overrides the ERC20Basic transfer() function to only allow token transfers after enableTransfer() is called.\n', '     */\n', '    function transfer(address _to, uint256 _value) public onlyWhenTransferEnabled returns (bool) {\n', '        return super.transfer(_to, _value);\n', '    }\n', '\n', '    /**\n', '     * Overrides the ERC20Basic transferFrom() function to only allow token transfers after enableTransfer() is called.\n', '     */\n', '    function transferFrom(address _from, address _to, uint256 _value) public onlyWhenTransferEnabled returns (bool) {\n', '        return super.transferFrom(_from, _to, _value);\n', '    }\n', '}\n', '\n', '\n', 'contract CoinFiAirdrop is Ownable {\n', '    uint256 public constant AIRDROP_AMOUNT = 500 * (10**18);\n', '\n', '    // Actual token instance to airdrop\n', '    ERC20 public token;\n', '\n', '    function CoinFiAirdrop(ERC20 _token) public {\n', '        token = _token;\n', '    }\n', '\n', '    function sendAirdrop(address[] airdropRecipients, bool allowDuplicates) external onlyOwner {\n', '        require(airdropRecipients.length > 0);\n', '\n', '        for (uint i = 0; i < airdropRecipients.length; i++) {\n', '            if (token.balanceOf(airdropRecipients[i]) == 0 || allowDuplicates) {\n', '                token.transferFrom(owner, airdropRecipients[i], AIRDROP_AMOUNT);\n', '            }\n', '        }\n', '    }\n', '}']