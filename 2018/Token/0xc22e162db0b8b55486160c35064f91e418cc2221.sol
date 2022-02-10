['pragma solidity ^0.4.16;\n', '\n', '/**\n', '\n', ' * Math operations with safety checks\n', '\n', ' */\n', '\n', 'contract BaseSafeMath {\n', '\n', '\n', '    /*\n', '\n', '    standard uint256 functions\n', '\n', '     */\n', '\n', '\n', '\n', '    function add(uint256 a, uint256 b) constant internal\n', '\n', '    returns (uint256) {\n', '\n', '        uint256 c = a + b;\n', '\n', '        assert(c >= a);\n', '\n', '        return c;\n', '\n', '    }\n', '\n', '\n', '    function sub(uint256 a, uint256 b) constant internal\n', '\n', '    returns (uint256) {\n', '\n', '        assert(b <= a);\n', '\n', '        return a - b;\n', '\n', '    }\n', '\n', '\n', '    function mul(uint256 a, uint256 b) constant internal\n', '\n', '    returns (uint256) {\n', '\n', '        uint256 c = a * b;\n', '\n', '        assert(a == 0 || c / a == b);\n', '\n', '        return c;\n', '\n', '    }\n', '\n', '\n', '    function div(uint256 a, uint256 b) constant internal\n', '\n', '    returns (uint256) {\n', '\n', '        uint256 c = a / b;\n', '\n', '        return c;\n', '\n', '    }\n', '\n', '\n', '    function min(uint256 x, uint256 y) constant internal\n', '\n', '    returns (uint256 z) {\n', '\n', '        return x <= y ? x : y;\n', '\n', '    }\n', '\n', '\n', '    function max(uint256 x, uint256 y) constant internal\n', '\n', '    returns (uint256 z) {\n', '\n', '        return x >= y ? x : y;\n', '\n', '    }\n', '\n', '\n', '\n', '    /*\n', '\n', '    uint128 functions\n', '\n', '     */\n', '\n', '\n', '\n', '    function madd(uint128 a, uint128 b) constant internal\n', '\n', '    returns (uint128) {\n', '\n', '        uint128 c = a + b;\n', '\n', '        assert(c >= a);\n', '\n', '        return c;\n', '\n', '    }\n', '\n', '\n', '    function msub(uint128 a, uint128 b) constant internal\n', '\n', '    returns (uint128) {\n', '\n', '        assert(b <= a);\n', '\n', '        return a - b;\n', '\n', '    }\n', '\n', '\n', '    function mmul(uint128 a, uint128 b) constant internal\n', '\n', '    returns (uint128) {\n', '\n', '        uint128 c = a * b;\n', '\n', '        assert(a == 0 || c / a == b);\n', '\n', '        return c;\n', '\n', '    }\n', '\n', '\n', '    function mdiv(uint128 a, uint128 b) constant internal\n', '\n', '    returns (uint128) {\n', '\n', '        uint128 c = a / b;\n', '\n', '        return c;\n', '\n', '    }\n', '\n', '\n', '    function mmin(uint128 x, uint128 y) constant internal\n', '\n', '    returns (uint128 z) {\n', '\n', '        return x <= y ? x : y;\n', '\n', '    }\n', '\n', '\n', '    function mmax(uint128 x, uint128 y) constant internal\n', '\n', '    returns (uint128 z) {\n', '\n', '        return x >= y ? x : y;\n', '\n', '    }\n', '\n', '\n', '\n', '    /*\n', '\n', '    uint64 functions\n', '\n', '     */\n', '\n', '\n', '\n', '    function miadd(uint64 a, uint64 b) constant internal\n', '\n', '    returns (uint64) {\n', '\n', '        uint64 c = a + b;\n', '\n', '        assert(c >= a);\n', '\n', '        return c;\n', '\n', '    }\n', '\n', '\n', '    function misub(uint64 a, uint64 b) constant internal\n', '\n', '    returns (uint64) {\n', '\n', '        assert(b <= a);\n', '\n', '        return a - b;\n', '\n', '    }\n', '\n', '\n', '    function mimul(uint64 a, uint64 b) constant internal\n', '\n', '    returns (uint64) {\n', '\n', '        uint64 c = a * b;\n', '\n', '        assert(a == 0 || c / a == b);\n', '\n', '        return c;\n', '\n', '    }\n', '\n', '\n', '    function midiv(uint64 a, uint64 b) constant internal\n', '\n', '    returns (uint64) {\n', '\n', '        uint64 c = a / b;\n', '\n', '        return c;\n', '\n', '    }\n', '\n', '\n', '    function mimin(uint64 x, uint64 y) constant internal\n', '\n', '    returns (uint64 z) {\n', '\n', '        return x <= y ? x : y;\n', '\n', '    }\n', '\n', '\n', '    function mimax(uint64 x, uint64 y) constant internal\n', '\n', '    returns (uint64 z) {\n', '\n', '        return x >= y ? x : y;\n', '\n', '    }\n', '\n', '\n', '}\n', '\n', '\n', '// Abstract contract for the full ERC 20 Token standard\n', '\n', '// https://github.com/ethereum/EIPs/issues/20\n', '\n', '\n', '\n', 'contract BaseERC20 {\n', '\n', '    // Public variables of the token\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals;\n', '    // 18 decimals is the strongly suggested default, avoid changing it\n', '    uint256 public totalSupply;\n', '\n', '    // This creates an array with all balances\n', '    mapping(address => uint256) public balanceOf;\n', '    mapping(address => mapping(address => uint256)) public allowance;\n', '\n', '    // This generates a public event on the blockchain that will notify clients\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    // This notifies clients about the amount burnt\n', '    event Burn(address indexed from, uint256 value);\n', '\n', '    /**\n', '     * Internal transfer, only can be called by this contract\n', '     */\n', '    function _transfer(address _from, address _to, uint _value) internal;\n', '\n', '    /**\n', '     * Transfer tokens\n', '     *\n', '     * Send `_value` tokens to `_to` from your account\n', '     *\n', '     * @param _to The address of the recipient\n', '     * @param _value the amount to send\n', '     */\n', '    function transfer(address _to, uint256 _value) public;\n', '\n', '    /**\n', '     * Transfer tokens from other address\n', '     *\n', '     * Send `_value` tokens to `_to` on behalf of `_from`\n', '     *\n', '     * @param _from The address of the sender\n', '     * @param _to The address of the recipient\n', '     * @param _value the amount to send\n', '     */\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);\n', '\n', '    /**\n', '     * Set allowance for other address\n', '     *\n', '     * Allows `_spender` to spend no more than `_value` tokens on your behalf\n', '     *\n', '     * @param _spender The address authorized to spend\n', '     * @param _value the max amount they can spend\n', '     */\n', '    function approve(address _spender, uint256 _value) public returns (bool success);\n', '\n', '    /**\n', '     * Set allowance for other address and notify\n', '     *\n', '     * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it\n', '     *\n', '     * @param _spender The address authorized to spend\n', '     * @param _value the max amount they can spend\n', '     * @param _extraData some extra information to send to the approved contract\n', '     */\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success);\n', '\n', '    /**\n', '     * Destroy tokens\n', '     *\n', '     * Remove `_value` tokens from the system irreversibly\n', '     *\n', '     * @param _value the amount of money to burn\n', '     */\n', '    function burn(uint256 _value) public returns (bool success);\n', '\n', '    /**\n', '     * Destroy tokens from other account\n', '     *\n', '     * Remove `_value` tokens from the system irreversibly on behalf of `_from`.\n', '     *\n', '     * @param _from the address of the sender\n', '     * @param _value the amount of money to burn\n', '     */\n', '    function burnFrom(address _from, uint256 _value) public returns (bool success);\n', '\n', '}\n', '\n', '\n', '/**\n', '\n', ' * @title Standard ERC20 token\n', '\n', ' *\n', '\n', ' * @dev Implementation of the basic standard token.\n', '\n', ' * @dev https://github.com/ethereum/EIPs/issues/20\n', '\n', ' * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', '\n', ' */\n', '\n', 'interface tokenRecipient {function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public;}\n', '\n', 'contract LockUtils {\n', '\n', '    address developer = 0x0;\n', '    uint8 public decimals = 18;// 精度为18\n', '    uint256 public createTime = now;// 创建时间\n', '\n', '    function LockUtils(address develop) public {\n', '        developer = develop;\n', '    }\n', '\n', '    function getLockWFee() public returns (uint256){\n', '        if (msg.sender != developer) {\n', '            return 0;\n', '        }\n', '        if (now < createTime + 30 minutes) {\n', '            return 1400000000 * 10 ** uint256(decimals);\n', '        } else if (now < createTime + 2 years) {\n', '            return 1500000000 * 10 ** uint256(decimals);\n', '        } else if (now < createTime + 2 years + 6 * 30 days) {\n', '            return 1125000000 * 10 ** uint256(decimals);\n', '        } else if (now < createTime + 3 years) {\n', '            return 750000000 * 10 ** uint256(decimals);\n', '        } else if (now < createTime + 3 years + 6 * 30 days) {\n', '            return 375000000 * 10 ** uint256(decimals);\n', '        } else {\n', '            return 0;\n', '        }\n', '    }\n', '\n', '}\n', '\n', 'contract WFee is BaseERC20, BaseSafeMath {\n', '    string public name = "WFee";\n', '    string public symbol = "WFEE";\n', '    uint8 public decimals = 18;// 精度为18\n', '    uint256 public totalSupply;// 100亿 构造方法初始化\n', '    LockUtils lockUtils;\n', '    mapping(address => uint256) public balanceOf;\n', '    mapping(address => mapping(address => uint256)) public allowance;\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Burn(address indexed from, uint256 value);\n', '\n', '    function WFee() public {\n', '        lockUtils = LockUtils(msg.sender);\n', '        totalSupply = 10000000000 * 10 ** uint256(decimals);\n', '        balanceOf[msg.sender] = totalSupply;\n', '        //        // 30% 基石和私募\n', '        //        transfer(0x09bde321606fb0d735e05f4f5bc4683460a9aa61, 3000000000 * 10 ** uint256(decimals));\n', '        //        // 35% 生态激励\n', '        //        transfer(0x09bde321606fb0d735e05f4f5bc4683460a9aa62, 3500000000 * 10 ** uint256(decimals));\n', '        //        // 10% 基础设施建设\n', '        //        transfer(0x09bde321606fb0d735e05f4f5bc4683460a9aa63, 1000000000 * 10 ** uint256(decimals));\n', '        //        // 10% 基金会的发展备用金\n', '        //        transfer(0x09bde321606fb0d735e05f4f5bc4683460a9aa64, 1000000000 * 10 ** uint256(decimals));\n', '        //        // 剩余的 15% 创始团队奖励分发\n', '    }\n', '\n', '    function _transfer(address _from, address _to, uint _value) internal {\n', '        // Prevent transfer to 0x0 address. Use burn() instead\n', '        require(_to != 0x0);\n', '        // Check if the sender has enough\n', '        // 转账必由之路，锁定的钱不可动\n', '        require((balanceOf[_from] - lockUtils.getLockWFee()) >= _value);\n', '        // Check for overflows\n', '        require(balanceOf[_to] + _value > balanceOf[_to]);\n', '        // Save this for an assertion in the future\n', '        uint previousBalances = balanceOf[_from] + balanceOf[_to];\n', '        // Subtract from the sender\n', '        balanceOf[_from] -= _value;\n', '        // Add the same to the recipient\n', '        balanceOf[_to] += _value;\n', '        Transfer(_from, _to, _value);\n', '        // Asserts are used to use static analysis to find bugs in your code. They should never fail\n', '        assert(balanceOf[_from] + balanceOf[_to] == previousBalances);\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) public {\n', '        _transfer(msg.sender, _to, _value);\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        require(_value <= allowance[_from][msg.sender]);\n', '        // Check allowance\n', '        allowance[_from][msg.sender] -= _value;\n', '        _transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public\n', '    returns (bool success) {\n', '        allowance[msg.sender][_spender] = _value;\n', '        return true;\n', '    }\n', '\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData)\n', '    public\n', '    returns (bool success) {\n', '        tokenRecipient spender = tokenRecipient(_spender);\n', '        if (approve(_spender, _value)) {\n', '            spender.receiveApproval(msg.sender, _value, this, _extraData);\n', '            return true;\n', '        }\n', '    }\n', '\n', '    function burn(uint256 _value) public returns (bool success) {\n', '        require(balanceOf[msg.sender] >= _value);\n', '        // Check if the sender has enough\n', '        balanceOf[msg.sender] -= _value;\n', '        // Subtract from the sender\n', '        totalSupply -= _value;\n', '        // Updates totalSupply\n', '        Burn(msg.sender, _value);\n', '        return true;\n', '    }\n', '\n', '    function burnFrom(address _from, uint256 _value) public returns (bool success) {\n', '        require(balanceOf[_from] >= _value);\n', '        // Check if the targeted balance is enough\n', '        require(_value <= allowance[_from][msg.sender]);\n', '        // Check allowance\n', '        balanceOf[_from] -= _value;\n', '        // Subtract from the targeted balance\n', '        allowance[_from][msg.sender] -= _value;\n', "        // Subtract from the sender's allowance\n", '        totalSupply -= _value;\n', '        // Update totalSupply\n', '        Burn(_from, _value);\n', '        return true;\n', '    }\n', '\n', '}']