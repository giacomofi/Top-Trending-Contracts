['pragma solidity ^0.4.11;\n', '\n', 'contract Token {\n', '    uint256 public totalSupply;\n', '    function balanceOf(address _owner) constant returns (uint256 balance);\n', '    function transfer(address _to, uint256 _value) returns (bool success);\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success);\n', '    function approve(address _spender, uint256 _value) returns (bool success);\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining);\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', 'contract StandardToken is Token {\n', '    modifier onlyPayloadSize(uint numwords) {\n', '        assert(msg.data.length == numwords * 32 + 4);\n', '        _;\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) onlyPayloadSize(2) returns (bool success) {\n', '        if (balances[msg.sender] >= _value && _value > 0) {\n', '            balances[msg.sender] -= _value;\n', '            balances[_to] += _value;\n', '            Transfer(msg.sender, _to, _value);\n', '            return true;\n', '        } else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(3) returns (bool success) {\n', '        if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {\n', '            balances[_to] += _value;\n', '            balances[_from] -= _value;\n', '            allowed[_from][msg.sender] -= _value;\n', '            Transfer(_from, _to, _value);\n', '            return true;\n', '        } else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '    function balanceOf(address _owner) constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) onlyPayloadSize(2) returns (bool success) {\n', '        require(_value == 0 || allowed[msg.sender][_spender] == 0);\n', '\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) constant onlyPayloadSize(2) returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    mapping (address => uint256) balances;\n', '\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '}\n', '\n', 'contract SolarEclipseToken is StandardToken {\n', '    uint8 public decimals = 18;\n', '    string public name = &#39;Solar Eclipse Token&#39;;\n', '    address owner;\n', '    string public symbol = &#39;SET&#39;;\n', '\n', '    uint startTime = 1503330410; // Aug 21, 2017 at 15:46:50 UTC\n', '    uint endTime = 1503349461; // Aug 21, 2017 at 21:04:21 UTC\n', '\n', '    uint metersInAstronomicalUnit = 149597870700;\n', '    uint milesInAstronomicalUnit = 92955807;\n', '    uint speedOfLightInMetersPerSecond = 299792458;\n', '\n', '    uint public totalSupplyCap = metersInAstronomicalUnit * 1 ether;\n', '    uint public tokensPerETH = milesInAstronomicalUnit;\n', '\n', '    uint public ownerTokens = speedOfLightInMetersPerSecond * 10 ether;\n', '\n', '    function ownerWithdraw() {\n', '        if (msg.sender != owner) revert(); // revert if not owner\n', '\n', '        owner.transfer(this.balance); // send contract balance to owner\n', '    }\n', '\n', '    function () payable {\n', '        if (now < startTime) revert(); // revert if solar eclipse has not started\n', '        if (now > endTime) revert(); // revert if solar eclipse has ended\n', '        if (totalSupply >= totalSupplyCap) revert(); // revert if totalSupplyCap has been exhausted\n', '\n', '        uint tokensIssued = msg.value * tokensPerETH;\n', '\n', '        if (totalSupply + tokensIssued > totalSupplyCap) {\n', '            tokensIssued = totalSupplyCap - totalSupply; // ensure supply is capped\n', '        }\n', '\n', '        totalSupply += tokensIssued;\n', '        balances[msg.sender] += tokensIssued; // transfer tokens to contributor\n', '    }\n', '\n', '    function SolarEclipseToken() {\n', '        owner = msg.sender;\n', '        totalSupply = ownerTokens;\n', '        balances[owner] = ownerTokens;\n', '    }\n', '}']
['pragma solidity ^0.4.11;\n', '\n', 'contract Token {\n', '    uint256 public totalSupply;\n', '    function balanceOf(address _owner) constant returns (uint256 balance);\n', '    function transfer(address _to, uint256 _value) returns (bool success);\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success);\n', '    function approve(address _spender, uint256 _value) returns (bool success);\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining);\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', 'contract StandardToken is Token {\n', '    modifier onlyPayloadSize(uint numwords) {\n', '        assert(msg.data.length == numwords * 32 + 4);\n', '        _;\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) onlyPayloadSize(2) returns (bool success) {\n', '        if (balances[msg.sender] >= _value && _value > 0) {\n', '            balances[msg.sender] -= _value;\n', '            balances[_to] += _value;\n', '            Transfer(msg.sender, _to, _value);\n', '            return true;\n', '        } else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(3) returns (bool success) {\n', '        if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {\n', '            balances[_to] += _value;\n', '            balances[_from] -= _value;\n', '            allowed[_from][msg.sender] -= _value;\n', '            Transfer(_from, _to, _value);\n', '            return true;\n', '        } else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '    function balanceOf(address _owner) constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) onlyPayloadSize(2) returns (bool success) {\n', '        require(_value == 0 || allowed[msg.sender][_spender] == 0);\n', '\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) constant onlyPayloadSize(2) returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    mapping (address => uint256) balances;\n', '\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '}\n', '\n', 'contract SolarEclipseToken is StandardToken {\n', '    uint8 public decimals = 18;\n', "    string public name = 'Solar Eclipse Token';\n", '    address owner;\n', "    string public symbol = 'SET';\n", '\n', '    uint startTime = 1503330410; // Aug 21, 2017 at 15:46:50 UTC\n', '    uint endTime = 1503349461; // Aug 21, 2017 at 21:04:21 UTC\n', '\n', '    uint metersInAstronomicalUnit = 149597870700;\n', '    uint milesInAstronomicalUnit = 92955807;\n', '    uint speedOfLightInMetersPerSecond = 299792458;\n', '\n', '    uint public totalSupplyCap = metersInAstronomicalUnit * 1 ether;\n', '    uint public tokensPerETH = milesInAstronomicalUnit;\n', '\n', '    uint public ownerTokens = speedOfLightInMetersPerSecond * 10 ether;\n', '\n', '    function ownerWithdraw() {\n', '        if (msg.sender != owner) revert(); // revert if not owner\n', '\n', '        owner.transfer(this.balance); // send contract balance to owner\n', '    }\n', '\n', '    function () payable {\n', '        if (now < startTime) revert(); // revert if solar eclipse has not started\n', '        if (now > endTime) revert(); // revert if solar eclipse has ended\n', '        if (totalSupply >= totalSupplyCap) revert(); // revert if totalSupplyCap has been exhausted\n', '\n', '        uint tokensIssued = msg.value * tokensPerETH;\n', '\n', '        if (totalSupply + tokensIssued > totalSupplyCap) {\n', '            tokensIssued = totalSupplyCap - totalSupply; // ensure supply is capped\n', '        }\n', '\n', '        totalSupply += tokensIssued;\n', '        balances[msg.sender] += tokensIssued; // transfer tokens to contributor\n', '    }\n', '\n', '    function SolarEclipseToken() {\n', '        owner = msg.sender;\n', '        totalSupply = ownerTokens;\n', '        balances[owner] = ownerTokens;\n', '    }\n', '}']
