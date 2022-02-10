['pragma solidity ^0.4.20;\n', '\n', 'interface ERC20Token {\n', '\n', '    function totalSupply() constant external returns (uint256 supply);\n', '\n', '    function balanceOf(address _owner) constant external returns (uint256 balance);\n', '\n', '    function transfer(address _to, uint256 _value) external returns (bool success);\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);\n', '\n', '    function approve(address _spender, uint256 _value) external returns (bool success);\n', '\n', '    function allowance(address _owner, address _spender) constant external returns (uint256 remaining);\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', 'contract Token is ERC20Token{\n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '\n', '    uint256 public totalSupply;\n', '\n', '    function balanceOf(address _owner) constant external returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) external returns (bool success) {\n', '        if(msg.data.length < (3 * 32) + 4) { revert(); }\n', '        \n', '        if (balances[msg.sender] >= _value && _value > 0) {\n', '            balances[msg.sender] -= _value;\n', '            balances[_to] += _value;\n', '            Transfer(msg.sender, _to, _value);\n', '            return true;\n', '        } else { return false; }\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) external returns (bool success) {\n', '        if(msg.data.length < (3 * 32) + 4) { revert(); }\n', '        \n', '        if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {\n', '            balances[_to] += _value;\n', '            balances[_from] -= _value;\n', '            allowed[_from][msg.sender] -= _value;\n', '            Transfer(_from, _to, _value);\n', '            return true;\n', '        } else { return false; }\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) external returns (bool success) {\n', '        if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }\n', '        \n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) constant external returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    function totalSupply() constant external returns (uint256 supply){\n', '        return totalSupply;\n', '    }\n', '}\n', '\n', 'contract DIUToken is Token{\n', '    address owner = msg.sender;\n', '    bool private paused = false;\n', '    \n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals;\n', '    uint256 public unitsOneEthCanBuy;\n', '    uint256 public totalEthInWei;\n', '    address public fundsWallet;\n', '\n', '    uint256 public ethRaised;\n', '    uint256 public tokenFunded;\n', '    \n', '    modifier onlyOwner{\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '    \n', '    modifier whenNotPause{\n', '        require(!paused);\n', '        _;\n', '    }\n', '\n', '    function DIUToken() {\n', '        balances[msg.sender] = 100000000 * 1000000000000000000;\n', '        totalSupply = 100000000 * 1000000000000000000;\n', '        name = "D!U";\n', '        decimals = 18;\n', '        symbol = "D!U";\n', '        unitsOneEthCanBuy = 100;\n', '        fundsWallet = msg.sender;\n', '        tokenFunded = 0;\n', '        ethRaised = 0;\n', '        paused = false;\n', '    }\n', '\n', '    function() payable whenNotPause{\n', '        if (msg.value >= 10 finney){\n', '            totalEthInWei = totalEthInWei + msg.value;\n', '            uint256 amount = msg.value * unitsOneEthCanBuy;\n', '            if (balances[fundsWallet] < amount) {\n', '                return;\n', '            }\n', '            \n', '            ethRaised = ethRaised + msg.value;\n', '            tokenFunded = tokenFunded + amount + ethRaised;\n', '    \n', '            balances[fundsWallet] = balances[fundsWallet] - amount - ethRaised;\n', '            balances[msg.sender] = balances[msg.sender] + amount + ethRaised;\n', '    \n', '            Transfer(fundsWallet, msg.sender, amount);\n', '        }\n', '        \n', '        fundsWallet.transfer(msg.value);\n', '    }\n', '\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '\n', '        if(!_spender.call(bytes4(bytes32(keccak256("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) {\n', '            revert();\n', '        }\n', '\n', '        return true;\n', '    }\n', '    \n', '    function pauseContract(bool) external onlyOwner{\n', '        paused = true;\n', '    }\n', '    \n', '    function unpauseContract(bool) external onlyOwner{\n', '        paused = false;\n', '    }\n', '    \n', '    function getStats() external constant returns (uint256, uint256, bool) {\n', '        return (ethRaised, tokenFunded, paused);\n', '    }\n', '\n', '}']
['pragma solidity ^0.4.20;\n', '\n', 'interface ERC20Token {\n', '\n', '    function totalSupply() constant external returns (uint256 supply);\n', '\n', '    function balanceOf(address _owner) constant external returns (uint256 balance);\n', '\n', '    function transfer(address _to, uint256 _value) external returns (bool success);\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);\n', '\n', '    function approve(address _spender, uint256 _value) external returns (bool success);\n', '\n', '    function allowance(address _owner, address _spender) constant external returns (uint256 remaining);\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', 'contract Token is ERC20Token{\n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '\n', '    uint256 public totalSupply;\n', '\n', '    function balanceOf(address _owner) constant external returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) external returns (bool success) {\n', '        if(msg.data.length < (3 * 32) + 4) { revert(); }\n', '        \n', '        if (balances[msg.sender] >= _value && _value > 0) {\n', '            balances[msg.sender] -= _value;\n', '            balances[_to] += _value;\n', '            Transfer(msg.sender, _to, _value);\n', '            return true;\n', '        } else { return false; }\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) external returns (bool success) {\n', '        if(msg.data.length < (3 * 32) + 4) { revert(); }\n', '        \n', '        if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {\n', '            balances[_to] += _value;\n', '            balances[_from] -= _value;\n', '            allowed[_from][msg.sender] -= _value;\n', '            Transfer(_from, _to, _value);\n', '            return true;\n', '        } else { return false; }\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) external returns (bool success) {\n', '        if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }\n', '        \n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) constant external returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    function totalSupply() constant external returns (uint256 supply){\n', '        return totalSupply;\n', '    }\n', '}\n', '\n', 'contract DIUToken is Token{\n', '    address owner = msg.sender;\n', '    bool private paused = false;\n', '    \n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals;\n', '    uint256 public unitsOneEthCanBuy;\n', '    uint256 public totalEthInWei;\n', '    address public fundsWallet;\n', '\n', '    uint256 public ethRaised;\n', '    uint256 public tokenFunded;\n', '    \n', '    modifier onlyOwner{\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '    \n', '    modifier whenNotPause{\n', '        require(!paused);\n', '        _;\n', '    }\n', '\n', '    function DIUToken() {\n', '        balances[msg.sender] = 100000000 * 1000000000000000000;\n', '        totalSupply = 100000000 * 1000000000000000000;\n', '        name = "D!U";\n', '        decimals = 18;\n', '        symbol = "D!U";\n', '        unitsOneEthCanBuy = 100;\n', '        fundsWallet = msg.sender;\n', '        tokenFunded = 0;\n', '        ethRaised = 0;\n', '        paused = false;\n', '    }\n', '\n', '    function() payable whenNotPause{\n', '        if (msg.value >= 10 finney){\n', '            totalEthInWei = totalEthInWei + msg.value;\n', '            uint256 amount = msg.value * unitsOneEthCanBuy;\n', '            if (balances[fundsWallet] < amount) {\n', '                return;\n', '            }\n', '            \n', '            ethRaised = ethRaised + msg.value;\n', '            tokenFunded = tokenFunded + amount + ethRaised;\n', '    \n', '            balances[fundsWallet] = balances[fundsWallet] - amount - ethRaised;\n', '            balances[msg.sender] = balances[msg.sender] + amount + ethRaised;\n', '    \n', '            Transfer(fundsWallet, msg.sender, amount);\n', '        }\n', '        \n', '        fundsWallet.transfer(msg.value);\n', '    }\n', '\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '\n', '        if(!_spender.call(bytes4(bytes32(keccak256("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) {\n', '            revert();\n', '        }\n', '\n', '        return true;\n', '    }\n', '    \n', '    function pauseContract(bool) external onlyOwner{\n', '        paused = true;\n', '    }\n', '    \n', '    function unpauseContract(bool) external onlyOwner{\n', '        paused = false;\n', '    }\n', '    \n', '    function getStats() external constant returns (uint256, uint256, bool) {\n', '        return (ethRaised, tokenFunded, paused);\n', '    }\n', '\n', '}']
