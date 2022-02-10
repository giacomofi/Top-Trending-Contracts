['pragma solidity ^0.4.13;\n', '\n', 'contract ERC20 {\n', '     function totalSupply() constant returns (uint256 totalSupply);\n', '     function balanceOf(address _owner) constant returns (uint256 balance);\n', '     function transfer(address _to, uint256 _value) returns (bool success);\n', '     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);\n', '     function approve(address _spender, uint256 _value) returns (bool success);\n', '     function allowance(address _owner, address _spender) constant returns (uint256 remaining);\n', '     event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '     event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', ' }\n', '  \n', '  contract BitcoinPro is ERC20 {\n', '     string public constant symbol = "BTCP";\n', '     string public constant name = "BTCP";\n', '     uint8 public constant decimals = 8;\n', '     uint256 _totalSupply = 2000000 * 10**8;\n', '     \n', '\n', '     address public owner;\n', '  \n', '     mapping(address => uint256) balances;\n', '  \n', '     mapping(address => mapping (address => uint256)) allowed;\n', '     \n', '  \n', '     function BitcoinPro() {\n', '         owner = 0xb4a36cc1971bd467d618ee5d7060f9d73e9bd12c;\n', '         balances[owner] = 2000000 * 10**8;\n', '     }\n', '     \n', '     modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '     \n', '     \n', '     function distributeBTR(address[] addresses) onlyOwner {\n', '         for (uint i = 0; i < addresses.length; i++) {\n', '             balances[owner] -= 2000 * 10**8;\n', '             balances[addresses[i]] += 2000 * 10**8;\n', '             Transfer(owner, addresses[i], 2000 * 10**8);\n', '         }\n', '     }\n', '     \n', '  \n', '     function totalSupply() constant returns (uint256 totalSupply) {\n', '         totalSupply = _totalSupply;\n', '     }\n', '  \n', '\n', '     function balanceOf(address _owner) constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '     }\n', ' \n', '     function transfer(address _to, uint256 _amount) returns (bool success) {\n', '         if (balances[msg.sender] >= _amount \n', '            && _amount > 0\n', '             && balances[_to] + _amount > balances[_to]) {\n', '             balances[msg.sender] -= _amount;\n', '             balances[_to] += _amount;\n', '             Transfer(msg.sender, _to, _amount);\n', '            return true;\n', '         } else {\n', '             return false;\n', '         }\n', '     }\n', '     \n', '     \n', '     function transferFrom(\n', '         address _from,\n', '         address _to,\n', '         uint256 _amount\n', '     ) returns (bool success) {\n', '         if (balances[_from] >= _amount\n', '             && allowed[_from][msg.sender] >= _amount\n', '             && _amount > 0\n', '             && balances[_to] + _amount > balances[_to]) {\n', '             balances[_from] -= _amount;\n', '             allowed[_from][msg.sender] -= _amount;\n', '             balances[_to] += _amount;\n', '             Transfer(_from, _to, _amount);\n', '             return true;\n', '         } else {\n', '            return false;\n', '         }\n', '     }\n', ' \n', '     function approve(address _spender, uint256 _amount) returns (bool success) {\n', '         allowed[msg.sender][_spender] = _amount;\n', '        Approval(msg.sender, _spender, _amount);\n', '         return true;\n', '     }\n', '  \n', '     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '         return allowed[_owner][_spender];\n', '    }\n', '}']