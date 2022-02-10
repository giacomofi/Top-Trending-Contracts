['pragma solidity ^0.4.24;\n', '\n', '/// @title SafeMath library\n', '/// @dev Math operations with safety checks that throw on error\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a * b;\n', '        assert(a == 0 || c / a == b);\n', '        return c;\n', '    }\n', ' \n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', '        // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '        return c;\n', '    }\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', '\n', '/// @title Centralized administrator\n', '/// @dev Centralized administrator parent contract\n', 'contract owned {\n', '    address public owner;\n', '\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) onlyOwner public {\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', '\n', '/// @title Abstract contract for the full ERC 20 Token standard\n', '/// @dev ERC 20 Token standard, ref to: https://github.com/ethereum/EIPs/issues/20\n', 'contract ERC20Token{\n', '    // Get the total token supply\n', '    function totalSupply() public view returns (uint256 supply);\n', '\n', '    // Get the account balance of another account with address _owner\n', '    function balanceOf(address _owner) public view returns (uint256 balance);\n', '\n', '    // Send _value amount of tokens to address _to\n', '    function transfer(address _to, uint256 _value) public returns (bool success);\n', '\n', '    // Send _value amount of tokens from address _from to address _to\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);\n', '\n', '    // Allow _spender to withdraw from your account, multiple times, up to the _value amount. \n', '    // If this function is called again it overwrites the current allowance with _value.\n', '    function approve(address _spender, uint256 _value) public returns (bool success);\n', '\n', '    // Returns the amount which _spender is still allowed to withdraw from _owner\n', '    function allowance(address _owner, address _spender) public view returns (uint256 remaining);\n', '\n', '    // Triggered when tokens are transferred.\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '\n', '    // Triggered whenever approve(address _spender, uint256 _value) is called.\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', '/// @title Token main contract\n', '/// @dev Token main contract\n', 'contract GTLToken is ERC20Token, owned {\n', '    using SafeMath for uint256;\n', '\n', '    // Public variables of the token\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public constant decimals = 18;\n', '    uint256 _totalSupply;\n', '\n', '    // Balances for each account\n', '    mapping (address => uint256) public balances;\n', '    // Owner of account approves the transfer of an amount to another account\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '\n', '    // Struct of Freeze Information\n', '    struct FreezeAccountInfo {\n', '        uint256 freezeStartTime;\n', '        uint256 freezePeriod;\n', '        uint256 freezeTotal;\n', '    }\n', '\n', '\n', '\n', '    // Freeze Information of accounts\n', '    mapping (address => FreezeAccountInfo) public freezeAccount;\n', '\n', '    // Triggered when tokens are issue and freeze\n', '    event IssueAndFreeze(address indexed to, uint256 _value, uint256 _freezePeriod);\n', '\n', '    /**\n', '     * Constrctor function\n', '     *\n', '     * Initializes contract with initial supply tokens to the creator of the contract\n', '     */\n', '    constructor(string _tokenName, string _tokenSymbol, uint256 _initialSupply) public {\n', '        _totalSupply = _initialSupply * 10 ** uint256(decimals);  // Total supply with the decimal amount\n', '        balances[msg.sender] = _totalSupply;                // Give the creator all initial tokens\n', '        name = _tokenName;                                   // Set the name for display purposes\n', '        symbol = _tokenSymbol;                               // Set the symbol for display purposes\n', '    }\n', '\n', '    /// @notice Get the total token supply\n', '    /// @dev Get the total token supply\n', '    /// @return Total token supply\n', '    function totalSupply() public view returns (uint256 supply) {\n', '        return _totalSupply;\n', '    }\n', '\n', '    /// @notice Get balance of account\n', '    /// @dev Get balance of &#39;_owner&#39;\n', '    /// @param _owner Target address\n', '    /// @return balance of &#39;_owner&#39;\n', '    function balanceOf(address _owner) public view returns (uint256 balance){\n', '        return balances[_owner];\n', '    }\n', '\n', '    /// @notice Issue tokens to account and these tokens will be frozen for a period of time\n', '    /// @dev Issue &#39;_value&#39; tokens to the address &#39;_to&#39; and these tokens will be frozen for a period of &#39;_freezePeriod&#39; minutes\n', '    /// @param _to Receiving address\n', '    /// @param _value The amount of frozen token to be issued\n', '    /// @param _freezePeriod Freeze Period(minutes)\n', '    function issueAndFreeze(address _to, uint _value, uint _freezePeriod) onlyOwner public {\n', '        _transfer(msg.sender, _to, _value);\n', '\n', '        freezeAccount[_to] = FreezeAccountInfo({\n', '            freezeStartTime : now,\n', '            freezePeriod : _freezePeriod,\n', '            freezeTotal : _value\n', '        });\n', '\n', '        emit IssueAndFreeze(_to, _value, _freezePeriod);\n', '    }\n', '\n', '    /// @notice Get account&#39;s freeze information\n', '    /// @dev Get freeze information of &#39;_target&#39;\n', '    /// @param _target Target address\n', '    /// @return _freezeStartTime Freeze start time; _freezePeriod Freeze period(minutes); _freezeAmount Freeze token amount; _freezeDeadline Freeze deadline\n', '    function getFreezeInfo(address _target) public view returns(\n', '        uint _freezeStartTime, \n', '        uint _freezePeriod, \n', '        uint _freezeTotal, \n', '        uint _freezeDeadline) {\n', '            \n', '        FreezeAccountInfo storage targetFreezeInfo = freezeAccount[_target];\n', '        uint freezeDeadline = targetFreezeInfo.freezeStartTime.add(targetFreezeInfo.freezePeriod.mul(1 minutes));\n', '        return (\n', '            targetFreezeInfo.freezeStartTime, \n', '            targetFreezeInfo.freezePeriod,\n', '            targetFreezeInfo.freezeTotal,\n', '            freezeDeadline\n', '        );\n', '    }\n', '\n', '    /// @dev Internal transfer, only can be called by this contract\n', '    /// @param _from The address of the sender\n', '    /// @param _to The address of the recipient\n', '    /// @param _value The amount to send\n', '    function _transfer(address _from, address _to, uint _value) internal {\n', '        // Prevent transfer to 0x0 address\n', '        require(_to != 0x0);\n', '        // Check if the sender has enough\n', '        require(balances[_from] >= _value);\n', '        // Check for overflows\n', '        require(balances[_to].add(_value) > balances[_to]);\n', '\n', '        uint256 freezeStartTime;\n', '        uint256 freezePeriod;\n', '        uint256 freezeTotal;\n', '        uint256 freezeDeadline;\n', '\n', '        // Get freeze information of sender\n', '        (freezeStartTime,freezePeriod,freezeTotal,freezeDeadline) = getFreezeInfo(_from);\n', '\n', '        // The free amount of _from\n', '        uint256 freeTotalFrom = balances[_from].sub(freezeTotal);\n', '\n', '        //Check if it is a freeze account\n', '        //Check if in Lock-up Period\n', '        //Check if the transfer amount > free amount\n', '        require(freezeStartTime == 0 || freezeDeadline < now || freeTotalFrom >= _value); \n', '\n', '        // Save this for an assertion in the future\n', '        uint previousBalances = balances[_from].add(balances[_to]);\n', '        // Subtract from the sender\n', '        balances[_from] = balances[_from].sub(_value);\n', '        // Add the same to the recipient\n', '        balances[_to] = balances[_to].add(_value);\n', '\n', '        // Notify client the transfer\n', '        emit Transfer(_from, _to, _value);\n', '        // Asserting that the total balances before and after the transaction should be the same\n', '        assert(balances[_from].add(balances[_to]) == previousBalances);\n', '    }\n', '\n', '    /// @notice Transfer tokens to account\n', '    /// @dev Send &#39;_value&#39; amount of tokens to address &#39;_to&#39;\n', '    /// @param _to The address of the recipient\n', '    /// @param _value The token amount to send\n', '    /// @return Whether succeed\n', '    function transfer(address _to, uint256 _value) public returns (bool success) {\n', '        _transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /// @notice Transfer tokens from other address\n', '    /// @dev Send &#39;_value&#39; amount of tokens from address &#39;_from&#39; to address &#39;_to&#39;\n', '    /// @param _from The address of the sender\n', '    /// @param _to The address of the recipient\n', '    /// @param _value The token amount to send\n', '    /// @return Whether succeed\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        require(_value <= allowance[_from][msg.sender]);     // Check allowance\n', '        allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);\n', '        _transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /// @notice Set allowance for other address\n', '    /// @dev Allows &#39;_spender&#39; to spend no more than &#39;_value&#39; tokens in your behalf. If this function is called again it overwrites the current allowance with _value\n', '    /// @param _spender The address authorized to spend\n', '    /// @param _value The max amount they can spend\n', '    /// @return Whether succeed.\n', '    function approve(address _spender, uint256 _value) public returns (bool success) {\n', '        allowance[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    /// @notice Get the amount which &#39;_spender&#39; is still allowed to withdraw from &#39;_owner&#39;\n', '    /// @dev Get the amount which &#39;_spender&#39; is still allowed to withdraw from &#39;_owner&#39;\n', '    /// @param _owner Target address\n', '    /// @param _spender The address authorized to spend\n', '    /// @return The max amount can spend\n', '    function allowance(address _owner, address _spender) public view returns (uint256 remaining){\n', '        return allowance[_owner][_spender];\n', '    }\n', '}']
['pragma solidity ^0.4.24;\n', '\n', '/// @title SafeMath library\n', '/// @dev Math operations with safety checks that throw on error\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a * b;\n', '        assert(a == 0 || c / a == b);\n', '        return c;\n', '    }\n', ' \n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '        return c;\n', '    }\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', '\n', '/// @title Centralized administrator\n', '/// @dev Centralized administrator parent contract\n', 'contract owned {\n', '    address public owner;\n', '\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) onlyOwner public {\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', '\n', '/// @title Abstract contract for the full ERC 20 Token standard\n', '/// @dev ERC 20 Token standard, ref to: https://github.com/ethereum/EIPs/issues/20\n', 'contract ERC20Token{\n', '    // Get the total token supply\n', '    function totalSupply() public view returns (uint256 supply);\n', '\n', '    // Get the account balance of another account with address _owner\n', '    function balanceOf(address _owner) public view returns (uint256 balance);\n', '\n', '    // Send _value amount of tokens to address _to\n', '    function transfer(address _to, uint256 _value) public returns (bool success);\n', '\n', '    // Send _value amount of tokens from address _from to address _to\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);\n', '\n', '    // Allow _spender to withdraw from your account, multiple times, up to the _value amount. \n', '    // If this function is called again it overwrites the current allowance with _value.\n', '    function approve(address _spender, uint256 _value) public returns (bool success);\n', '\n', '    // Returns the amount which _spender is still allowed to withdraw from _owner\n', '    function allowance(address _owner, address _spender) public view returns (uint256 remaining);\n', '\n', '    // Triggered when tokens are transferred.\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '\n', '    // Triggered whenever approve(address _spender, uint256 _value) is called.\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', '/// @title Token main contract\n', '/// @dev Token main contract\n', 'contract GTLToken is ERC20Token, owned {\n', '    using SafeMath for uint256;\n', '\n', '    // Public variables of the token\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public constant decimals = 18;\n', '    uint256 _totalSupply;\n', '\n', '    // Balances for each account\n', '    mapping (address => uint256) public balances;\n', '    // Owner of account approves the transfer of an amount to another account\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '\n', '    // Struct of Freeze Information\n', '    struct FreezeAccountInfo {\n', '        uint256 freezeStartTime;\n', '        uint256 freezePeriod;\n', '        uint256 freezeTotal;\n', '    }\n', '\n', '\n', '\n', '    // Freeze Information of accounts\n', '    mapping (address => FreezeAccountInfo) public freezeAccount;\n', '\n', '    // Triggered when tokens are issue and freeze\n', '    event IssueAndFreeze(address indexed to, uint256 _value, uint256 _freezePeriod);\n', '\n', '    /**\n', '     * Constrctor function\n', '     *\n', '     * Initializes contract with initial supply tokens to the creator of the contract\n', '     */\n', '    constructor(string _tokenName, string _tokenSymbol, uint256 _initialSupply) public {\n', '        _totalSupply = _initialSupply * 10 ** uint256(decimals);  // Total supply with the decimal amount\n', '        balances[msg.sender] = _totalSupply;                // Give the creator all initial tokens\n', '        name = _tokenName;                                   // Set the name for display purposes\n', '        symbol = _tokenSymbol;                               // Set the symbol for display purposes\n', '    }\n', '\n', '    /// @notice Get the total token supply\n', '    /// @dev Get the total token supply\n', '    /// @return Total token supply\n', '    function totalSupply() public view returns (uint256 supply) {\n', '        return _totalSupply;\n', '    }\n', '\n', '    /// @notice Get balance of account\n', "    /// @dev Get balance of '_owner'\n", '    /// @param _owner Target address\n', "    /// @return balance of '_owner'\n", '    function balanceOf(address _owner) public view returns (uint256 balance){\n', '        return balances[_owner];\n', '    }\n', '\n', '    /// @notice Issue tokens to account and these tokens will be frozen for a period of time\n', "    /// @dev Issue '_value' tokens to the address '_to' and these tokens will be frozen for a period of '_freezePeriod' minutes\n", '    /// @param _to Receiving address\n', '    /// @param _value The amount of frozen token to be issued\n', '    /// @param _freezePeriod Freeze Period(minutes)\n', '    function issueAndFreeze(address _to, uint _value, uint _freezePeriod) onlyOwner public {\n', '        _transfer(msg.sender, _to, _value);\n', '\n', '        freezeAccount[_to] = FreezeAccountInfo({\n', '            freezeStartTime : now,\n', '            freezePeriod : _freezePeriod,\n', '            freezeTotal : _value\n', '        });\n', '\n', '        emit IssueAndFreeze(_to, _value, _freezePeriod);\n', '    }\n', '\n', "    /// @notice Get account's freeze information\n", "    /// @dev Get freeze information of '_target'\n", '    /// @param _target Target address\n', '    /// @return _freezeStartTime Freeze start time; _freezePeriod Freeze period(minutes); _freezeAmount Freeze token amount; _freezeDeadline Freeze deadline\n', '    function getFreezeInfo(address _target) public view returns(\n', '        uint _freezeStartTime, \n', '        uint _freezePeriod, \n', '        uint _freezeTotal, \n', '        uint _freezeDeadline) {\n', '            \n', '        FreezeAccountInfo storage targetFreezeInfo = freezeAccount[_target];\n', '        uint freezeDeadline = targetFreezeInfo.freezeStartTime.add(targetFreezeInfo.freezePeriod.mul(1 minutes));\n', '        return (\n', '            targetFreezeInfo.freezeStartTime, \n', '            targetFreezeInfo.freezePeriod,\n', '            targetFreezeInfo.freezeTotal,\n', '            freezeDeadline\n', '        );\n', '    }\n', '\n', '    /// @dev Internal transfer, only can be called by this contract\n', '    /// @param _from The address of the sender\n', '    /// @param _to The address of the recipient\n', '    /// @param _value The amount to send\n', '    function _transfer(address _from, address _to, uint _value) internal {\n', '        // Prevent transfer to 0x0 address\n', '        require(_to != 0x0);\n', '        // Check if the sender has enough\n', '        require(balances[_from] >= _value);\n', '        // Check for overflows\n', '        require(balances[_to].add(_value) > balances[_to]);\n', '\n', '        uint256 freezeStartTime;\n', '        uint256 freezePeriod;\n', '        uint256 freezeTotal;\n', '        uint256 freezeDeadline;\n', '\n', '        // Get freeze information of sender\n', '        (freezeStartTime,freezePeriod,freezeTotal,freezeDeadline) = getFreezeInfo(_from);\n', '\n', '        // The free amount of _from\n', '        uint256 freeTotalFrom = balances[_from].sub(freezeTotal);\n', '\n', '        //Check if it is a freeze account\n', '        //Check if in Lock-up Period\n', '        //Check if the transfer amount > free amount\n', '        require(freezeStartTime == 0 || freezeDeadline < now || freeTotalFrom >= _value); \n', '\n', '        // Save this for an assertion in the future\n', '        uint previousBalances = balances[_from].add(balances[_to]);\n', '        // Subtract from the sender\n', '        balances[_from] = balances[_from].sub(_value);\n', '        // Add the same to the recipient\n', '        balances[_to] = balances[_to].add(_value);\n', '\n', '        // Notify client the transfer\n', '        emit Transfer(_from, _to, _value);\n', '        // Asserting that the total balances before and after the transaction should be the same\n', '        assert(balances[_from].add(balances[_to]) == previousBalances);\n', '    }\n', '\n', '    /// @notice Transfer tokens to account\n', "    /// @dev Send '_value' amount of tokens to address '_to'\n", '    /// @param _to The address of the recipient\n', '    /// @param _value The token amount to send\n', '    /// @return Whether succeed\n', '    function transfer(address _to, uint256 _value) public returns (bool success) {\n', '        _transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /// @notice Transfer tokens from other address\n', "    /// @dev Send '_value' amount of tokens from address '_from' to address '_to'\n", '    /// @param _from The address of the sender\n', '    /// @param _to The address of the recipient\n', '    /// @param _value The token amount to send\n', '    /// @return Whether succeed\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        require(_value <= allowance[_from][msg.sender]);     // Check allowance\n', '        allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);\n', '        _transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /// @notice Set allowance for other address\n', "    /// @dev Allows '_spender' to spend no more than '_value' tokens in your behalf. If this function is called again it overwrites the current allowance with _value\n", '    /// @param _spender The address authorized to spend\n', '    /// @param _value The max amount they can spend\n', '    /// @return Whether succeed.\n', '    function approve(address _spender, uint256 _value) public returns (bool success) {\n', '        allowance[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', "    /// @notice Get the amount which '_spender' is still allowed to withdraw from '_owner'\n", "    /// @dev Get the amount which '_spender' is still allowed to withdraw from '_owner'\n", '    /// @param _owner Target address\n', '    /// @param _spender The address authorized to spend\n', '    /// @return The max amount can spend\n', '    function allowance(address _owner, address _spender) public view returns (uint256 remaining){\n', '        return allowance[_owner][_spender];\n', '    }\n', '}']
