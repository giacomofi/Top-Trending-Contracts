['pragma solidity ^0.4.24;\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '    function mul(uint a, uint b) internal pure returns (uint) {\n', '        uint c = a * b;\n', '        assert(a == 0 || c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint a, uint b) internal pure returns (uint) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint c = a / b;\n', '        // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '        return c;\n', '    }\n', '\n', '    function sub(uint a, uint b) internal pure returns (uint) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint a, uint b) internal pure returns (uint) {\n', '        uint c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '    uint public totalSupply;\n', '    function balanceOf(address who) public view returns (uint);\n', '    function transfer(address to, uint value) public returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint value);\n', '}\n', '\n', '/**\n', ' * @title Basic token\n', ' * @dev Basic version of StandardToken, with no allowances.\n', ' */\n', 'contract BasicToken is ERC20Basic {\n', '    using SafeMath for uint;\n', '\n', '    mapping(address => uint) balances;\n', '\n', '  /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '    function transfer(address _to, uint _value) public returns (bool) {\n', '        require(_to != address(0));\n', '        require(_value <= balances[msg.sender]);\n', '\n', '        // SafeMath.sub will throw if there is not enough balance.\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of.\n', '  * @return An uint representing the amount owned by the passed address.\n', '  */\n', '    function balanceOf(address _owner) public view returns (uint balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '}\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '    function allowance(address owner, address spender) public view returns (uint);\n', '\n', '    function transferFrom(address from, address to, uint value) public returns (bool);\n', '\n', '    function approve(address spender, uint value) public returns (bool);\n', '    event Approval(address indexed owner, address indexed spender, uint value);\n', '}\n', '\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implementation of the basic standard token.\n', ' * @dev https://github.com/ethereum/EIPs/issues/20\n', ' * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '    mapping (address => mapping (address => uint)) allowed;\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint the amount of tokens to be transferred\n', '   */\n', '    function transferFrom(address _from, address _to, uint _value) public returns (bool) {\n', '        require(_to != address(0));\n', '\n', '        uint _allowance = allowed[_from][msg.sender];\n', '\n', '        // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met\n', '        require (_value <= _allowance);\n', '        require(_value > 0);\n', '\n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        allowed[_from][msg.sender] = _allowance.sub(_value);\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '  /**\n', '   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '    function approve(address _spender, uint _value) public returns (bool) {\n', '\n', '        // To change the approve amount you first have to reduce the addresses`\n', '        //  allowance to zero by calling `approve(_spender, 0)` if it is not\n', '        //  already 0 to mitigate the race condition described here:\n', '        //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '        require((_value == 0) || (allowed[msg.sender][_spender] == 0));\n', '\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint specifying the amount of tokens still available for the spender.\n', '   */\n', '    function allowance(address _owner, address _spender) public view returns (uint remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '  /**\n', '   * approve should be called when allowed[_spender] == 0. To increment\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   */\n', '    function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {\n', '        allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '    function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {\n', '        uint oldValue = allowed[msg.sender][_spender];\n', '        if (_subtractedValue > oldValue) {\n', '            allowed[msg.sender][_spender] = 0;\n', '        } else {\n', '            allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '        }\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '}\n', '\n', '/**\n', ' * @title ACToken\n', ' */\n', 'contract GOENTEST is StandardToken {\n', '\n', '    string public constant name = "goentesttoken";\n', '    string public constant symbol = "GOENTEST";\n', '    // string public constant name = "gttoken";\n', '    // string public constant symbol = "GTT";\n', '    uint public constant decimals = 18; // 18位小数\n', '\n', '    uint public constant INITIAL_SUPPLY =  10000000000 * (10 ** decimals); // 100000000000000000000000000（100亿）\n', '\n', '    /**\n', '    * @dev Contructor that gives msg.sender all of existing tokens.\n', '    */\n', '    constructor() public { \n', '        totalSupply = INITIAL_SUPPLY;\n', '        balances[msg.sender] = INITIAL_SUPPLY;\n', '    }\n', '}\n', '\n', '//big lock storehouse\n', 'contract lockStorehouseToken is ERC20 {\n', '    using SafeMath for uint;\n', '    \n', '    GOENTEST   tokenReward;\n', '    \n', '    address private beneficial;\n', '    uint    private lockMonth;\n', '    uint    private startTime;\n', '    uint    private releaseSupply;\n', '    bool    private released = false;\n', '    uint    private per;\n', '    uint    private releasedCount = 0;\n', '    uint    public  limitMaxSupply; //限制从合约转出代币的最大金额\n', '    uint    public  oldBalance;\n', '    uint    private constant decimals = 18;\n', '    \n', '    constructor(\n', '        address _tokenReward,\n', '        address _beneficial,\n', '        uint    _per,\n', '        uint    _startTime,\n', '        uint    _lockMonth,\n', '        uint    _limitMaxSupply\n', '    ) public {\n', '        tokenReward     = GOENTEST(_tokenReward);\n', '        beneficial      = _beneficial;\n', '        per             = _per;\n', '        startTime       = _startTime;\n', '        lockMonth       = _lockMonth;\n', '        limitMaxSupply  = _limitMaxSupply * (10 ** decimals);\n', '        \n', '        // 测试代码\n', '        // tokenReward = GOENT(0xEfe106c517F3d23Ab126a0EBD77f6Ec0f9efc7c7);\n', '        // beneficial = 0x1cDAf48c23F30F1e5bC7F4194E4a9CD8145aB651;\n', '        // per = 125;\n', '        // startTime = now;\n', '        // lockMonth = 1;\n', '        // limitMaxSupply = 3000000000 * (10 ** decimals);\n', '    }\n', '    \n', '    mapping(address => uint) balances;\n', '    \n', '    function approve(address _spender, uint _value) public returns (bool){}\n', '    \n', '    function allowance(address _owner, address _spender) public view returns (uint){}\n', '    \n', '    function balanceOf(address _owner) public view returns (uint balance) {\n', '        return balances[_owner];\n', '    }\n', '    \n', '    function transfer(address _to, uint _value) public returns (bool) {\n', '        require(_to != address(0));\n', '        require(_value <= balances[msg.sender]);\n', '        \n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '    \n', '    function transferFrom(address _from, address _to, uint _value) public returns (bool) {\n', '        require(_to != address(0));\n', '        require (_value > 0);\n', '        require(_value <= balances[_from]);\n', '        \n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '    \n', '    function getBeneficialAddress() public constant returns (address){\n', '        return beneficial;\n', '    }\n', '    \n', '    function getBalance() public constant returns(uint){\n', '        return tokenReward.balanceOf(this);\n', '    }\n', '    \n', '    modifier checkBalance {\n', '        if(!released){\n', '            oldBalance = getBalance();\n', '            if(oldBalance > limitMaxSupply){\n', '                oldBalance = limitMaxSupply;\n', '            }\n', '        }\n', '        _;\n', '    }\n', '    \n', '    function release() checkBalance public returns(bool) {\n', '        // uint _lockMonth;\n', '        // uint _baseDate;\n', '        uint cliffTime;\n', '        uint monthUnit;\n', '        \n', '        released = true;\n', '        // 释放金额\n', '        releaseSupply = SafeMath.mul(SafeMath.div(oldBalance, 1000), per);\n', '        \n', '        // 释放金额必须小于等于当前合同余额\n', '        if(SafeMath.mul(releasedCount, releaseSupply) <= oldBalance){\n', '            // if(per == 1000){\n', '            //     _lockMonth = SafeMath.div(lockMonth, 12);\n', '            //     _baseDate = 1 years;\n', '                \n', '            // }\n', '            \n', '            // if(per < 1000){\n', '            //     _lockMonth = lockMonth;\n', '            //     _baseDate = 30 days;\n', '            //     // _baseDate = 1 minutes;\n', '            // }\n', '\n', '            // _lockMonth = lockMonth;\n', '            // _baseDate = 30 days;\n', '            // monthUnit = SafeMath.mul(5, 1 minutes);\n', '            monthUnit = SafeMath.mul(lockMonth, 30 days);\n', '            cliffTime = SafeMath.add(startTime, monthUnit);\n', '        \n', '            if(now > cliffTime){\n', '                \n', '                tokenReward.transfer(beneficial, releaseSupply);\n', '                \n', '                releasedCount++;\n', '\n', '                startTime = now;\n', '                \n', '                return true;\n', '            \n', '            }\n', '        } else {\n', '            return false;\n', '        }\n', '        \n', '    }\n', '    \n', '    function () private payable {\n', '    }\n', '}']