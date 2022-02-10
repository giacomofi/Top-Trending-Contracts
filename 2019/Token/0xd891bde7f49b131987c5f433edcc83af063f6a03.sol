['/**\n', ' *Submitted for verification at Etherscan.io on 2019-04-29\n', '*/\n', '\n', 'pragma solidity ^0.4.18;\n', '\n', 'contract BETHtoken {\n', '\n', '    string public name = "BETH";\n', '    string public symbol = "BETH";\n', '    uint8 public decimals = 18;\n', '\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '\n', '    uint256 public totalSupply;\n', '    uint256 constant initialSupply = 990000000000;\n', '    \n', '    bool public stopped = false;\n', '\n', '    address internal owner = 0x0;\n', '\n', '    modifier ownerOnly {\n', '        require(owner == msg.sender);\n', '        _;\n', '    }\n', '\n', '    modifier isRunning {\n', '        require(!stopped);\n', '        _;\n', '    }\n', '\n', '    modifier validAddress {\n', '        require(msg.sender != 0x0);\n', '        _;\n', '    }\n', '\n', '    function BETHtoken() public {\n', '        owner = msg.sender;\n', '        totalSupply = initialSupply * 10 ** uint256(decimals);\n', '        balanceOf[owner] = totalSupply;\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) isRunning validAddress public returns (bool success) {\n', '        require(_to != 0x0);\n', '        require(balanceOf[msg.sender] >= _value);\n', '        require(balanceOf[_to] + _value >= balanceOf[_to]);\n', '        balanceOf[msg.sender] -= _value;\n', '        balanceOf[_to] += _value;\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) isRunning validAddress public returns (bool success) {\n', '        require(_to != 0x0);\n', '        require(balanceOf[_from] >= _value);\n', '        require(balanceOf[_to] + _value >= balanceOf[_to]);\n', '        require(allowance[_from][msg.sender] >= _value);\n', '        allowance[_from][msg.sender] -= _value;\n', '        balanceOf[_from] -= _value;\n', '        balanceOf[_to] += _value;\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) isRunning validAddress public returns (bool success) {\n', '        require(_value == 0 || allowance[msg.sender][_spender] == 0);\n', '        allowance[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function stop() ownerOnly public {\n', '        stopped = true;\n', '    }\n', '\n', '    function start() ownerOnly public {\n', '        stopped = false;\n', '    }\n', '    \n', '      function mint(uint256 _amount)   public returns (bool) {\n', '        require(owner == msg.sender);\n', '        totalSupply += _amount;\n', '        balanceOf[msg.sender] += _amount;\n', '        transfer(msg.sender, _amount);\n', '        return true;\n', '    }\n', '\n', '\n', '    function burn(uint256 _value) isRunning validAddress public {\n', '        require(balanceOf[msg.sender] >= _value);\n', '        require(totalSupply >= _value);\n', '        balanceOf[msg.sender] -= _value;\n', '        totalSupply -= _value;\n', '    }\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}']