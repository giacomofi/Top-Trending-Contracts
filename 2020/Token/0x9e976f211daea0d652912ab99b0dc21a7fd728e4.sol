['pragma solidity ^0.5.17;\n', '// SPDX-License-Identifier: MIT\n', '  library SafeMath {\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '      assert(b <= a);\n', '      return a - b;\n', '    }\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '      uint256 c = a + b;\n', '      assert(c >= a);\n', '      return c;\n', '    }\n', '  }\n', '  contract map {\n', '    using SafeMath for uint256;\n', '    \n', '    string public constant name = "MAP Protocol";\n', '    string public constant symbol = "MAP";\n', '    uint256 public constant decimals = 18;\n', '    uint256 public constant totalSupply = 10000000000*10**decimals;\n', '    \n', '    mapping (address => uint256) private balances;\n', '    mapping (address => mapping (address => uint256)) private allowed;\n', '    \n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '    \n', '    constructor(address _moveAddr) public {\n', '      balances[_moveAddr] = totalSupply;\n', '    }\n', '\n', '    function balanceOf(address _owner) public view returns (uint256 balance) {\n', '      return balances[_owner];\n', '    }\n', '    \n', '    function transfer(address _to, uint256 _value) public returns (bool success) {\n', '      require (_to != address(0), "not enough balance !");\n', '      require((balances[msg.sender] >= _value), "");\n', '      balances[msg.sender] = balances[msg.sender].sub(_value);\n', '      balances[_to] = balances[_to].add(_value);\n', '      emit Transfer(msg.sender, _to, _value);\n', '      return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '      require (_to != address(0), "not enough balance !");\n', '      require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value, "not enough allowed balance");\n', '      allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '      balances[_from] = balances[_from].sub(_value);\n', '      balances[_to] = balances[_to].add(_value);\n', '      emit Transfer(_from, _to, _value);\n', '      return true;\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool success) {\n', '      allowed[msg.sender][_spender] = _value;\n', '      emit Approval(msg.sender, _spender, _value);\n', '      return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {\n', '      return allowed[_owner][_spender];\n', '    }\n', '    \n', '    function batchTransfer(\n', '        address payable[] memory _users, \n', '        uint256[] memory _amounts\n', '    ) \n', '        public\n', '        returns (bool)\n', '    {\n', '        require(_users.length == _amounts.length,"not same length");\n', '        \n', '        for(uint8 i = 0; i < _users.length; i++){\n', '            require(_users[i] != address(0),"address is zero");\n', '            require(balances[msg.sender] >= _amounts[i] ,"not enough balance !");\n', '            balances[msg.sender] = balances[msg.sender].sub(_amounts[i]);\n', '            balances[_users[i]] = balances[_users[i]].add(_amounts[i]); \n', '            emit Transfer(msg.sender, _users[i], _amounts[i]);\n', '        }\n', '        return true;\n', '    }\n', '  }']