['pragma solidity ^0.4.20;\n', '\n', '/*\n', ' * ERC20 interface\n', ' * see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 {\n', '    uint public totalSupply;\n', '    function balanceOf(address who) constant returns (uint);\n', '    function allowance(address owner, address spender) constant returns (uint);\n', '\n', '    function transfer(address to, uint value) returns (bool ok);\n', '    function transferFrom(address from, address to, uint value) returns (bool ok);\n', '    function approve(address spender, uint value) returns (bool ok);\n', '    event Transfer(address indexed from, address indexed to, uint value);\n', '    event Approval(address indexed owner, address indexed spender, uint value);\n', '}\n', '\n', '\n', '/**\n', ' * Math operations with safety checks\n', ' */\n', 'contract SafeMath {\n', '    function safeMul(uint a, uint b) internal returns (uint) {\n', '        uint c = a * b;\n', '        assert(a == 0 || c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function safeDiv(uint a, uint b) internal returns (uint) {\n', '        assert(b > 0);\n', '        uint c = a / b;\n', '        assert(a == b * c + a % b);\n', '        return c;\n', '    }\n', '\n', '    function safeSub(uint a, uint b) internal returns (uint) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function safeAdd(uint a, uint b) internal returns (uint) {\n', '        uint c = a + b;\n', '        assert(c >= a && c >= b);\n', '        return c;\n', '    }\n', '\n', '    function max64(uint64 a, uint64 b) internal constant returns (uint64) {\n', '        return a >= b ? a : b;\n', '    }\n', '\n', '    function min64(uint64 a, uint64 b) internal constant returns (uint64) {\n', '        return a < b ? a : b;\n', '    }\n', '\n', '    function max256(uint256 a, uint256 b) internal constant returns (uint256) {\n', '        return a >= b ? a : b;\n', '    }\n', '\n', '    function min256(uint256 a, uint256 b) internal constant returns (uint256) {\n', '        return a < b ? a : b;\n', '    }\n', '\n', '    function assert(bool assertion) internal {\n', '        if (!assertion) {\n', '            throw;\n', '        }\n', '    }\n', '\n', '}\n', '\n', '/**\n', ' * Owned contract\n', ' */\n', 'contract Owned {\n', '    address public owner;\n', '\n', '    function Owned() {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function isOwner(address _owner) internal returns (bool){\n', '        if (_owner == owner){\n', '            return true;\n', '        }\n', '        return false;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) onlyOwner {\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', '/**\n', ' * BP crowdsale contract\n', '*/\n', 'contract BPToken is SafeMath, Owned, ERC20 {\n', '    string public constant name = "Backpack Travel Token";\n', '    string public constant symbol = "BP";\n', '    uint256 public constant decimals = 18;  \n', '\n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '\n', '    function BPToken() {\n', '        totalSupply = 2000000000 * 10 ** uint256(decimals);\n', '        balances[msg.sender] = totalSupply;\n', '    }\n', '    \n', '    event Issue(uint16 role, address indexed to, uint256 value);\n', '\n', '    /// roles\n', '    enum Roles { Default, Angel, PrivateSale, Partner, Fans, Team, Foundation, Backup }\n', '    mapping (address => uint256) addressHold;\n', '    mapping (address => uint16) addressRole;\n', '\n', '    uint perMonthSecond = 2592000;\n', '    \n', '    /// lock rule\n', '    struct LockRule {\n', '        uint baseLockPercent;\n', '        uint startLockTime;\n', '        uint stopLockTime;\n', '        uint linearRelease;\n', '    }\n', '    mapping (uint16 => LockRule) roleRule;\n', '\n', '    /// set the rule for special role\n', '    function setRule(uint16 _role, uint _baseLockPercent, uint _startLockTime, uint _stopLockTime,uint _linearRelease) onlyOwner {\n', '        assert(_startLockTime > block.timestamp);\n', '        assert(_stopLockTime > _startLockTime);\n', '        \n', '        roleRule[_role] = LockRule({\n', '            baseLockPercent: _baseLockPercent,\n', '            startLockTime: _startLockTime,\n', '            stopLockTime: _stopLockTime,\n', '            linearRelease: _linearRelease\n', '        });\n', '    }\n', '    \n', '    /// assign BP token to another address\n', '    function assign(uint16 role, address to, uint256 amount) onlyOwner returns (bool) {\n', '        assert(role <= uint16(Roles.Backup));\n', '        assert(balances[msg.sender] > amount);\n', '        \n', '        /// one address only belong to one role\n', '        if ((addressRole[to] != uint16(Roles.Default)) && (addressRole[to] != role)) throw;\n', '\n', '        if (role != uint16(Roles.Default)) {\n', '            addressRole[to] = role;\n', '            addressHold[to] = safeAdd(addressHold[to],amount);\n', '        }\n', '\n', '        if (transfer(to,amount)) {\n', '            Issue(role, to, amount);\n', '            return true;\n', '        }\n', '\n', '        return false;\n', '    }\n', '\n', '    function isRole(address who) internal returns(uint16) {\n', '        uint16 role = addressRole[who];\n', '        if (role != 0) {\n', '            return role;\n', '        }\n', '        return 100;\n', '    }\n', '    \n', '    /// calc the balance that the user shuold hold\n', '    function shouldHadBalance(address who) internal returns (uint){\n', '        uint16 currentRole = isRole(who);\n', '        if (isOwner(who) || (currentRole == 100)) {\n', '            return 0;\n', '        }\n', '        \n', '        // base lock amount \n', '        uint256 baseLockAmount = safeDiv(safeMul(addressHold[who], roleRule[currentRole].baseLockPercent),100);\n', '        \n', '        /// will not linear release\n', '        if (roleRule[currentRole].linearRelease == 0) {\n', '            if (block.timestamp < roleRule[currentRole].stopLockTime) {\n', '                return baseLockAmount;\n', '            } else {\n', '                return 0;\n', '            }\n', '        }\n', '        /// will linear release \n', '\n', '        /// now timestamp before start lock time \n', '        if (block.timestamp < roleRule[currentRole].startLockTime + perMonthSecond) {\n', '            return baseLockAmount;\n', '        }\n', '        // total lock months\n', '        uint lockMonth = safeDiv(safeSub(roleRule[currentRole].stopLockTime,roleRule[currentRole].startLockTime),perMonthSecond);\n', '        // unlock amount of every month\n', '        uint256 monthUnlockAmount = safeDiv(baseLockAmount,lockMonth);\n', '        // current timestamp passed month \n', '        uint hadPassMonth = safeDiv(safeSub(block.timestamp,roleRule[currentRole].startLockTime),perMonthSecond);\n', '\n', '        return safeSub(baseLockAmount,safeMul(hadPassMonth,monthUnlockAmount));\n', '    }\n', '\n', '    /// get balance of the special address\n', '    function balanceOf(address who) constant returns (uint) {\n', '        return balances[who];\n', '    }\n', '\n', '    /// @notice Transfer `value` BP tokens from sender&#39;s account\n', '    /// `msg.sender` to provided account address `to`.\n', '    /// @notice This function is disabled during the funding.\n', '    /// @dev Required state: Success\n', '    /// @param to The address of the recipient\n', '    /// @param value The number of BPs to transfer\n', '    /// @return Whether the transfer was successful or not\n', '    function transfer(address to, uint256 value) returns (bool) {\n', '        if (safeSub(balances[msg.sender],value) < shouldHadBalance(msg.sender)) throw;\n', '\n', '        uint256 senderBalance = balances[msg.sender];\n', '        if (senderBalance >= value && value > 0) {\n', '            senderBalance = safeSub(senderBalance, value);\n', '            balances[msg.sender] = senderBalance;\n', '            balances[to] = safeAdd(balances[to], value);\n', '            Transfer(msg.sender, to, value);\n', '            return true;\n', '        }\n', '        return false;\n', '    }\n', '\n', '    /// @notice Transfer `value` BP tokens from sender &#39;from&#39;\n', '    /// to provided account address `to`.\n', '    /// @notice This function is disabled during the funding.\n', '    /// @dev Required state: Success\n', '    /// @param from The address of the sender\n', '    /// @param to The address of the recipient\n', '    /// @param value The number of BPs to transfer\n', '    /// @return Whether the transfer was successful or not\n', '    function transferFrom(address from, address to, uint256 value) returns (bool) {\n', '        // Abort if not in Success state.\n', '        // protect against wrapping uints\n', '        if (balances[from] >= value &&\n', '        allowed[from][msg.sender] >= value &&\n', '        safeAdd(balances[to], value) > balances[to])\n', '        {\n', '            balances[to] = safeAdd(balances[to], value);\n', '            balances[from] = safeSub(balances[from], value);\n', '            allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], value);\n', '            Transfer(from, to, value);\n', '            return true;\n', '        }\n', '        else {return false;}\n', '    }\n', '\n', '    /// @notice `msg.sender` approves `spender` to spend `value` tokens\n', '    /// @param spender The address of the account able to transfer the tokens\n', '    /// @param value The amount of wei to be approved for transfer\n', '    /// @return Whether the approval was successful or not\n', '    function approve(address spender, uint256 value) returns (bool) {\n', '        if (safeSub(balances[msg.sender],value) < shouldHadBalance(msg.sender)) throw;\n', '        \n', '        // Abort if not in Success state.\n', '        allowed[msg.sender][spender] = value;\n', '        Approval(msg.sender, spender, value);\n', '        return true;\n', '    }\n', '\n', '    /// @param owner The address of the account owning tokens\n', '    /// @param spender The address of the account able to transfer the tokens\n', '    /// @return Amount of remaining tokens allowed to spent\n', '    function allowance(address owner, address spender) constant returns (uint) {\n', '        uint allow = allowed[owner][spender];\n', '        return allow;\n', '    }\n', '}']