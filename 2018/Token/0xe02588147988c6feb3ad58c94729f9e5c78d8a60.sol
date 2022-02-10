['// Project: AleHub\n', '// v1, 2018-05-24\n', '// This code is the property of CryptoB2B.io\n', '// Copying in whole or in part is prohibited.\n', '// Authors: Ivan Fedorov and Dmitry Borodin\n', '// Do you want the same TokenSale platform? www.cryptob2b.io\n', '\n', '// *.sol in 1 file - https://cryptob2b.io/solidity/alehub/\n', '\n', 'pragma solidity ^0.4.21;\n', '\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a / b;\n', '        return c;\n', '    }\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '    function minus(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (b>=a) return 0;\n', '        return a - b;\n', '    }\n', '}\n', '\n', 'contract MigrationAgent\n', '{\n', '    function migrateFrom(address _from, uint256 _value) public;\n', '}\n', '\n', 'contract IRightAndRoles {\n', '    address[][] public wallets;\n', '    mapping(address => uint16) public roles;\n', '\n', '    event WalletChanged(address indexed newWallet, address indexed oldWallet, uint8 indexed role);\n', '    event CloneChanged(address indexed wallet, uint8 indexed role, bool indexed mod);\n', '\n', '    function changeWallet(address _wallet, uint8 _role) external;\n', '    function setManagerPowerful(bool _mode) external;\n', '    function onlyRoles(address _sender, uint16 _roleMask) view external returns(bool);\n', '}\n', '\n', 'contract GuidedByRoles {\n', '    IRightAndRoles public rightAndRoles;\n', '    function GuidedByRoles(IRightAndRoles _rightAndRoles) public {\n', '        rightAndRoles = _rightAndRoles;\n', '    }\n', '}\n', '\n', 'contract Pausable is GuidedByRoles {\n', '\n', '    mapping (address => bool) public unpausedWallet;\n', '\n', '    event Pause();\n', '    event Unpause();\n', '\n', '    bool public paused = true;\n', '\n', '\n', '    /**\n', '     * @dev Modifier to make a function callable only when the contract is not paused.\n', '     */\n', '    modifier whenNotPaused(address _to) {\n', '        require(!paused||unpausedWallet[msg.sender]||unpausedWallet[_to]);\n', '        _;\n', '    }\n', '\n', '    function onlyAdmin() internal view {\n', '        require(rightAndRoles.onlyRoles(msg.sender,3));\n', '    }\n', '\n', '    // Add a wallet ignoring the "Exchange pause". Available to the owner of the contract.\n', '    function setUnpausedWallet(address _wallet, bool mode) public {\n', '        onlyAdmin();\n', '        unpausedWallet[_wallet] = mode;\n', '    }\n', '\n', '    /**\n', '     * @dev called by the owner to pause, triggers stopped state\n', '     */\n', '    function setPause(bool mode)  public {\n', '        require(rightAndRoles.onlyRoles(msg.sender,1));\n', '        if (!paused && mode) {\n', '            paused = true;\n', '            emit Pause();\n', '        }else\n', '        if (paused && !mode) {\n', '            paused = false;\n', '            emit Unpause();\n', '        }\n', '    }\n', '\n', '}\n', '\n', 'contract ERC20Basic {\n', '    function totalSupply() public view returns (uint256);\n', '    function balanceOf(address who) public view returns (uint256);\n', '    function transfer(address to, uint256 value) public returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', 'contract BasicToken is ERC20Basic {\n', '    using SafeMath for uint256;\n', '\n', '    mapping(address => uint256) balances;\n', '\n', '    uint256 totalSupply_;\n', '\n', '    /**\n', '    * @dev total number of tokens in existence\n', '    */\n', '    function totalSupply() public view returns (uint256) {\n', '        return totalSupply_;\n', '    }\n', '\n', '    /**\n', '    * @dev transfer token for a specified address\n', '    * @param _to The address to transfer to.\n', '    * @param _value The amount to be transferred.\n', '    */\n', '    function transfer(address _to, uint256 _value) public returns (bool) {\n', '        require(_to != address(0));\n', '        require(_value <= balances[msg.sender]);\n', '\n', '        // SafeMath.sub will throw if there is not enough balance.\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '    * @dev Gets the balance of the specified address.\n', '    * @param _owner The address to query the the balance of.\n', '    * @return An uint256 representing the amount owned by the passed address.\n', '    */\n', '    function balanceOf(address _owner) public view returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '}\n', '\n', 'contract BurnableToken is BasicToken, GuidedByRoles {\n', '\n', '    event Burn(address indexed burner, uint256 value);\n', '\n', '    /**\n', '     * @dev Burns a specific amount of tokens.\n', '     * @param _value The amount of token to be burned.\n', '     */\n', '    function burn(address _beneficiary, uint256 _value) public {\n', '        require(rightAndRoles.onlyRoles(msg.sender,1));\n', '        require(_value <= balances[_beneficiary]);\n', '        // no need to require value <= totalSupply, since that would imply the\n', '        // sender&#39;s balance is greater than the totalSupply, which *should* be an assertion failure\n', '\n', '        balances[_beneficiary] = balances[_beneficiary].sub(_value);\n', '        totalSupply_ = totalSupply_.sub(_value);\n', '        emit Burn(_beneficiary, _value);\n', '        emit Transfer(_beneficiary, address(0), _value);\n', '    }\n', '}\n', '\n', 'contract ERC20 is ERC20Basic {\n', '    function allowance(address owner, address spender) public view returns (uint256);\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '    function approve(address spender, uint256 value) public returns (bool);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '    mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '\n', '    /**\n', '     * @dev Transfer tokens from one address to another\n', '     * @param _from address The address which you want to send tokens from\n', '     * @param _to address The address which you want to transfer to\n', '     * @param _value uint256 the amount of tokens to be transferred\n', '     */\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '        require(_to != address(0));\n', '        require(_value <= balances[_from]);\n', '        require(_value <= allowed[_from][msg.sender]);\n', '\n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '     *\n', '     * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', '     * race condition is to first reduce the spender&#39;s allowance to 0 and set the desired value afterwards:\n', '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     * @param _spender The address which will spend the funds.\n', '     * @param _value The amount of tokens to be spent.\n', '     */\n', '    function approve(address _spender, uint256 _value) public returns (bool) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '     * @param _owner address The address which owns the funds.\n', '     * @param _spender address The address which will spend the funds.\n', '     * @return A uint256 specifying the amount of tokens still available for the spender.\n', '     */\n', '    function allowance(address _owner, address _spender) public view returns (uint256) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    /**\n', '     * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '     *\n', '     * approve should be called when allowed[_spender] == 0. To increment\n', '     * allowed value is better to use this function to avoid 2 calls (and wait until\n', '     * the first transaction is mined)\n', '     * From MonolithDAO Token.sol\n', '     * @param _spender The address which will spend the funds.\n', '     * @param _addedValue The amount of tokens to increase the allowance by.\n', '     */\n', '    function increaseApproval(address _spender, uint _addedValue) public returns (bool) {\n', '        allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '     *\n', '     * approve should be called when allowed[_spender] == 0. To decrement\n', '     * allowed value is better to use this function to avoid 2 calls (and wait until\n', '     * the first transaction is mined)\n', '     * From MonolithDAO Token.sol\n', '     * @param _spender The address which will spend the funds.\n', '     * @param _subtractedValue The amount of tokens to decrease the allowance by.\n', '     */\n', '    function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {\n', '        uint oldValue = allowed[msg.sender][_spender];\n', '        if (_subtractedValue > oldValue) {\n', '            allowed[msg.sender][_spender] = 0;\n', '        } else {\n', '            allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '        }\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '}\n', '\n', 'contract PausableToken is StandardToken, Pausable {\n', '\n', '    function transfer(address _to, uint256 _value) public whenNotPaused(_to) returns (bool) {\n', '        return super.transfer(_to, _value);\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused(_to) returns (bool) {\n', '        return super.transferFrom(_from, _to, _value);\n', '    }\n', '}\n', '\n', 'contract FreezingToken is PausableToken {\n', '    struct freeze {\n', '    uint256 amount;\n', '    uint256 when;\n', '    }\n', '\n', '\n', '    mapping (address => freeze) freezedTokens;\n', '\n', '    function freezedTokenOf(address _beneficiary) public view returns (uint256 amount){\n', '        freeze storage _freeze = freezedTokens[_beneficiary];\n', '        if(_freeze.when < now) return 0;\n', '        return _freeze.amount;\n', '    }\n', '\n', '    function defrostDate(address _beneficiary) public view returns (uint256 Date) {\n', '        freeze storage _freeze = freezedTokens[_beneficiary];\n', '        if(_freeze.when < now) return 0;\n', '        return _freeze.when;\n', '    }\n', '\n', '    function freezeTokens(address _beneficiary, uint256 _amount, uint256 _when) public {\n', '        require(rightAndRoles.onlyRoles(msg.sender,1));\n', '        freeze storage _freeze = freezedTokens[_beneficiary];\n', '        _freeze.amount = _amount;\n', '        _freeze.when = _when;\n', '    }\n', '\n', '    function masFreezedTokens(address[] _beneficiary, uint256[] _amount, uint256[] _when) public {\n', '        onlyAdmin();\n', '        require(_beneficiary.length == _amount.length && _beneficiary.length == _when.length);\n', '        for(uint16 i = 0; i < _beneficiary.length; i++){\n', '            freeze storage _freeze = freezedTokens[_beneficiary[i]];\n', '            _freeze.amount = _amount[i];\n', '            _freeze.when = _when[i];\n', '        }\n', '    }\n', '\n', '\n', '    function transferAndFreeze(address _to, uint256 _value, uint256 _when) external {\n', '        require(unpausedWallet[msg.sender]);\n', '        require(freezedTokenOf(_to) == 0);\n', '        if(_when > 0){\n', '            freeze storage _freeze = freezedTokens[_to];\n', '            _freeze.amount = _value;\n', '            _freeze.when = _when;\n', '        }\n', '        transfer(_to,_value);\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool) {\n', '        require(balanceOf(msg.sender) >= freezedTokenOf(msg.sender).add(_value));\n', '        return super.transfer(_to,_value);\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '        require(balanceOf(_from) >= freezedTokenOf(_from).add(_value));\n', '        return super.transferFrom( _from,_to,_value);\n', '    }\n', '}\n', '\n', 'contract MigratableToken is BasicToken,GuidedByRoles {\n', '\n', '    uint256 public totalMigrated;\n', '    address public migrationAgent;\n', '\n', '    event Migrate(address indexed _from, address indexed _to, uint256 _value);\n', '\n', '    function setMigrationAgent(address _migrationAgent) public {\n', '        require(rightAndRoles.onlyRoles(msg.sender,1));\n', '        require(totalMigrated == 0);\n', '        migrationAgent = _migrationAgent;\n', '    }\n', '\n', '\n', '    function migrateInternal(address _holder) internal{\n', '        require(migrationAgent != 0x0);\n', '\n', '        uint256 value = balances[_holder];\n', '        balances[_holder] = 0;\n', '\n', '        totalSupply_ = totalSupply_.sub(value);\n', '        totalMigrated = totalMigrated.add(value);\n', '\n', '        MigrationAgent(migrationAgent).migrateFrom(_holder, value);\n', '        emit Migrate(_holder,migrationAgent,value);\n', '    }\n', '\n', '    function migrateAll(address[] _holders) public {\n', '        require(rightAndRoles.onlyRoles(msg.sender,1));\n', '        for(uint i = 0; i < _holders.length; i++){\n', '            migrateInternal(_holders[i]);\n', '        }\n', '    }\n', '\n', '    // Reissue your tokens.\n', '    function migrate() public\n', '    {\n', '        require(balances[msg.sender] > 0);\n', '        migrateInternal(msg.sender);\n', '    }\n', '\n', '}\n', '\n', 'contract IToken{\n', '    function setUnpausedWallet(address _wallet, bool mode) public;\n', '    function mint(address _to, uint256 _amount) public returns (bool);\n', '    function totalSupply() public view returns (uint256);\n', '    function setPause(bool mode) public;\n', '    function setMigrationAgent(address _migrationAgent) public;\n', '    function migrateAll(address[] _holders) public;\n', '    function burn(address _beneficiary, uint256 _value) public;\n', '    function freezedTokenOf(address _beneficiary) public view returns (uint256 amount);\n', '    function defrostDate(address _beneficiary) public view returns (uint256 Date);\n', '    function freezeTokens(address _beneficiary, uint256 _amount, uint256 _when) public;\n', '}\n', '\n', 'contract MintableToken is StandardToken, GuidedByRoles {\n', '    event Mint(address indexed to, uint256 amount);\n', '    event MintFinished();\n', '\n', '    /**\n', '     * @dev Function to mint tokens\n', '     * @param _to The address that will receive the minted tokens.\n', '     * @param _amount The amount of tokens to mint.\n', '     * @return A boolean that indicates if the operation was successful.\n', '     */\n', '    function mint(address _to, uint256 _amount) public returns (bool) {\n', '        require(rightAndRoles.onlyRoles(msg.sender,1));\n', '        totalSupply_ = totalSupply_.add(_amount);\n', '        balances[_to] = balances[_to].add(_amount);\n', '        emit Mint(_to, _amount);\n', '        emit Transfer(address(0), _to, _amount);\n', '        return true;\n', '    }\n', '}\n', '\n', 'contract Token is IToken, FreezingToken, MintableToken, MigratableToken, BurnableToken{\n', '    function Token(IRightAndRoles _rightAndRoles) GuidedByRoles(_rightAndRoles) public {}\n', '    string public constant name = "Ale Coin";\n', '    string public constant symbol = "ALE";\n', '    uint8 public constant decimals = 18;\n', '}']
['// Project: AleHub\n', '// v1, 2018-05-24\n', '// This code is the property of CryptoB2B.io\n', '// Copying in whole or in part is prohibited.\n', '// Authors: Ivan Fedorov and Dmitry Borodin\n', '// Do you want the same TokenSale platform? www.cryptob2b.io\n', '\n', '// *.sol in 1 file - https://cryptob2b.io/solidity/alehub/\n', '\n', 'pragma solidity ^0.4.21;\n', '\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a / b;\n', '        return c;\n', '    }\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '    function minus(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (b>=a) return 0;\n', '        return a - b;\n', '    }\n', '}\n', '\n', 'contract MigrationAgent\n', '{\n', '    function migrateFrom(address _from, uint256 _value) public;\n', '}\n', '\n', 'contract IRightAndRoles {\n', '    address[][] public wallets;\n', '    mapping(address => uint16) public roles;\n', '\n', '    event WalletChanged(address indexed newWallet, address indexed oldWallet, uint8 indexed role);\n', '    event CloneChanged(address indexed wallet, uint8 indexed role, bool indexed mod);\n', '\n', '    function changeWallet(address _wallet, uint8 _role) external;\n', '    function setManagerPowerful(bool _mode) external;\n', '    function onlyRoles(address _sender, uint16 _roleMask) view external returns(bool);\n', '}\n', '\n', 'contract GuidedByRoles {\n', '    IRightAndRoles public rightAndRoles;\n', '    function GuidedByRoles(IRightAndRoles _rightAndRoles) public {\n', '        rightAndRoles = _rightAndRoles;\n', '    }\n', '}\n', '\n', 'contract Pausable is GuidedByRoles {\n', '\n', '    mapping (address => bool) public unpausedWallet;\n', '\n', '    event Pause();\n', '    event Unpause();\n', '\n', '    bool public paused = true;\n', '\n', '\n', '    /**\n', '     * @dev Modifier to make a function callable only when the contract is not paused.\n', '     */\n', '    modifier whenNotPaused(address _to) {\n', '        require(!paused||unpausedWallet[msg.sender]||unpausedWallet[_to]);\n', '        _;\n', '    }\n', '\n', '    function onlyAdmin() internal view {\n', '        require(rightAndRoles.onlyRoles(msg.sender,3));\n', '    }\n', '\n', '    // Add a wallet ignoring the "Exchange pause". Available to the owner of the contract.\n', '    function setUnpausedWallet(address _wallet, bool mode) public {\n', '        onlyAdmin();\n', '        unpausedWallet[_wallet] = mode;\n', '    }\n', '\n', '    /**\n', '     * @dev called by the owner to pause, triggers stopped state\n', '     */\n', '    function setPause(bool mode)  public {\n', '        require(rightAndRoles.onlyRoles(msg.sender,1));\n', '        if (!paused && mode) {\n', '            paused = true;\n', '            emit Pause();\n', '        }else\n', '        if (paused && !mode) {\n', '            paused = false;\n', '            emit Unpause();\n', '        }\n', '    }\n', '\n', '}\n', '\n', 'contract ERC20Basic {\n', '    function totalSupply() public view returns (uint256);\n', '    function balanceOf(address who) public view returns (uint256);\n', '    function transfer(address to, uint256 value) public returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', 'contract BasicToken is ERC20Basic {\n', '    using SafeMath for uint256;\n', '\n', '    mapping(address => uint256) balances;\n', '\n', '    uint256 totalSupply_;\n', '\n', '    /**\n', '    * @dev total number of tokens in existence\n', '    */\n', '    function totalSupply() public view returns (uint256) {\n', '        return totalSupply_;\n', '    }\n', '\n', '    /**\n', '    * @dev transfer token for a specified address\n', '    * @param _to The address to transfer to.\n', '    * @param _value The amount to be transferred.\n', '    */\n', '    function transfer(address _to, uint256 _value) public returns (bool) {\n', '        require(_to != address(0));\n', '        require(_value <= balances[msg.sender]);\n', '\n', '        // SafeMath.sub will throw if there is not enough balance.\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '    * @dev Gets the balance of the specified address.\n', '    * @param _owner The address to query the the balance of.\n', '    * @return An uint256 representing the amount owned by the passed address.\n', '    */\n', '    function balanceOf(address _owner) public view returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '}\n', '\n', 'contract BurnableToken is BasicToken, GuidedByRoles {\n', '\n', '    event Burn(address indexed burner, uint256 value);\n', '\n', '    /**\n', '     * @dev Burns a specific amount of tokens.\n', '     * @param _value The amount of token to be burned.\n', '     */\n', '    function burn(address _beneficiary, uint256 _value) public {\n', '        require(rightAndRoles.onlyRoles(msg.sender,1));\n', '        require(_value <= balances[_beneficiary]);\n', '        // no need to require value <= totalSupply, since that would imply the\n', "        // sender's balance is greater than the totalSupply, which *should* be an assertion failure\n", '\n', '        balances[_beneficiary] = balances[_beneficiary].sub(_value);\n', '        totalSupply_ = totalSupply_.sub(_value);\n', '        emit Burn(_beneficiary, _value);\n', '        emit Transfer(_beneficiary, address(0), _value);\n', '    }\n', '}\n', '\n', 'contract ERC20 is ERC20Basic {\n', '    function allowance(address owner, address spender) public view returns (uint256);\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '    function approve(address spender, uint256 value) public returns (bool);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '    mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '\n', '    /**\n', '     * @dev Transfer tokens from one address to another\n', '     * @param _from address The address which you want to send tokens from\n', '     * @param _to address The address which you want to transfer to\n', '     * @param _value uint256 the amount of tokens to be transferred\n', '     */\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '        require(_to != address(0));\n', '        require(_value <= balances[_from]);\n', '        require(_value <= allowed[_from][msg.sender]);\n', '\n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '     *\n', '     * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', "     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:\n", '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     * @param _spender The address which will spend the funds.\n', '     * @param _value The amount of tokens to be spent.\n', '     */\n', '    function approve(address _spender, uint256 _value) public returns (bool) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '     * @param _owner address The address which owns the funds.\n', '     * @param _spender address The address which will spend the funds.\n', '     * @return A uint256 specifying the amount of tokens still available for the spender.\n', '     */\n', '    function allowance(address _owner, address _spender) public view returns (uint256) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    /**\n', '     * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '     *\n', '     * approve should be called when allowed[_spender] == 0. To increment\n', '     * allowed value is better to use this function to avoid 2 calls (and wait until\n', '     * the first transaction is mined)\n', '     * From MonolithDAO Token.sol\n', '     * @param _spender The address which will spend the funds.\n', '     * @param _addedValue The amount of tokens to increase the allowance by.\n', '     */\n', '    function increaseApproval(address _spender, uint _addedValue) public returns (bool) {\n', '        allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '     *\n', '     * approve should be called when allowed[_spender] == 0. To decrement\n', '     * allowed value is better to use this function to avoid 2 calls (and wait until\n', '     * the first transaction is mined)\n', '     * From MonolithDAO Token.sol\n', '     * @param _spender The address which will spend the funds.\n', '     * @param _subtractedValue The amount of tokens to decrease the allowance by.\n', '     */\n', '    function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {\n', '        uint oldValue = allowed[msg.sender][_spender];\n', '        if (_subtractedValue > oldValue) {\n', '            allowed[msg.sender][_spender] = 0;\n', '        } else {\n', '            allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '        }\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '}\n', '\n', 'contract PausableToken is StandardToken, Pausable {\n', '\n', '    function transfer(address _to, uint256 _value) public whenNotPaused(_to) returns (bool) {\n', '        return super.transfer(_to, _value);\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused(_to) returns (bool) {\n', '        return super.transferFrom(_from, _to, _value);\n', '    }\n', '}\n', '\n', 'contract FreezingToken is PausableToken {\n', '    struct freeze {\n', '    uint256 amount;\n', '    uint256 when;\n', '    }\n', '\n', '\n', '    mapping (address => freeze) freezedTokens;\n', '\n', '    function freezedTokenOf(address _beneficiary) public view returns (uint256 amount){\n', '        freeze storage _freeze = freezedTokens[_beneficiary];\n', '        if(_freeze.when < now) return 0;\n', '        return _freeze.amount;\n', '    }\n', '\n', '    function defrostDate(address _beneficiary) public view returns (uint256 Date) {\n', '        freeze storage _freeze = freezedTokens[_beneficiary];\n', '        if(_freeze.when < now) return 0;\n', '        return _freeze.when;\n', '    }\n', '\n', '    function freezeTokens(address _beneficiary, uint256 _amount, uint256 _when) public {\n', '        require(rightAndRoles.onlyRoles(msg.sender,1));\n', '        freeze storage _freeze = freezedTokens[_beneficiary];\n', '        _freeze.amount = _amount;\n', '        _freeze.when = _when;\n', '    }\n', '\n', '    function masFreezedTokens(address[] _beneficiary, uint256[] _amount, uint256[] _when) public {\n', '        onlyAdmin();\n', '        require(_beneficiary.length == _amount.length && _beneficiary.length == _when.length);\n', '        for(uint16 i = 0; i < _beneficiary.length; i++){\n', '            freeze storage _freeze = freezedTokens[_beneficiary[i]];\n', '            _freeze.amount = _amount[i];\n', '            _freeze.when = _when[i];\n', '        }\n', '    }\n', '\n', '\n', '    function transferAndFreeze(address _to, uint256 _value, uint256 _when) external {\n', '        require(unpausedWallet[msg.sender]);\n', '        require(freezedTokenOf(_to) == 0);\n', '        if(_when > 0){\n', '            freeze storage _freeze = freezedTokens[_to];\n', '            _freeze.amount = _value;\n', '            _freeze.when = _when;\n', '        }\n', '        transfer(_to,_value);\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool) {\n', '        require(balanceOf(msg.sender) >= freezedTokenOf(msg.sender).add(_value));\n', '        return super.transfer(_to,_value);\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '        require(balanceOf(_from) >= freezedTokenOf(_from).add(_value));\n', '        return super.transferFrom( _from,_to,_value);\n', '    }\n', '}\n', '\n', 'contract MigratableToken is BasicToken,GuidedByRoles {\n', '\n', '    uint256 public totalMigrated;\n', '    address public migrationAgent;\n', '\n', '    event Migrate(address indexed _from, address indexed _to, uint256 _value);\n', '\n', '    function setMigrationAgent(address _migrationAgent) public {\n', '        require(rightAndRoles.onlyRoles(msg.sender,1));\n', '        require(totalMigrated == 0);\n', '        migrationAgent = _migrationAgent;\n', '    }\n', '\n', '\n', '    function migrateInternal(address _holder) internal{\n', '        require(migrationAgent != 0x0);\n', '\n', '        uint256 value = balances[_holder];\n', '        balances[_holder] = 0;\n', '\n', '        totalSupply_ = totalSupply_.sub(value);\n', '        totalMigrated = totalMigrated.add(value);\n', '\n', '        MigrationAgent(migrationAgent).migrateFrom(_holder, value);\n', '        emit Migrate(_holder,migrationAgent,value);\n', '    }\n', '\n', '    function migrateAll(address[] _holders) public {\n', '        require(rightAndRoles.onlyRoles(msg.sender,1));\n', '        for(uint i = 0; i < _holders.length; i++){\n', '            migrateInternal(_holders[i]);\n', '        }\n', '    }\n', '\n', '    // Reissue your tokens.\n', '    function migrate() public\n', '    {\n', '        require(balances[msg.sender] > 0);\n', '        migrateInternal(msg.sender);\n', '    }\n', '\n', '}\n', '\n', 'contract IToken{\n', '    function setUnpausedWallet(address _wallet, bool mode) public;\n', '    function mint(address _to, uint256 _amount) public returns (bool);\n', '    function totalSupply() public view returns (uint256);\n', '    function setPause(bool mode) public;\n', '    function setMigrationAgent(address _migrationAgent) public;\n', '    function migrateAll(address[] _holders) public;\n', '    function burn(address _beneficiary, uint256 _value) public;\n', '    function freezedTokenOf(address _beneficiary) public view returns (uint256 amount);\n', '    function defrostDate(address _beneficiary) public view returns (uint256 Date);\n', '    function freezeTokens(address _beneficiary, uint256 _amount, uint256 _when) public;\n', '}\n', '\n', 'contract MintableToken is StandardToken, GuidedByRoles {\n', '    event Mint(address indexed to, uint256 amount);\n', '    event MintFinished();\n', '\n', '    /**\n', '     * @dev Function to mint tokens\n', '     * @param _to The address that will receive the minted tokens.\n', '     * @param _amount The amount of tokens to mint.\n', '     * @return A boolean that indicates if the operation was successful.\n', '     */\n', '    function mint(address _to, uint256 _amount) public returns (bool) {\n', '        require(rightAndRoles.onlyRoles(msg.sender,1));\n', '        totalSupply_ = totalSupply_.add(_amount);\n', '        balances[_to] = balances[_to].add(_amount);\n', '        emit Mint(_to, _amount);\n', '        emit Transfer(address(0), _to, _amount);\n', '        return true;\n', '    }\n', '}\n', '\n', 'contract Token is IToken, FreezingToken, MintableToken, MigratableToken, BurnableToken{\n', '    function Token(IRightAndRoles _rightAndRoles) GuidedByRoles(_rightAndRoles) public {}\n', '    string public constant name = "Ale Coin";\n', '    string public constant symbol = "ALE";\n', '    uint8 public constant decimals = 18;\n', '}']
