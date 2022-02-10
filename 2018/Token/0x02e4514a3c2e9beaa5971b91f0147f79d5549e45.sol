['pragma solidity ^0.4.23;\n', '\n', 'contract CoinOtg // @eachvar\n', '{\n', '    // ======== 初始化代币相关逻辑 ==============\n', '    // 地址信息\n', '    address public admin_address = 0xc5259e85f9E3bC882d151D09f475A16B4001aF61; // @eachvar\n', '    address public account_address = 0xc5259e85f9E3bC882d151D09f475A16B4001aF61; // @eachvar 初始化后转入代币的地址\n', '    \n', '    // 定义账户余额\n', '    mapping(address => uint256) balances;\n', '    \n', '    // solidity 会自动为 public 变量添加方法，有了下边这些变量，就能获得代币的基本信息了\n', '    string public name = "欧特股"; // @eachvar\n', '    string public symbol = "OTG"; // @eachvar\n', '    uint8 public decimals = 18; // @eachvar\n', '    uint256 initSupply = 500000000; // @eachvar\n', '    uint256 public totalSupply = 0; // @eachvar\n', '\n', '    // 生成代币，并转入到 account_address 地址\n', '    constructor() \n', '    payable \n', '    public\n', '    {\n', '        totalSupply = mul(initSupply, 10**uint256(decimals));\n', '        balances[account_address] = totalSupply;\n', '\n', '        \n', '    }\n', '\n', '    function balanceOf( address _addr ) public view returns ( uint )\n', '    {\n', '        return balances[_addr];\n', '    }\n', '\n', '    // ========== 转账相关逻辑 ====================\n', '    event Transfer(\n', '        address indexed from, \n', '        address indexed to, \n', '        uint256 value\n', '    ); \n', '\n', '    function transfer(\n', '        address _to, \n', '        uint256 _value\n', '    ) \n', '    public \n', '    returns (bool) \n', '    {\n', '        require(_to != address(0));\n', '        require(_value <= balances[msg.sender]);\n', '\n', '        balances[msg.sender] = sub(balances[msg.sender],_value);\n', '\n', '            \n', '\n', '        balances[_to] = add(balances[_to], _value);\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    // ========= 授权转账相关逻辑 =============\n', '    \n', '    mapping (address => mapping (address => uint256)) internal allowed;\n', '    event Approval(\n', '        address indexed owner,\n', '        address indexed spender,\n', '        uint256 value\n', '    );\n', '\n', '    function transferFrom(\n', '        address _from,\n', '        address _to,\n', '        uint256 _value\n', '    )\n', '    public\n', '    returns (bool)\n', '    {\n', '        require(_to != address(0));\n', '        require(_value <= balances[_from]);\n', '        require(_value <= allowed[_from][msg.sender]);\n', '\n', '        balances[_from] = sub(balances[_from], _value);\n', '        \n', '        \n', '        balances[_to] = add(balances[_to], _value);\n', '        allowed[_from][msg.sender] = sub(allowed[_from][msg.sender], _value);\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function approve(\n', '        address _spender, \n', '        uint256 _value\n', '    ) \n', '    public \n', '    returns (bool) \n', '    {\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(\n', '        address _owner,\n', '        address _spender\n', '    )\n', '    public\n', '    view\n', '    returns (uint256)\n', '    {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    function increaseApproval(\n', '        address _spender,\n', '        uint256 _addedValue\n', '    )\n', '    public\n', '    returns (bool)\n', '    {\n', '        allowed[msg.sender][_spender] = add(allowed[msg.sender][_spender], _addedValue);\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '    function decreaseApproval(\n', '        address _spender,\n', '        uint256 _subtractedValue\n', '    )\n', '    public\n', '    returns (bool)\n', '    {\n', '        uint256 oldValue = allowed[msg.sender][_spender];\n', '\n', '        if (_subtractedValue > oldValue) {\n', '            allowed[msg.sender][_spender] = 0;\n', '        } \n', '        else \n', '        {\n', '            allowed[msg.sender][_spender] = sub(oldValue, _subtractedValue);\n', '        }\n', '        \n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '    \n', '    \n', '\n', '     \n', '    // ========== 代码销毁相关逻辑 ================\n', '    event Burn(address indexed burner, uint256 value);\n', '\n', '    function burn(uint256 _value) public \n', '    {\n', '        _burn(msg.sender, _value);\n', '    }\n', '\n', '    function _burn(address _who, uint256 _value) internal \n', '    {\n', '        require(_value <= balances[_who]);\n', '        \n', '        balances[_who] = sub(balances[_who], _value);\n', '\n', '            \n', '\n', '        totalSupply = sub(totalSupply, _value);\n', '        emit Burn(_who, _value);\n', '        emit Transfer(_who, address(0), _value);\n', '    }\n', '    \n', '    \n', '    // ============== admin 相关函数 ==================\n', '    modifier admin_only()\n', '    {\n', '        require(msg.sender==admin_address);\n', '        _;\n', '    }\n', '\n', '    function setAdmin( address new_admin_address ) \n', '    public \n', '    admin_only \n', '    returns (bool)\n', '    {\n', '        require(new_admin_address != address(0));\n', '        admin_address = new_admin_address;\n', '        return true;\n', '    }\n', '\n', '    \n', '    // 虽然没有开启直投，但也可能转错钱的，给合约留一个提现口总是好的\n', '    function withDraw()\n', '    public\n', '    admin_only\n', '    {\n', '        require(address(this).balance > 0);\n', '        admin_address.transfer(address(this).balance);\n', '    }\n', '        // ======================================\n', '    /// 默认函数\n', '    function () external payable\n', '    {\n', '                \n', '        \n', '        \n', '           \n', '    }\n', '\n', '    // ========== 公用函数 ===============\n', '    // 主要就是 safemath\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256 c) \n', '    {\n', '        if (a == 0) \n', '        {\n', '            return 0;\n', '        }\n', '\n', '        c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) \n', '    {\n', '        return a / b;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) \n', '    {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256 c) \n', '    {\n', '        c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '\n', '}']