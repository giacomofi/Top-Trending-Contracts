['/**\n', ' *Submitted for verification at Etherscan.io on 2021-03-16\n', '*/\n', '\n', 'pragma solidity ^0.6.0;\n', '\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', 'contract MUSO {\n', '    using SafeMath for uint;\n', '    \n', '    string public name; // ERC20标准\n', '    string public symbol; // ERC20标准\n', '    uint256 public decimals;  // ERC20标准，decimals 可以有的小数点个数，最小的代币单位。18 是建议的默认值\n', '    uint256 public totalSupply; // ERC20标准 总供应量\n', '\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '    event Burn(address indexed from, uint256 value);\n', '\n', '    constructor(uint256 initialSupply, string memory tokenName, string memory tokenSymbol, uint256 _decimals) public {\n', '        totalSupply = initialSupply * 10 ** _decimals;       // 供应的份额，份额跟最小的代币单位有关，份额 = 币数 * 10 ** decimals。\n', '        balanceOf[msg.sender] = totalSupply;                // 创建者拥有所有的代币\n', '        name = tokenName;                                   // 代币名称\n', '        symbol = tokenSymbol;                               // 代币符号\n', '        decimals = _decimals;\n', '    }\n', '\n', '    /**\n', '     * 代币交易转移的内部实现\n', '     */\n', '    function _transfer(address _from, address _to, uint _value) internal {\n', '        require(_to != address(0));\n', '        require(balanceOf[_from] >= _value);\n', '        require(balanceOf[_to].add(_value) > balanceOf[_to]);\n', '\n', '        uint previousBalances = balanceOf[_from].add(balanceOf[_to]);\n', '        balanceOf[_from] = balanceOf[_from].sub(_value);\n', '        balanceOf[_to] = balanceOf[_to].add(_value);\n', '        emit Transfer(_from, _to, _value);\n', '\n', '        assert(balanceOf[_from].add(balanceOf[_to]) == previousBalances);\n', '    }\n', '\n', '    /**\n', '     *  代币交易转移\n', '     *  从自己（创建交易者）账号发送`_value`个代币到 `_to`账号\n', '     * ERC20标准\n', '     * @param _to 接收者地址\n', '     * @param _value 转移数额\n', '     */\n', '    function transfer(address _to, uint256 _value) public {\n', '        _transfer(msg.sender, _to, _value);\n', '    }\n', '\n', '    /**\n', '     * 账号之间代币交易转移\n', '     * ERC20标准\n', '     * @param _from 发送者地址\n', '     * @param _to 接收者地址\n', '     * @param _value 转移数额\n', '     */\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        require(_value <= allowance[_from][msg.sender]);     // Check allowance\n', '        allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);\n', '        _transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * 设置某个地址（合约）可以创建交易者名义花费的代币数。\n', '     *\n', '     * 允许发送者`_spender` 花费不多于 `_value` 个代币\n', '     * ERC20标准\n', '     * @param _spender The address authorized to spend\n', '     * @param _value the max amount they can spend\n', '     */\n', '    function approve(address _spender, uint256 _value) public\n', '    returns (bool success) {\n', '        require(_spender != address(0));\n', '        allowance[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * 销毁我（创建交易者）账户中指定个代币\n', '     *-非ERC20标准\n', '     */\n', '    function burn(uint256 _value) public returns (bool success) {\n', '        require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough\n', '        balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);            // Subtract from the sender\n', '        totalSupply = totalSupply.sub(_value);                      // Updates totalSupply\n', '        emit Burn(msg.sender, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * 销毁用户账户中指定个代币\n', '     *-非ERC20标准\n', '     * Remove `_value` tokens from the system irreversibly on behalf of `_from`.\n', '     *\n', '     * @param _from the address of the sender\n', '     * @param _value the amount of money to burn\n', '     */\n', '    function burnFrom(address _from, uint256 _value) public returns (bool success) {\n', '        require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough\n', '        require(_value <= allowance[_from][msg.sender]);    // Check allowance\n', '        balanceOf[_from] = balanceOf[_from].sub(_value);                         // Subtract from the targeted balance\n', "        allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);             // Subtract from the sender's allowance\n", '        totalSupply = totalSupply.sub(_value);                              // Update totalSupply\n', '        emit Burn(_from, _value);\n', '        return true;\n', '    }\n', '}']