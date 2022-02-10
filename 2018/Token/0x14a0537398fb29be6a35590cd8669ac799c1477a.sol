['pragma solidity 0.4.24;\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', 'contract owned {\n', '    address public owner;\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '    \n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner , "Unauthorized Access");\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) onlyOwner public {\n', '        require(newOwner != address(0));\n', '        emit OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', 'contract Pausable is owned {\n', '  event Pause();\n', '  event Unpause();\n', '\n', '  bool public paused = false;\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is not paused.\n', '   */\n', '  modifier whenNotPaused() {\n', '    require(!paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is paused.\n', '   */\n', '  modifier whenPaused() {\n', '    require(paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to pause, triggers stopped state\n', '   */\n', '  function pause() onlyOwner whenNotPaused public {\n', '    paused = true;\n', '    emit Pause();\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to unpause, returns to normal state\n', '   */\n', '  function unpause() onlyOwner whenPaused public {\n', '    paused = false;\n', '    emit Unpause();\n', '  }\n', '}\n', '\n', 'interface ERC223Interface {\n', '   \n', '    function balanceOf(address who) constant external returns (uint);\n', '    function transfer(address to, uint value)  external returns (bool success); //erc20 compatible\n', '    function transfer(address to, uint value, bytes data) external returns (bool success);\n', '    event Transfer(address indexed from, address indexed to, uint value, bytes data);\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value); //erc20 compatible\n', '}\n', '/**\n', ' * @title Contract that will work with ERC223 tokens.\n', ' */\n', ' \n', 'contract ERC223ReceivingContract { \n', '/**\n', ' * @dev Standard ERC223 function that will handle incoming token transfers.\n', ' *\n', ' * @param _from  Token sender address.\n', ' * @param _value Amount of tokens.\n', ' * @param _data  Transaction metadata.\n', ' */\n', '    function tokenFallback(address _from, uint _value, bytes _data) external;\n', '}\n', '/**\n', ' * @title Reference implementation of the ERC223 standard token.\n', ' */\n', 'contract ERC223Token is ERC223Interface, Pausable {\n', '    using SafeMath for uint;\n', '    uint256 public _CAP;\n', '    mapping(address => uint256) balances; // List of user balances.\n', '    \n', '    /**\n', '     * @dev Transfer the specified amount of tokens to the specified address.\n', '     *      Invokes the `tokenFallback` function if the recipient is a contract.\n', '     *      The token transfer fails if the recipient is a contract\n', '     *      but does not implement the `tokenFallback` function\n', '     *      or the fallback function to receive funds.\n', '     *\n', '     * @param _to    Receiver address.\n', '     * @param _value Amount of tokens that will be transferred.\n', '     * @param _data  Transaction metadata.\n', '     */\n', '    function transfer(address _to, uint _value, bytes _data) whenNotPaused external returns (bool success){\n', '        // Standard function transfer similar to ERC20 transfer with no _data .\n', '        // Added due to backwards compatibility reasons .\n', '        require(balances[msg.sender] >= _value && _value > 0);\n', '        if(isContract(_to)){\n', '           return transferToContract(_to, _value, _data);\n', '        }\n', '        else\n', '        {\n', '            return transferToAddress(_to, _value,  _data);\n', '        }\n', '    }\n', '    \n', '    /**\n', '     * @dev Transfer the specified amount of tokens to the specified address.\n', '     *      This function works the same with the previous one\n', '     *      but doesn&#39;t contain `_data` param.\n', '     *      Added due to backwards compatibility reasons.\n', '     *\n', '     * @param _to    Receiver address.\n', '     * @param _value Amount of tokens that will be transferred.\n', '     */\n', '    function transfer(address _to, uint _value) whenNotPaused external returns (bool success){\n', '        require(balances[msg.sender] >= _value && _value > 0);\n', '        bytes memory empty;\n', '        if(isContract(_to)){\n', '           return transferToContract(_to, _value, empty);\n', '        }\n', '        else\n', '        {\n', '            return transferToAddress(_to, _value, empty);\n', '        }\n', '        //emit Transfer(msg.sender, _to, _value, empty);\n', '    }\n', '    \n', '//assemble the given address bytecode. If bytecode exists then the _addr is a contract.\n', '  function isContract(address _addr) internal view returns (bool is_contract) {\n', '    // retrieve the size of the code on target address, this needs assembly\n', '    uint length;\n', '    assembly { length := extcodesize(_addr) }\n', '    if (length > 0)\n', '    return true;\n', '    else\n', '    return false;\n', '  }\n', '  // function that is called when transaction target is an address\n', '    function transferToAddress(address _to, uint _value, bytes _data) private whenNotPaused returns (bool success) {\n', '        require(_to != address(0));\n', '        require(balances[msg.sender] >= _value && _value > 0);\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        emit Transfer(msg.sender, _to, _value);\n', '        emit Transfer(msg.sender, _to, _value, _data);\n', '        return true;\n', '    }\n', '    // function that is called when transaction target is a contract\n', '    function transferToContract(address _to, uint _value, bytes _data) private whenNotPaused returns (bool success) {\n', '        require(_to != address(0));\n', '        require(balances[msg.sender] >= _value && _value > 0);\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);\n', '        receiver.tokenFallback(msg.sender, _value, _data);\n', '        emit Transfer(msg.sender, _to, _value);\n', '        emit Transfer(msg.sender, _to, _value, _data);\n', '        return true;\n', '    }\n', '    /**\n', '     * @dev Returns balance of the `_owner`.\n', '     *\n', '     * @param _owner   The address whose balance will be returned.\n', '     * @return balance Balance of the `_owner`.\n', '     */\n', '    function balanceOf(address _owner) constant external returns (uint balance) {\n', '        return balances[_owner];\n', '    }\n', '}\n', 'contract ERC20BackedERC223 is ERC223Token{\n', '    \n', '    \n', '  modifier onlyPayloadSize(uint size) {\n', '     assert(msg.data.length >= size.add(4));\n', '     _;\n', '   } \n', '    function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(3 * 32) whenNotPaused external returns (bool success) {\n', '        require(_to != address(0));\n', '        require(_value <= balances[_from]);\n', '        require(_value <= allowed[_from][msg.sender]);\n', '\n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', ' \n', '    /// @notice `msg.sender` approves `_addr` to spend `_value` tokens\n', '    /// @param _spender The address of the account able to transfer the tokens\n', '    /// @param _value The amount of wei to be approved for transfer\n', '    /// @return Whether the approval was successful or not\n', '    function approve(address _spender, uint256 _value) whenNotPaused public returns (bool success) {\n', '        require((balances[msg.sender] >= _value) && ((_value == 0) || (allowed[msg.sender][_spender] == 0)));\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '    function disApprove(address _spender) whenNotPaused public returns (bool success)\n', '    {\n', '        allowed[msg.sender][_spender] = 0;\n', '        assert(allowed[msg.sender][_spender] == 0);\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '   function increaseApproval(address _spender, uint _addedValue) whenNotPaused public returns (bool success) {\n', '    require(balances[msg.sender] >= allowed[msg.sender][_spender].add(_addedValue), "Callers balance not enough");\n', '    allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '  function decreaseApproval(address _spender, uint _subtractedValue) whenNotPaused public returns (bool success) {\n', '    uint oldValue = allowed[msg.sender][_spender];\n', '    require((_subtractedValue != 0) && (oldValue > _subtractedValue) , "The amount to be decreased is incorrect");\n', '    allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '}\n', '\n', '   \n', '    /// @param _owner The address of the account owning tokens\n', '    /// @param _spender The address of the account able to transfer the tokens\n', '    /// @return Amount of remaining tokens allowed to spent\n', '    function allowance(address _owner, address _spender) constant public returns (uint256 remaining) {\n', '      return allowed[_owner][_spender];\n', '    }\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '}\n', 'contract burnableERC223 is ERC20BackedERC223{\n', '         // This notifies clients about the amount burnt\n', '         uint256  public _totalBurnedTokens = 0;\n', '         event Burn(address indexed from, uint256 value);\n', '     /**\n', '     * Destroy tokens\n', '     *\n', '     * Remove `_value` tokens from the system irreversibly\n', '     *\n', '     * @param _value the amount of money to burn\n', '     */\n', '    function burn(uint256 _value) onlyOwner public returns (bool success) {\n', '        require(balances[msg.sender] >= _value, "Sender doesn&#39;t have enough balance");   // Check if the sender has enough\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);            // Subtract from the sender\n', '        _CAP = _CAP.sub(_value);                      // Updates totalSupply\n', '        _totalBurnedTokens = _totalBurnedTokens.add(_value);\n', '        emit Burn(msg.sender, _value);\n', '        emit Transfer(msg.sender, address(0), _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Destroy tokens from other account\n', '     *\n', '     * Remove `_value` tokens from the system irreversibly on behalf of `_from`.\n', '     *\n', '     * @param _from the address of the sender\n', '     * @param _value the amount of money to burn\n', '     */\n', '    function burnFrom(address _from, uint256 _value) onlyOwner public returns (bool success) {\n', '        require(balances[_from] >= _value , "target balance is not enough");                // Check if the targeted balance is enough\n', '        require(_value <= allowed[_from][msg.sender]);    // Check allowance\n', '        balances[_from] = balances[_from].sub(_value);                         // Subtract from the targeted balance\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);             // Subtract from the sender&#39;s allowance\n', '        _CAP = _CAP.sub(_value);                              // Update totalSupply\n', '        emit Burn(_from, _value);\n', '        emit Transfer(_from, address(0), _value);\n', '        return true;\n', '    }\n', '    \n', '}\n', 'contract mintableERC223 is burnableERC223{\n', '    \n', '    uint256 public _totalMinedSupply;\n', '    uint256 public _initialSupply;\n', '    event Mint(address indexed to, uint256 amount);\n', '    event MintFinished();\n', '    bool public mintingFinished = false;\n', '\n', '\n', '  modifier canMint() {\n', '    require(!mintingFinished);\n', '    _;\n', '  }\n', '  /**\n', '   * @dev Function to mint tokens\n', '   * @param _to The address that will receive the minted tokens.\n', '   * @param _amount The amount of tokens to mint.\n', '   * @return A boolean that indicates if the operation was successful.\n', '   */\n', '  function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {\n', '      bytes memory empty;\n', '      uint256 availableMinedSupply;\n', '      availableMinedSupply =  (_totalMinedSupply.sub(_totalBurnedTokens)).add(_amount);\n', '    require(_CAP >= availableMinedSupply , "All tokens minted, Cap reached");\n', '    _totalMinedSupply = _totalMinedSupply.add(_amount);\n', '    if(_CAP <= _totalMinedSupply.sub(_totalBurnedTokens))\n', '    mintingFinished = true;\n', '    balances[_to] = balances[_to].add(_amount);\n', '    emit Mint(_to, _amount);\n', '    emit Transfer(address(0), _to, _amount);\n', '    emit Transfer(address(0), _to, _amount, empty);\n', '    return true;\n', '  }\n', ' /**\n', '   * @dev Function to stop minting new tokens.\n', '   * @return True if the operation was successful.\n', '   */\n', '  function finishMinting() onlyOwner canMint public returns (bool) {\n', '    mintingFinished = true;\n', '    emit MintFinished();\n', '    return true;\n', '  }\n', '    /// @return total amount of tokens\n', '    function maximumSupply() public view returns (uint256 supply){\n', '        \n', '        return _CAP;\n', '    }\n', '      /// @return total amount of tokens\n', '    function totalMinedSupply() public view returns (uint256 supply){\n', '        \n', '        return _totalMinedSupply;\n', '    }\n', '      /// @return total amount of tokens\n', '    function preMinedSupply() public view returns (uint256 supply){\n', '        \n', '        return _initialSupply;\n', '    }\n', '\tfunction totalBurnedTokens() public view returns (uint256 supply){\n', '        \n', '        return _totalBurnedTokens;\n', '    }\n', '     function totalSupply() public view returns (uint256 supply){\n', '        \n', '        return _totalMinedSupply.sub(_totalBurnedTokens);\n', '    }\n', '}\n', 'contract CyBit is mintableERC223{\n', '    \n', '     /* Public variables of the token */\n', '\n', '    /*\n', '    NOTE:\n', '    \n', '    They allow one to customise the token contract & in no way influences the core functionality.\n', '    Some wallets/interfaces might not even bother to look at this information.\n', '    */\n', '    string public name;                   //Name Of Token\n', '    uint256 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It&#39;s like comparing 1 wei to 1 ether.\n', '    string public symbol;                 //An identifier: eg SBX\n', '    string public version;                 //An Arbitrary versioning scheme.\n', '\n', '    uint256 private initialsupply;\n', '    uint256 private totalsupply;\n', '\n', '    \n', ' constructor() public\n', ' {\n', '     decimals = 8;\n', '     name = "CyBit";                                    // Set the name for display purposes\n', '     symbol = "eCBT";                                   // Set the symbol for display purposes\n', '     version = "V1.0";                                  //Version.\n', '     initialsupply = 7000000000;                        //PreMined Tokens\n', '     totalsupply = 10000000000;                         //Total Tokens\n', '     _CAP = totalsupply.mul(10 ** decimals);\n', '     _initialSupply = initialsupply.mul(10 ** decimals);\n', '     _totalMinedSupply = _initialSupply;\n', '     balances[msg.sender] = _initialSupply;\n', '     \n', ' }\n', ' function() public {\n', '         //not payable fallback function\n', '          revert();\n', '    }\n', '    \n', '    /* Get the contract constant _name */\n', '      function version() public view returns (string _v) {\n', '        return version;\n', '    }\n', '    function name() public view returns (string _name) {\n', '        return name;\n', '    }\n', '\n', '    /* Get the contract constant _symbol */\n', '    function symbol() public view returns (string _symbol) {\n', '        return symbol;\n', '    }\n', '\n', '    /* Get the contract constant _decimals */\n', '    function decimals() public view returns (uint256 _decimals) {\n', '        return decimals;\n', '    }\n', '\n', ' }']