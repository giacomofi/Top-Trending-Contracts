['pragma solidity ^0.4.8;\n', '\n', 'contract ERC20Interface {\n', '    function totalSupply() public constant returns (uint256 supply);\n', '    function balance() public constant returns (uint256);\n', '    function balanceOf(address _owner) public constant returns (uint256);\n', '    function transfer(address _to, uint256 _value) public returns (bool success);\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);\n', '    function approve(address _spender, uint256 _value) public returns (bool success);\n', '    function allowance(address _owner, address _spender) public constant returns (uint256 remaining);\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', '// GROWCHAIN\n', '// YOU get a GROWCHAIN, and YOU get a GROWCHAIN, and YOU get a GROWCHAIN!\n', 'contract GROWCHAIN is ERC20Interface {\n', '    string public constant symbol = "GROW";\n', '    string public constant name = "GROW CHAIN";\n', '    uint8 public constant decimals = 2;\n', '\n', '    uint256 _totalSupply = 0;\n', '    uint256 _airdropAmount = 188 * 10 ** uint256(decimals);\n', '    uint256 _cutoff = 1000000 * 10 ** uint256(decimals);\n', '    uint256 _outAmount = 0;\n', '\n', '    mapping(address => uint256) balances;\n', '    mapping(address => bool) initialized;\n', '\n', '    // GROWCHAIN accepts request to tip-touch another GROWCHAIN\n', '    mapping(address => mapping (address => uint256)) allowed;\n', '\n', '    function GROWCHAIN() {\n', '        initialized[msg.sender] = true;\n', '        balances[msg.sender] = 5000000000 * 10 ** uint256(decimals) - _cutoff;\n', '        _totalSupply = balances[msg.sender];\n', '    }\n', '\n', '    function totalSupply() constant returns (uint256 supply) {\n', '        return _totalSupply;\n', '    }\n', '\n', '    // What&#39;s my girth?\n', '    function balance() constant returns (uint256) {\n', '        return getBalance(msg.sender);\n', '    }\n', '\n', '    // What is the length of a particular GROWCHAIN?\n', '    function balanceOf(address _address) constant returns (uint256) {\n', '        return getBalance(_address);\n', '    }\n', '\n', '    // Tenderly remove hand from GROWCHAIN and place on another GROWCHAIN\n', '    function transfer(address _to, uint256 _amount) returns (bool success) {\n', '        initialize(msg.sender);\n', '\n', '        if (balances[msg.sender] >= _amount\n', '            && _amount > 0) {\n', '            initialize(_to);\n', '            if (balances[_to] + _amount > balances[_to]) {\n', '\n', '                balances[msg.sender] -= _amount;\n', '                balances[_to] += _amount;\n', '\n', '                Transfer(msg.sender, _to, _amount);\n', '\n', '                return true;\n', '            } else {\n', '                return false;\n', '            }\n', '        } else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '    // Perform the inevitable actions which cause release of that which each GROWCHAIN\n', '    // is built to deliver. In EtherGROWCHAINLand there are only GROWCHAINes, so this \n', '    // allows the transmission of one GROWCHAIN&#39;s payload (or partial payload but that\n', '    // is not as much fun) INTO another GROWCHAIN. This causes the GROWCHAINae to change \n', '    // form such that all may see the glory they each represent. Erections.\n', '    function transferFrom(address _from, address _to, uint256 _amount) returns (bool success) {\n', '        initialize(_from);\n', '\n', '        if (balances[_from] >= _amount\n', '            && allowed[_from][msg.sender] >= _amount\n', '            && _amount > 0) {\n', '            initialize(_to);\n', '            if (balances[_to] + _amount > balances[_to]) {\n', '\n', '                balances[_from] -= _amount;\n', '                allowed[_from][msg.sender] -= _amount;\n', '                balances[_to] += _amount;\n', '\n', '                Transfer(_from, _to, _amount);\n', '\n', '                return true;\n', '            } else {\n', '                return false;\n', '            }\n', '        } else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '    // Allow splooger to cause a payload release from your GROWCHAIN, multiple times, up to \n', '    // the point at which no further release is possible..\n', '    function approve(address _spender, uint256 _amount) returns (bool success) {\n', '        allowed[msg.sender][_spender] = _amount;\n', '        Approval(msg.sender, _spender, _amount);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    // internal privats\n', '    function initialize(address _address) internal returns (bool success) {\n', '        if (_outAmount < _cutoff && !initialized[_address]) {\n', '            initialized[_address] = true;\n', '            balances[_address] = _airdropAmount;\n', '            _outAmount += _airdropAmount;\n', '            _totalSupply += _airdropAmount;\n', '        }\n', '        return true;\n', '    }\n', '\n', '    function getBalance(address _address) internal returns (uint256) {\n', '        if (_outAmount < _cutoff && !initialized[_address]) {\n', '            return balances[_address] + _airdropAmount;\n', '        }\n', '        else {\n', '            return balances[_address];\n', '        }\n', '    }\n', '    \n', '    function getOutAmount()constant returns(uint256 amount){\n', '        return _outAmount;\n', '    }\n', '    \n', '}']