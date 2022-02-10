['pragma solidity ^0.4.17;\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '// TIP token contract\n', '//\n', '// Symbol           : TIP\n', '// Name             : Tipcoin\n', '// Total supply     : 10,000,000,000.000000000000000000\n', '// Decimals         : 18\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '// Safe math\n', '// ----------------------------------------------------------------------------\n', 'library SafeMath {\n', '    function add(uint a, uint b) internal pure returns (uint c) {\n', '        c = a + b;\n', '        require(c >= a);\n', '    }\n', '    function sub(uint a, uint b) internal pure returns (uint c) {\n', '        require(b <= a);\n', '        c = a - b;\n', '    }\n', '    function mul(uint a, uint b) internal pure returns (uint c) {\n', '        c = a * b;\n', '        require(a == 0 || c / a == b);\n', '    }\n', '    function div(uint a, uint b) internal pure returns (uint c) {\n', '        require(b > 0);\n', '        c = a / b;\n', '    }\n', '}\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '// ERC Token Standard #20 Interface\n', '// https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md\n', '// ----------------------------------------------------------------------------\n', 'contract ERC20Interface {\n', '    function totalSupply() public view returns (uint);\n', '    function balanceOf(address tokenOwner) public view returns (uint balance);\n', '    function allowance(address tokenOwner, address spender) public view returns (uint remaining);\n', '    function transfer(address to, uint tokens) public returns (bool success);\n', '    function approve(address spender, uint tokens) public returns (bool success);\n', '    function transferFrom(address from, address to, uint tokens) public returns (bool success);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint tokens);\n', '    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);\n', '}\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '// ERC20 Token, with the addition of symbol, name and decimals and an\n', '// initial fixed supply\n', '// ----------------------------------------------------------------------------\n', 'contract Tipcoin is ERC20Interface {\n', '    \n', '    using SafeMath for uint;\n', '\n', '    string public symbol;\n', '    string public  name;\n', '    uint8 public decimals;\n', '    uint public _totalSupply;\n', '\n', '    mapping(address => uint) balances;\n', '    mapping(address => mapping(address => uint)) allowed;\n', '    \n', '    \n', '    // ------------------------------------------------------------------------\n', '    // Constructor\n', '    // ------------------------------------------------------------------------\n', '    function Tipcoin() public {\n', '        symbol = "TIP";\n', '        name = "Tipcoin";\n', '        decimals = 18;\n', '        _totalSupply = 10000000000 * 10**uint(decimals);\n', '        address owner = 0x0eEda9Eb3333F2EBA926853a8637fa3e8Aa4b8e2;\n', '        balances[owner] = _totalSupply;\n', '        emit Transfer(address(0), owner, _totalSupply);\n', '    }\n', '    \n', '    \n', '    // ------------------------------------------------------------------------\n', '    // Reject when someone sends ethers to this contract\n', '    // ------------------------------------------------------------------------\n', '    function() public payable {\n', '        revert();\n', '    }\n', '    \n', '    \n', '    // ------------------------------------------------------------------------\n', '    // Total supply\n', '    // ------------------------------------------------------------------------\n', '    function totalSupply() public view returns (uint) {\n', '        return _totalSupply;\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Get the token balance for account `tokenOwner`\n', '    // ------------------------------------------------------------------------\n', '    function balanceOf(address tokenOwner) public view returns (uint balance) {\n', '        return balances[tokenOwner];\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Transfer the balance from token owner&#39;s account to `to` account\n', '    // - Owner&#39;s account must have sufficient balance to transfer\n', '    // - 0 value transfers are allowed\n', '    // ------------------------------------------------------------------------\n', '    function transfer(address to, uint tokens) public returns (bool success) {\n', '        if(balances[msg.sender] >= tokens && tokens > 0 && to != address(0)) {\n', '            balances[msg.sender] = balances[msg.sender].sub(tokens);\n', '            balances[to] = balances[to].add(tokens);\n', '            emit Transfer(msg.sender, to, tokens);\n', '            return true;\n', '        } else { return false; }\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Token owner can approve for `spender` to transferFrom(...) `tokens`\n', '    // from the token owner&#39;s account\n', '    //\n', '    // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md\n', '    // recommends that there are no checks for the approval double-spend attack\n', '    // as this should be implemented in user interfaces \n', '    // ------------------------------------------------------------------------\n', '    function approve(address spender, uint tokens) public returns (bool success) {\n', '        if(tokens > 0 && spender != address(0)) {\n', '            allowed[msg.sender][spender] = tokens;\n', '            emit Approval(msg.sender, spender, tokens);\n', '            return true;\n', '        } else { return false; }\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Transfer `tokens` from the `from` account to the `to` account\n', '    // \n', '    // The calling account must already have sufficient tokens approve(...)-d\n', '    // for spending from the `from` account and\n', '    // - From account must have sufficient balance to transfer\n', '    // - Spender must have sufficient allowance to transfer\n', '    // - 0 value transfers are allowed\n', '    // ------------------------------------------------------------------------\n', '    function transferFrom(address from, address to, uint tokens) public returns (bool success) {\n', '        if (balances[from] >= tokens && allowed[from][msg.sender] >= tokens && tokens > 0) {\n', '            balances[from] = balances[from].sub(tokens);\n', '            allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);\n', '            balances[to] = balances[to].add(tokens);\n', '            emit Transfer(from, to, tokens);\n', '            return true;\n', '        } else { return false; }\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Returns the amount of tokens approved by the owner that can be\n', '    // transferred to the spender&#39;s account\n', '    // ------------------------------------------------------------------------\n', '    function allowance(address tokenOwner, address spender) public view returns (uint remaining) {\n', '        return allowed[tokenOwner][spender];\n', '    }\n', '    \n', '    \n', '    // ------------------------------------------------------------------------\n', '    // Increase the amount of tokens that an owner allowed to a spender.\n', '    //\n', '    // approve should be called when allowed[_spender] == 0. To increment\n', '    // allowed value is better to use this function to avoid 2 calls (and wait until\n', '    // the first transaction is mined)\n', '    // From MonolithDAO Token.sol\n', '    // _spender The address which will spend the funds.\n', '    // _addedValue The amount of tokens to increase the allowance by.\n', '    // ------------------------------------------------------------------------\n', '    function increaseApproval(address _spender, uint _addedValue) public returns (bool) {\n', '        allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '    \n', '    \n', '    // ------------------------------------------------------------------------\n', '    // Decrease the amount of tokens that an owner allowed to a spender.\n', '    //\n', '    // approve should be called when allowed[_spender] == 0. To decrement\n', '    // allowed value is better to use this function to avoid 2 calls (and wait until\n', '    // the first transaction is mined)\n', '    // From MonolithDAO Token.sol\n', '    // _spender The address which will spend the funds.\n', '    // _subtractedValue The amount of tokens to decrease the allowance by.\n', '    // ------------------------------------------------------------------------\n', '    function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {\n', '        uint oldValue = allowed[msg.sender][_spender];\n', '        if (_subtractedValue > oldValue) {\n', '            allowed[msg.sender][_spender] = 0;\n', '        } else {\n', '            allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '        }\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '}']
['pragma solidity ^0.4.17;\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '// TIP token contract\n', '//\n', '// Symbol           : TIP\n', '// Name             : Tipcoin\n', '// Total supply     : 10,000,000,000.000000000000000000\n', '// Decimals         : 18\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '// Safe math\n', '// ----------------------------------------------------------------------------\n', 'library SafeMath {\n', '    function add(uint a, uint b) internal pure returns (uint c) {\n', '        c = a + b;\n', '        require(c >= a);\n', '    }\n', '    function sub(uint a, uint b) internal pure returns (uint c) {\n', '        require(b <= a);\n', '        c = a - b;\n', '    }\n', '    function mul(uint a, uint b) internal pure returns (uint c) {\n', '        c = a * b;\n', '        require(a == 0 || c / a == b);\n', '    }\n', '    function div(uint a, uint b) internal pure returns (uint c) {\n', '        require(b > 0);\n', '        c = a / b;\n', '    }\n', '}\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '// ERC Token Standard #20 Interface\n', '// https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md\n', '// ----------------------------------------------------------------------------\n', 'contract ERC20Interface {\n', '    function totalSupply() public view returns (uint);\n', '    function balanceOf(address tokenOwner) public view returns (uint balance);\n', '    function allowance(address tokenOwner, address spender) public view returns (uint remaining);\n', '    function transfer(address to, uint tokens) public returns (bool success);\n', '    function approve(address spender, uint tokens) public returns (bool success);\n', '    function transferFrom(address from, address to, uint tokens) public returns (bool success);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint tokens);\n', '    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);\n', '}\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '// ERC20 Token, with the addition of symbol, name and decimals and an\n', '// initial fixed supply\n', '// ----------------------------------------------------------------------------\n', 'contract Tipcoin is ERC20Interface {\n', '    \n', '    using SafeMath for uint;\n', '\n', '    string public symbol;\n', '    string public  name;\n', '    uint8 public decimals;\n', '    uint public _totalSupply;\n', '\n', '    mapping(address => uint) balances;\n', '    mapping(address => mapping(address => uint)) allowed;\n', '    \n', '    \n', '    // ------------------------------------------------------------------------\n', '    // Constructor\n', '    // ------------------------------------------------------------------------\n', '    function Tipcoin() public {\n', '        symbol = "TIP";\n', '        name = "Tipcoin";\n', '        decimals = 18;\n', '        _totalSupply = 10000000000 * 10**uint(decimals);\n', '        address owner = 0x0eEda9Eb3333F2EBA926853a8637fa3e8Aa4b8e2;\n', '        balances[owner] = _totalSupply;\n', '        emit Transfer(address(0), owner, _totalSupply);\n', '    }\n', '    \n', '    \n', '    // ------------------------------------------------------------------------\n', '    // Reject when someone sends ethers to this contract\n', '    // ------------------------------------------------------------------------\n', '    function() public payable {\n', '        revert();\n', '    }\n', '    \n', '    \n', '    // ------------------------------------------------------------------------\n', '    // Total supply\n', '    // ------------------------------------------------------------------------\n', '    function totalSupply() public view returns (uint) {\n', '        return _totalSupply;\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Get the token balance for account `tokenOwner`\n', '    // ------------------------------------------------------------------------\n', '    function balanceOf(address tokenOwner) public view returns (uint balance) {\n', '        return balances[tokenOwner];\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', "    // Transfer the balance from token owner's account to `to` account\n", "    // - Owner's account must have sufficient balance to transfer\n", '    // - 0 value transfers are allowed\n', '    // ------------------------------------------------------------------------\n', '    function transfer(address to, uint tokens) public returns (bool success) {\n', '        if(balances[msg.sender] >= tokens && tokens > 0 && to != address(0)) {\n', '            balances[msg.sender] = balances[msg.sender].sub(tokens);\n', '            balances[to] = balances[to].add(tokens);\n', '            emit Transfer(msg.sender, to, tokens);\n', '            return true;\n', '        } else { return false; }\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Token owner can approve for `spender` to transferFrom(...) `tokens`\n', "    // from the token owner's account\n", '    //\n', '    // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md\n', '    // recommends that there are no checks for the approval double-spend attack\n', '    // as this should be implemented in user interfaces \n', '    // ------------------------------------------------------------------------\n', '    function approve(address spender, uint tokens) public returns (bool success) {\n', '        if(tokens > 0 && spender != address(0)) {\n', '            allowed[msg.sender][spender] = tokens;\n', '            emit Approval(msg.sender, spender, tokens);\n', '            return true;\n', '        } else { return false; }\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Transfer `tokens` from the `from` account to the `to` account\n', '    // \n', '    // The calling account must already have sufficient tokens approve(...)-d\n', '    // for spending from the `from` account and\n', '    // - From account must have sufficient balance to transfer\n', '    // - Spender must have sufficient allowance to transfer\n', '    // - 0 value transfers are allowed\n', '    // ------------------------------------------------------------------------\n', '    function transferFrom(address from, address to, uint tokens) public returns (bool success) {\n', '        if (balances[from] >= tokens && allowed[from][msg.sender] >= tokens && tokens > 0) {\n', '            balances[from] = balances[from].sub(tokens);\n', '            allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);\n', '            balances[to] = balances[to].add(tokens);\n', '            emit Transfer(from, to, tokens);\n', '            return true;\n', '        } else { return false; }\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Returns the amount of tokens approved by the owner that can be\n', "    // transferred to the spender's account\n", '    // ------------------------------------------------------------------------\n', '    function allowance(address tokenOwner, address spender) public view returns (uint remaining) {\n', '        return allowed[tokenOwner][spender];\n', '    }\n', '    \n', '    \n', '    // ------------------------------------------------------------------------\n', '    // Increase the amount of tokens that an owner allowed to a spender.\n', '    //\n', '    // approve should be called when allowed[_spender] == 0. To increment\n', '    // allowed value is better to use this function to avoid 2 calls (and wait until\n', '    // the first transaction is mined)\n', '    // From MonolithDAO Token.sol\n', '    // _spender The address which will spend the funds.\n', '    // _addedValue The amount of tokens to increase the allowance by.\n', '    // ------------------------------------------------------------------------\n', '    function increaseApproval(address _spender, uint _addedValue) public returns (bool) {\n', '        allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '    \n', '    \n', '    // ------------------------------------------------------------------------\n', '    // Decrease the amount of tokens that an owner allowed to a spender.\n', '    //\n', '    // approve should be called when allowed[_spender] == 0. To decrement\n', '    // allowed value is better to use this function to avoid 2 calls (and wait until\n', '    // the first transaction is mined)\n', '    // From MonolithDAO Token.sol\n', '    // _spender The address which will spend the funds.\n', '    // _subtractedValue The amount of tokens to decrease the allowance by.\n', '    // ------------------------------------------------------------------------\n', '    function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {\n', '        uint oldValue = allowed[msg.sender][_spender];\n', '        if (_subtractedValue > oldValue) {\n', '            allowed[msg.sender][_spender] = 0;\n', '        } else {\n', '            allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '        }\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '}']
