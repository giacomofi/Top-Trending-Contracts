['// File: node_modules\\openzeppelin-solidity\\contracts\\token\\ERC20\\ERC20Basic.sol\n', '\n', 'pragma solidity ^0.4.24;\n', '\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * See https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address _who) public view returns (uint256);\n', '  function transfer(address _to, uint256 _value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '// File: node_modules\\openzeppelin-solidity\\contracts\\math\\SafeMath.sol\n', '\n', 'pragma solidity ^0.4.24;\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {\n', "    // Gas optimization: this is cheaper than asserting 'a' not being zero, but the\n", "    // benefit is lost if 'b' is also tested.\n", '    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '    if (_a == 0) {\n', '      return 0;\n', '    }\n', '\n', '    c = _a * _b;\n', '    assert(c / _a == _b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 _a, uint256 _b) internal pure returns (uint256) {\n', '    // assert(_b > 0); // Solidity automatically throws when dividing by 0\n', '    // uint256 c = _a / _b;\n', "    // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold\n", '    return _a / _b;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {\n', '    assert(_b <= _a);\n', '    return _a - _b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {\n', '    c = _a + _b;\n', '    assert(c >= _a);\n', '    return c;\n', '  }\n', '}\n', '\n', '// File: node_modules\\openzeppelin-solidity\\contracts\\token\\ERC20\\BasicToken.sol\n', '\n', 'pragma solidity ^0.4.24;\n', '\n', '\n', '\n', '\n', '/**\n', ' * @title Basic token\n', ' * @dev Basic version of StandardToken, with no allowances.\n', ' */\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) internal balances;\n', '\n', '  uint256 internal totalSupply_;\n', '\n', '  /**\n', '  * @dev Total number of tokens in existence\n', '  */\n', '  function totalSupply() public view returns (uint256) {\n', '    return totalSupply_;\n', '  }\n', '\n', '  /**\n', '  * @dev Transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    require(_value <= balances[msg.sender]);\n', '    require(_to != address(0));\n', '\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    emit Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) public view returns (uint256) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', '// File: node_modules\\openzeppelin-solidity\\contracts\\token\\ERC20\\ERC20.sol\n', '\n', 'pragma solidity ^0.4.24;\n', '\n', '\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address _owner, address _spender)\n', '    public view returns (uint256);\n', '\n', '  function transferFrom(address _from, address _to, uint256 _value)\n', '    public returns (bool);\n', '\n', '  function approve(address _spender, uint256 _value) public returns (bool);\n', '  event Approval(\n', '    address indexed owner,\n', '    address indexed spender,\n', '    uint256 value\n', '  );\n', '}\n', '\n', '// File: openzeppelin-solidity\\contracts\\token\\ERC20\\StandardToken.sol\n', '\n', 'pragma solidity ^0.4.24;\n', '\n', '\n', '\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implementation of the basic standard token.\n', ' * https://github.com/ethereum/EIPs/issues/20\n', ' * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '  mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amount of tokens to be transferred\n', '   */\n', '  function transferFrom(\n', '    address _from,\n', '    address _to,\n', '    uint256 _value\n', '  )\n', '    public\n', '    returns (bool)\n', '  {\n', '    require(_value <= balances[_from]);\n', '    require(_value <= allowed[_from][msg.sender]);\n', '    require(_to != address(0));\n', '\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '    emit Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', "   * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:\n", '   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    emit Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifying the amount of tokens still available for the spender.\n', '   */\n', '  function allowance(\n', '    address _owner,\n', '    address _spender\n', '   )\n', '    public\n', '    view\n', '    returns (uint256)\n', '  {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  /**\n', '   * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '   * approve should be called when allowed[_spender] == 0. To increment\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _addedValue The amount of tokens to increase the allowance by.\n', '   */\n', '  function increaseApproval(\n', '    address _spender,\n', '    uint256 _addedValue\n', '  )\n', '    public\n', '    returns (bool)\n', '  {\n', '    allowed[msg.sender][_spender] = (\n', '      allowed[msg.sender][_spender].add(_addedValue));\n', '    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '   * approve should be called when allowed[_spender] == 0. To decrement\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _subtractedValue The amount of tokens to decrease the allowance by.\n', '   */\n', '  function decreaseApproval(\n', '    address _spender,\n', '    uint256 _subtractedValue\n', '  )\n', '    public\n', '    returns (bool)\n', '  {\n', '    uint256 oldValue = allowed[msg.sender][_spender];\n', '    if (_subtractedValue >= oldValue) {\n', '      allowed[msg.sender][_spender] = 0;\n', '    } else {\n', '      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '    }\n', '    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '}\n', '\n', '// File: openzeppelin-solidity\\contracts\\ownership\\Ownable.sol\n', '\n', 'pragma solidity ^0.4.24;\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipRenounced(address indexed previousOwner);\n', '  event OwnershipTransferred(\n', '    address indexed previousOwner,\n', '    address indexed newOwner\n', '  );\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to relinquish control of the contract.\n', '   * @notice Renouncing to ownership will leave the contract without an owner.\n', '   * It will not be possible to call the functions with the `onlyOwner`\n', '   * modifier anymore.\n', '   */\n', '  function renounceOwnership() public onlyOwner {\n', '    emit OwnershipRenounced(owner);\n', '    owner = address(0);\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param _newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address _newOwner) public onlyOwner {\n', '    _transferOwnership(_newOwner);\n', '  }\n', '\n', '  /**\n', '   * @dev Transfers control of the contract to a newOwner.\n', '   * @param _newOwner The address to transfer ownership to.\n', '   */\n', '  function _transferOwnership(address _newOwner) internal {\n', '    require(_newOwner != address(0));\n', '    emit OwnershipTransferred(owner, _newOwner);\n', '    owner = _newOwner;\n', '  }\n', '}\n', '\n', '// File: openzeppelin-solidity\\contracts\\token\\ERC1132\\ERC1132.sol\n', '\n', 'pragma solidity ^0.4.24;\n', '\n', 'contract ERC1132 {\n', '    /**\n', "     * @dev Reasons why a user's tokens have been locked\n", '     */\n', '    mapping(address => bytes32[]) public lockReason;\n', '\n', '    /**\n', '     * @dev locked token structure\n', '     */\n', '    struct lockToken {\n', '        uint256 amount;\n', '        uint256 validity;\n', '        bool claimed;\n', '    }\n', '\n', '    /**\n', '     * @dev Holds number & validity of tokens locked for a given reason for\n', '     *      a specified address\n', '     */\n', '    mapping(address => mapping(bytes32 => lockToken)) public locked;\n', '\n', '    /**\n', '     * @dev Records data of all the tokens Locked\n', '     */\n', '    event Locked(\n', '        address indexed _of,\n', '        bytes32 indexed _reason,\n', '        uint256 _amount,\n', '        uint256 _validity\n', '    );\n', '\n', '    /**\n', '     * @dev Records data of all the tokens unlocked\n', '     */\n', '    event Unlocked(\n', '        address indexed _of,\n', '        bytes32 indexed _reason,\n', '        uint256 _amount\n', '    );\n', '    \n', '    /**\n', '     * @dev Locks a specified amount of tokens against an address,\n', '     *      for a specified reason and time\n', '     * @param _reason The reason to lock tokens\n', '     * @param _amount Number of tokens to be locked\n', '     * @param _time Lock time in seconds\n', '     */\n', '    function lock(bytes32 _reason, uint256 _amount, uint256 _time, address _of)\n', '        public returns (bool);\n', '  \n', '    /**\n', '     * @dev Returns tokens locked for a specified address for a\n', '     *      specified reason\n', '     *\n', '     * @param _of The address whose tokens are locked\n', '     * @param _reason The reason to query the lock tokens for\n', '     */\n', '    function tokensLocked(address _of, bytes32 _reason)\n', '        public view returns (uint256 amount);\n', '    \n', '    /**\n', '     * @dev Returns tokens locked for a specified address for a\n', '     *      specified reason at a specific time\n', '     *\n', '     * @param _of The address whose tokens are locked\n', '     * @param _reason The reason to query the lock tokens for\n', '     * @param _time The timestamp to query the lock tokens for\n', '     */\n', '    function tokensLockedAtTime(address _of, bytes32 _reason, uint256 _time)\n', '        public view returns (uint256 amount);\n', '    \n', '    /**\n', '     * @dev Returns total tokens held by an address (locked + transferable)\n', '     * @param _of The address to query the total balance of\n', '     */\n', '    function totalBalanceOf(address _of)\n', '        public view returns (uint256 amount);\n', '    \n', '    /**\n', '     * @dev Extends lock for a specified reason and time\n', '     * @param _reason The reason to lock tokens\n', '     * @param _time Lock extension time in seconds\n', '     */\n', '    function extendLock(bytes32 _reason, uint256 _time)\n', '        public returns (bool);\n', '    \n', '    /**\n', '     * @dev Increase number of tokens locked for a specified reason\n', '     * @param _reason The reason to lock tokens\n', '     * @param _amount Number of tokens to be increased\n', '     */\n', '    function increaseLockAmount(bytes32 _reason, uint256 _amount)\n', '        public returns (bool);\n', '\n', '    /**\n', '     * @dev Returns unlockable tokens for a specified address for a specified reason\n', '     * @param _of The address to query the the unlockable token count of\n', '     * @param _reason The reason to query the unlockable tokens for\n', '     */\n', '    function tokensUnlockable(address _of, bytes32 _reason)\n', '        public view returns (uint256 amount);\n', ' \n', '    /**\n', '     * @dev Unlocks the unlockable tokens of a specified address\n', '     * @param _of Address of user, claiming back unlockable tokens\n', '     */\n', '    function unlock(address _of)\n', '        public returns (uint256 unlockableTokens);\n', '\n', '    /**\n', '     * @dev Gets the unlockable tokens of a specified address\n', '     * @param _of The address to query the the unlockable token count of\n', '     */\n', '    function getUnlockableTokens(address _of)\n', '        public view returns (uint256 unlockableTokens);\n', '\n', '}\n', '\n', '// File: contracts\\BiibroSToken.sol\n', '\n', 'pragma solidity ^0.4.24;\n', '\n', '// Import\n', '\n', '\n', '\n', '\n', '\n', '// Contract\n', 'contract BiibroSToken is StandardToken, Ownable, ERC1132 {\n', '\t// Define constants\n', '\tstring public constant name \t\t\t\t\t= "S-Token";\n', '\tstring public constant symbol \t\t\t\t\t= "STO";\n', '\tuint256 public constant decimals \t\t\t\t= 18;\n', '\tuint256 public constant INITIAL_SUPPLY \t\t\t\t= 500000000000 * (10 ** decimals);\n', '    \n', '\tconstructor() public {\n', '        \ttotalSupply_ \t\t\t\t\t\t= INITIAL_SUPPLY;\n', '\t\tbalances[msg.sender] \t\t\t\t\t= INITIAL_SUPPLY;\n', '\t}\n', '\n', '\t// Define events\n', '    \tevent Mint(address minter, uint256 value);\n', '\tevent Burn(address burner, uint256 value);\n', '\n', '\t// Dev Error messages for require statements\n', "\tstring internal constant INVALID_TOKEN_VALUES \t\t\t= 'Invalid token values';\n", "\tstring internal constant NOT_ENOUGH_TOKENS \t\t\t= 'Not enough tokens';\n", "\tstring internal constant ALREADY_LOCKED \t\t\t= 'Tokens already locked';\n", "\tstring internal constant NOT_LOCKED \t\t\t\t= 'No tokens locked';\n", "\tstring internal constant AMOUNT_ZERO \t\t\t\t= 'Amount can not be 0';\n", '\n', '\t// Mint\n', '\tfunction mint(address _to, uint256 _amount) public onlyOwner {\n', '        \trequire(_amount > 0, INVALID_TOKEN_VALUES);\n', '        \t\n', '\t\tbalances[_to] \t\t\t\t\t\t= balances[_to].add(_amount);\n', '        \ttotalSupply_ \t\t\t\t\t\t= totalSupply_.add(_amount);\n', '        \t\n', '\t\temit Mint(_to, _amount);\n', '\t}\t\n', '\n', '\t// Burn\n', '\tfunction burn(address _of, uint256 _amount) public onlyOwner {\n', '        \trequire(_amount > 0, INVALID_TOKEN_VALUES);\n', '        \trequire(_amount <= balances[_of], NOT_ENOUGH_TOKENS);\n', '        \t\n', '\t\tbalances[_of] \t\t\t\t\t\t= balances[_of].sub(_amount);\n', '        \ttotalSupply_ \t\t\t\t\t\t= totalSupply_.sub(_amount);\n', '        \t\n', '\t\temit Burn(_of, _amount);\n', '\t}\n', '\n', '\t// Lock - Important\n', '    \tfunction lock(bytes32 _reason, uint256 _amount, uint256 _time, address _of) public onlyOwner returns (bool) {\n', '        \tuint256 validUntil \t\t\t\t\t= now.add(_time);\n', '\n', '\t\trequire(_amount <= balances[_of], NOT_ENOUGH_TOKENS);\n', '\t\trequire(tokensLocked(_of, _reason) == 0, ALREADY_LOCKED);\n', '\t\trequire(_amount != 0, AMOUNT_ZERO);\n', '\n', '\t\tif (locked[_of][_reason].amount == 0)\n', '\t\t\tlockReason[_of].push(_reason);\n', '\n', '\t\tbalances[address(this)] = balances[address(this)].add(_amount);\n', '\t\tbalances[_of] = balances[_of].sub(_amount);\n', '\n', '\t\tlocked[_of][_reason] = lockToken(_amount, validUntil, false);\n', '\n', '\t\temit Transfer(_of, address(this), _amount);\n', '\t\temit Locked(_of, _reason, _amount, validUntil);\n', '\t\t\n', '\t\treturn true;\n', '    \t}\n', '\n', '    \tfunction transferWithLock(address _to, bytes32 _reason, uint256 _amount, uint256 _time) public returns (bool) {\n', '        \tuint256 validUntil \t\t\t\t\t= now.add(_time); \n', '\n', '        \trequire(tokensLocked(_to, _reason) == 0, ALREADY_LOCKED);\n', '        \trequire(_amount != 0, AMOUNT_ZERO);\n', '\n', '        \tif (locked[_to][_reason].amount == 0)\n', '            \t\tlockReason[_to].push(_reason);\n', '\n', '        \ttransfer(address(this), _amount);\n', '\n', '        \tlocked[_to][_reason] \t\t\t\t\t= lockToken(_amount, validUntil, false);\n', '\n', '        \temit Locked(_to, _reason, _amount, validUntil);\n', '        \n', '\t\treturn true;\n', '    \t}\n', '\n', '    \tfunction tokensLocked(address _of, bytes32 _reason) public view returns (uint256 amount) {\t\n', '        \tif (!locked[_of][_reason].claimed)\n', '            \t\tamount \t\t\t\t\t\t= locked[_of][_reason].amount;\n', '    \t}\n', '\n', '    \tfunction tokensLockedAtTime(address _of, bytes32 _reason, uint256 _time) public view returns (uint256 amount) {\n', '        \tif (locked[_of][_reason].validity > _time)\n', '            \t\tamount \t\t\t\t\t\t= locked[_of][_reason].amount;\n', '    \t}\n', '\n', '    \tfunction totalBalanceOf(address _of) public view returns (uint256 amount) {\n', '        \tamount \t\t\t\t\t\t\t= balanceOf(_of);\n', '\n', '        \tfor (uint256 i = 0; i < lockReason[_of].length; i++) {\n', '            \t\tamount \t\t\t\t\t\t= amount.add(tokensLocked(_of, lockReason[_of][i]));\n', '        \t}\n', '    \t}\n', '\n', '    \tfunction extendLock(bytes32 _reason, uint256 _time) public returns (bool) {\n', '        \trequire(tokensLocked(msg.sender, _reason) > 0, NOT_LOCKED);\n', '\n', '        \tlocked[msg.sender][_reason].validity \t\t\t= locked[msg.sender][_reason].validity.add(_time);\n', '\n', '        \temit Locked(msg.sender, _reason, locked[msg.sender][_reason].amount, locked[msg.sender][_reason].validity);\n', '        \n', '\t\treturn true;\n', '    \t}\t\n', '\n', '    \tfunction increaseLockAmount(bytes32 _reason, uint256 _amount) public returns (bool) {\n', '        \trequire(tokensLocked(msg.sender, _reason) > 0, NOT_LOCKED);\n', '        \t\n', '\t\ttransfer(address(this), _amount);\n', '\n', '        \tlocked[msg.sender][_reason].amount \t\t\t= locked[msg.sender][_reason].amount.add(_amount);\n', '\n', '        \temit Locked(msg.sender, _reason, locked[msg.sender][_reason].amount, locked[msg.sender][_reason].validity);\n', '        \n', '\t\treturn true;\n', '   \t}\n', '\n', '    \tfunction tokensUnlockable(address _of, bytes32 _reason) public view returns (uint256 amount) {\n', '        \tif (locked[_of][_reason].validity <= now && !locked[_of][_reason].claimed) \n', '            \t\tamount \t\t\t\t\t\t= locked[_of][_reason].amount;\n', '    \t}\n', '\n', '    \tfunction unlock(address _of) public returns (uint256 unlockableTokens) {\n', '        \tuint256 lockedTokens;\n', '\n', '        \tfor (uint256 i = 0; i < lockReason[_of].length; i++) {\n', '            \t\tlockedTokens \t\t\t\t\t= tokensUnlockable(_of, lockReason[_of][i]);\n', '            \n', '\t    \t\tif (lockedTokens > 0) {\n', '                \t\tunlockableTokens \t\t\t= unlockableTokens.add(lockedTokens);\n', '                \t\tlocked[_of][lockReason[_of][i]].claimed = true;\n', '\n', '                \t\temit Unlocked(_of, lockReason[_of][i], lockedTokens);\n', '            \t\t}\n', '        \t}\n', '\n', '        \tif (unlockableTokens > 0)\n', '            \t\tthis.transfer(_of, unlockableTokens);\n', '    \t}\n', '\n', '    \tfunction getUnlockableTokens(address _of) public view returns (uint256 unlockableTokens) {\n', '        \tfor (uint256 i = 0; i < lockReason[_of].length; i++) {\n', '            \t\tunlockableTokens \t\t\t\t= unlockableTokens.add(tokensUnlockable(_of, lockReason[_of][i]));\n', '        \t}\n', '    \t}\n', '}']