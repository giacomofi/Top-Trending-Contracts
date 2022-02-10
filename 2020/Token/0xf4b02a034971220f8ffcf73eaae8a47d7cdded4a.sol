['pragma solidity ^0.4.24;\n', '\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', "    // Gas optimization: this is cheaper than asserting 'a' not being zero, but the\n", "    // benefit is lost if 'b' is also tested.\n", '    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '\n', '    c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    // uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return a / b;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '\n', '\n', '/**\n', ' * @title Basic token\n', ' * @dev Basic version of StandardToken, with no allowances.\n', ' */\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '\n', '  uint256 totalSupply_;\n', '\n', '  /**\n', '  * @dev total number of tokens in existence\n', '  */\n', '  function totalSupply() public view returns (uint256) {\n', '    return totalSupply_;\n', '  }\n', '\n', '  /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[msg.sender]);\n', '\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    emit Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) public view returns (uint256) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender)\n', '    public view returns (uint256);\n', '\n', '  function transferFrom(address from, address to, uint256 value)\n', '    public returns (bool);\n', '\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(\n', '    address indexed owner,\n', '    address indexed spender,\n', '    uint256 value\n', '  );\n', '}\n', '\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implementation of the basic standard token.\n', ' * @dev https://github.com/ethereum/EIPs/issues/20\n', ' * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '  mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amount of tokens to be transferred\n', '   */\n', '  function transferFrom(\n', '    address _from,\n', '    address _to,\n', '    uint256 _value\n', '  )\n', '    public\n', '    returns (bool)\n', '  {\n', '    require(_to != address(0));\n', '    require(_value <= balances[_from]);\n', '    require(_value <= allowed[_from][msg.sender]);\n', '\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '    emit Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   *\n', '   * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', "   * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:\n", '   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    emit Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifying the amount of tokens still available for the spender.\n', '   */\n', '  function allowance(\n', '    address _owner,\n', '    address _spender\n', '   )\n', '    public\n', '    view\n', '    returns (uint256)\n', '  {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  /**\n', '   * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '   *\n', '   * approve should be called when allowed[_spender] == 0. To increment\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _addedValue The amount of tokens to increase the allowance by.\n', '   */\n', '  function increaseApproval(\n', '    address _spender,\n', '    uint _addedValue\n', '  )\n', '    public\n', '    returns (bool)\n', '  {\n', '    allowed[msg.sender][_spender] = (\n', '      allowed[msg.sender][_spender].add(_addedValue));\n', '    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '   *\n', '   * approve should be called when allowed[_spender] == 0. To decrement\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _subtractedValue The amount of tokens to decrease the allowance by.\n', '   */\n', '  function decreaseApproval(\n', '    address _spender,\n', '    uint _subtractedValue\n', '  )\n', '    public\n', '    returns (bool)\n', '  {\n', '    uint oldValue = allowed[msg.sender][_spender];\n', '    if (_subtractedValue > oldValue) {\n', '      allowed[msg.sender][_spender] = 0;\n', '    } else {\n', '      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '    }\n', '    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '}\n', '\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipRenounced(address indexed previousOwner);\n', '  event OwnershipTransferred(\n', '    address indexed previousOwner,\n', '    address indexed newOwner\n', '  );\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to relinquish control of the contract.\n', '   */\n', '  function renounceOwnership() public onlyOwner {\n', '    emit OwnershipRenounced(owner);\n', '    owner = address(0);\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param _newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address _newOwner) public onlyOwner {\n', '    _transferOwnership(_newOwner);\n', '  }\n', '\n', '  /**\n', '   * @dev Transfers control of the contract to a newOwner.\n', '   * @param _newOwner The address to transfer ownership to.\n', '   */\n', '  function _transferOwnership(address _newOwner) internal {\n', '    require(_newOwner != address(0));\n', '    emit OwnershipTransferred(owner, _newOwner);\n', '    owner = _newOwner;\n', '  }\n', '}\n', '\n', '\n', '/**\n', ' * @title Mintable token\n', ' * @dev Simple ERC20 Token example, with mintable token creation\n', ' * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120\n', ' * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol\n', ' */\n', 'contract MintableToken is StandardToken, Ownable {\n', '  event Mint(address indexed to, uint256 amount);\n', '  event MintFinished();\n', '\n', '  bool public mintingFinished = false;\n', '\n', '\n', '  modifier canMint() {\n', '    require(!mintingFinished);\n', '    _;\n', '  }\n', '\n', '  modifier hasMintPermission() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to mint tokens\n', '   * @param _to The address that will receive the minted tokens.\n', '   * @param _amount The amount of tokens to mint.\n', '   * @return A boolean that indicates if the operation was successful.\n', '   */\n', '  function mint(\n', '    address _to,\n', '    uint256 _amount\n', '  )\n', '    hasMintPermission\n', '    canMint\n', '    public\n', '    returns (bool)\n', '  {\n', '    totalSupply_ = totalSupply_.add(_amount);\n', '    balances[_to] = balances[_to].add(_amount);\n', '    emit Mint(_to, _amount);\n', '    emit Transfer(address(0), _to, _amount);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to stop minting new tokens.\n', '   * @return True if the operation was successful.\n', '   */\n', '  function finishMinting() onlyOwner canMint public returns (bool) {\n', '    mintingFinished = true;\n', '    emit MintFinished();\n', '    return true;\n', '  }\n', '}\n', '\n', '\n', 'contract FreezableToken is StandardToken {\n', '    // freezing chains\n', '    mapping (bytes32 => uint64) internal chains;\n', '    // freezing amounts for each chain\n', '    mapping (bytes32 => uint) internal freezings;\n', '    // total freezing balance per address\n', '    mapping (address => uint) internal freezingBalance;\n', '\n', '    event Freezed(address indexed to, uint64 release, uint amount);\n', '    event Released(address indexed owner, uint amount);\n', '\n', '    /**\n', '     * @dev Gets the balance of the specified address include freezing tokens.\n', '     * @param _owner The address to query the the balance of.\n', '     * @return An uint256 representing the amount owned by the passed address.\n', '     */\n', '    function balanceOf(address _owner) public view returns (uint256 balance) {\n', '        return super.balanceOf(_owner) + freezingBalance[_owner];\n', '    }\n', '\n', '    /**\n', '     * @dev Gets the balance of the specified address without freezing tokens.\n', '     * @param _owner The address to query the the balance of.\n', '     * @return An uint256 representing the amount owned by the passed address.\n', '     */\n', '    function actualBalanceOf(address _owner) public view returns (uint256 balance) {\n', '        return super.balanceOf(_owner);\n', '    }\n', '\n', '    function freezingBalanceOf(address _owner) public view returns (uint256 balance) {\n', '        return freezingBalance[_owner];\n', '    }\n', '\n', '    /**\n', '     * @dev gets freezing count\n', '     * @param _addr Address of freeze tokens owner.\n', '     */\n', '    function freezingCount(address _addr) public view returns (uint count) {\n', '        uint64 release = chains[toKey(_addr, 0)];\n', '        while (release != 0) {\n', '            count++;\n', '            release = chains[toKey(_addr, release)];\n', '        }\n', '    }\n', '\n', '    /**\n', '     * @dev gets freezing end date and freezing balance for the freezing portion specified by index.\n', '     * @param _addr Address of freeze tokens owner.\n', '     * @param _index Freezing portion index. It ordered by release date descending.\n', '     */\n', '    function getFreezing(address _addr, uint _index) public view returns (uint64 _release, uint _balance) {\n', '        for (uint i = 0; i < _index + 1; i++) {\n', '            _release = chains[toKey(_addr, _release)];\n', '            if (_release == 0) {\n', '                return;\n', '            }\n', '        }\n', '        _balance = freezings[toKey(_addr, _release)];\n', '    }\n', '\n', '    /**\n', '     * @dev freeze your tokens to the specified address.\n', '     *      Be careful, gas usage is not deterministic,\n', '     *      and depends on how many freezes _to address already has.\n', '     * @param _to Address to which token will be freeze.\n', '     * @param _amount Amount of token to freeze.\n', '     * @param _until Release date, must be in future.\n', '     */\n', '    function freezeTo(address _to, uint _amount, uint64 _until) public {\n', '        require(_to != address(0));\n', '        require(_amount <= balances[msg.sender]);\n', '\n', '        balances[msg.sender] = balances[msg.sender].sub(_amount);\n', '\n', '        bytes32 currentKey = toKey(_to, _until);\n', '        freezings[currentKey] = freezings[currentKey].add(_amount);\n', '        freezingBalance[_to] = freezingBalance[_to].add(_amount);\n', '\n', '        freeze(_to, _until);\n', '        emit Transfer(msg.sender, _to, _amount);\n', '        emit Freezed(_to, _until, _amount);\n', '    }\n', '\n', '    /**\n', '     * @dev release first available freezing tokens.\n', '     */\n', '    function releaseOnce() public {\n', '        bytes32 headKey = toKey(msg.sender, 0);\n', '        uint64 head = chains[headKey];\n', '        require(head != 0);\n', '        require(uint64(block.timestamp) > head);\n', '        bytes32 currentKey = toKey(msg.sender, head);\n', '\n', '        uint64 next = chains[currentKey];\n', '\n', '        uint amount = freezings[currentKey];\n', '        delete freezings[currentKey];\n', '\n', '        balances[msg.sender] = balances[msg.sender].add(amount);\n', '        freezingBalance[msg.sender] = freezingBalance[msg.sender].sub(amount);\n', '\n', '        if (next == 0) {\n', '            delete chains[headKey];\n', '        } else {\n', '            chains[headKey] = next;\n', '            delete chains[currentKey];\n', '        }\n', '        emit Released(msg.sender, amount);\n', '    }\n', '\n', '    /**\n', '     * @dev release all available for release freezing tokens. Gas usage is not deterministic!\n', '     * @return how many tokens was released\n', '     */\n', '    function releaseAll() public returns (uint tokens) {\n', '        uint release;\n', '        uint balance;\n', '        (release, balance) = getFreezing(msg.sender, 0);\n', '        while (release != 0 && block.timestamp > release) {\n', '            releaseOnce();\n', '            tokens += balance;\n', '            (release, balance) = getFreezing(msg.sender, 0);\n', '        }\n', '    }\n', '\n', '    function toKey(address _addr, uint _release) internal pure returns (bytes32 result) {\n', '        // WISH masc to increase entropy\n', '        result = 0x5749534800000000000000000000000000000000000000000000000000000000;\n', '        assembly {\n', '            result := or(result, mul(_addr, 0x10000000000000000))\n', '            result := or(result, _release)\n', '        }\n', '    }\n', '\n', '    function freeze(address _to, uint64 _until) internal {\n', '        require(_until > block.timestamp);\n', '        bytes32 key = toKey(_to, _until);\n', '        bytes32 parentKey = toKey(_to, uint64(0));\n', '        uint64 next = chains[parentKey];\n', '\n', '        if (next == 0) {\n', '            chains[parentKey] = _until;\n', '            return;\n', '        }\n', '\n', '        bytes32 nextKey = toKey(_to, next);\n', '        uint parent;\n', '\n', '        while (next != 0 && _until > next) {\n', '            parent = next;\n', '            parentKey = nextKey;\n', '\n', '            next = chains[nextKey];\n', '            nextKey = toKey(_to, next);\n', '        }\n', '\n', '        if (_until == next) {\n', '            return;\n', '        }\n', '\n', '        if (next != 0) {\n', '            chains[key] = next;\n', '        }\n', '\n', '        chains[parentKey] = _until;\n', '    }\n', '}\n', '\n', '\n', '/**\n', ' * @title Burnable Token\n', ' * @dev Token that can be irreversibly burned (destroyed).\n', ' */\n', 'contract BurnableToken is BasicToken {\n', '\n', '  event Burn(address indexed burner, uint256 value);\n', '\n', '  /**\n', '   * @dev Burns a specific amount of tokens.\n', '   * @param _value The amount of token to be burned.\n', '   */\n', '  function burn(uint256 _value) public {\n', '    _burn(msg.sender, _value);\n', '  }\n', '\n', '  function _burn(address _who, uint256 _value) internal {\n', '    require(_value <= balances[_who]);\n', '    // no need to require value <= totalSupply, since that would imply the\n', "    // sender's balance is greater than the totalSupply, which *should* be an assertion failure\n", '\n', '    balances[_who] = balances[_who].sub(_value);\n', '    totalSupply_ = totalSupply_.sub(_value);\n', '    emit Burn(_who, _value);\n', '    emit Transfer(_who, address(0), _value);\n', '  }\n', '}\n', '\n', '\n', '\n', '/**\n', ' * @title Pausable\n', ' * @dev Base contract which allows children to implement an emergency stop mechanism.\n', ' */\n', 'contract Pausable is Ownable {\n', '  event Pause();\n', '  event Unpause();\n', '\n', '  bool public paused = false;\n', '\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is not paused.\n', '   */\n', '  modifier whenNotPaused() {\n', '    require(!paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is paused.\n', '   */\n', '  modifier whenPaused() {\n', '    require(paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to pause, triggers stopped state\n', '   */\n', '  function pause() onlyOwner whenNotPaused public {\n', '    paused = true;\n', '    emit Pause();\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to unpause, returns to normal state\n', '   */\n', '  function unpause() onlyOwner whenPaused public {\n', '    paused = false;\n', '    emit Unpause();\n', '  }\n', '}\n', '\n', '\n', 'contract FreezableMintableToken is FreezableToken, MintableToken {\n', '    /**\n', '     * @dev Mint the specified amount of token to the specified address and freeze it until the specified date.\n', '     *      Be careful, gas usage is not deterministic,\n', '     *      and depends on how many freezes _to address already has.\n', '     * @param _to Address to which token will be freeze.\n', '     * @param _amount Amount of token to mint and freeze.\n', '     * @param _until Release date, must be in future.\n', '     * @return A boolean that indicates if the operation was successful.\n', '     */\n', '    function mintAndFreeze(address _to, uint _amount, uint64 _until) public onlyOwner canMint returns (bool) {\n', '        totalSupply_ = totalSupply_.add(_amount);\n', '\n', '        bytes32 currentKey = toKey(_to, _until);\n', '        freezings[currentKey] = freezings[currentKey].add(_amount);\n', '        freezingBalance[_to] = freezingBalance[_to].add(_amount);\n', '\n', '        freeze(_to, _until);\n', '        emit Mint(_to, _amount);\n', '        emit Freezed(_to, _until, _amount);\n', '        emit Transfer(msg.sender, _to, _amount);\n', '        return true;\n', '    }\n', '}\n', '\n', '\n', '\n', 'contract Consts {\n', '    uint public constant TOKEN_DECIMALS = 18;\n', '    uint8 public constant TOKEN_DECIMALS_UINT8 = 18;\n', '    uint public constant TOKEN_DECIMAL_MULTIPLIER = 10 ** TOKEN_DECIMALS;\n', '\n', '    string public constant TOKEN_NAME = "GXM";\n', '    string public constant TOKEN_SYMBOL = "GXM";\n', '    bool public constant PAUSED = false;\n', '    address public constant TARGET_USER = 0x2F1585496954b4Ee008C9F1feEe563d3D8B2bAC3;\n', '    \n', '    bool public constant CONTINUE_MINTING = false;\n', '}\n', '\n', '\n', '\n', '\n', 'contract MainToken is Consts, FreezableMintableToken, BurnableToken, Pausable\n', '    \n', '{\n', '    \n', '    event Initialized();\n', '    bool public initialized = false;\n', '\n', '    constructor() public {\n', '        init();\n', '        transferOwnership(TARGET_USER);\n', '    }\n', '    \n', '\n', '    function name() public pure returns (string _name) {\n', '        return TOKEN_NAME;\n', '    }\n', '\n', '    function symbol() public pure returns (string _symbol) {\n', '        return TOKEN_SYMBOL;\n', '    }\n', '\n', '    function decimals() public pure returns (uint8 _decimals) {\n', '        return TOKEN_DECIMALS_UINT8;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool _success) {\n', '        require(!paused);\n', '        return super.transferFrom(_from, _to, _value);\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool _success) {\n', '        require(!paused);\n', '        return super.transfer(_to, _value);\n', '    }\n', '\n', '    \n', '    function init() private {\n', '        require(!initialized);\n', '        initialized = true;\n', '\n', '        if (PAUSED) {\n', '            pause();\n', '        }\n', '\n', '        \n', '        address[1] memory addresses = [address(0x2f1585496954b4ee008c9f1feee563d3d8b2bac3)];\n', '        uint[1] memory amounts = [uint(100000000000000000000000000)];\n', '        uint64[1] memory freezes = [uint64(0)];\n', '\n', '        for (uint i = 0; i < addresses.length; i++) {\n', '            if (freezes[i] == 0) {\n', '                mint(addresses[i], amounts[i]);\n', '            } else {\n', '                mintAndFreeze(addresses[i], amounts[i], freezes[i]);\n', '            }\n', '        }\n', '        \n', '\n', '        if (!CONTINUE_MINTING) {\n', '            finishMinting();\n', '        }\n', '\n', '        emit Initialized();\n', '    }\n', '    \n', '}']