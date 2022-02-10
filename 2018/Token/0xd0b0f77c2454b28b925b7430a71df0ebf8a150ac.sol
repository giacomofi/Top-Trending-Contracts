['pragma solidity ^0.4.21;\n', '\n', 'contract Lambo {\n', '\n', '    string public name = "Lambo";      //  token name\n', '    string public symbol = "LAMBO";           //  token symbol\n', '    uint256 public decimals = 18;            //  token digit\n', '\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '\n', '    uint256 public totalSupply = 0;\n', '\n', '    address owner;\n', '\n', '    modifier isOwner {\n', '        assert(owner == msg.sender);\n', '        _;\n', '    }\n', '\n', '\n', '\n', '    modifier validAddress {\n', '        assert(0x0 != msg.sender);\n', '        _;\n', '    }\n', '\n', '    function Lambo() public {\n', '        owner = msg.sender;\n', '        mint(owner);\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) public validAddress returns (bool success) {\n', '        require(balanceOf[msg.sender] >= _value);\n', '        require(balanceOf[_to] + _value >= balanceOf[_to]);\n', '        balanceOf[msg.sender] -= _value;\n', '        balanceOf[_to] += _value;\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public validAddress returns (bool success) {\n', '        require(balanceOf[_from] >= _value);\n', '        require(balanceOf[_to] + _value >= balanceOf[_to]);\n', '        require(allowance[_from][msg.sender] >= _value);\n', '        balanceOf[_to] += _value;\n', '        balanceOf[_from] -= _value;\n', '        allowance[_from][msg.sender] -= _value;\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public validAddress returns (bool success) {\n', '        require(_value == 0 || allowance[msg.sender][_spender] == 0);\n', '        allowance[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    // WTF you want to burn LAMBO!?\n', '    function burn(uint256 _value) public {\n', '        require(balanceOf[msg.sender] >= _value);\n', '        balanceOf[msg.sender] -= _value;\n', '        balanceOf[0x0] += _value;\n', '        emit Transfer(msg.sender, 0x0, _value);\n', '    }\n', '    \n', '    function mint(address who) public {\n', '        if (who == 0x0){\n', '            who = msg.sender;\n', '        }\n', '        require(balanceOf[who] == 0);\n', '        _mint(who, 1);\n', '    }\n', '    \n', '    function mintMore(address who) public payable{\n', '        if (who == 0x0){\n', '            who = msg.sender;\n', '        }\n', '        require(msg.value >= (1 finney));\n', '        _mint(who,3);\n', '        owner.transfer(msg.value);\n', '    }\n', '    \n', '    function _mint(address who, uint256 howmuch) internal {\n', '        balanceOf[who] = balanceOf[who] + howmuch * (10 ** decimals);\n', '        totalSupply = totalSupply + howmuch * (10 ** decimals);\n', '        emit Transfer(0x0, who, howmuch * (10 ** decimals));\n', '    }\n', '    \n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}']
['pragma solidity ^0.4.21;\n', '\n', 'contract Lambo {\n', '\n', '    string public name = "Lambo";      //  token name\n', '    string public symbol = "LAMBO";           //  token symbol\n', '    uint256 public decimals = 18;            //  token digit\n', '\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '\n', '    uint256 public totalSupply = 0;\n', '\n', '    address owner;\n', '\n', '    modifier isOwner {\n', '        assert(owner == msg.sender);\n', '        _;\n', '    }\n', '\n', '\n', '\n', '    modifier validAddress {\n', '        assert(0x0 != msg.sender);\n', '        _;\n', '    }\n', '\n', '    function Lambo() public {\n', '        owner = msg.sender;\n', '        mint(owner);\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) public validAddress returns (bool success) {\n', '        require(balanceOf[msg.sender] >= _value);\n', '        require(balanceOf[_to] + _value >= balanceOf[_to]);\n', '        balanceOf[msg.sender] -= _value;\n', '        balanceOf[_to] += _value;\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public validAddress returns (bool success) {\n', '        require(balanceOf[_from] >= _value);\n', '        require(balanceOf[_to] + _value >= balanceOf[_to]);\n', '        require(allowance[_from][msg.sender] >= _value);\n', '        balanceOf[_to] += _value;\n', '        balanceOf[_from] -= _value;\n', '        allowance[_from][msg.sender] -= _value;\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public validAddress returns (bool success) {\n', '        require(_value == 0 || allowance[msg.sender][_spender] == 0);\n', '        allowance[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    // WTF you want to burn LAMBO!?\n', '    function burn(uint256 _value) public {\n', '        require(balanceOf[msg.sender] >= _value);\n', '        balanceOf[msg.sender] -= _value;\n', '        balanceOf[0x0] += _value;\n', '        emit Transfer(msg.sender, 0x0, _value);\n', '    }\n', '    \n', '    function mint(address who) public {\n', '        if (who == 0x0){\n', '            who = msg.sender;\n', '        }\n', '        require(balanceOf[who] == 0);\n', '        _mint(who, 1);\n', '    }\n', '    \n', '    function mintMore(address who) public payable{\n', '        if (who == 0x0){\n', '            who = msg.sender;\n', '        }\n', '        require(msg.value >= (1 finney));\n', '        _mint(who,3);\n', '        owner.transfer(msg.value);\n', '    }\n', '    \n', '    function _mint(address who, uint256 howmuch) internal {\n', '        balanceOf[who] = balanceOf[who] + howmuch * (10 ** decimals);\n', '        totalSupply = totalSupply + howmuch * (10 ** decimals);\n', '        emit Transfer(0x0, who, howmuch * (10 ** decimals));\n', '    }\n', '    \n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}']
