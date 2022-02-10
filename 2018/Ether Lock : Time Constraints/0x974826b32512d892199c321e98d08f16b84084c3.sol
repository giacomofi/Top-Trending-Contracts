['pragma solidity ^0.4.16;\n', '\n', '/**\n', '\n', ' * Math operations with safety checks\n', '\n', ' */\n', '\n', 'contract BaseSafeMath {\n', '\n', '\n', '    /*\n', '\n', '    standard uint256 functions\n', '\n', '     */\n', '\n', '\n', '\n', '    function add(uint256 a, uint256 b) internal pure\n', '\n', '    returns (uint256) {\n', '\n', '        uint256 c = a + b;\n', '\n', '        assert(c >= a);\n', '\n', '        return c;\n', '\n', '    }\n', '\n', '\n', '    function sub(uint256 a, uint256 b) internal pure\n', '\n', '    returns (uint256) {\n', '\n', '        assert(b <= a);\n', '\n', '        return a - b;\n', '\n', '    }\n', '\n', '\n', '    function mul(uint256 a, uint256 b) internal pure\n', '\n', '    returns (uint256) {\n', '\n', '        uint256 c = a * b;\n', '\n', '        assert(a == 0 || c / a == b);\n', '\n', '        return c;\n', '\n', '    }\n', '\n', '\n', '    function div(uint256 a, uint256 b) internal pure\n', '\n', '    returns (uint256) {\n', '\n', '        uint256 c = a / b;\n', '\n', '        return c;\n', '\n', '    }\n', '\n', '\n', '    function min(uint256 x, uint256 y) internal pure\n', '\n', '    returns (uint256 z) {\n', '\n', '        return x <= y ? x : y;\n', '\n', '    }\n', '\n', '\n', '    function max(uint256 x, uint256 y) internal pure\n', '\n', '    returns (uint256 z) {\n', '\n', '        return x >= y ? x : y;\n', '\n', '    }\n', '\n', '\n', '\n', '    /*\n', '\n', '    uint128 functions\n', '\n', '     */\n', '\n', '\n', '\n', '    function madd(uint128 a, uint128 b) internal pure\n', '\n', '    returns (uint128) {\n', '\n', '        uint128 c = a + b;\n', '\n', '        assert(c >= a);\n', '\n', '        return c;\n', '\n', '    }\n', '\n', '\n', '    function msub(uint128 a, uint128 b) internal pure\n', '\n', '    returns (uint128) {\n', '\n', '        assert(b <= a);\n', '\n', '        return a - b;\n', '\n', '    }\n', '\n', '\n', '    function mmul(uint128 a, uint128 b) internal pure\n', '\n', '    returns (uint128) {\n', '\n', '        uint128 c = a * b;\n', '\n', '        assert(a == 0 || c / a == b);\n', '\n', '        return c;\n', '\n', '    }\n', '\n', '\n', '    function mdiv(uint128 a, uint128 b) internal pure\n', '\n', '    returns (uint128) {\n', '\n', '        uint128 c = a / b;\n', '\n', '        return c;\n', '\n', '    }\n', '\n', '\n', '    function mmin(uint128 x, uint128 y) internal pure\n', '\n', '    returns (uint128 z) {\n', '\n', '        return x <= y ? x : y;\n', '\n', '    }\n', '\n', '\n', '    function mmax(uint128 x, uint128 y) internal pure\n', '\n', '    returns (uint128 z) {\n', '\n', '        return x >= y ? x : y;\n', '\n', '    }\n', '\n', '\n', '\n', '    /*\n', '\n', '    uint64 functions\n', '\n', '     */\n', '\n', '\n', '\n', '    function miadd(uint64 a, uint64 b) internal pure\n', '\n', '    returns (uint64) {\n', '\n', '        uint64 c = a + b;\n', '\n', '        assert(c >= a);\n', '\n', '        return c;\n', '\n', '    }\n', '\n', '\n', '    function misub(uint64 a, uint64 b) internal pure\n', '\n', '    returns (uint64) {\n', '\n', '        assert(b <= a);\n', '\n', '        return a - b;\n', '\n', '    }\n', '\n', '\n', '    function mimul(uint64 a, uint64 b) internal pure\n', '\n', '    returns (uint64) {\n', '\n', '        uint64 c = a * b;\n', '\n', '        assert(a == 0 || c / a == b);\n', '\n', '        return c;\n', '\n', '    }\n', '\n', '\n', '    function midiv(uint64 a, uint64 b) internal pure\n', '\n', '    returns (uint64) {\n', '\n', '        uint64 c = a / b;\n', '\n', '        return c;\n', '\n', '    }\n', '\n', '\n', '    function mimin(uint64 x, uint64 y) internal pure\n', '\n', '    returns (uint64 z) {\n', '\n', '        return x <= y ? x : y;\n', '\n', '    }\n', '\n', '\n', '    function mimax(uint64 x, uint64 y) internal pure\n', '\n', '    returns (uint64 z) {\n', '\n', '        return x >= y ? x : y;\n', '\n', '    }\n', '\n', '\n', '}\n', '\n', '\n', '// Abstract contract for the full ERC 20 Token standard\n', '\n', '// https://github.com/ethereum/EIPs/issues/20\n', '\n', 'contract BaseERC20 {\n', '\n', '    // Public variables of the token\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals;\n', '    // 18 decimals is the strongly suggested default, avoid changing it\n', '    uint256 public totalSupply;\n', '\n', '    // This creates an array with all balances\n', '    mapping(address => uint256) public balanceOf;\n', '    mapping(address => mapping(address => uint256)) public allowance;\n', '\n', '    // This generates a public event on the blockchain that will notify clients\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    /**\n', '     * Internal transfer, only can be called by this contract\n', '     */\n', '    function _transfer(address _from, address _to, uint _value) internal;\n', '\n', '    /**\n', '     * Transfer tokens\n', '     *\n', '     * Send `_value` tokens to `_to` from your account\n', '     *\n', '     * @param _to The address of the recipient\n', '     * @param _value the amount to send\n', '     */\n', '    function transfer(address _to, uint256 _value) public;\n', '\n', '    /**\n', '     * Transfer tokens from other address\n', '     *\n', '     * Send `_value` tokens to `_to` on behalf of `_from`\n', '     *\n', '     * @param _from The address of the sender\n', '     * @param _to The address of the recipient\n', '     * @param _value the amount to send\n', '     */\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);\n', '\n', '    /**\n', '     * Set allowance for other address\n', '     *\n', '     * Allows `_spender` to spend no more than `_value` tokens on your behalf\n', '     *\n', '     * @param _spender The address authorized to spend\n', '     * @param _value the max amount they can spend\n', '     */\n', '    function approve(address _spender, uint256 _value) public returns (bool success);\n', '\n', '    /**\n', '     * Set allowance for other address and notify\n', '     *\n', '     * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it\n', '     *\n', '     * @param _spender The address authorized to spend\n', '     * @param _value the max amount they can spend\n', '     * @param _extraData some extra information to send to the approved contract\n', '     */\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success);\n', '\n', '}\n', '\n', '\n', '/**\n', '\n', ' * @title Standard ERC20 token\n', '\n', ' *\n', '\n', ' * @dev Implementation of the basic standard token.\n', '\n', ' * @dev https://github.com/ethereum/EIPs/issues/20\n', '\n', ' * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', '\n', ' */\n', '\n', 'interface tokenRecipient {function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public;}\n', '\n', '\n', 'contract LockUtils {\n', '    // Advance mining\n', '    address advance_mining = 0x5EDBe36c4c4a816f150959B445d5Ae1F33054a82;\n', '    // community\n', '    address community = 0xacF2e917E296547C0C476fDACf957111ca0307ce;\n', '    // foundation_investment\n', '    address foundation_investment = 0x9746079BEbcFfFf177818e23AedeC834ad0fb5f9;\n', '    // mining\n', '    address mining = 0xBB7d6f428E77f98069AE1E01964A9Ed6db3c5Fe5;\n', '    // adviser\n', '    address adviser = 0x0aE269Ae5F511786Fce5938c141DbF42e8A71E12;\n', '    // unlock start time 2018-09-10\n', '    uint256 unlock_time_0910 = 1536508800;\n', '    // unlock start time 2018-10-10\n', '    uint256 unlock_time_1010 = 1539100800;\n', '    // unlock start time 2018-11-10\n', '    uint256 unlock_time_1110 = 1541779200;\n', '    // unlock start time 2018-12-10\n', '    uint256 unlock_time_1210 = 1544371200;\n', '    // unlock start time 2019-01-10\n', '    uint256 unlock_time_0110 = 1547049600;\n', '    // unlock start time 2019-02-10\n', '    uint256 unlock_time_0210 = 1549728000;\n', '    // unlock start time 2019-03-10\n', '    uint256 unlock_time_0310 = 1552147200;\n', '    // unlock start time 2019-04-10\n', '    uint256 unlock_time_0410 = 1554825600;\n', '    // unlock start time 2019-05-10\n', '    uint256 unlock_time_0510 = 1557417600;\n', '    // unlock start time 2019-06-10\n', '    uint256 unlock_time_0610 = 1560096000;\n', '    // unlock start time 2019-07-10\n', '    uint256 unlock_time_0710 = 1562688000;\n', '    // unlock start time 2019-08-10\n', '    uint256 unlock_time_0810 = 1565366400;\n', '    // unlock start time 2019-09-10\n', '    uint256 unlock_time_end  = 1568044800;\n', '    // 1 monthss\n', '    uint256 time_months = 2678400;\n', '    // xxx\n', '    function getLockBalance(address account, uint8 decimals) internal view returns (uint256) {\n', '        uint256 tempLock = 0;\n', '        if (account == advance_mining) {\n', '            if (now < unlock_time_0910) {\n', '                tempLock = 735000000 * 10 ** uint256(decimals);\n', '            } else if (now >= unlock_time_0910 && now < unlock_time_1210) {\n', '                tempLock = 367500000 * 10 ** uint256(decimals);\n', '            } else if (now >= unlock_time_1210 && now < unlock_time_0310) {\n', '                tempLock = 183750000 * 10 ** uint256(decimals);\n', '            }\n', '        } else if (account == community) {\n', '            if (now < unlock_time_0910) {\n', '                tempLock = 18375000 * 6 * 10 ** uint256(decimals);\n', '            } else if (now >= unlock_time_0910 && now < unlock_time_1010) {\n', '                tempLock = 18375000 * 5 * 10 ** uint256(decimals);\n', '            } else if (now >= unlock_time_1010 && now < unlock_time_1110) {\n', '                tempLock = 18375000 * 4 * 10 ** uint256(decimals);\n', '            } else if (now >= unlock_time_1110 && now < unlock_time_1210) {\n', '                tempLock = 18375000 * 3 * 10 ** uint256(decimals);\n', '            } else if (now >= unlock_time_1210 && now < unlock_time_0110) {\n', '                tempLock = 18375000 * 2 * 10 ** uint256(decimals);\n', '            } else if (now >= unlock_time_0110 && now < unlock_time_0210) {\n', '                tempLock = 18375000 * 1 * 10 ** uint256(decimals);\n', '            }\n', '        } else if (account == foundation_investment) {\n', '            if (now < unlock_time_0910) {\n', '                tempLock = 18812500 * 12 * 10 ** uint256(decimals);\n', '            } else if (now >= unlock_time_0910 && now < unlock_time_1010) {\n', '                tempLock = 18812500 * 11 * 10 ** uint256(decimals);\n', '            } else if (now >= unlock_time_1010 && now < unlock_time_1110) {\n', '                tempLock = 18812500 * 10 * 10 ** uint256(decimals);\n', '            } else if (now >= unlock_time_1110 && now < unlock_time_1210) {\n', '                tempLock = 18812500 * 9 * 10 ** uint256(decimals);\n', '            } else if (now >= unlock_time_1210 && now < unlock_time_0110) {\n', '                tempLock = 18812500 * 8 * 10 ** uint256(decimals);\n', '            } else if (now >= unlock_time_0110 && now < unlock_time_0210) {\n', '                tempLock = 18812500 * 7 * 10 ** uint256(decimals);\n', '            } else if (now >= unlock_time_0210 && now < unlock_time_0310) {\n', '                tempLock = 18812500 * 6 * 10 ** uint256(decimals);\n', '            } else if (now >= unlock_time_0310 && now < unlock_time_0410) {\n', '                tempLock = 18812500 * 5 * 10 ** uint256(decimals);\n', '            } else if (now >= unlock_time_0410 && now < unlock_time_0510) {\n', '                tempLock = 18812500 * 4 * 10 ** uint256(decimals);\n', '            } else if (now >= unlock_time_0510 && now < unlock_time_0610) {\n', '                tempLock = 18812500 * 3 * 10 ** uint256(decimals);\n', '            } else if (now >= unlock_time_0610 && now < unlock_time_0710) {\n', '                tempLock = 18812500 * 2 * 10 ** uint256(decimals);\n', '            } else if (now >= unlock_time_0710 && now < unlock_time_0810) {\n', '                tempLock = 18812500 * 1 * 10 ** uint256(decimals);\n', '            }\n', '        } else if (account == mining) {\n', '            if (now < unlock_time_0910) {\n', '                tempLock = 840000000 * 10 ** uint256(decimals);\n', '            }\n', '        } else if (account == adviser) {\n', '            if (now < unlock_time_0910) {\n', '                tempLock = 15750000 * 12 * 10 ** uint256(decimals);\n', '            } else if (now >= unlock_time_0910 && now < unlock_time_1010) {\n', '                tempLock = 15750000 * 11 * 10 ** uint256(decimals);\n', '            } else if (now >= unlock_time_1010 && now < unlock_time_1110) {\n', '                tempLock = 15750000 * 10 * 10 ** uint256(decimals);\n', '            } else if (now >= unlock_time_1110 && now < unlock_time_1210) {\n', '                tempLock = 15750000 * 9 * 10 ** uint256(decimals);\n', '            } else if (now >= unlock_time_1210 && now < unlock_time_0110) {\n', '                tempLock = 15750000 * 8 * 10 ** uint256(decimals);\n', '            } else if (now >= unlock_time_0110 && now < unlock_time_0210) {\n', '                tempLock = 15750000 * 7 * 10 ** uint256(decimals);\n', '            } else if (now >= unlock_time_0210 && now < unlock_time_0310) {\n', '                tempLock = 15750000 * 6 * 10 ** uint256(decimals);\n', '            } else if (now >= unlock_time_0310 && now < unlock_time_0410) {\n', '                tempLock = 15750000 * 5 * 10 ** uint256(decimals);\n', '            } else if (now >= unlock_time_0410 && now < unlock_time_0510) {\n', '                tempLock = 15750000 * 4 * 10 ** uint256(decimals);\n', '            } else if (now >= unlock_time_0510 && now < unlock_time_0610) {\n', '                tempLock = 15750000 * 3 * 10 ** uint256(decimals);\n', '            } else if (now >= unlock_time_0610 && now < unlock_time_0710) {\n', '                tempLock = 15750000 * 2 * 10 ** uint256(decimals);\n', '            } else if (now >= unlock_time_0710 && now < unlock_time_0810) {\n', '                tempLock = 15750000 * 1 * 10 ** uint256(decimals);\n', '            }\n', '        }\n', '        return tempLock;\n', '    }\n', '}\n', '\n', 'contract PDTToken is BaseERC20, BaseSafeMath, LockUtils {\n', '\n', '    //The solidity created time\n', '    \n', '\n', '    function PDTToken() public {\n', '        name = "Matrix World";\n', '        symbol = "PDT";\n', '        decimals = 18;\n', '        totalSupply = 2100000000 * 10 ** uint256(decimals);\n', '        // balanceOf[msg.sender] = totalSupply;\n', '        balanceOf[0x5EDBe36c4c4a816f150959B445d5Ae1F33054a82] = 735000000 * 10 ** uint256(decimals);\n', '        balanceOf[0xacF2e917E296547C0C476fDACf957111ca0307ce] = 110250000 * 10 ** uint256(decimals);\n', '        balanceOf[0x9746079BEbcFfFf177818e23AedeC834ad0fb5f9] = 225750000 * 10 ** uint256(decimals);\n', '        balanceOf[0xBB7d6f428E77f98069AE1E01964A9Ed6db3c5Fe5] = 840000000 * 10 ** uint256(decimals);\n', '        balanceOf[0x0aE269Ae5F511786Fce5938c141DbF42e8A71E12] = 189000000 * 10 ** uint256(decimals);\n', '    }\n', '\n', '    function _transfer(address _from, address _to, uint _value) internal {\n', '        // Prevent transfer to 0x0 address. Use burn() instead\n', '        require(_to != 0x0);\n', '        // Check if the sender has enough\n', '        // All transfer will check the available unlocked balance\n', '        require((balanceOf[_from] - getLockBalance(_from, decimals)) >= _value);\n', '        // Check balance\n', '        require(balanceOf[_from] >= _value);\n', '        // Check for overflows\n', '        require((balanceOf[_to] + _value) > balanceOf[_to]);\n', '        // Save this for an assertion in the future\n', '        uint previousBalances = balanceOf[_from] + balanceOf[_to];\n', '        // Subtract from the sender\n', '        balanceOf[_from] -= _value;\n', '        // Add the same to the recipient\n', '        balanceOf[_to] += _value;\n', '        Transfer(_from, _to, _value);\n', '        // Asserts are used to use static analysis to find bugs in your code. They should never fail\n', '        assert(balanceOf[_from] + balanceOf[_to] == previousBalances);\n', '    }\n', '    \n', '    function lockBalanceOf(address _owner) public returns (uint256) {\n', '        return getLockBalance(_owner, decimals);\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) public {\n', '        _transfer(msg.sender, _to, _value);\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        require(_value <= allowance[_from][msg.sender]);\n', '        // Check allowance\n', '        allowance[_from][msg.sender] -= _value;\n', '        _transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public\n', '    returns (bool success) {\n', '        allowance[msg.sender][_spender] = _value;\n', '        return true;\n', '    }\n', '\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData)\n', '    public\n', '    returns (bool success) {\n', '        tokenRecipient spender = tokenRecipient(_spender);\n', '        if (approve(_spender, _value)) {\n', '            spender.receiveApproval(msg.sender, _value, this, _extraData);\n', '            return true;\n', '        }\n', '    }\n', '}']