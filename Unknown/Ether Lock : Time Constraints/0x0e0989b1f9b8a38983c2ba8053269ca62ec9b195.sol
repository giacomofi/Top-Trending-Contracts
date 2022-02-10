['pragma solidity ^0.4.15;\n', '\n', '\n', '/// @title Abstract ERC20 token interface\n', 'contract AbstractToken {\n', '\n', '    function totalSupply() constant returns (uint256) {}\n', '    function balanceOf(address owner) constant returns (uint256 balance);\n', '    function transfer(address to, uint256 value) returns (bool success);\n', '    function transferFrom(address from, address to, uint256 value) returns (bool success);\n', '    function approve(address spender, uint256 value) returns (bool success);\n', '    function allowance(address owner, address spender) constant returns (uint256 remaining);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '    event Issuance(address indexed to, uint256 value);\n', '}\n', '\n', '\n', 'contract Owned {\n', '\n', '    address public owner = msg.sender;\n', '    address public potentialOwner;\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    modifier onlyPotentialOwner {\n', '        require(msg.sender == potentialOwner);\n', '        _;\n', '    }\n', '\n', '    event NewOwner(address old, address current);\n', '    event NewPotentialOwner(address old, address potential);\n', '\n', '    function setOwner(address _new)\n', '        public\n', '        onlyOwner\n', '    {\n', '        NewPotentialOwner(owner, _new);\n', '        potentialOwner = _new;\n', '    }\n', '\n', '    function confirmOwnership()\n', '        public\n', '        onlyPotentialOwner\n', '    {\n', '        NewOwner(owner, potentialOwner);\n', '        owner = potentialOwner;\n', '        potentialOwner = 0;\n', '    }\n', '}\n', '\n', '\n', '/// Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/issues/20\n', 'contract StandardToken is AbstractToken, Owned {\n', '\n', '    /*\n', '     *  Data structures\n', '     */\n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '    uint256 public totalSupply;\n', '\n', '    /*\n', '     *  Read and write storage functions\n', '     */\n', '    /// @dev Transfers sender&#39;s tokens to a given address. Returns success.\n', '    /// @param _to Address of token receiver.\n', '    /// @param _value Number of tokens to transfer.\n', '    function transfer(address _to, uint256 _value) returns (bool success) {\n', '        if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {\n', '            balances[msg.sender] -= _value;\n', '            balances[_to] += _value;\n', '            Transfer(msg.sender, _to, _value);\n', '            return true;\n', '        }\n', '        else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '    /// @dev Allows allowed third party to transfer tokens from one address to another. Returns success.\n', '    /// @param _from Address from where tokens are withdrawn.\n', '    /// @param _to Address to where tokens are sent.\n', '    /// @param _value Number of tokens to transfer.\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {\n', '      if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {\n', '            balances[_to] += _value;\n', '            balances[_from] -= _value;\n', '            allowed[_from][msg.sender] -= _value;\n', '            Transfer(_from, _to, _value);\n', '            return true;\n', '        }\n', '        else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '    /// @dev Returns number of tokens owned by given address.\n', '    /// @param _owner Address of token owner.\n', '    function balanceOf(address _owner) constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    /// @dev Sets approved amount of tokens for spender. Returns success.\n', '    /// @param _spender Address of allowed account.\n', '    /// @param _value Number of approved tokens.\n', '    function approve(address _spender, uint256 _value) returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    /*\n', '     * Read storage functions\n', '     */\n', '    /// @dev Returns number of allowed tokens for given address.\n', '    /// @param _owner Address of token owner.\n', '    /// @param _spender Address of token spender.\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '      return allowed[_owner][_spender];\n', '    }\n', '\n', '}\n', '\n', '\n', '/// @title SafeMath contract - Math operations with safety checks.\n', '/// @author OpenZeppelin: https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/math/SafeMath.sol\n', 'contract SafeMath {\n', '    function mul(uint a, uint b) internal returns (uint) {\n', '        uint c = a * b;\n', '        assert(a == 0 || c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint a, uint b) internal returns (uint) {\n', '        assert(b > 0);\n', '        uint c = a / b;\n', '        assert(a == b * c + a % b);\n', '        return c;\n', '    }\n', '\n', '    function sub(uint a, uint b) internal returns (uint) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint a, uint b) internal returns (uint) {\n', '        uint c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '\n', '    function pow(uint a, uint b) internal returns (uint) {\n', '        uint c = a ** b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', '\n', '/// @title Token contract - Implements Standard ERC20 with additional features.\n', '/// @author Zerion - <<span class="__cf_email__" data-cfemail="433926312a2c2d032a2d212c3b6d202c2e">[email&#160;protected]</span>>\n', 'contract Token is StandardToken, SafeMath {\n', '    // Time of the contract creation\n', '    uint public creationTime;\n', '\n', '    function Token() {\n', '        creationTime = now;\n', '    }\n', '\n', '\n', '    /// @dev Owner can transfer out any accidentally sent ERC20 tokens\n', '    function transferERC20Token(address tokenAddress)\n', '        public\n', '        onlyOwner\n', '        returns (bool)\n', '    {\n', '        uint balance = AbstractToken(tokenAddress).balanceOf(this);\n', '        return AbstractToken(tokenAddress).transfer(owner, balance);\n', '    }\n', '\n', '    /// @dev Multiplies the given number by 10^(decimals)\n', '    function withDecimals(uint number, uint decimals)\n', '        internal\n', '        returns (uint)\n', '    {\n', '        return mul(number, pow(10, decimals));\n', '    }\n', '}\n', '\n', '\n', '/// @title Token contract - Implements Standard ERC20 Token with Po.et features.\n', '/// @author Zerion - <<span class="__cf_email__" data-cfemail="b3c9d6c1dadcddf3daddd1dccb9dd0dcde">[email&#160;protected]</span>>\n', 'contract PoetToken is Token {\n', '\n', '    /*\n', '     * Token meta data\n', '     */\n', '    string constant public name = "Po.et";\n', '    string constant public symbol = "POE";\n', '    uint8 constant public decimals = 8;\n', '\n', '    // Address where all investors tokens created during the ICO stage initially allocated\n', '    address constant public icoAllocation = 0x1111111111111111111111111111111111111111;\n', '\n', '    // Address where Foundation tokens are allocated\n', '    address constant public foundationReserve = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;\n', '\n', '    // Number of tokens initially allocated to Foundation\n', '    uint foundationTokens;\n', '\n', '    // Store number of days in each month\n', '    mapping(uint8 => uint8) daysInMonth;\n', '\n', '    // UNIX timestamp for September 1, 2017\n', '    // It&#39;s a date when first 2% of foundation reserve will be unlocked\n', '    uint Sept1_2017 = 1504224000;\n', '\n', '    // Number of days since September 1, 2017 before all tokens will be unlocked\n', '    uint reserveDelta = 456;\n', '\n', '\n', '    /// @dev Contract constructor function sets totalSupply and allocates all ICO tokens to the icoAllocation address\n', '    function PoetToken()\n', '    {   \n', '        // Overall, 3,141,592,653 POE tokens are distributed\n', '        totalSupply = withDecimals(3141592653, decimals);\n', '\n', '        // Allocate 32% of all tokens to Foundation\n', '        foundationTokens = div(mul(totalSupply, 32), 100);\n', '        balances[foundationReserve] = foundationTokens;\n', '\n', '        // Allocate the rest to icoAllocation address\n', '        balances[icoAllocation] = sub(totalSupply, foundationTokens);\n', '\n', '        // Allow owner to distribute tokens allocated on the icoAllocation address\n', '        allowed[icoAllocation][owner] = balanceOf(icoAllocation);\n', '\n', '        // Fill mapping with numbers of days\n', '        // Note: we consider only February of 2018 that has 28 days\n', '        daysInMonth[1]  = 31; daysInMonth[2]  = 28; daysInMonth[3]  = 31;\n', '        daysInMonth[4]  = 30; daysInMonth[5]  = 31; daysInMonth[6]  = 30;\n', '        daysInMonth[7]  = 31; daysInMonth[8]  = 31; daysInMonth[9]  = 30;\n', '        daysInMonth[10] = 31; daysInMonth[11] = 30; daysInMonth[12] = 31;\n', '    }\n', '\n', '    /// @dev Sends tokens from icoAllocation to investor\n', '    function distribute(address investor, uint amount)\n', '        public\n', '        onlyOwner\n', '    {\n', '        transferFrom(icoAllocation, investor, amount);\n', '    }\n', '\n', '    /// @dev Overrides Owned.sol function\n', '    function confirmOwnership()\n', '        public\n', '        onlyPotentialOwner\n', '    {   \n', '        // Allow new owner to distribute tokens allocated on the icoAllocation address\n', '        allowed[icoAllocation][potentialOwner] = balanceOf(icoAllocation);\n', '\n', '        // Forbid old owner to distribute tokens\n', '        allowed[icoAllocation][owner] = 0;\n', '\n', '        // Forbid old owner to withdraw tokens from foundation reserve\n', '        allowed[foundationReserve][owner] = 0;\n', '\n', '        // Change owner\n', '        super.confirmOwnership();\n', '    }\n', '\n', '    /// @dev Overrides StandardToken.sol function\n', '    function allowance(address _owner, address _spender)\n', '        public\n', '        constant\n', '        returns (uint256 remaining)\n', '    {\n', '        if (_owner == foundationReserve && _spender == owner) {\n', '            return availableReserve();\n', '        }\n', '\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    /// @dev Returns max number of tokens that actually can be withdrawn from foundation reserve\n', '    function availableReserve() \n', '        public\n', '        constant\n', '        returns (uint)\n', '    {   \n', '        // No tokens should be available for withdrawal before September 1, 2017\n', '        if (now < Sept1_2017) {\n', '            return 0;\n', '        }\n', '\n', '        // Number of days passed  since September 1, 2017\n', '        uint daysPassed = div(sub(now, Sept1_2017), 1 days);\n', '\n', '        // All tokens should be unlocked if reserveDelta days passed\n', '        if (daysPassed >= reserveDelta) {\n', '            return balanceOf(foundationReserve);\n', '        }\n', '\n', '        // Percentage of unlocked tokens by the current date\n', '        uint unlockedPercentage = 0;\n', '\n', '        uint16 _days = 0;  uint8 month = 9;\n', '        while (_days <= daysPassed) {\n', '            unlockedPercentage += 2;\n', '            _days += daysInMonth[month];\n', '            month = month % 12 + 1;\n', '        }\n', '\n', '        // Number of unlocked tokens by the current date\n', '        uint unlockedTokens = div(mul(totalSupply, unlockedPercentage), 100);\n', '\n', '        // Number of tokens that should remain locked\n', '        uint lockedTokens = foundationTokens - unlockedTokens;\n', '\n', '        return balanceOf(foundationReserve) - lockedTokens;\n', '    }\n', '\n', '    /// @dev Withdraws tokens from foundation reserve\n', '    function withdrawFromReserve(uint amount)\n', '        public\n', '        onlyOwner\n', '    {   \n', '        // Allow owner to withdraw no more than this amount of tokens\n', '        allowed[foundationReserve][owner] = availableReserve();\n', '\n', '        // Withdraw tokens from foundation reserve to owner address\n', '        require(transferFrom(foundationReserve, owner, amount));\n', '    }\n', '}']
['pragma solidity ^0.4.15;\n', '\n', '\n', '/// @title Abstract ERC20 token interface\n', 'contract AbstractToken {\n', '\n', '    function totalSupply() constant returns (uint256) {}\n', '    function balanceOf(address owner) constant returns (uint256 balance);\n', '    function transfer(address to, uint256 value) returns (bool success);\n', '    function transferFrom(address from, address to, uint256 value) returns (bool success);\n', '    function approve(address spender, uint256 value) returns (bool success);\n', '    function allowance(address owner, address spender) constant returns (uint256 remaining);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '    event Issuance(address indexed to, uint256 value);\n', '}\n', '\n', '\n', 'contract Owned {\n', '\n', '    address public owner = msg.sender;\n', '    address public potentialOwner;\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    modifier onlyPotentialOwner {\n', '        require(msg.sender == potentialOwner);\n', '        _;\n', '    }\n', '\n', '    event NewOwner(address old, address current);\n', '    event NewPotentialOwner(address old, address potential);\n', '\n', '    function setOwner(address _new)\n', '        public\n', '        onlyOwner\n', '    {\n', '        NewPotentialOwner(owner, _new);\n', '        potentialOwner = _new;\n', '    }\n', '\n', '    function confirmOwnership()\n', '        public\n', '        onlyPotentialOwner\n', '    {\n', '        NewOwner(owner, potentialOwner);\n', '        owner = potentialOwner;\n', '        potentialOwner = 0;\n', '    }\n', '}\n', '\n', '\n', '/// Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/issues/20\n', 'contract StandardToken is AbstractToken, Owned {\n', '\n', '    /*\n', '     *  Data structures\n', '     */\n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '    uint256 public totalSupply;\n', '\n', '    /*\n', '     *  Read and write storage functions\n', '     */\n', "    /// @dev Transfers sender's tokens to a given address. Returns success.\n", '    /// @param _to Address of token receiver.\n', '    /// @param _value Number of tokens to transfer.\n', '    function transfer(address _to, uint256 _value) returns (bool success) {\n', '        if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {\n', '            balances[msg.sender] -= _value;\n', '            balances[_to] += _value;\n', '            Transfer(msg.sender, _to, _value);\n', '            return true;\n', '        }\n', '        else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '    /// @dev Allows allowed third party to transfer tokens from one address to another. Returns success.\n', '    /// @param _from Address from where tokens are withdrawn.\n', '    /// @param _to Address to where tokens are sent.\n', '    /// @param _value Number of tokens to transfer.\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {\n', '      if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {\n', '            balances[_to] += _value;\n', '            balances[_from] -= _value;\n', '            allowed[_from][msg.sender] -= _value;\n', '            Transfer(_from, _to, _value);\n', '            return true;\n', '        }\n', '        else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '    /// @dev Returns number of tokens owned by given address.\n', '    /// @param _owner Address of token owner.\n', '    function balanceOf(address _owner) constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    /// @dev Sets approved amount of tokens for spender. Returns success.\n', '    /// @param _spender Address of allowed account.\n', '    /// @param _value Number of approved tokens.\n', '    function approve(address _spender, uint256 _value) returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    /*\n', '     * Read storage functions\n', '     */\n', '    /// @dev Returns number of allowed tokens for given address.\n', '    /// @param _owner Address of token owner.\n', '    /// @param _spender Address of token spender.\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '      return allowed[_owner][_spender];\n', '    }\n', '\n', '}\n', '\n', '\n', '/// @title SafeMath contract - Math operations with safety checks.\n', '/// @author OpenZeppelin: https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/math/SafeMath.sol\n', 'contract SafeMath {\n', '    function mul(uint a, uint b) internal returns (uint) {\n', '        uint c = a * b;\n', '        assert(a == 0 || c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint a, uint b) internal returns (uint) {\n', '        assert(b > 0);\n', '        uint c = a / b;\n', '        assert(a == b * c + a % b);\n', '        return c;\n', '    }\n', '\n', '    function sub(uint a, uint b) internal returns (uint) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint a, uint b) internal returns (uint) {\n', '        uint c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '\n', '    function pow(uint a, uint b) internal returns (uint) {\n', '        uint c = a ** b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', '\n', '/// @title Token contract - Implements Standard ERC20 with additional features.\n', '/// @author Zerion - <zerion@inbox.com>\n', 'contract Token is StandardToken, SafeMath {\n', '    // Time of the contract creation\n', '    uint public creationTime;\n', '\n', '    function Token() {\n', '        creationTime = now;\n', '    }\n', '\n', '\n', '    /// @dev Owner can transfer out any accidentally sent ERC20 tokens\n', '    function transferERC20Token(address tokenAddress)\n', '        public\n', '        onlyOwner\n', '        returns (bool)\n', '    {\n', '        uint balance = AbstractToken(tokenAddress).balanceOf(this);\n', '        return AbstractToken(tokenAddress).transfer(owner, balance);\n', '    }\n', '\n', '    /// @dev Multiplies the given number by 10^(decimals)\n', '    function withDecimals(uint number, uint decimals)\n', '        internal\n', '        returns (uint)\n', '    {\n', '        return mul(number, pow(10, decimals));\n', '    }\n', '}\n', '\n', '\n', '/// @title Token contract - Implements Standard ERC20 Token with Po.et features.\n', '/// @author Zerion - <zerion@inbox.com>\n', 'contract PoetToken is Token {\n', '\n', '    /*\n', '     * Token meta data\n', '     */\n', '    string constant public name = "Po.et";\n', '    string constant public symbol = "POE";\n', '    uint8 constant public decimals = 8;\n', '\n', '    // Address where all investors tokens created during the ICO stage initially allocated\n', '    address constant public icoAllocation = 0x1111111111111111111111111111111111111111;\n', '\n', '    // Address where Foundation tokens are allocated\n', '    address constant public foundationReserve = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;\n', '\n', '    // Number of tokens initially allocated to Foundation\n', '    uint foundationTokens;\n', '\n', '    // Store number of days in each month\n', '    mapping(uint8 => uint8) daysInMonth;\n', '\n', '    // UNIX timestamp for September 1, 2017\n', "    // It's a date when first 2% of foundation reserve will be unlocked\n", '    uint Sept1_2017 = 1504224000;\n', '\n', '    // Number of days since September 1, 2017 before all tokens will be unlocked\n', '    uint reserveDelta = 456;\n', '\n', '\n', '    /// @dev Contract constructor function sets totalSupply and allocates all ICO tokens to the icoAllocation address\n', '    function PoetToken()\n', '    {   \n', '        // Overall, 3,141,592,653 POE tokens are distributed\n', '        totalSupply = withDecimals(3141592653, decimals);\n', '\n', '        // Allocate 32% of all tokens to Foundation\n', '        foundationTokens = div(mul(totalSupply, 32), 100);\n', '        balances[foundationReserve] = foundationTokens;\n', '\n', '        // Allocate the rest to icoAllocation address\n', '        balances[icoAllocation] = sub(totalSupply, foundationTokens);\n', '\n', '        // Allow owner to distribute tokens allocated on the icoAllocation address\n', '        allowed[icoAllocation][owner] = balanceOf(icoAllocation);\n', '\n', '        // Fill mapping with numbers of days\n', '        // Note: we consider only February of 2018 that has 28 days\n', '        daysInMonth[1]  = 31; daysInMonth[2]  = 28; daysInMonth[3]  = 31;\n', '        daysInMonth[4]  = 30; daysInMonth[5]  = 31; daysInMonth[6]  = 30;\n', '        daysInMonth[7]  = 31; daysInMonth[8]  = 31; daysInMonth[9]  = 30;\n', '        daysInMonth[10] = 31; daysInMonth[11] = 30; daysInMonth[12] = 31;\n', '    }\n', '\n', '    /// @dev Sends tokens from icoAllocation to investor\n', '    function distribute(address investor, uint amount)\n', '        public\n', '        onlyOwner\n', '    {\n', '        transferFrom(icoAllocation, investor, amount);\n', '    }\n', '\n', '    /// @dev Overrides Owned.sol function\n', '    function confirmOwnership()\n', '        public\n', '        onlyPotentialOwner\n', '    {   \n', '        // Allow new owner to distribute tokens allocated on the icoAllocation address\n', '        allowed[icoAllocation][potentialOwner] = balanceOf(icoAllocation);\n', '\n', '        // Forbid old owner to distribute tokens\n', '        allowed[icoAllocation][owner] = 0;\n', '\n', '        // Forbid old owner to withdraw tokens from foundation reserve\n', '        allowed[foundationReserve][owner] = 0;\n', '\n', '        // Change owner\n', '        super.confirmOwnership();\n', '    }\n', '\n', '    /// @dev Overrides StandardToken.sol function\n', '    function allowance(address _owner, address _spender)\n', '        public\n', '        constant\n', '        returns (uint256 remaining)\n', '    {\n', '        if (_owner == foundationReserve && _spender == owner) {\n', '            return availableReserve();\n', '        }\n', '\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    /// @dev Returns max number of tokens that actually can be withdrawn from foundation reserve\n', '    function availableReserve() \n', '        public\n', '        constant\n', '        returns (uint)\n', '    {   \n', '        // No tokens should be available for withdrawal before September 1, 2017\n', '        if (now < Sept1_2017) {\n', '            return 0;\n', '        }\n', '\n', '        // Number of days passed  since September 1, 2017\n', '        uint daysPassed = div(sub(now, Sept1_2017), 1 days);\n', '\n', '        // All tokens should be unlocked if reserveDelta days passed\n', '        if (daysPassed >= reserveDelta) {\n', '            return balanceOf(foundationReserve);\n', '        }\n', '\n', '        // Percentage of unlocked tokens by the current date\n', '        uint unlockedPercentage = 0;\n', '\n', '        uint16 _days = 0;  uint8 month = 9;\n', '        while (_days <= daysPassed) {\n', '            unlockedPercentage += 2;\n', '            _days += daysInMonth[month];\n', '            month = month % 12 + 1;\n', '        }\n', '\n', '        // Number of unlocked tokens by the current date\n', '        uint unlockedTokens = div(mul(totalSupply, unlockedPercentage), 100);\n', '\n', '        // Number of tokens that should remain locked\n', '        uint lockedTokens = foundationTokens - unlockedTokens;\n', '\n', '        return balanceOf(foundationReserve) - lockedTokens;\n', '    }\n', '\n', '    /// @dev Withdraws tokens from foundation reserve\n', '    function withdrawFromReserve(uint amount)\n', '        public\n', '        onlyOwner\n', '    {   \n', '        // Allow owner to withdraw no more than this amount of tokens\n', '        allowed[foundationReserve][owner] = availableReserve();\n', '\n', '        // Withdraw tokens from foundation reserve to owner address\n', '        require(transferFrom(foundationReserve, owner, amount));\n', '    }\n', '}']