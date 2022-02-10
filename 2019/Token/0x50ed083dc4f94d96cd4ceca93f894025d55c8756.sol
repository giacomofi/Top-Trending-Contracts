['pragma solidity ^0.5.0;\n', '\n', '\n', '/*\n', ' * Ownable\n', ' *\n', ' * Base contract with an owner.\n', ' * Provides onlyOwner modifier, which prevents function from running if it is called by anyone other than the owner.\n', ' */\n', 'contract Ownable {\n', '    address public owner;\n', '\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner() {\n', '        if (msg.sender != owner) {\n', '            revert();\n', '        }\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        if (newOwner != address(0)) {\n', '            owner = newOwner;\n', '        }\n', '    }\n', '\n', '}\n', '\n', '\n', '/*\n', ' * ERC20 interface\n', ' * see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 {\n', '    uint public totalSupply;\n', '\n', '    function balanceOf(address who) public view returns (uint);\n', '    function allowance(address owner, address spender) public view returns (uint);\n', '\n', '    function transfer(address to, uint value) public returns (bool ok);\n', '    function transferFrom(address from, address to, uint value) public returns (bool ok);\n', '    function approve(address spender, uint value) public returns (bool ok);\n', '    event Transfer(address indexed from, address indexed to, uint value);\n', '    event Approval(address indexed owner, address indexed spender, uint value);\n', '}\n', '\n', '\n', '\n', '/**\n', ' * Math operations with safety checks\n', ' */\n', 'contract SafeMath {\n', '    function safeMul(uint a, uint b) internal pure returns (uint) {\n', '        uint c = a * b;\n', '        assertThat(a == 0 || c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function safeDiv(uint a, uint b) internal pure returns (uint) {\n', '        assertThat(b > 0);\n', '        uint c = a / b;\n', '        assertThat(a == b * c + a % b);\n', '        return c;\n', '    }\n', '\n', '    function safeSub(uint a, uint b) internal pure returns (uint) {\n', '        assertThat(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function safeAdd(uint a, uint b) internal pure returns (uint) {\n', '        uint c = a + b;\n', '        assertThat(c>=a && c>=b);\n', '        return c;\n', '    }\n', '\n', '    function max64(uint64 a, uint64 b) internal pure returns (uint64) {\n', '        return a >= b ? a : b;\n', '    }\n', '\n', '    function min64(uint64 a, uint64 b) internal pure returns (uint64) {\n', '        return a < b ? a : b;\n', '    }\n', '\n', '    function max256(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return a >= b ? a : b;\n', '    }\n', '\n', '    function min256(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return a < b ? a : b;\n', '    }\n', '\n', '    function assertThat(bool assertion) internal pure {\n', '        if (!assertion) {\n', '            revert();\n', '        }\n', '    }\n', '}\n', '\n', '\n', '/**\n', ' * Standard ERC20 token with Short Hand Attack and approve() race condition mitigation.\n', ' *\n', ' * Based on code by FirstBlood:\n', ' * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract StandardToken is ERC20, SafeMath {\n', '\n', '    string public name;\n', '    string public symbol;\n', '    uint public decimals;\n', '\n', '    /* Actual balances of token holders */\n', '    mapping(address => uint) balances;\n', '\n', '    /* approve() allowances */\n', '    mapping (address => mapping (address => uint)) allowed;\n', '\n', '    /**\n', '     *\n', '     * Fix for the ERC20 short address attack\n', '     *\n', '     * http://vessenes.com/the-erc20-short-address-attack-explained/\n', '     */\n', '    modifier onlyPayloadSize(uint size) {\n', '        if(msg.data.length < size + 4) {\n', '            revert();\n', '        }\n', '        _;\n', '    }\n', '\n', '    function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) public returns (bool success) {\n', '        balances[msg.sender] = safeSub(balances[msg.sender], _value);\n', '        balances[_to] = safeAdd(balances[_to], _value);\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint _value) public returns (bool success) {\n', '        uint _allowance = allowed[_from][msg.sender];\n', '\n', '        balances[_to] = safeAdd(balances[_to], _value);\n', '        balances[_from] = safeSub(balances[_from], _value);\n', '        allowed[_from][msg.sender] = safeSub(_allowance, _value);\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function balanceOf(address _owner) public view returns (uint balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function approve(address _spender, uint _value) public returns (bool success) {\n', '\n', '        // To change the approve amount you first have to reduce the addresses`\n', '        //  allowance to zero by calling `approve(_spender, 0)` if it is not\n', '        //  already 0 to mitigate the race condition described here:\n', '        //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '        if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) revert();\n', '\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) public view returns (uint remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    /**\n', '   * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '   *\n', '   * approve should be called when allowed[_spender] == 0. To increment\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _addedValue The amount of tokens to increase the allowance by.\n', '   */\n', '    function increaseApproval(address _spender, uint _addedValue) public returns (bool) {\n', '        allowed[msg.sender][_spender] = safeAdd(allowed[msg.sender][_spender],_addedValue);\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '     *\n', '     * approve should be called when allowed[_spender] == 0. To decrement\n', '     * allowed value is better to use this function to avoid 2 calls (and wait until\n', '     * the first transaction is mined)\n', '     * From MonolithDAO Token.sol\n', '     * @param _spender The address which will spend the funds.\n', '     * @param _subtractedValue The amount of tokens to decrease the allowance by.\n', '     */\n', '    function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {\n', '        uint oldValue = allowed[msg.sender][_spender];\n', '        if (_subtractedValue > oldValue) {\n', '            allowed[msg.sender][_spender] = 0;\n', '        } else {\n', '            allowed[msg.sender][_spender] = safeSub(oldValue, _subtractedValue);\n', '        }\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '}\n', '\n', '/**\n', ' * @title Pausable\n', ' * @dev Base contract which allows children to implement an emergency stop mechanism.\n', ' */\n', 'contract Pausable is Ownable {\n', '    event Pause();\n', '    event Unpause();\n', '\n', '    bool public paused = false;\n', '\n', '\n', '    /**\n', '     * @dev Modifier to make a function callable only when the contract is not paused.\n', '     */\n', '    modifier whenNotPaused() {\n', '        require(!paused);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Modifier to make a function callable only when the contract is paused.\n', '     */\n', '    modifier whenPaused() {\n', '        require(paused);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev called by the owner to pause, triggers stopped state\n', '     */\n', '    function pause() onlyOwner whenNotPaused public {\n', '        paused = true;\n', '        emit Pause();\n', '    }\n', '\n', '    /**\n', '     * @dev called by the owner to unpause, returns to normal state\n', '     */\n', '    function unpause() onlyOwner whenPaused public {\n', '        paused = false;\n', '        emit Unpause();\n', '    }\n', '}\n', '\n', '/**\n', ' * @title Pausable token\n', ' * @dev StandardToken modified with pausable transfers.\n', ' **/\n', 'contract PausableToken is StandardToken, Pausable {\n', '\n', '    function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {\n', '        return super.transfer(_to, _value);\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {\n', '        return super.transferFrom(_from, _to, _value);\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {\n', '        return super.approve(_spender, _value);\n', '    }\n', '\n', '    function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {\n', '        return super.increaseApproval(_spender, _addedValue);\n', '    }\n', '\n', '    function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {\n', '        return super.decreaseApproval(_spender, _subtractedValue);\n', '    }\n', '}\n', '\n', '/**\n', ' * @title Freezable\n', ' * @dev Base contract which allows children to freeze the operations from a certain address in case of an emergency.\n', ' */\n', 'contract Freezable is Ownable {\n', '\n', '    mapping (address => bool) internal frozenAddresses;\n', '\n', '    modifier ifNotFrozen() {\n', '        require(frozenAddresses[msg.sender] == false);\n', '        _;\n', '    }\n', '\n', '    function freezeAddress(address addr) public onlyOwner {\n', '        frozenAddresses[addr] = true;\n', '    }\n', '\n', '    function unfreezeAddress(address addr) public onlyOwner {\n', '        frozenAddresses[addr] = false;\n', '    }\n', '}\n', '\n', '/**\n', ' * @title Freezable token\n', ' * @dev StandardToken modified with freezable transfers.\n', ' **/\n', 'contract FreezableToken is StandardToken, Freezable {\n', '\n', '    function transfer(address _to, uint256 _value) public ifNotFrozen returns (bool) {\n', '        return super.transfer(_to, _value);\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public ifNotFrozen returns (bool) {\n', '        return super.transferFrom(_from, _to, _value);\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public ifNotFrozen returns (bool) {\n', '        return super.approve(_spender, _value);\n', '    }\n', '\n', '    function increaseApproval(address _spender, uint _addedValue) public ifNotFrozen returns (bool success) {\n', '        return super.increaseApproval(_spender, _addedValue);\n', '    }\n', '\n', '    function decreaseApproval(address _spender, uint _subtractedValue) public ifNotFrozen returns (bool success) {\n', '        return super.decreaseApproval(_spender, _subtractedValue);\n', '    }\n', '}\n', '\n', '/**\n', ' * A a standard token with an anti-theft mechanism.\n', ' * Is able to restore stolen funds to a new address where the corresponding private key is safe.\n', ' *\n', ' */\n', 'contract AntiTheftToken is FreezableToken {\n', '\n', '    function restoreFunds(address from, address to, uint amount) public onlyOwner {\n', '        //can only restore stolen funds from a frozen address\n', '        require(frozenAddresses[from] == true);\n', '        require(to != address(0));\n', '        require(amount <= balances[from]);\n', '\n', '        balances[from] = safeSub(balances[from], amount);\n', '        balances[to] = safeAdd(balances[to], amount);\n', '        emit Transfer(from, to, amount);\n', '    }\n', '}\n', '\n', 'contract BurnableToken is StandardToken {\n', '\n', '    /** How many tokens we burned */\n', '    event Burned(address burner, uint burnedAmount);\n', '\n', '    /**\n', '     * Burn extra tokens from a balance.\n', '     *\n', '     */\n', '    function burn(uint burnAmount) public {\n', '        address burner = msg.sender;\n', '        balances[burner] = safeSub(balances[burner], burnAmount);\n', '        totalSupply = safeSub(totalSupply, burnAmount);\n', '        emit Burned(burner, burnAmount);\n', '    }\n', '}\n', '\n', 'contract ICOToken is BurnableToken, AntiTheftToken, PausableToken {\n', '\n', '    constructor(string memory _name, string memory _symbol, uint _decimals, uint _max_supply) public {\n', '        symbol = _symbol;\n', '        name = _name;\n', '        decimals = _decimals;\n', '        \n', '        totalSupply = _max_supply * (10 ** _decimals);\n', '        balances[msg.sender] = totalSupply;\n', '        emit Transfer(address(0x0), msg.sender, totalSupply);\n', '    }\n', '\n', '}']
['pragma solidity ^0.5.0;\n', '\n', '\n', '/*\n', ' * Ownable\n', ' *\n', ' * Base contract with an owner.\n', ' * Provides onlyOwner modifier, which prevents function from running if it is called by anyone other than the owner.\n', ' */\n', 'contract Ownable {\n', '    address public owner;\n', '\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner() {\n', '        if (msg.sender != owner) {\n', '            revert();\n', '        }\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        if (newOwner != address(0)) {\n', '            owner = newOwner;\n', '        }\n', '    }\n', '\n', '}\n', '\n', '\n', '/*\n', ' * ERC20 interface\n', ' * see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 {\n', '    uint public totalSupply;\n', '\n', '    function balanceOf(address who) public view returns (uint);\n', '    function allowance(address owner, address spender) public view returns (uint);\n', '\n', '    function transfer(address to, uint value) public returns (bool ok);\n', '    function transferFrom(address from, address to, uint value) public returns (bool ok);\n', '    function approve(address spender, uint value) public returns (bool ok);\n', '    event Transfer(address indexed from, address indexed to, uint value);\n', '    event Approval(address indexed owner, address indexed spender, uint value);\n', '}\n', '\n', '\n', '\n', '/**\n', ' * Math operations with safety checks\n', ' */\n', 'contract SafeMath {\n', '    function safeMul(uint a, uint b) internal pure returns (uint) {\n', '        uint c = a * b;\n', '        assertThat(a == 0 || c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function safeDiv(uint a, uint b) internal pure returns (uint) {\n', '        assertThat(b > 0);\n', '        uint c = a / b;\n', '        assertThat(a == b * c + a % b);\n', '        return c;\n', '    }\n', '\n', '    function safeSub(uint a, uint b) internal pure returns (uint) {\n', '        assertThat(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function safeAdd(uint a, uint b) internal pure returns (uint) {\n', '        uint c = a + b;\n', '        assertThat(c>=a && c>=b);\n', '        return c;\n', '    }\n', '\n', '    function max64(uint64 a, uint64 b) internal pure returns (uint64) {\n', '        return a >= b ? a : b;\n', '    }\n', '\n', '    function min64(uint64 a, uint64 b) internal pure returns (uint64) {\n', '        return a < b ? a : b;\n', '    }\n', '\n', '    function max256(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return a >= b ? a : b;\n', '    }\n', '\n', '    function min256(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return a < b ? a : b;\n', '    }\n', '\n', '    function assertThat(bool assertion) internal pure {\n', '        if (!assertion) {\n', '            revert();\n', '        }\n', '    }\n', '}\n', '\n', '\n', '/**\n', ' * Standard ERC20 token with Short Hand Attack and approve() race condition mitigation.\n', ' *\n', ' * Based on code by FirstBlood:\n', ' * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract StandardToken is ERC20, SafeMath {\n', '\n', '    string public name;\n', '    string public symbol;\n', '    uint public decimals;\n', '\n', '    /* Actual balances of token holders */\n', '    mapping(address => uint) balances;\n', '\n', '    /* approve() allowances */\n', '    mapping (address => mapping (address => uint)) allowed;\n', '\n', '    /**\n', '     *\n', '     * Fix for the ERC20 short address attack\n', '     *\n', '     * http://vessenes.com/the-erc20-short-address-attack-explained/\n', '     */\n', '    modifier onlyPayloadSize(uint size) {\n', '        if(msg.data.length < size + 4) {\n', '            revert();\n', '        }\n', '        _;\n', '    }\n', '\n', '    function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) public returns (bool success) {\n', '        balances[msg.sender] = safeSub(balances[msg.sender], _value);\n', '        balances[_to] = safeAdd(balances[_to], _value);\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint _value) public returns (bool success) {\n', '        uint _allowance = allowed[_from][msg.sender];\n', '\n', '        balances[_to] = safeAdd(balances[_to], _value);\n', '        balances[_from] = safeSub(balances[_from], _value);\n', '        allowed[_from][msg.sender] = safeSub(_allowance, _value);\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function balanceOf(address _owner) public view returns (uint balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function approve(address _spender, uint _value) public returns (bool success) {\n', '\n', '        // To change the approve amount you first have to reduce the addresses`\n', '        //  allowance to zero by calling `approve(_spender, 0)` if it is not\n', '        //  already 0 to mitigate the race condition described here:\n', '        //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '        if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) revert();\n', '\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) public view returns (uint remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    /**\n', '   * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '   *\n', '   * approve should be called when allowed[_spender] == 0. To increment\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _addedValue The amount of tokens to increase the allowance by.\n', '   */\n', '    function increaseApproval(address _spender, uint _addedValue) public returns (bool) {\n', '        allowed[msg.sender][_spender] = safeAdd(allowed[msg.sender][_spender],_addedValue);\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '     *\n', '     * approve should be called when allowed[_spender] == 0. To decrement\n', '     * allowed value is better to use this function to avoid 2 calls (and wait until\n', '     * the first transaction is mined)\n', '     * From MonolithDAO Token.sol\n', '     * @param _spender The address which will spend the funds.\n', '     * @param _subtractedValue The amount of tokens to decrease the allowance by.\n', '     */\n', '    function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {\n', '        uint oldValue = allowed[msg.sender][_spender];\n', '        if (_subtractedValue > oldValue) {\n', '            allowed[msg.sender][_spender] = 0;\n', '        } else {\n', '            allowed[msg.sender][_spender] = safeSub(oldValue, _subtractedValue);\n', '        }\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '}\n', '\n', '/**\n', ' * @title Pausable\n', ' * @dev Base contract which allows children to implement an emergency stop mechanism.\n', ' */\n', 'contract Pausable is Ownable {\n', '    event Pause();\n', '    event Unpause();\n', '\n', '    bool public paused = false;\n', '\n', '\n', '    /**\n', '     * @dev Modifier to make a function callable only when the contract is not paused.\n', '     */\n', '    modifier whenNotPaused() {\n', '        require(!paused);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Modifier to make a function callable only when the contract is paused.\n', '     */\n', '    modifier whenPaused() {\n', '        require(paused);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev called by the owner to pause, triggers stopped state\n', '     */\n', '    function pause() onlyOwner whenNotPaused public {\n', '        paused = true;\n', '        emit Pause();\n', '    }\n', '\n', '    /**\n', '     * @dev called by the owner to unpause, returns to normal state\n', '     */\n', '    function unpause() onlyOwner whenPaused public {\n', '        paused = false;\n', '        emit Unpause();\n', '    }\n', '}\n', '\n', '/**\n', ' * @title Pausable token\n', ' * @dev StandardToken modified with pausable transfers.\n', ' **/\n', 'contract PausableToken is StandardToken, Pausable {\n', '\n', '    function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {\n', '        return super.transfer(_to, _value);\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {\n', '        return super.transferFrom(_from, _to, _value);\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {\n', '        return super.approve(_spender, _value);\n', '    }\n', '\n', '    function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {\n', '        return super.increaseApproval(_spender, _addedValue);\n', '    }\n', '\n', '    function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {\n', '        return super.decreaseApproval(_spender, _subtractedValue);\n', '    }\n', '}\n', '\n', '/**\n', ' * @title Freezable\n', ' * @dev Base contract which allows children to freeze the operations from a certain address in case of an emergency.\n', ' */\n', 'contract Freezable is Ownable {\n', '\n', '    mapping (address => bool) internal frozenAddresses;\n', '\n', '    modifier ifNotFrozen() {\n', '        require(frozenAddresses[msg.sender] == false);\n', '        _;\n', '    }\n', '\n', '    function freezeAddress(address addr) public onlyOwner {\n', '        frozenAddresses[addr] = true;\n', '    }\n', '\n', '    function unfreezeAddress(address addr) public onlyOwner {\n', '        frozenAddresses[addr] = false;\n', '    }\n', '}\n', '\n', '/**\n', ' * @title Freezable token\n', ' * @dev StandardToken modified with freezable transfers.\n', ' **/\n', 'contract FreezableToken is StandardToken, Freezable {\n', '\n', '    function transfer(address _to, uint256 _value) public ifNotFrozen returns (bool) {\n', '        return super.transfer(_to, _value);\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public ifNotFrozen returns (bool) {\n', '        return super.transferFrom(_from, _to, _value);\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public ifNotFrozen returns (bool) {\n', '        return super.approve(_spender, _value);\n', '    }\n', '\n', '    function increaseApproval(address _spender, uint _addedValue) public ifNotFrozen returns (bool success) {\n', '        return super.increaseApproval(_spender, _addedValue);\n', '    }\n', '\n', '    function decreaseApproval(address _spender, uint _subtractedValue) public ifNotFrozen returns (bool success) {\n', '        return super.decreaseApproval(_spender, _subtractedValue);\n', '    }\n', '}\n', '\n', '/**\n', ' * A a standard token with an anti-theft mechanism.\n', ' * Is able to restore stolen funds to a new address where the corresponding private key is safe.\n', ' *\n', ' */\n', 'contract AntiTheftToken is FreezableToken {\n', '\n', '    function restoreFunds(address from, address to, uint amount) public onlyOwner {\n', '        //can only restore stolen funds from a frozen address\n', '        require(frozenAddresses[from] == true);\n', '        require(to != address(0));\n', '        require(amount <= balances[from]);\n', '\n', '        balances[from] = safeSub(balances[from], amount);\n', '        balances[to] = safeAdd(balances[to], amount);\n', '        emit Transfer(from, to, amount);\n', '    }\n', '}\n', '\n', 'contract BurnableToken is StandardToken {\n', '\n', '    /** How many tokens we burned */\n', '    event Burned(address burner, uint burnedAmount);\n', '\n', '    /**\n', '     * Burn extra tokens from a balance.\n', '     *\n', '     */\n', '    function burn(uint burnAmount) public {\n', '        address burner = msg.sender;\n', '        balances[burner] = safeSub(balances[burner], burnAmount);\n', '        totalSupply = safeSub(totalSupply, burnAmount);\n', '        emit Burned(burner, burnAmount);\n', '    }\n', '}\n', '\n', 'contract ICOToken is BurnableToken, AntiTheftToken, PausableToken {\n', '\n', '    constructor(string memory _name, string memory _symbol, uint _decimals, uint _max_supply) public {\n', '        symbol = _symbol;\n', '        name = _name;\n', '        decimals = _decimals;\n', '        \n', '        totalSupply = _max_supply * (10 ** _decimals);\n', '        balances[msg.sender] = totalSupply;\n', '        emit Transfer(address(0x0), msg.sender, totalSupply);\n', '    }\n', '\n', '}']
