['pragma solidity ^0.4.6;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract Owned {\n', '\n', '    // The address of the account that is the current owner\n', '    address public owner;\n', '\n', '    // The publiser is the inital owner\n', '    function Owned() {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    /**\n', '     * Restricted access to the current owner\n', '     */\n', '    modifier onlyOwner() {\n', '        if (msg.sender != owner) throw;\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * Transfer ownership to `_newOwner`\n', '     *\n', '     * @param _newOwner The address of the account that will become the new owner\n', '     */\n', '    function transferOwnership(address _newOwner) onlyOwner {\n', '        owner = _newOwner;\n', '    }\n', '}\n', '\n', '// Abstract contract for the full ERC 20 Token standard\n', '// https://github.com/ethereum/EIPs/issues/20\n', 'contract Token {\n', '    /* This is a slight change to the ERC20 base standard.\n', '    function totalSupply() constant returns (uint256 supply);\n', '    is replaced with:\n', '    uint256 public totalSupply;\n', '    This automatically creates a getter function for the totalSupply.\n', '    This is moved to the base contract since public getter functions are not\n', '    currently recognised as an implementation of the matching abstract\n', '    function by the compiler.\n', '    */\n', '    /// total amount of tokens\n', '    uint256 public totalSupply;\n', '\n', '    /// @param _owner The address from which the balance will be retrieved\n', '    /// @return The balance\n', '    function balanceOf(address _owner) constant returns (uint256 balance);\n', '\n', '    /// @notice send `_value` token to `_to` from `msg.sender`\n', '    /// @param _to The address of the recipient\n', '    /// @param _value The amount of token to be transferred\n', '    /// @return Whether the transfer was successful or not\n', '    function transfer(address _to, uint256 _value) returns (bool success);\n', '\n', '    /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`\n', '    /// @param _from The address of the sender\n', '    /// @param _to The address of the recipient\n', '    /// @param _value The amount of token to be transferred\n', '    /// @return Whether the transfer was successful or not\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success);\n', '\n', '    /// @notice `msg.sender` approves `_spender` to spend `_value` tokens\n', '    /// @param _spender The address of the account able to transfer the tokens\n', '    /// @param _value The amount of tokens to be approved for transfer\n', '    /// @return Whether the approval was successful or not\n', '    function approve(address _spender, uint256 _value) returns (bool success);\n', '\n', '    /// @param _owner The address of the account owning tokens\n', '    /// @param _spender The address of the account able to transfer the tokens\n', '    /// @return Amount of remaining tokens allowed to spent\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining);\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', '/**\n', ' * @title RICH token\n', ' *\n', ' * Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/issues/20 with the addition\n', ' * of ownership, a lock and issuing.\n', ' *\n', ' * #created 05/03/2017\n', ' * #author Frank Bonnet\n', ' */\n', 'contract RICHToken is Owned, Token {\n', '\n', '    using SafeMath for uint256;\n', '\n', '    // Ethereum token standaard\n', '    string public standard = "Token 0.1";\n', '\n', '    // Full name\n', '    string public name = "RICH";\n', '\n', '    // Symbol\n', '    string public symbol = "RICH";\n', '\n', '    // No decimal points\n', '    uint8 public decimals = 8;\n', '\n', '    // Token starts if the locked state restricting transfers\n', '    bool public locked;\n', '\n', '    uint256 public crowdsaleStart; // Reference to time of first crowd sale\n', '    uint256 public icoPeriod = 10 days;\n', '    uint256 public noIcoPeriod = 10 days;\n', '    mapping (address => mapping (uint256 => uint256)) balancesPerIcoPeriod;\n', '\n', '    uint256 public burnPercentageDefault = 1; // 0.01%\n', '    uint256 public burnPercentage10m = 5; // 0.05%\n', '    uint256 public burnPercentage100m = 50; // 0.5%\n', '    uint256 public burnPercentage1000m = 100; // 1%\n', '\n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '\n', '    /**\n', '     * Get burning line. All investors that own less than burning line\n', '     * will lose some tokens if they don&#39;t invest each round 20% more tokens\n', '     *\n', '     * @return burnLine\n', '     */\n', '    function getBurnLine() returns (uint256 burnLine) {\n', '        if (totalSupply < 10**7 * 10**8) {\n', '            return totalSupply * burnPercentageDefault / 10000;\n', '        }\n', '\n', '        if (totalSupply < 10**8 * 10**8) {\n', '            return totalSupply * burnPercentage10m / 10000;\n', '        }\n', '\n', '        if (totalSupply < 10**9 * 10**8) {\n', '            return totalSupply * burnPercentage100m / 10000;\n', '        }\n', '\n', '        return totalSupply * burnPercentage1000m / 10000;\n', '    }\n', '\n', '    /**\n', '     * Return ICO number (PreIco has index 0)\n', '     *\n', '     * @return ICO number\n', '     */\n', '    function getCurrentIcoNumber() returns (uint256 icoNumber) {\n', '        uint256 timeBehind = now - crowdsaleStart;\n', '\n', '        if (now < crowdsaleStart) {\n', '            return 0;\n', '        }\n', '\n', '        return 1 + ((timeBehind - (timeBehind % (icoPeriod + noIcoPeriod))) / (icoPeriod + noIcoPeriod));\n', '    }\n', '\n', '    /**\n', '     * Get balance of `_owner`\n', '     *\n', '     * @param _owner The address from which the balance will be retrieved\n', '     * @return The balance\n', '     */\n', '    function balanceOf(address _owner) constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    /**\n', '     * Start of the crowd sale can be set only once\n', '     *\n', '     * @param _start start of the crowd sale\n', '     */\n', '    function setCrowdSaleStart(uint256 _start) onlyOwner {\n', '        if (crowdsaleStart > 0) {\n', '            return;\n', '        }\n', '\n', '        crowdsaleStart = _start;\n', '    }\n', '\n', '    /**\n', '     * Send `_value` token to `_to` from `msg.sender`\n', '     *\n', '     * @param _to The address of the recipient\n', '     * @param _value The amount of token to be transferred\n', '     * @return Whether the transfer was successful or not\n', '     */\n', '    function transfer(address _to, uint256 _value) returns (bool success) {\n', '\n', '        // Unable to transfer while still locked\n', '        if (locked) {\n', '            throw;\n', '        }\n', '\n', '        // Check if the sender has enough tokens\n', '        if (balances[msg.sender] < _value) {\n', '            throw;\n', '        }\n', '\n', '        // Check for overflows\n', '        if (balances[_to] + _value < balances[_to])  {\n', '            throw;\n', '        }\n', '\n', '        // Transfer tokens\n', '        balances[msg.sender] -= _value;\n', '        balances[_to] += _value;\n', '\n', '        // Notify listners\n', '        Transfer(msg.sender, _to, _value);\n', '\n', '        balancesPerIcoPeriod[_to][getCurrentIcoNumber()] = balances[_to];\n', '        balancesPerIcoPeriod[msg.sender][getCurrentIcoNumber()] = balances[msg.sender];\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Send `_value` token to `_to` from `_from` on the condition it is approved by `_from`\n', '     *\n', '     * @param _from The address of the sender\n', '     * @param _to The address of the recipient\n', '     * @param _value The amount of token to be transferred\n', '     * @return Whether the transfer was successful or not\n', '     */\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {\n', '\n', '         // Unable to transfer while still locked\n', '        if (locked) {\n', '            throw;\n', '        }\n', '\n', '        // Check if the sender has enough\n', '        if (balances[_from] < _value) {\n', '            throw;\n', '        }\n', '\n', '        // Check for overflows\n', '        if (balances[_to] + _value < balances[_to]) {\n', '            throw;\n', '        }\n', '\n', '        // Check allowance\n', '        if (_value > allowed[_from][msg.sender]) {\n', '            throw;\n', '        }\n', '\n', '        // Transfer tokens\n', '        balances[_to] += _value;\n', '        balances[_from] -= _value;\n', '\n', '        // Update allowance\n', '        allowed[_from][msg.sender] -= _value;\n', '\n', '        // Notify listners\n', '        Transfer(_from, _to, _value);\n', '\n', '        balancesPerIcoPeriod[_to][getCurrentIcoNumber()] = balances[_to];\n', '        balancesPerIcoPeriod[_from][getCurrentIcoNumber()] = balances[_from];\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * `msg.sender` approves `_spender` to spend `_value` tokens\n', '     *\n', '     * @param _spender The address of the account able to transfer the tokens\n', '     * @param _value The amount of tokens to be approved for transfer\n', '     * @return Whether the approval was successful or not\n', '     */\n', '    function approve(address _spender, uint256 _value) returns (bool success) {\n', '\n', '        // Unable to approve while still locked\n', '        if (locked) {\n', '            throw;\n', '        }\n', '\n', '        // Update allowance\n', '        allowed[msg.sender][_spender] = _value;\n', '\n', '        // Notify listners\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '\n', '    /**\n', '     * Get the amount of remaining tokens that `_spender` is allowed to spend from `_owner`\n', '     *\n', '     * @param _owner The address of the account owning tokens\n', '     * @param _spender The address of the account able to transfer the tokens\n', '     * @return Amount of remaining tokens allowed to spent\n', '     */\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '      return allowed[_owner][_spender];\n', '    }\n', '\n', '    /**\n', '     * Starts with a total supply of zero and the creator starts with\n', '     * zero tokens (just like everyone else)\n', '     */\n', '    function RICHToken() {\n', '        balances[msg.sender] = 0;\n', '        totalSupply = 0;\n', '        locked = false;\n', '    }\n', '\n', '\n', '    /**\n', '     * Unlocks the token irreversibly so that the transfering of value is enabled\n', '     *\n', '     * @return Whether the unlocking was successful or not\n', '     */\n', '    function unlock() onlyOwner returns (bool success)  {\n', '        locked = false;\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Restricted access to the current owner\n', '     */\n', '    modifier onlyOwner() {\n', '        if (msg.sender != owner) throw;\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * Issues `_value` new tokens to `_recipient`\n', '     *\n', '     * @param _recipient The address to which the tokens will be issued\n', '     * @param _value The amount of new tokens to issue\n', '     * @return Whether the approval was successful or not\n', '     */\n', '    function issue(address _recipient, uint256 _value) onlyOwner returns (bool success) {\n', '\n', '        // Create tokens\n', '        balances[_recipient] += _value;\n', '        totalSupply += _value;\n', '\n', '        balancesPerIcoPeriod[_recipient][getCurrentIcoNumber()] = balances[_recipient];\n', '\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Check if investor has invested enough to avoid burning\n', '     *\n', '     * @param _investor Investor\n', '     * @return Whether investor has invested enough or not\n', '     */\n', '    function isIncreasedEnough(address _investor) returns (bool success) {\n', '        uint256 currentIcoNumber = getCurrentIcoNumber();\n', '\n', '        if (currentIcoNumber - 2 < 0) {\n', '            return true;\n', '        }\n', '\n', '        uint256 currentBalance = balances[_investor];\n', '        uint256 icosBefore = balancesPerIcoPeriod[_investor][currentIcoNumber - 2];\n', '\n', '        if (icosBefore == 0) {\n', '            for(uint i = currentIcoNumber; i >= 2; i--) {\n', '                icosBefore = balancesPerIcoPeriod[_investor][i-2];\n', '\n', '                if (icosBefore != 0) {\n', '                    break;\n', '                }\n', '            }\n', '        }\n', '\n', '        if (currentBalance < icosBefore) {\n', '            return false;\n', '        }\n', '\n', '        if (currentBalance - icosBefore > icosBefore * 12 / 10) {\n', '            return true;\n', '        }\n', '\n', '        return false;\n', '    }\n', '\n', '    /**\n', '     * Function that everyone can call and burn for other tokens if they can\n', '     * be burned. In return, 10% of burned tokens go to executor of function\n', '     *\n', '     * @param _investor Address of investor which tokens are subject of burn\n', '     */\n', '    function burn(address _investor) public {\n', '\n', '        uint256 burnLine = getBurnLine();\n', '\n', '        if (balances[_investor] > burnLine || isIncreasedEnough(_investor)) {\n', '            return;\n', '        }\n', '\n', '        uint256 toBeBurned = burnLine - balances[_investor];\n', '        if (toBeBurned > balances[_investor]) {\n', '            toBeBurned = balances[_investor];\n', '        }\n', '\n', '        // 10% for executor\n', '        uint256 executorReward = toBeBurned / 10;\n', '\n', '        balances[msg.sender] = balances[msg.sender].add(executorReward);\n', '        balances[_investor] = balances[_investor].sub(toBeBurned);\n', '        totalSupply = totalSupply.sub(toBeBurned - executorReward);\n', '        Burn(_investor, toBeBurned);\n', '    }\n', '\n', '    event Burn(address indexed burner, uint indexed value);\n', '\n', '    /**\n', '     * Prevents accidental sending of ether\n', '     */\n', '    function () {\n', '        throw;\n', '    }\n', '}']
['pragma solidity ^0.4.6;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract Owned {\n', '\n', '    // The address of the account that is the current owner\n', '    address public owner;\n', '\n', '    // The publiser is the inital owner\n', '    function Owned() {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    /**\n', '     * Restricted access to the current owner\n', '     */\n', '    modifier onlyOwner() {\n', '        if (msg.sender != owner) throw;\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * Transfer ownership to `_newOwner`\n', '     *\n', '     * @param _newOwner The address of the account that will become the new owner\n', '     */\n', '    function transferOwnership(address _newOwner) onlyOwner {\n', '        owner = _newOwner;\n', '    }\n', '}\n', '\n', '// Abstract contract for the full ERC 20 Token standard\n', '// https://github.com/ethereum/EIPs/issues/20\n', 'contract Token {\n', '    /* This is a slight change to the ERC20 base standard.\n', '    function totalSupply() constant returns (uint256 supply);\n', '    is replaced with:\n', '    uint256 public totalSupply;\n', '    This automatically creates a getter function for the totalSupply.\n', '    This is moved to the base contract since public getter functions are not\n', '    currently recognised as an implementation of the matching abstract\n', '    function by the compiler.\n', '    */\n', '    /// total amount of tokens\n', '    uint256 public totalSupply;\n', '\n', '    /// @param _owner The address from which the balance will be retrieved\n', '    /// @return The balance\n', '    function balanceOf(address _owner) constant returns (uint256 balance);\n', '\n', '    /// @notice send `_value` token to `_to` from `msg.sender`\n', '    /// @param _to The address of the recipient\n', '    /// @param _value The amount of token to be transferred\n', '    /// @return Whether the transfer was successful or not\n', '    function transfer(address _to, uint256 _value) returns (bool success);\n', '\n', '    /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`\n', '    /// @param _from The address of the sender\n', '    /// @param _to The address of the recipient\n', '    /// @param _value The amount of token to be transferred\n', '    /// @return Whether the transfer was successful or not\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success);\n', '\n', '    /// @notice `msg.sender` approves `_spender` to spend `_value` tokens\n', '    /// @param _spender The address of the account able to transfer the tokens\n', '    /// @param _value The amount of tokens to be approved for transfer\n', '    /// @return Whether the approval was successful or not\n', '    function approve(address _spender, uint256 _value) returns (bool success);\n', '\n', '    /// @param _owner The address of the account owning tokens\n', '    /// @param _spender The address of the account able to transfer the tokens\n', '    /// @return Amount of remaining tokens allowed to spent\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining);\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', '/**\n', ' * @title RICH token\n', ' *\n', ' * Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/issues/20 with the addition\n', ' * of ownership, a lock and issuing.\n', ' *\n', ' * #created 05/03/2017\n', ' * #author Frank Bonnet\n', ' */\n', 'contract RICHToken is Owned, Token {\n', '\n', '    using SafeMath for uint256;\n', '\n', '    // Ethereum token standaard\n', '    string public standard = "Token 0.1";\n', '\n', '    // Full name\n', '    string public name = "RICH";\n', '\n', '    // Symbol\n', '    string public symbol = "RICH";\n', '\n', '    // No decimal points\n', '    uint8 public decimals = 8;\n', '\n', '    // Token starts if the locked state restricting transfers\n', '    bool public locked;\n', '\n', '    uint256 public crowdsaleStart; // Reference to time of first crowd sale\n', '    uint256 public icoPeriod = 10 days;\n', '    uint256 public noIcoPeriod = 10 days;\n', '    mapping (address => mapping (uint256 => uint256)) balancesPerIcoPeriod;\n', '\n', '    uint256 public burnPercentageDefault = 1; // 0.01%\n', '    uint256 public burnPercentage10m = 5; // 0.05%\n', '    uint256 public burnPercentage100m = 50; // 0.5%\n', '    uint256 public burnPercentage1000m = 100; // 1%\n', '\n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '\n', '    /**\n', '     * Get burning line. All investors that own less than burning line\n', "     * will lose some tokens if they don't invest each round 20% more tokens\n", '     *\n', '     * @return burnLine\n', '     */\n', '    function getBurnLine() returns (uint256 burnLine) {\n', '        if (totalSupply < 10**7 * 10**8) {\n', '            return totalSupply * burnPercentageDefault / 10000;\n', '        }\n', '\n', '        if (totalSupply < 10**8 * 10**8) {\n', '            return totalSupply * burnPercentage10m / 10000;\n', '        }\n', '\n', '        if (totalSupply < 10**9 * 10**8) {\n', '            return totalSupply * burnPercentage100m / 10000;\n', '        }\n', '\n', '        return totalSupply * burnPercentage1000m / 10000;\n', '    }\n', '\n', '    /**\n', '     * Return ICO number (PreIco has index 0)\n', '     *\n', '     * @return ICO number\n', '     */\n', '    function getCurrentIcoNumber() returns (uint256 icoNumber) {\n', '        uint256 timeBehind = now - crowdsaleStart;\n', '\n', '        if (now < crowdsaleStart) {\n', '            return 0;\n', '        }\n', '\n', '        return 1 + ((timeBehind - (timeBehind % (icoPeriod + noIcoPeriod))) / (icoPeriod + noIcoPeriod));\n', '    }\n', '\n', '    /**\n', '     * Get balance of `_owner`\n', '     *\n', '     * @param _owner The address from which the balance will be retrieved\n', '     * @return The balance\n', '     */\n', '    function balanceOf(address _owner) constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    /**\n', '     * Start of the crowd sale can be set only once\n', '     *\n', '     * @param _start start of the crowd sale\n', '     */\n', '    function setCrowdSaleStart(uint256 _start) onlyOwner {\n', '        if (crowdsaleStart > 0) {\n', '            return;\n', '        }\n', '\n', '        crowdsaleStart = _start;\n', '    }\n', '\n', '    /**\n', '     * Send `_value` token to `_to` from `msg.sender`\n', '     *\n', '     * @param _to The address of the recipient\n', '     * @param _value The amount of token to be transferred\n', '     * @return Whether the transfer was successful or not\n', '     */\n', '    function transfer(address _to, uint256 _value) returns (bool success) {\n', '\n', '        // Unable to transfer while still locked\n', '        if (locked) {\n', '            throw;\n', '        }\n', '\n', '        // Check if the sender has enough tokens\n', '        if (balances[msg.sender] < _value) {\n', '            throw;\n', '        }\n', '\n', '        // Check for overflows\n', '        if (balances[_to] + _value < balances[_to])  {\n', '            throw;\n', '        }\n', '\n', '        // Transfer tokens\n', '        balances[msg.sender] -= _value;\n', '        balances[_to] += _value;\n', '\n', '        // Notify listners\n', '        Transfer(msg.sender, _to, _value);\n', '\n', '        balancesPerIcoPeriod[_to][getCurrentIcoNumber()] = balances[_to];\n', '        balancesPerIcoPeriod[msg.sender][getCurrentIcoNumber()] = balances[msg.sender];\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Send `_value` token to `_to` from `_from` on the condition it is approved by `_from`\n', '     *\n', '     * @param _from The address of the sender\n', '     * @param _to The address of the recipient\n', '     * @param _value The amount of token to be transferred\n', '     * @return Whether the transfer was successful or not\n', '     */\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {\n', '\n', '         // Unable to transfer while still locked\n', '        if (locked) {\n', '            throw;\n', '        }\n', '\n', '        // Check if the sender has enough\n', '        if (balances[_from] < _value) {\n', '            throw;\n', '        }\n', '\n', '        // Check for overflows\n', '        if (balances[_to] + _value < balances[_to]) {\n', '            throw;\n', '        }\n', '\n', '        // Check allowance\n', '        if (_value > allowed[_from][msg.sender]) {\n', '            throw;\n', '        }\n', '\n', '        // Transfer tokens\n', '        balances[_to] += _value;\n', '        balances[_from] -= _value;\n', '\n', '        // Update allowance\n', '        allowed[_from][msg.sender] -= _value;\n', '\n', '        // Notify listners\n', '        Transfer(_from, _to, _value);\n', '\n', '        balancesPerIcoPeriod[_to][getCurrentIcoNumber()] = balances[_to];\n', '        balancesPerIcoPeriod[_from][getCurrentIcoNumber()] = balances[_from];\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * `msg.sender` approves `_spender` to spend `_value` tokens\n', '     *\n', '     * @param _spender The address of the account able to transfer the tokens\n', '     * @param _value The amount of tokens to be approved for transfer\n', '     * @return Whether the approval was successful or not\n', '     */\n', '    function approve(address _spender, uint256 _value) returns (bool success) {\n', '\n', '        // Unable to approve while still locked\n', '        if (locked) {\n', '            throw;\n', '        }\n', '\n', '        // Update allowance\n', '        allowed[msg.sender][_spender] = _value;\n', '\n', '        // Notify listners\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '\n', '    /**\n', '     * Get the amount of remaining tokens that `_spender` is allowed to spend from `_owner`\n', '     *\n', '     * @param _owner The address of the account owning tokens\n', '     * @param _spender The address of the account able to transfer the tokens\n', '     * @return Amount of remaining tokens allowed to spent\n', '     */\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '      return allowed[_owner][_spender];\n', '    }\n', '\n', '    /**\n', '     * Starts with a total supply of zero and the creator starts with\n', '     * zero tokens (just like everyone else)\n', '     */\n', '    function RICHToken() {\n', '        balances[msg.sender] = 0;\n', '        totalSupply = 0;\n', '        locked = false;\n', '    }\n', '\n', '\n', '    /**\n', '     * Unlocks the token irreversibly so that the transfering of value is enabled\n', '     *\n', '     * @return Whether the unlocking was successful or not\n', '     */\n', '    function unlock() onlyOwner returns (bool success)  {\n', '        locked = false;\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Restricted access to the current owner\n', '     */\n', '    modifier onlyOwner() {\n', '        if (msg.sender != owner) throw;\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * Issues `_value` new tokens to `_recipient`\n', '     *\n', '     * @param _recipient The address to which the tokens will be issued\n', '     * @param _value The amount of new tokens to issue\n', '     * @return Whether the approval was successful or not\n', '     */\n', '    function issue(address _recipient, uint256 _value) onlyOwner returns (bool success) {\n', '\n', '        // Create tokens\n', '        balances[_recipient] += _value;\n', '        totalSupply += _value;\n', '\n', '        balancesPerIcoPeriod[_recipient][getCurrentIcoNumber()] = balances[_recipient];\n', '\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Check if investor has invested enough to avoid burning\n', '     *\n', '     * @param _investor Investor\n', '     * @return Whether investor has invested enough or not\n', '     */\n', '    function isIncreasedEnough(address _investor) returns (bool success) {\n', '        uint256 currentIcoNumber = getCurrentIcoNumber();\n', '\n', '        if (currentIcoNumber - 2 < 0) {\n', '            return true;\n', '        }\n', '\n', '        uint256 currentBalance = balances[_investor];\n', '        uint256 icosBefore = balancesPerIcoPeriod[_investor][currentIcoNumber - 2];\n', '\n', '        if (icosBefore == 0) {\n', '            for(uint i = currentIcoNumber; i >= 2; i--) {\n', '                icosBefore = balancesPerIcoPeriod[_investor][i-2];\n', '\n', '                if (icosBefore != 0) {\n', '                    break;\n', '                }\n', '            }\n', '        }\n', '\n', '        if (currentBalance < icosBefore) {\n', '            return false;\n', '        }\n', '\n', '        if (currentBalance - icosBefore > icosBefore * 12 / 10) {\n', '            return true;\n', '        }\n', '\n', '        return false;\n', '    }\n', '\n', '    /**\n', '     * Function that everyone can call and burn for other tokens if they can\n', '     * be burned. In return, 10% of burned tokens go to executor of function\n', '     *\n', '     * @param _investor Address of investor which tokens are subject of burn\n', '     */\n', '    function burn(address _investor) public {\n', '\n', '        uint256 burnLine = getBurnLine();\n', '\n', '        if (balances[_investor] > burnLine || isIncreasedEnough(_investor)) {\n', '            return;\n', '        }\n', '\n', '        uint256 toBeBurned = burnLine - balances[_investor];\n', '        if (toBeBurned > balances[_investor]) {\n', '            toBeBurned = balances[_investor];\n', '        }\n', '\n', '        // 10% for executor\n', '        uint256 executorReward = toBeBurned / 10;\n', '\n', '        balances[msg.sender] = balances[msg.sender].add(executorReward);\n', '        balances[_investor] = balances[_investor].sub(toBeBurned);\n', '        totalSupply = totalSupply.sub(toBeBurned - executorReward);\n', '        Burn(_investor, toBeBurned);\n', '    }\n', '\n', '    event Burn(address indexed burner, uint indexed value);\n', '\n', '    /**\n', '     * Prevents accidental sending of ether\n', '     */\n', '    function () {\n', '        throw;\n', '    }\n', '}']