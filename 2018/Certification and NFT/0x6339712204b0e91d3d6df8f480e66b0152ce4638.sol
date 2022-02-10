['pragma solidity ^0.4.11;\n', '\n', 'interface token {\n', '  function transfer( address to, uint256 value) external returns (bool ok);\n', '  function balanceOf( address who ) external constant returns (uint256 value);\n', '}\n', '\n', 'contract EnvientaPreToken {\n', '\n', '  string public constant symbol = "pENV";\n', '  string public constant name = "ENVIENTA pre-token";\n', '  uint8 public constant decimals = 18;\n', '  \n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '  mapping( address => uint256 ) _balances;\n', '  \n', '  uint256 public _supply = 30000000 * 10**uint256(decimals);\n', '  address _creator;\n', '  token public backingToken;\n', '  bool _buyBackMode = false;\n', '  \n', '  constructor() public {\n', '    _creator = msg.sender;\n', '    _balances[msg.sender] = _supply;\n', '  }\n', '  \n', '  function totalSupply() public constant returns (uint256 supply) {\n', '    return _supply;\n', '  }\n', '  \n', '  function balanceOf( address who ) public constant returns (uint256 value) {\n', '    return _balances[who];\n', '  }\n', '  \n', '  function enableBuyBackMode(address _backingToken) public {\n', '    require( msg.sender == _creator );\n', '    \n', '    backingToken = token(_backingToken);\n', '    _buyBackMode = true;\n', '  }\n', '  \n', '  function transfer( address to, uint256 value) public returns (bool ok) {\n', '    require( _balances[msg.sender] >= value );\n', '    require( _balances[to] + value >= _balances[to]);\n', '    \n', '    if( _buyBackMode ) {\n', '        require( msg.sender != _creator );\n', '        require( to == address(this) );\n', '        require( backingToken.balanceOf(address(this)) >= value );\n', '        \n', '        _balances[msg.sender] -= value;\n', '        _balances[to] += value;\n', '        emit Transfer( msg.sender, to, value );\n', '        \n', '        backingToken.transfer(msg.sender, value);\n', '        return true;\n', '    } else {\n', '        require( msg.sender == _creator );\n', '        \n', '        _balances[msg.sender] -= value;\n', '        _balances[to] += value;\n', '        emit Transfer( msg.sender, to, value );\n', '        return true;\n', '    }\n', '  }\n', '  \n', '}']
['pragma solidity ^0.4.11;\n', '\n', 'interface token {\n', '  function transfer( address to, uint256 value) external returns (bool ok);\n', '  function balanceOf( address who ) external constant returns (uint256 value);\n', '}\n', '\n', 'contract EnvientaPreToken {\n', '\n', '  string public constant symbol = "pENV";\n', '  string public constant name = "ENVIENTA pre-token";\n', '  uint8 public constant decimals = 18;\n', '  \n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '  mapping( address => uint256 ) _balances;\n', '  \n', '  uint256 public _supply = 30000000 * 10**uint256(decimals);\n', '  address _creator;\n', '  token public backingToken;\n', '  bool _buyBackMode = false;\n', '  \n', '  constructor() public {\n', '    _creator = msg.sender;\n', '    _balances[msg.sender] = _supply;\n', '  }\n', '  \n', '  function totalSupply() public constant returns (uint256 supply) {\n', '    return _supply;\n', '  }\n', '  \n', '  function balanceOf( address who ) public constant returns (uint256 value) {\n', '    return _balances[who];\n', '  }\n', '  \n', '  function enableBuyBackMode(address _backingToken) public {\n', '    require( msg.sender == _creator );\n', '    \n', '    backingToken = token(_backingToken);\n', '    _buyBackMode = true;\n', '  }\n', '  \n', '  function transfer( address to, uint256 value) public returns (bool ok) {\n', '    require( _balances[msg.sender] >= value );\n', '    require( _balances[to] + value >= _balances[to]);\n', '    \n', '    if( _buyBackMode ) {\n', '        require( msg.sender != _creator );\n', '        require( to == address(this) );\n', '        require( backingToken.balanceOf(address(this)) >= value );\n', '        \n', '        _balances[msg.sender] -= value;\n', '        _balances[to] += value;\n', '        emit Transfer( msg.sender, to, value );\n', '        \n', '        backingToken.transfer(msg.sender, value);\n', '        return true;\n', '    } else {\n', '        require( msg.sender == _creator );\n', '        \n', '        _balances[msg.sender] -= value;\n', '        _balances[to] += value;\n', '        emit Transfer( msg.sender, to, value );\n', '        return true;\n', '    }\n', '  }\n', '  \n', '}']