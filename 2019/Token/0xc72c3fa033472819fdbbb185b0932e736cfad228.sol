['pragma solidity ^0.5.4;\n', '\n', '/* taking ideas from FirstBlood token */\n', 'contract SafeMath {\n', '\n', '    /* function assert(bool assertion) internal { */\n', '    /*   if (!assertion) { */\n', '    /*     throw; */\n', '    /*   } */\n', '    /* }      // assert no longer needed once solidity is on 0.4.10 */\n', '\n', '    function safeAdd(uint256 x, uint256 y) internal pure returns(uint256) {\n', '      uint256 z = x + y;\n', '      assert((z >= x) && (z >= y));\n', '      return z;\n', '    }\n', '\n', '    function safeSub(uint256 x, uint256 y) internal pure returns(uint256) {\n', '      assert(x >= y);\n', '      uint256 z = x - y;\n', '      return z;\n', '    }\n', '\n', '    function safeMult(uint256 x, uint256 y) internal pure returns(uint256) {\n', '      uint256 z = x * y;\n', '      assert((x == 0)||(z/x == y));\n', '      return z;\n', '    }\n', '\n', '    function safeDiv(uint256 x, uint256 y) internal pure returns(uint256) {\n', '        require(y > 0);\n', '        return x / y;\n', '    }\n', '}\n', '\n', 'contract Authorization {\n', '    mapping(address => bool) internal authbook;\n', '    address[] public operators;\n', '    address public owner;\n', '    bool public powerStatus = true;\n', '    constructor()\n', '        public\n', '        payable\n', '    {\n', '        owner = msg.sender;\n', '        assignOperator(msg.sender);\n', '    }\n', '    modifier onlyOwner\n', '    {\n', '        assert(msg.sender == owner);\n', '        _;\n', '    }\n', '    modifier onlyOperator\n', '    {\n', '        assert(checkOperator(msg.sender));\n', '        _;\n', '    }\n', '    modifier onlyActive\n', '    {\n', '        assert(powerStatus);\n', '        _;\n', '    }\n', '    function powerSwitch(\n', '        bool onOff_\n', '    )\n', '        public\n', '        onlyOperator\n', '    {\n', '        powerStatus = onOff_;\n', '    }\n', '    function transferOwnership(address newOwner_)\n', '        onlyOwner\n', '        public\n', '    {\n', '        owner = newOwner_;\n', '    }\n', '    \n', '    function assignOperator(address user_)\n', '        public\n', '        onlyOwner\n', '    {\n', '        if(user_ != address(0) && !authbook[user_]) {\n', '            authbook[user_] = true;\n', '            operators.push(user_);\n', '        }\n', '    }\n', '    \n', '    function dismissOperator(address user_)\n', '        public\n', '        onlyOwner\n', '    {\n', '        delete authbook[user_];\n', '        for(uint i = 0; i < operators.length; i++) {\n', '            if(operators[i] == user_) {\n', '                operators[i] = operators[operators.length - 1];\n', '                operators.length -= 1;\n', '            }\n', '        }\n', '    }\n', '\n', '    function checkOperator(address user_)\n', '        public\n', '        view\n', '    returns(bool) {\n', '        return authbook[user_];\n', '    }\n', '}\n', '\n', 'contract tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes calldata _extraData) external; }\n', '\n', 'contract Token is Authorization {\n', '    uint256 public totalSupply;\n', '    function balanceOf(address _owner) public view returns (uint256 balance);\n', '    function transfer(address _to, uint256 _value) public returns (bool success);\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);\n', '    function approve(address _spender, uint256 _value) public returns (bool success);\n', '    function allowance(address _owner, address _spender) public view returns (uint256 remaining);\n', '    \n', '    /* This generates a public event on the blockchain that will notify clients */\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', '\n', '/*  ERC 20 token */\n', 'contract StandardToken is SafeMath, Token {\n', '    /* Send coins */\n', '    function transfer(address _to, uint256 _value) onlyActive public returns (bool success) {\n', '        if (balances[msg.sender] >= _value && _value > 0) {\n', '            balances[msg.sender] = safeSub(balances[msg.sender], _value);\n', '            balances[_to] = safeAdd(balances[_to], _value);\n', '            emit Transfer(msg.sender, _to, _value);\n', '            return true;\n', '        } else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '    /* A contract attempts to get the coins */\n', '    function transferFrom(address _from, address _to, uint256 _value) onlyActive public returns (bool success) {\n', '        if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {\n', '            balances[_to] = safeAdd(balances[_to], _value);\n', '            balances[_from] = safeSub(balances[_from], _value);\n', '            allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender], _value);\n', '            emit Transfer(_from, _to, _value);\n', '            return true;\n', '        } else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '    function balanceOf(address _owner) view public returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    /* Allow another contract to spend some tokens in your behalf */\n', '    function approve(address _spender, uint256 _value) public returns (bool success) {\n', '        assert((_value == 0) || (allowed[msg.sender][_spender] == 0));\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    /* This creates an array with all balances */\n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '}\n', '\n', 'contract TBT is StandardToken {\n', '\n', '    // metadata\n', '    string public name = "Tidebit Token";\n', '    string public symbol = "TBT";\n', '    uint256 public constant decimals = 18;\n', '    string public version = "1.0";\n', '    uint256 public tokenCreationCap =  2 * (10**8) * 10**decimals;\n', '\n', '    // fund accounts\n', '    address public FundAccount;      // deposit address for Owner.\n', '\n', '    // events\n', '    event CreateToken(address indexed _to, uint256 _value);\n', '\n', '    // constructor\n', '    constructor(\n', '        string memory _name,\n', '        string memory _symbol,\n', '        uint256 _tokenCreationCap,\n', '        address _FundAccount\n', '    ) public\n', '    {\n', '        name = _name;\n', '        symbol = _symbol;\n', '        tokenCreationCap = _tokenCreationCap * 10**decimals;\n', '        FundAccount = _FundAccount;\n', '        totalSupply = tokenCreationCap;\n', '        balances[FundAccount] = tokenCreationCap;    // deposit all token to Owner.\n', '        emit CreateToken(FundAccount, tokenCreationCap);    // logs deposit of Owner\n', '    }\n', '\n', '    /* Approve and then communicate the approved contract in a single tx */\n', '    function approveAndCall(address _spender, uint256 _value, bytes memory _extraData) public\n', '        returns (bool success) {    \n', '        tokenRecipient spender = tokenRecipient(_spender);\n', '        if (approve(_spender, _value)) {\n', '            spender.receiveApproval(msg.sender, _value, address(this), _extraData);\n', '            return true;\n', '        }\n', '    }\n', '}']