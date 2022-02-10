['pragma solidity ^0.4.21;\n', '\n', '\n', '\n', '// File: contracts/library/SafeMath.sol\n', '\n', '/**\n', ' * @title Safe Math\n', ' *\n', ' * @dev Library for safe mathematical operations.\n', ' */\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a * b;\n', '        assert(a == 0 || c / a == b);\n', '\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a / b;\n', '\n', '        return c;\n', '    }\n', '\n', '    function minus(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '\n', '        return a - b;\n', '    }\n', '\n', '    function plus(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '\n', '        return c;\n', '    }\n', '}\n', '\n', '// File: contracts/token/ERC20Token.sol\n', '\n', '/**\n', ' * @dev The standard ERC20 Token contract base.\n', ' */\n', 'contract ERC20Token {\n', '    uint256 public totalSupply;  /* shorthand for public function and a property */\n', '\n', '    function balanceOf(address _owner) public view returns (uint256 balance);\n', '    function transfer(address _to, uint256 _value) public returns (bool success);\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);\n', '    function approve(address _spender, uint256 _value) public returns (bool success);\n', '    function allowance(address _owner, address _spender) public view returns (uint256 remaining);\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', '\n', '\n', '// File: contracts/component/TokenSafe.sol\n', '\n', '/**\n', ' * @title TokenSafe\n', ' *\n', ' * @dev Abstract contract that serves as a base for the token safes. It is a multi-group token safe, where each group\n', " *      has it's own release time and multiple accounts with locked tokens.\n", ' */\n', 'contract TokenSafe {\n', '    using SafeMath for uint;\n', '\n', '    // The ERC20 token contract.\n', '    ERC20Token token;\n', '\n', '    struct Group {\n', '        // The release date for the locked tokens\n', '        // Note: Unix timestamp fits in uint32, however block.timestamp is uint256\n', '        uint256 releaseTimestamp;\n', '        // The total remaining tokens in the group.\n', '        uint256 remaining;\n', '        // The individual account token balances in the group.\n', '        mapping (address => uint) balances;\n', '    }\n', '\n', '    // The groups of locked tokens\n', '    mapping (uint8 => Group) public groups;\n', '\n', '    /**\n', '     * @dev The constructor.\n', '     *\n', '     * @param _token The address of the  contract.\n', '     */\n', '    constructor(address _token) public {\n', '        token = ERC20Token(_token);\n', '    }\n', '\n', '    /**\n', '     * @dev The function initializes a group with a release date.\n', '     *\n', '     * @param _id Group identifying number.\n', '     * @param _releaseTimestamp Unix timestamp of the time after which the tokens can be released\n', '     */\n', '    function init(uint8 _id, uint _releaseTimestamp) internal {\n', '        require(_releaseTimestamp > 0);\n', '\n', '        Group storage group = groups[_id];\n', '        group.releaseTimestamp = _releaseTimestamp;\n', '    }\n', '\n', '    /**\n', '     * @dev Add new account with locked token balance to the specified group id.\n', '     *\n', '     * @param _id Group identifying number.\n', '     * @param _account The address of the account to be added.\n', '     * @param _balance The number of tokens to be locked.\n', '     */\n', '    function add(uint8 _id, address _account, uint _balance) internal {\n', '        Group storage group = groups[_id];\n', '        group.balances[_account] = group.balances[_account].plus(_balance);\n', '        group.remaining = group.remaining.plus(_balance);\n', '    }\n', '\n', '    /**\n', '     * @dev Allows an account to be released if it meets the time constraints of the group.\n', '     *\n', '     * @param _id Group identifying number.\n', '     * @param _account The address of the account to be released.\n', '     */\n', '    function release(uint8 _id, address _account) public {\n', '        Group storage group = groups[_id];\n', '        require(now >= group.releaseTimestamp);\n', '\n', '        uint tokens = group.balances[_account];\n', '        require(tokens > 0);\n', '\n', '        group.balances[_account] = 0;\n', '        group.remaining = group.remaining.minus(tokens);\n', '\n', '        if (!token.transfer(_account, tokens)) {\n', '            revert();\n', '        }\n', '    }\n', '}\n', '\n', '\n', '\n', '\n', '\n', '\n', '// File: contracts/token/StandardToken.sol\n', '\n', '/**\n', ' * @title Standard Token\n', ' *\n', ' * @dev The standard abstract implementation of the ERC20 interface.\n', ' */\n', 'contract StandardToken is ERC20Token {\n', '    using SafeMath for uint256;\n', '\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals;\n', '\n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '    /**\n', '     * @dev The constructor assigns the token name, symbols and decimals.\n', '     */\n', '    constructor(string _name, string _symbol, uint8 _decimals) internal {\n', '        name = _name;\n', '        symbol = _symbol;\n', '        decimals = _decimals;\n', '    }\n', '\n', '    /**\n', '     * @dev Get the balance of an address.\n', '     *\n', "     * @param _address The address which's balance will be checked.\n", '     *\n', '     * @return The current balance of the address.\n', '     */\n', '    function balanceOf(address _address) public view returns (uint256 balance) {\n', '        return balances[_address];\n', '    }\n', '\n', '    /**\n', '     * @dev Checks the amount of tokens that an owner allowed to a spender.\n', '     *\n', '     * @param _owner The address which owns the funds allowed for spending by a third-party.\n', '     * @param _spender The third-party address that is allowed to spend the tokens.\n', '     *\n', '     * @return The number of tokens available to `_spender` to be spent.\n', '     */\n', '    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    /**\n', '     * @dev Give permission to `_spender` to spend `_value` number of tokens on your behalf.\n', '     * E.g. You place a buy or sell order on an exchange and in that example, the\n', '     * `_spender` address is the address of the contract the exchange created to add your token to their\n', '     * website and you are `msg.sender`.\n', '     *\n', '     * @param _spender The address which will spend the funds.\n', '     * @param _value The amount of tokens to be spent.\n', '     *\n', '     * @return Whether the approval process was successful or not.\n', '     */\n', '    function approve(address _spender, uint256 _value) public returns (bool) {\n', '        allowed[msg.sender][_spender] = _value;\n', '\n', '        emit Approval(msg.sender, _spender, _value);\n', '\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers `_value` number of tokens to the `_to` address.\n', '     *\n', '     * @param _to The address of the recipient.\n', '     * @param _value The number of tokens to be transferred.\n', '     */\n', '    function transfer(address _to, uint256 _value) public returns (bool) {\n', '        executeTransfer(msg.sender, _to, _value);\n', '\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Allows another contract to spend tokens on behalf of the `_from` address and send them to the `_to` address.\n', '     *\n', '     * @param _from The address which approved you to spend tokens on their behalf.\n', '     * @param _to The address where you want to send tokens.\n', '     * @param _value The number of tokens to be sent.\n', '     *\n', '     * @return Whether the transfer was successful or not.\n', '     */\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '        require(_value <= allowed[_from][msg.sender]);\n', '\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].minus(_value);\n', '        executeTransfer(_from, _to, _value);\n', '\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Internal function that this reused by the transfer functions\n', '     */\n', '    function executeTransfer(address _from, address _to, uint256 _value) internal {\n', '        require(_to != address(0));\n', '        require(_value != 0 && _value <= balances[_from]);\n', '\n', '        balances[_from] = balances[_from].minus(_value);\n', '        balances[_to] = balances[_to].plus(_value);\n', '\n', '        emit Transfer(_from, _to, _value);\n', '    }\n', '}\n', '\n', '\n', '\n', '\n', '\n', '\n', '// File: contracts/token/MintableToken.sol\n', '\n', '/**\n', ' * @title Mintable Token\n', ' *\n', ' * @dev Allows the creation of new tokens.\n', ' */\n', 'contract MintableToken is StandardToken {\n', '    /// @dev The only address allowed to mint coins\n', '    address public minter;\n', '\n', '    /// @dev Indicates whether the token is still mintable.\n', '    bool public mintingDisabled = false;\n', '\n', '    /**\n', '     * @dev Event fired when minting is no longer allowed.\n', '     */\n', '    event MintingDisabled();\n', '\n', '    /**\n', '     * @dev Allows a function to be executed only if minting is still allowed.\n', '     */\n', '    modifier canMint() {\n', '        require(!mintingDisabled);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Allows a function to be called only by the minter\n', '     */\n', '    modifier onlyMinter() {\n', '        require(msg.sender == minter);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev The constructor assigns the minter which is allowed to mind and disable minting\n', '     */\n', '    constructor(address _minter) internal {\n', '        minter = _minter;\n', '    }\n', '\n', '    /**\n', '    * @dev Creates new `_value` number of tokens and sends them to the `_to` address.\n', '    *\n', '    * @param _to The address which will receive the freshly minted tokens.\n', '    * @param _value The number of tokens that will be created.\n', '    */\n', '    function mint(address _to, uint256 _value) public onlyMinter canMint {\n', '        totalSupply = totalSupply.plus(_value);\n', '        balances[_to] = balances[_to].plus(_value);\n', '\n', '        emit Transfer(0x0, _to, _value);\n', '    }\n', '\n', '    /**\n', '    * @dev Disable the minting of new tokens. Cannot be reversed.\n', '    *\n', '    * @return Whether or not the process was successful.\n', '    */\n', '    function disableMinting() public onlyMinter canMint {\n', '        mintingDisabled = true;\n', '\n', '        emit MintingDisabled();\n', '    }\n', '}\n', '\n', '// File: contracts/token/BurnableToken.sol\n', '\n', '/**\n', ' * @title Burnable Token\n', ' *\n', ' * @dev Allows tokens to be destroyed.\n', ' */\n', 'contract BurnableToken is StandardToken {\n', '    /**\n', '     * @dev Event fired when tokens are burned.\n', '     *\n', '     * @param _from The address from which tokens will be removed.\n', '     * @param _value The number of tokens to be destroyed.\n', '     */\n', '    event Burn(address indexed _from, uint256 _value);\n', '\n', '    /**\n', '     * @dev Burnes `_value` number of tokens.\n', '     *\n', '     * @param _value The number of tokens that will be burned.\n', '     */\n', '    function burn(uint256 _value) public {\n', '        require(_value != 0);\n', '\n', '        address burner = msg.sender;\n', '        require(_value <= balances[burner]);\n', '\n', '        balances[burner] = balances[burner].minus(_value);\n', '        totalSupply = totalSupply.minus(_value);\n', '\n', '        emit Burn(burner, _value);\n', '        emit Transfer(burner, address(0), _value);\n', '    }\n', '}\n', '\n', '// File: contracts/trait/HasOwner.sol\n', '\n', '/**\n', ' * @title HasOwner\n', ' *\n', ' * @dev Allows for exclusive access to certain functionality.\n', ' */\n', 'contract HasOwner {\n', '    // The current owner.\n', '    address public owner;\n', '\n', '    // Conditionally the new owner.\n', '    address public newOwner;\n', '\n', '    /**\n', '     * @dev The constructor.\n', '     *\n', '     * @param _owner The address of the owner.\n', '     */\n', '    constructor(address _owner) public {\n', '        owner = _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Access control modifier that allows only the current owner to call the function.\n', '     */\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev The event is fired when the current owner is changed.\n', '     *\n', '     * @param _oldOwner The address of the previous owner.\n', '     * @param _newOwner The address of the new owner.\n', '     */\n', '    event OwnershipTransfer(address indexed _oldOwner, address indexed _newOwner);\n', '\n', '    /**\n', '     * @dev Transfering the ownership is a two-step process, as we prepare\n', '     * for the transfer by setting `newOwner` and requiring `newOwner` to accept\n', '     * the transfer. This prevents accidental lock-out if something goes wrong\n', '     * when passing the `newOwner` address.\n', '     *\n', '     * @param _newOwner The address of the proposed new owner.\n', '     */\n', '    function transferOwnership(address _newOwner) public onlyOwner {\n', '        newOwner = _newOwner;\n', '    }\n', '\n', '    /**\n', '     * @dev The `newOwner` finishes the ownership transfer process by accepting the\n', '     * ownership.\n', '     */\n', '    function acceptOwnership() public {\n', '        require(msg.sender == newOwner);\n', '\n', '        emit OwnershipTransfer(owner, newOwner);\n', '\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', '// File: contracts/token/PausableToken.sol\n', '\n', '/**\n', ' * @title Pausable Token\n', ' *\n', ' * @dev Allows you to pause/unpause transfers of your token.\n', ' **/\n', 'contract PausableToken is StandardToken, HasOwner {\n', '\n', '    /// Indicates whether the token contract is paused or not.\n', '    bool public paused = false;\n', '\n', '    /**\n', '     * @dev Event fired when the token contracts gets paused.\n', '     */\n', '    event Pause();\n', '\n', '    /**\n', '     * @dev Event fired when the token contracts gets unpaused.\n', '     */\n', '    event Unpause();\n', '\n', '    /**\n', '     * @dev Allows a function to be called only when the token contract is not paused.\n', '     */\n', '    modifier whenNotPaused() {\n', '        require(!paused);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Pauses the token contract.\n', '     */\n', '    function pause() public onlyOwner whenNotPaused {\n', '        paused = true;\n', '        emit Pause();\n', '    }\n', '\n', '    /**\n', '     * @dev Unpauses the token contract.\n', '     */\n', '    function unpause() public onlyOwner {\n', '        require(paused);\n', '\n', '        paused = false;\n', '        emit Unpause();\n', '    }\n', '\n', "    /// Overrides of the standard token's functions to add the paused/unpaused functionality.\n", '\n', '    function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {\n', '        return super.transfer(_to, _value);\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {\n', '        return super.approve(_spender, _value);\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {\n', '        return super.transferFrom(_from, _to, _value);\n', '    }\n', '}\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '// File: contracts/token/StandardMintableToken.sol\n', '\n', 'contract StandardMintableToken is MintableToken {\n', '    constructor(address _minter, string _name, string _symbol, uint8 _decimals)\n', '        StandardToken(_name, _symbol, _decimals)\n', '        MintableToken(_minter)\n', '        public\n', '    {\n', '    }\n', '}\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '/**\n', ' * @title CoinwareToken\n', ' */\n', '\n', 'contract CoinwareToken is MintableToken, BurnableToken, PausableToken {\n', '    constructor(address _owner, address _minter)\n', '        StandardToken(\n', '            "CoinwareToken",   // Token name\n', '            "CWT", // Token symbol\n', '            18  // Token decimals\n', '        )\n', '        HasOwner(_owner)\n', '        MintableToken(_minter)\n', '        public\n', '    {\n', '    }\n', '}']