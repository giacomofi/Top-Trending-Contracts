['pragma solidity ^0.4.24;\n', ' \n', 'contract TSCoin {\n', ' \n', '    uint256 totalSupply_; \n', '    string public constant name = "TS Coin";\n', '    string public constant symbol = "TSC";\n', '    uint8 public constant decimals = 18;\n', '    uint256 public constant initialSupply = 200000000*(10**uint256(decimals));\n', '\tuint256 public buyPrice;\n', '\taddress public owner;\n', ' \n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', ' \n', '    mapping (address => uint256) balances; \n', '    mapping (address => mapping (address => uint256)) allowed;\n', '    \n', '    function totalSupply() public view returns (uint256){\n', '        return totalSupply_;\n', '    }\n', ' \n', '    function balanceOf(address _owner) public view returns (uint256){\n', '        return balances[_owner];\n', '    }\n', ' \n', '    function allowance(address _owner, address _spender) public view returns (uint256) {\n', '        return allowed[_owner][_spender];\n', '  }\n', '\n', '\n', '\t\n', '\tfunction _transfer(address _from, address _to, uint256 _value) internal returns (bool ) {\n', '        require(_to != address(0));\n', '        require(balances[_from] >= _value); \n', '        balances[_from] = balances[_from] - _value; \n', '        balances[_to] = balances[_to] + _value; \n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '    \n', '    function transfer(address _to, uint256 _value)  public {\n', '        _transfer(msg.sender, _to, _value);\n', '    }\n', '\n', '\n', '\t\tfunction _buy(address _from, uint256 _value) internal {\n', '\t\tuint256 _amount = (_value / buyPrice)*(10**uint256(decimals));\n', '\t\t_transfer(this, _from, _amount);\n', '\t\temit Transfer(this, _from, _amount);\n', '\t\t}\n', '\t\t\n', '\t\tfunction() public payable{\n', '\t\t\t _buy(msg.sender, msg.value);\n', '\t\t}\n', '\t\t\n', '\t\tfunction buy() public payable {\n', '\t\t\t_buy(msg.sender, msg.value);\n', '\t\t}\n', '\t\t\n', '\t\n', '\n', '\t\tfunction transferEthers() public {\n', '\t\t\trequire(msg.sender == owner);\n', '\t\t\towner.transfer(address(this).balance);\n', '\t\t}\n', '\n', ' \n', '    function approve(address _spender, uint256 _value) public returns (bool) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', ' \n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '        require(_to != address(0));\n', '        require(_value <= balances[_from]);\n', '        require(_value <= allowed[_from][msg.sender]); \n', '        balances[_from] = balances[_from] - _value; \n', '        balances[_to] = balances[_to] + _value; \n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender] - _value; \n', '        emit Transfer(_from, _to, _value); \n', '        return true; \n', '        } \n', ' \n', '     function increaseApproval(address _spender, uint _addedValue) public returns (bool) { \n', '     allowed[msg.sender][_spender] = allowed[msg.sender][_spender] + _addedValue; \n', '     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]); \n', '     return true; \n', '     } \n', ' \n', '    function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) { \n', '        uint oldValue = allowed[msg.sender][_spender]; \n', '        if (_subtractedValue > oldValue) {\n', '     \n', '            allowed[msg.sender][_spender] = 0;\n', '        } \n', '            else {\n', '            allowed[msg.sender][_spender] = oldValue - _subtractedValue;\n', '        }\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '    \n', '\t\n', '\n', ' \n', '    constructor(uint256 prices) public {\n', '        totalSupply_ = initialSupply;\n', '        balances[msg.sender] = initialSupply;\n', '        \n', '\t\tbuyPrice = prices;\n', '\t\towner = msg.sender;\n', '    }\n', '}']