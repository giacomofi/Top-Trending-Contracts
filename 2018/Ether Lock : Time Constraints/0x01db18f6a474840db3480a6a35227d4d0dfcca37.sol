['pragma solidity ^0.4.20;\n', '\n', '\n', '/*\n', ' * ERC20 interface\n', ' * see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 {\n', '    uint public totalSupply;\n', '    function balanceOf(address who) constant returns (uint);\n', '    function allowance(address owner, address spender) constant returns (uint);\n', '\n', '    function transfer(address to, uint value) returns (bool ok);\n', '    function transferFrom(address from, address to, uint value) returns (bool ok);\n', '    function approve(address spender, uint value) returns (bool ok);\n', '    event Transfer(address indexed from, address indexed to, uint value);\n', '    event Approval(address indexed owner, address indexed spender, uint value);\n', '}\n', '\n', '\n', '/**\n', ' * Math operations with safety checks\n', ' */\n', 'contract SafeMath {\n', '    function safeMul(uint a, uint b) internal returns (uint) {\n', '        uint c = a * b;\n', '        assert(a == 0 || c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function safeDiv(uint a, uint b) internal returns (uint) {\n', '        assert(b > 0);\n', '        uint c = a / b;\n', '        assert(a == b * c + a % b);\n', '        return c;\n', '    }\n', '\n', '    function safeSub(uint a, uint b) internal returns (uint) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function safeAdd(uint a, uint b) internal returns (uint) {\n', '        uint c = a + b;\n', '        assert(c >= a && c >= b);\n', '        return c;\n', '    }\n', '\n', '    function max64(uint64 a, uint64 b) internal constant returns (uint64) {\n', '        return a >= b ? a : b;\n', '    }\n', '\n', '    function min64(uint64 a, uint64 b) internal constant returns (uint64) {\n', '        return a < b ? a : b;\n', '    }\n', '\n', '    function max256(uint256 a, uint256 b) internal constant returns (uint256) {\n', '        return a >= b ? a : b;\n', '    }\n', '\n', '    function min256(uint256 a, uint256 b) internal constant returns (uint256) {\n', '        return a < b ? a : b;\n', '    }\n', '\n', '    function assert(bool assertion) internal {\n', '        if (!assertion) {\n', '            throw;\n', '        }\n', '    }\n', '\n', '}\n', '\n', '/**\n', ' * Owned contract\n', ' */\n', 'contract Owned {\n', '    address[] public pools;\n', '    address public owner;\n', '\n', '    function Owned() {\n', '        owner = msg.sender;\n', '        pools.push(msg.sender);\n', '    }\n', '\n', '    modifier onlyPool {\n', '        require(isPool(msg.sender));\n', '        _;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '    \n', '    /// add new pool address to pools\n', '    function addPool(address newPool) onlyOwner {\n', '        assert (newPool != 0);\n', '        if (isPool(newPool)) throw;\n', '        pools.push(newPool);\n', '    }\n', '    \n', '    /// remove a address from pools\n', '    function removePool(address pool) onlyOwner{\n', '        assert (pool != 0);\n', '        if (!isPool(pool)) throw;\n', '        \n', '        for (uint i=0; i<pools.length - 1; i++) {\n', '            if (pools[i] == pool) {\n', '                pools[i] = pools[pools.length - 1];\n', '                break;\n', '            }\n', '        }\n', '        pools.length -= 1;\n', '    }\n', '\n', '    function isPool(address pool) internal returns (bool ok){\n', '        for (uint i=0; i<pools.length; i++) {\n', '            if (pools[i] == pool)\n', '                return true;\n', '        }\n', '        return false;\n', '    }\n', '    \n', '    function transferOwnership(address newOwner) onlyOwner public {\n', '        removePool(owner);\n', '        addPool(newOwner);\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', '/**\n', ' * BP crowdsale contract\n', '*/\n', 'contract BPToken is SafeMath, Owned, ERC20 {\n', '    string public constant name = "Backpack Token";\n', '    string public constant symbol = "BP";\n', '    uint256 public constant decimals = 18;  \n', '\n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '\n', '    function BPToken() {\n', '        totalSupply = 2000000000 * 10 ** uint256(decimals);\n', '        balances[msg.sender] = totalSupply;\n', '    }\n', '\n', '    /// asset pool map\n', '    mapping (address => address) addressPool;\n', '\n', '    /// address base amount\n', '    mapping (address => uint256) addressAmount;\n', '\n', '    /// per month seconds\n', '    uint perMonthSecond = 2592000;\n', '    \n', '    /// calc the balance that the user shuold hold\n', '    function shouldHadBalance(address who) constant returns (uint256){\n', '        if (isPool(who)) return 0;\n', '\n', '        address apAddress = getAssetPoolAddress(who);\n', '        uint256 baseAmount  = getBaseAmount(who);\n', '\n', '        /// Does not belong to AssetPool contract\n', '        if( (apAddress == address(0)) || (baseAmount == 0) ) return 0;\n', '\n', '        /// Instantiate ap contract\n', '        AssetPool ap = AssetPool(apAddress);\n', '\n', '        uint startLockTime = ap.getStartLockTime();\n', '        uint stopLockTime = ap.getStopLockTime();\n', '\n', '        if (block.timestamp > stopLockTime) {\n', '            return 0;\n', '        }\n', '\n', '        if (ap.getBaseLockPercent() == 0) {\n', '            return 0;\n', '        }\n', '\n', '        // base lock amount \n', '        uint256 baseLockAmount = safeDiv(safeMul(baseAmount, ap.getBaseLockPercent()),100);\n', '        if (block.timestamp < startLockTime) {\n', '            return baseLockAmount;\n', '        }\n', '        \n', '        /// will not linear release\n', '        if (ap.getLinearRelease() == 0) {\n', '            if (block.timestamp < stopLockTime) {\n', '                return baseLockAmount;\n', '            } else {\n', '                return 0;\n', '            }\n', '        }\n', '        /// will linear release \n', '\n', '        /// now timestamp before start lock time \n', '        if (block.timestamp < startLockTime + perMonthSecond) {\n', '            return baseLockAmount;\n', '        }\n', '        // total lock months\n', '        uint lockMonth = safeDiv(safeSub(stopLockTime,startLockTime),perMonthSecond);\n', '        if (lockMonth <= 0) {\n', '            if (block.timestamp >= stopLockTime) {\n', '                return 0;\n', '            } else {\n', '                return baseLockAmount;\n', '            }\n', '        }\n', '\n', '        // unlock amount of every month\n', '        uint256 monthUnlockAmount = safeDiv(baseLockAmount,lockMonth);\n', '\n', '        // current timestamp passed month \n', '        uint hadPassMonth = safeDiv(safeSub(block.timestamp,startLockTime),perMonthSecond);\n', '\n', '        return safeSub(baseLockAmount,safeMul(hadPassMonth,monthUnlockAmount));\n', '    }\n', '\n', '    function getAssetPoolAddress(address who) internal returns(address){\n', '        return addressPool[who];\n', '    }\n', '\n', '    function getBaseAmount(address who) internal returns(uint256){\n', '        return addressAmount[who];\n', '    }\n', '\n', '    function getBalance() constant returns(uint){\n', '        return balances[msg.sender];\n', '    }\n', '\n', '    function setPoolAndAmount(address who, uint256 amount) onlyPool returns (bool) {\n', '        assert(balances[msg.sender] >= amount);\n', '\n', '        if (owner == who) {\n', '            return true;\n', '        }\n', '        \n', '        address apAddress = getAssetPoolAddress(who);\n', '        uint256 baseAmount = getBaseAmount(who);\n', '\n', '        assert((apAddress == msg.sender) || (baseAmount == 0));\n', '\n', '        addressPool[who] = msg.sender;\n', '        addressAmount[who] += amount;\n', '\n', '        return true;\n', '    }\n', '\n', '    /// get balance of the special address\n', '    function balanceOf(address who) constant returns (uint) {\n', '        return balances[who];\n', '    }\n', '\n', '    /// @notice Transfer `value` BP tokens from sender&#39;s account\n', '    /// `msg.sender` to provided account address `to`.\n', '    /// @notice This function is disabled during the funding.\n', '    /// @dev Required state: Success\n', '    /// @param to The address of the recipient\n', '    /// @param value The number of BPs to transfer\n', '    /// @return Whether the transfer was successful or not\n', '    function transfer(address to, uint256 value) returns (bool) {\n', '        if (safeSub(balances[msg.sender],value) < shouldHadBalance(msg.sender)) throw;\n', '\n', '        uint256 senderBalance = balances[msg.sender];\n', '        if (senderBalance >= value && value > 0) {\n', '            senderBalance = safeSub(senderBalance, value);\n', '            balances[msg.sender] = senderBalance;\n', '            balances[to] = safeAdd(balances[to], value);\n', '            Transfer(msg.sender, to, value);\n', '            return true;\n', '        } else {\n', '            throw;\n', '        }\n', '    }\n', '\n', '    /// @notice Transfer `value` BP tokens from sender &#39;from&#39;\n', '    /// to provided account address `to`.\n', '    /// @notice This function is disabled during the funding.\n', '    /// @dev Required state: Success\n', '    /// @param from The address of the sender\n', '    /// @param to The address of the recipient\n', '    /// @param value The number of BPs to transfer\n', '    /// @return Whether the transfer was successful or not\n', '    function transferFrom(address from, address to, uint256 value) returns (bool) {\n', '        // Abort if not in Success state.\n', '        // protect against wrapping uints\n', '        if (balances[from] >= value &&\n', '        allowed[from][msg.sender] >= value &&\n', '        safeAdd(balances[to], value) > balances[to])\n', '        {\n', '            balances[to] = safeAdd(balances[to], value);\n', '            balances[from] = safeSub(balances[from], value);\n', '            allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], value);\n', '            Transfer(from, to, value);\n', '            return true;\n', '        } else {\n', '            throw;\n', '        }\n', '    }\n', '\n', '    /// @notice `msg.sender` approves `spender` to spend `value` tokens\n', '    /// @param spender The address of the account able to transfer the tokens\n', '    /// @param value The amount of wei to be approved for transfer\n', '    /// @return Whether the approval was successful or not\n', '    function approve(address spender, uint256 value) returns (bool) {\n', '        if (safeSub(balances[msg.sender],value) < shouldHadBalance(msg.sender)) throw;\n', '        \n', '        // Abort if not in Success state.\n', '        allowed[msg.sender][spender] = value;\n', '        Approval(msg.sender, spender, value);\n', '        return true;\n', '    }\n', '\n', '    /// @param owner The address of the account owning tokens\n', '    /// @param spender The address of the account able to transfer the tokens\n', '    /// @return Amount of remaining tokens allowed to spent\n', '    function allowance(address owner, address spender) constant returns (uint) {\n', '        uint allow = allowed[owner][spender];\n', '        return allow;\n', '    }\n', '}\n', '\n', '\n', '\n', 'contract ownedPool {\n', '    address public owner;\n', '\n', '    function ownedPool() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) onlyOwner public {\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', '/**\n', ' * Asset pool contract\n', '*/\n', 'contract AssetPool is ownedPool {\n', '    uint  baseLockPercent;\n', '    uint  startLockTime;\n', '    uint  stopLockTime;\n', '    uint  linearRelease;\n', '    address public bpTokenAddress;\n', '\n', '    BPToken bp;\n', '\n', '    function AssetPool(address _bpTokenAddress, uint _baseLockPercent, uint _startLockTime, uint _stopLockTime, uint _linearRelease) {\n', '        assert(_stopLockTime > _startLockTime);\n', '        \n', '        baseLockPercent = _baseLockPercent;\n', '        startLockTime = _startLockTime;\n', '        stopLockTime = _stopLockTime;\n', '        linearRelease = _linearRelease;\n', '\n', '        bpTokenAddress = _bpTokenAddress;\n', '        bp = BPToken(bpTokenAddress);\n', '\n', '        owner = msg.sender;\n', '    }\n', '    \n', '    /// set role value\n', '    function setRule(uint _baseLockPercent, uint _startLockTime, uint _stopLockTime, uint _linearRelease) onlyOwner {\n', '        assert(_stopLockTime > _startLockTime);\n', '       \n', '        baseLockPercent = _baseLockPercent;\n', '        startLockTime = _startLockTime;\n', '        stopLockTime = _stopLockTime;\n', '        linearRelease = _linearRelease;\n', '    }\n', '\n', '    /// set bp token contract address\n', '    // function setBpToken(address _bpTokenAddress) onlyOwner {\n', '    //     bpTokenAddress = _bpTokenAddress;\n', '    //     bp = BPToken(bpTokenAddress);\n', '    // }\n', '    \n', '    /// assign BP token to another address\n', '    function assign(address to, uint256 amount) onlyOwner returns (bool) {\n', '        if (bp.setPoolAndAmount(to,amount)) {\n', '            if (bp.transfer(to,amount)) {\n', '                return true;\n', '            }\n', '        }\n', '        return false;\n', '    }\n', '\n', '    /// get the balance of current asset pool\n', '    function getPoolBalance() constant returns (uint) {\n', '        return bp.getBalance();\n', '    }\n', '    \n', '    function getStartLockTime() constant returns (uint) {\n', '        return startLockTime;\n', '    }\n', '    \n', '    function getStopLockTime() constant returns (uint) {\n', '        return stopLockTime;\n', '    }\n', '    \n', '    function getBaseLockPercent() constant returns (uint) {\n', '        return baseLockPercent;\n', '    }\n', '    \n', '    function getLinearRelease() constant returns (uint) {\n', '        return linearRelease;\n', '    }\n', '}']
['pragma solidity ^0.4.20;\n', '\n', '\n', '/*\n', ' * ERC20 interface\n', ' * see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 {\n', '    uint public totalSupply;\n', '    function balanceOf(address who) constant returns (uint);\n', '    function allowance(address owner, address spender) constant returns (uint);\n', '\n', '    function transfer(address to, uint value) returns (bool ok);\n', '    function transferFrom(address from, address to, uint value) returns (bool ok);\n', '    function approve(address spender, uint value) returns (bool ok);\n', '    event Transfer(address indexed from, address indexed to, uint value);\n', '    event Approval(address indexed owner, address indexed spender, uint value);\n', '}\n', '\n', '\n', '/**\n', ' * Math operations with safety checks\n', ' */\n', 'contract SafeMath {\n', '    function safeMul(uint a, uint b) internal returns (uint) {\n', '        uint c = a * b;\n', '        assert(a == 0 || c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function safeDiv(uint a, uint b) internal returns (uint) {\n', '        assert(b > 0);\n', '        uint c = a / b;\n', '        assert(a == b * c + a % b);\n', '        return c;\n', '    }\n', '\n', '    function safeSub(uint a, uint b) internal returns (uint) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function safeAdd(uint a, uint b) internal returns (uint) {\n', '        uint c = a + b;\n', '        assert(c >= a && c >= b);\n', '        return c;\n', '    }\n', '\n', '    function max64(uint64 a, uint64 b) internal constant returns (uint64) {\n', '        return a >= b ? a : b;\n', '    }\n', '\n', '    function min64(uint64 a, uint64 b) internal constant returns (uint64) {\n', '        return a < b ? a : b;\n', '    }\n', '\n', '    function max256(uint256 a, uint256 b) internal constant returns (uint256) {\n', '        return a >= b ? a : b;\n', '    }\n', '\n', '    function min256(uint256 a, uint256 b) internal constant returns (uint256) {\n', '        return a < b ? a : b;\n', '    }\n', '\n', '    function assert(bool assertion) internal {\n', '        if (!assertion) {\n', '            throw;\n', '        }\n', '    }\n', '\n', '}\n', '\n', '/**\n', ' * Owned contract\n', ' */\n', 'contract Owned {\n', '    address[] public pools;\n', '    address public owner;\n', '\n', '    function Owned() {\n', '        owner = msg.sender;\n', '        pools.push(msg.sender);\n', '    }\n', '\n', '    modifier onlyPool {\n', '        require(isPool(msg.sender));\n', '        _;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '    \n', '    /// add new pool address to pools\n', '    function addPool(address newPool) onlyOwner {\n', '        assert (newPool != 0);\n', '        if (isPool(newPool)) throw;\n', '        pools.push(newPool);\n', '    }\n', '    \n', '    /// remove a address from pools\n', '    function removePool(address pool) onlyOwner{\n', '        assert (pool != 0);\n', '        if (!isPool(pool)) throw;\n', '        \n', '        for (uint i=0; i<pools.length - 1; i++) {\n', '            if (pools[i] == pool) {\n', '                pools[i] = pools[pools.length - 1];\n', '                break;\n', '            }\n', '        }\n', '        pools.length -= 1;\n', '    }\n', '\n', '    function isPool(address pool) internal returns (bool ok){\n', '        for (uint i=0; i<pools.length; i++) {\n', '            if (pools[i] == pool)\n', '                return true;\n', '        }\n', '        return false;\n', '    }\n', '    \n', '    function transferOwnership(address newOwner) onlyOwner public {\n', '        removePool(owner);\n', '        addPool(newOwner);\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', '/**\n', ' * BP crowdsale contract\n', '*/\n', 'contract BPToken is SafeMath, Owned, ERC20 {\n', '    string public constant name = "Backpack Token";\n', '    string public constant symbol = "BP";\n', '    uint256 public constant decimals = 18;  \n', '\n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '\n', '    function BPToken() {\n', '        totalSupply = 2000000000 * 10 ** uint256(decimals);\n', '        balances[msg.sender] = totalSupply;\n', '    }\n', '\n', '    /// asset pool map\n', '    mapping (address => address) addressPool;\n', '\n', '    /// address base amount\n', '    mapping (address => uint256) addressAmount;\n', '\n', '    /// per month seconds\n', '    uint perMonthSecond = 2592000;\n', '    \n', '    /// calc the balance that the user shuold hold\n', '    function shouldHadBalance(address who) constant returns (uint256){\n', '        if (isPool(who)) return 0;\n', '\n', '        address apAddress = getAssetPoolAddress(who);\n', '        uint256 baseAmount  = getBaseAmount(who);\n', '\n', '        /// Does not belong to AssetPool contract\n', '        if( (apAddress == address(0)) || (baseAmount == 0) ) return 0;\n', '\n', '        /// Instantiate ap contract\n', '        AssetPool ap = AssetPool(apAddress);\n', '\n', '        uint startLockTime = ap.getStartLockTime();\n', '        uint stopLockTime = ap.getStopLockTime();\n', '\n', '        if (block.timestamp > stopLockTime) {\n', '            return 0;\n', '        }\n', '\n', '        if (ap.getBaseLockPercent() == 0) {\n', '            return 0;\n', '        }\n', '\n', '        // base lock amount \n', '        uint256 baseLockAmount = safeDiv(safeMul(baseAmount, ap.getBaseLockPercent()),100);\n', '        if (block.timestamp < startLockTime) {\n', '            return baseLockAmount;\n', '        }\n', '        \n', '        /// will not linear release\n', '        if (ap.getLinearRelease() == 0) {\n', '            if (block.timestamp < stopLockTime) {\n', '                return baseLockAmount;\n', '            } else {\n', '                return 0;\n', '            }\n', '        }\n', '        /// will linear release \n', '\n', '        /// now timestamp before start lock time \n', '        if (block.timestamp < startLockTime + perMonthSecond) {\n', '            return baseLockAmount;\n', '        }\n', '        // total lock months\n', '        uint lockMonth = safeDiv(safeSub(stopLockTime,startLockTime),perMonthSecond);\n', '        if (lockMonth <= 0) {\n', '            if (block.timestamp >= stopLockTime) {\n', '                return 0;\n', '            } else {\n', '                return baseLockAmount;\n', '            }\n', '        }\n', '\n', '        // unlock amount of every month\n', '        uint256 monthUnlockAmount = safeDiv(baseLockAmount,lockMonth);\n', '\n', '        // current timestamp passed month \n', '        uint hadPassMonth = safeDiv(safeSub(block.timestamp,startLockTime),perMonthSecond);\n', '\n', '        return safeSub(baseLockAmount,safeMul(hadPassMonth,monthUnlockAmount));\n', '    }\n', '\n', '    function getAssetPoolAddress(address who) internal returns(address){\n', '        return addressPool[who];\n', '    }\n', '\n', '    function getBaseAmount(address who) internal returns(uint256){\n', '        return addressAmount[who];\n', '    }\n', '\n', '    function getBalance() constant returns(uint){\n', '        return balances[msg.sender];\n', '    }\n', '\n', '    function setPoolAndAmount(address who, uint256 amount) onlyPool returns (bool) {\n', '        assert(balances[msg.sender] >= amount);\n', '\n', '        if (owner == who) {\n', '            return true;\n', '        }\n', '        \n', '        address apAddress = getAssetPoolAddress(who);\n', '        uint256 baseAmount = getBaseAmount(who);\n', '\n', '        assert((apAddress == msg.sender) || (baseAmount == 0));\n', '\n', '        addressPool[who] = msg.sender;\n', '        addressAmount[who] += amount;\n', '\n', '        return true;\n', '    }\n', '\n', '    /// get balance of the special address\n', '    function balanceOf(address who) constant returns (uint) {\n', '        return balances[who];\n', '    }\n', '\n', "    /// @notice Transfer `value` BP tokens from sender's account\n", '    /// `msg.sender` to provided account address `to`.\n', '    /// @notice This function is disabled during the funding.\n', '    /// @dev Required state: Success\n', '    /// @param to The address of the recipient\n', '    /// @param value The number of BPs to transfer\n', '    /// @return Whether the transfer was successful or not\n', '    function transfer(address to, uint256 value) returns (bool) {\n', '        if (safeSub(balances[msg.sender],value) < shouldHadBalance(msg.sender)) throw;\n', '\n', '        uint256 senderBalance = balances[msg.sender];\n', '        if (senderBalance >= value && value > 0) {\n', '            senderBalance = safeSub(senderBalance, value);\n', '            balances[msg.sender] = senderBalance;\n', '            balances[to] = safeAdd(balances[to], value);\n', '            Transfer(msg.sender, to, value);\n', '            return true;\n', '        } else {\n', '            throw;\n', '        }\n', '    }\n', '\n', "    /// @notice Transfer `value` BP tokens from sender 'from'\n", '    /// to provided account address `to`.\n', '    /// @notice This function is disabled during the funding.\n', '    /// @dev Required state: Success\n', '    /// @param from The address of the sender\n', '    /// @param to The address of the recipient\n', '    /// @param value The number of BPs to transfer\n', '    /// @return Whether the transfer was successful or not\n', '    function transferFrom(address from, address to, uint256 value) returns (bool) {\n', '        // Abort if not in Success state.\n', '        // protect against wrapping uints\n', '        if (balances[from] >= value &&\n', '        allowed[from][msg.sender] >= value &&\n', '        safeAdd(balances[to], value) > balances[to])\n', '        {\n', '            balances[to] = safeAdd(balances[to], value);\n', '            balances[from] = safeSub(balances[from], value);\n', '            allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], value);\n', '            Transfer(from, to, value);\n', '            return true;\n', '        } else {\n', '            throw;\n', '        }\n', '    }\n', '\n', '    /// @notice `msg.sender` approves `spender` to spend `value` tokens\n', '    /// @param spender The address of the account able to transfer the tokens\n', '    /// @param value The amount of wei to be approved for transfer\n', '    /// @return Whether the approval was successful or not\n', '    function approve(address spender, uint256 value) returns (bool) {\n', '        if (safeSub(balances[msg.sender],value) < shouldHadBalance(msg.sender)) throw;\n', '        \n', '        // Abort if not in Success state.\n', '        allowed[msg.sender][spender] = value;\n', '        Approval(msg.sender, spender, value);\n', '        return true;\n', '    }\n', '\n', '    /// @param owner The address of the account owning tokens\n', '    /// @param spender The address of the account able to transfer the tokens\n', '    /// @return Amount of remaining tokens allowed to spent\n', '    function allowance(address owner, address spender) constant returns (uint) {\n', '        uint allow = allowed[owner][spender];\n', '        return allow;\n', '    }\n', '}\n', '\n', '\n', '\n', 'contract ownedPool {\n', '    address public owner;\n', '\n', '    function ownedPool() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) onlyOwner public {\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', '/**\n', ' * Asset pool contract\n', '*/\n', 'contract AssetPool is ownedPool {\n', '    uint  baseLockPercent;\n', '    uint  startLockTime;\n', '    uint  stopLockTime;\n', '    uint  linearRelease;\n', '    address public bpTokenAddress;\n', '\n', '    BPToken bp;\n', '\n', '    function AssetPool(address _bpTokenAddress, uint _baseLockPercent, uint _startLockTime, uint _stopLockTime, uint _linearRelease) {\n', '        assert(_stopLockTime > _startLockTime);\n', '        \n', '        baseLockPercent = _baseLockPercent;\n', '        startLockTime = _startLockTime;\n', '        stopLockTime = _stopLockTime;\n', '        linearRelease = _linearRelease;\n', '\n', '        bpTokenAddress = _bpTokenAddress;\n', '        bp = BPToken(bpTokenAddress);\n', '\n', '        owner = msg.sender;\n', '    }\n', '    \n', '    /// set role value\n', '    function setRule(uint _baseLockPercent, uint _startLockTime, uint _stopLockTime, uint _linearRelease) onlyOwner {\n', '        assert(_stopLockTime > _startLockTime);\n', '       \n', '        baseLockPercent = _baseLockPercent;\n', '        startLockTime = _startLockTime;\n', '        stopLockTime = _stopLockTime;\n', '        linearRelease = _linearRelease;\n', '    }\n', '\n', '    /// set bp token contract address\n', '    // function setBpToken(address _bpTokenAddress) onlyOwner {\n', '    //     bpTokenAddress = _bpTokenAddress;\n', '    //     bp = BPToken(bpTokenAddress);\n', '    // }\n', '    \n', '    /// assign BP token to another address\n', '    function assign(address to, uint256 amount) onlyOwner returns (bool) {\n', '        if (bp.setPoolAndAmount(to,amount)) {\n', '            if (bp.transfer(to,amount)) {\n', '                return true;\n', '            }\n', '        }\n', '        return false;\n', '    }\n', '\n', '    /// get the balance of current asset pool\n', '    function getPoolBalance() constant returns (uint) {\n', '        return bp.getBalance();\n', '    }\n', '    \n', '    function getStartLockTime() constant returns (uint) {\n', '        return startLockTime;\n', '    }\n', '    \n', '    function getStopLockTime() constant returns (uint) {\n', '        return stopLockTime;\n', '    }\n', '    \n', '    function getBaseLockPercent() constant returns (uint) {\n', '        return baseLockPercent;\n', '    }\n', '    \n', '    function getLinearRelease() constant returns (uint) {\n', '        return linearRelease;\n', '    }\n', '}']