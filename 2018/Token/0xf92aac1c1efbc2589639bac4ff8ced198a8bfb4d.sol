['pragma solidity ^0.4.20;\n', '\n', '\n', 'contract ERC20Interface {\n', '    uint256 public totalSupply;\n', '    function balanceOf(address _owner) public view returns (uint256 balance);\n', '    function transfer(address _to, uint256 _value) public returns (bool success);\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);\n', '    function approve(address _spender, uint256 _value) public returns (bool success);\n', '    function allowance(address _owner, address _spender) public view returns (uint256 remaining);\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value); \n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', '\n', 'contract ADT is ERC20Interface {\n', '    string public name = "AdToken";\n', '    string public symbol = "ADT goo.gl/SpdpxN";\n', '    uint8 public decimals = 18;                \n', '    \n', '    uint256 stdBalance;\n', '    mapping (address => uint256) balances;\n', '    address owner;\n', '    bool paused;\n', '    \n', '    function ADT() public {\n', '        owner = msg.sender;\n', '        totalSupply = 400000000 * 1e18;\n', '        stdBalance = 1000 * 1e18;\n', '        paused = false;\n', '    }\n', '    \n', '    function transfer(address _to, uint256 _value) public returns (bool) {\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '    \n', '    function transferFrom(address _from, address _to, uint256 _value)\n', '        public returns (bool success)\n', '    {\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '    \n', '    function pause() public {\n', '        require(msg.sender == owner);\n', '        paused = true;\n', '    }\n', '    \n', '    function unpause() public {\n', '        require(msg.sender == owner);\n', '        paused = false;\n', '    }\n', '    \n', '    function setAd(string _name, string _symbol) public {\n', '        require(owner == msg.sender);\n', '        name = _name;\n', '        symbol = _symbol;\n', '    }\n', '\n', '    function balanceOf(address _owner) public view returns (uint256 balance) {\n', '        if (paused){\n', '            return 0;\n', '        }\n', '        else {\n', '            return stdBalance+balances[_owner];\n', '        }\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool) {\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) public view returns (uint256) {\n', '        return 0;\n', '    }\n', '    \n', '    function() public payable {\n', '        owner.transfer(msg.value);\n', '    }\n', '    \n', '    function withdrawTokens(address _address, uint256 _amount) public returns (bool) {\n', '        return ERC20Interface(_address).transfer(owner, _amount);\n', '    }\n', '}']
['pragma solidity ^0.4.20;\n', '\n', '\n', 'contract ERC20Interface {\n', '    uint256 public totalSupply;\n', '    function balanceOf(address _owner) public view returns (uint256 balance);\n', '    function transfer(address _to, uint256 _value) public returns (bool success);\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);\n', '    function approve(address _spender, uint256 _value) public returns (bool success);\n', '    function allowance(address _owner, address _spender) public view returns (uint256 remaining);\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value); \n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', '\n', 'contract ADT is ERC20Interface {\n', '    string public name = "AdToken";\n', '    string public symbol = "ADT goo.gl/SpdpxN";\n', '    uint8 public decimals = 18;                \n', '    \n', '    uint256 stdBalance;\n', '    mapping (address => uint256) balances;\n', '    address owner;\n', '    bool paused;\n', '    \n', '    function ADT() public {\n', '        owner = msg.sender;\n', '        totalSupply = 400000000 * 1e18;\n', '        stdBalance = 1000 * 1e18;\n', '        paused = false;\n', '    }\n', '    \n', '    function transfer(address _to, uint256 _value) public returns (bool) {\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '    \n', '    function transferFrom(address _from, address _to, uint256 _value)\n', '        public returns (bool success)\n', '    {\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '    \n', '    function pause() public {\n', '        require(msg.sender == owner);\n', '        paused = true;\n', '    }\n', '    \n', '    function unpause() public {\n', '        require(msg.sender == owner);\n', '        paused = false;\n', '    }\n', '    \n', '    function setAd(string _name, string _symbol) public {\n', '        require(owner == msg.sender);\n', '        name = _name;\n', '        symbol = _symbol;\n', '    }\n', '\n', '    function balanceOf(address _owner) public view returns (uint256 balance) {\n', '        if (paused){\n', '            return 0;\n', '        }\n', '        else {\n', '            return stdBalance+balances[_owner];\n', '        }\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool) {\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) public view returns (uint256) {\n', '        return 0;\n', '    }\n', '    \n', '    function() public payable {\n', '        owner.transfer(msg.value);\n', '    }\n', '    \n', '    function withdrawTokens(address _address, uint256 _amount) public returns (bool) {\n', '        return ERC20Interface(_address).transfer(owner, _amount);\n', '    }\n', '}']