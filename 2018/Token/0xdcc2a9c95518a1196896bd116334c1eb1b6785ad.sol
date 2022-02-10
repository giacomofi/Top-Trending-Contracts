['pragma solidity ^0.4.18;\n', '\n', '/*\n', 'License\n', '\n', 'The MIT License (MIT)\n', '\n', 'Copyright (c) 2016 Smart Contract Solutions, Inc.\n', '\n', 'Permission is hereby granted, free of charge, to any person obtaining\n', 'a copy of this software and associated documentation files (the\n', '"Software"), to deal in the Software without restriction, including\n', 'without limitation the rights to use, copy, modify, merge, publish,\n', 'distribute, sublicense, and/or sell copies of the Software, and to\n', 'permit persons to whom the Software is furnished to do so, subject to\n', 'the following conditions:\n', '\n', 'The above copyright notice and this permission notice shall be included\n', 'in all copies or substantial portions of the Software.\n', '\n', 'THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS\n', 'OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF\n', 'MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.\n', 'IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY\n', 'CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,\n', 'TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE\n', 'SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.\n', '\n', 'Author - Daniel Blank, The Workshopp\n', '\n', '*/\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '// ----------------------------------------------------------------------------\n', '// ERC Token Standard #20 Interface\n', '// https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md\n', '// ----------------------------------------------------------------------------\n', 'contract ERC20Interface {\n', '    function totalSupply() public view returns (uint);\n', '    function balanceOf(address tokenOwner) public view returns (uint balance);\n', '    function allowance(address tokenOwner, address spender) public view returns (uint remaining);\n', '    function transfer(address to, uint tokens) public returns (bool success);\n', '    function approve(address spender, uint tokens) public returns (bool success);\n', '    function transferFrom(address from, address to, uint tokens) public returns (bool success);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint tokens);\n', '    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);\n', '}\n', '\n', '// ----------------------------------------------------------------------------\n', '// ERC20 Token, with the addition of symbol, name and decimals and an\n', '// initial fixed supply\n', '// ----------------------------------------------------------------------------\n', 'contract CGTToken is ERC20Interface {\n', '    using SafeMath for uint;\n', '\n', '    string public symbol;\n', '    string public name;\n', '    uint8 public decimals;\n', '    uint _totalSupply;\n', '\n', '    mapping(address => uint) balances;\n', '    mapping(address => mapping(address => uint)) internal allowed;\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Constructor\n', '    // ------------------------------------------------------------------------\n', '    function CGTToken() public {\n', '        symbol = "CGT";\n', '        name = "Cryptov Group Token";\n', '        decimals = 2;\n', '        _totalSupply = 10000000 * 10**uint(decimals);\n', '        balances[msg.sender] = _totalSupply;\n', '        Transfer(address(0), msg.sender, _totalSupply);\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Total supply\n', '    // ------------------------------------------------------------------------\n', '    function totalSupply() public view returns (uint) {\n', '        return _totalSupply - balances[address(0)];\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Get the token balance for account `tokenOwner`\n', '    // ------------------------------------------------------------------------\n', '    function balanceOf(address tokenOwner) public constant returns (uint balance) {\n', '        return balances[tokenOwner];\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Transfer the balance from token owner&#39;s account to `to` account\n', '    // - Owner&#39;s account must have sufficient balance to transfer\n', '    // - 0 value transfers are allowed\n', '    // ------------------------------------------------------------------------\n', '    function transfer(address to, uint tokens) public returns (bool success) {\n', '        require(to != address(0));\n', '        require(tokens <= balances[msg.sender]);\n', '    \n', '        // SafeMath.sub will throw if there is not enough balance.\n', '        balances[msg.sender] = balances[msg.sender].sub(tokens);\n', '        balances[to] = balances[to].add(tokens);\n', '        Transfer(msg.sender, to, tokens);\n', '        return true;\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Token owner can approve for `spender` to transferFrom(...) `tokens`\n', '    // from the token owner&#39;s account\n', '    //\n', '    // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md\n', '    // recommends that there are no checks for the approval double-spend attack\n', '    // as this should be implemented in user interfaces \n', '    // ------------------------------------------------------------------------\n', '    function approve(address spender, uint tokens) public returns (bool success) {\n', '        allowed[msg.sender][spender] = tokens;\n', '        Approval(msg.sender, spender, tokens);\n', '        return true;\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Transfer `tokens` from the `from` account to the `to` account\n', '    // \n', '    // The calling account must already have sufficient tokens approve(...)-d\n', '    // for spending from the `from` account and\n', '    // - From account must have sufficient balance to transfer\n', '    // - Spender must have sufficient allowance to transfer\n', '    // - 0 value transfers are allowed\n', '    // ------------------------------------------------------------------------\n', '    function transferFrom(address from, address to, uint tokens) public returns (bool success) {\n', '        require(to != address(0));\n', '        require(tokens <= balances[from]);\n', '        require(tokens <= allowed[from][msg.sender]);\n', '        \n', '        balances[from] = balances[from].sub(tokens);\n', '        balances[to] = balances[to].add(tokens);\n', '        allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);\n', '        Transfer(from, to, tokens);\n', '        return true;\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Returns the amount of tokens approved by the owner that can be\n', '    // transferred to the spender&#39;s account\n', '    // ------------------------------------------------------------------------\n', '    function allowance(address tokenOwner, address spender) public view returns (uint remaining) {\n', '        return allowed[tokenOwner][spender];\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', '    // @dev Increase the amount of tokens that an owner allowed to a spender.\n', '    //\n', '    //  * approve should be called when allowed[_spender] == 0. To increment\n', '    //  * allowed value is better to use this function to avoid 2 calls (and wait until\n', '    //  * the first transaction is mined)\n', '    //  From MonolithDAO Token.sol\n', '    //  @param _spender The address which will spend the funds.\n', '    //  @param _addedValue The amount of tokens to increase the allowance by.\n', '    // ------------------------------------------------------------------------\n', '    function increaseApproval(address _spender, uint _addedValue) public returns (bool) {\n', '        allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '        Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '   // ------------------------------------------------------------------------\n', '   // @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '   //\n', '   // approve should be called when allowed[_spender] == 0. To decrement\n', '   // allowed value is better to use this function to avoid 2 calls (and wait until\n', '   // the first transaction is mined)\n', '   // From MonolithDAO Token.sol\n', '   // @param _spender The address which will spend the funds.\n', '   // @param _subtractedValue The amount of tokens to decrease the allowance by.\n', '   // ------------------------------------------------------------------------\n', '    function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {\n', '        uint oldValue = allowed[msg.sender][_spender];\n', '        if (_subtractedValue > oldValue) {\n', '        allowed[msg.sender][_spender] = 0;\n', '        } else {\n', '        allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '        }\n', '        Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '}']
['pragma solidity ^0.4.18;\n', '\n', '/*\n', 'License\n', '\n', 'The MIT License (MIT)\n', '\n', 'Copyright (c) 2016 Smart Contract Solutions, Inc.\n', '\n', 'Permission is hereby granted, free of charge, to any person obtaining\n', 'a copy of this software and associated documentation files (the\n', '"Software"), to deal in the Software without restriction, including\n', 'without limitation the rights to use, copy, modify, merge, publish,\n', 'distribute, sublicense, and/or sell copies of the Software, and to\n', 'permit persons to whom the Software is furnished to do so, subject to\n', 'the following conditions:\n', '\n', 'The above copyright notice and this permission notice shall be included\n', 'in all copies or substantial portions of the Software.\n', '\n', 'THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS\n', 'OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF\n', 'MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.\n', 'IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY\n', 'CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,\n', 'TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE\n', 'SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.\n', '\n', 'Author - Daniel Blank, The Workshopp\n', '\n', '*/\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '// ----------------------------------------------------------------------------\n', '// ERC Token Standard #20 Interface\n', '// https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md\n', '// ----------------------------------------------------------------------------\n', 'contract ERC20Interface {\n', '    function totalSupply() public view returns (uint);\n', '    function balanceOf(address tokenOwner) public view returns (uint balance);\n', '    function allowance(address tokenOwner, address spender) public view returns (uint remaining);\n', '    function transfer(address to, uint tokens) public returns (bool success);\n', '    function approve(address spender, uint tokens) public returns (bool success);\n', '    function transferFrom(address from, address to, uint tokens) public returns (bool success);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint tokens);\n', '    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);\n', '}\n', '\n', '// ----------------------------------------------------------------------------\n', '// ERC20 Token, with the addition of symbol, name and decimals and an\n', '// initial fixed supply\n', '// ----------------------------------------------------------------------------\n', 'contract CGTToken is ERC20Interface {\n', '    using SafeMath for uint;\n', '\n', '    string public symbol;\n', '    string public name;\n', '    uint8 public decimals;\n', '    uint _totalSupply;\n', '\n', '    mapping(address => uint) balances;\n', '    mapping(address => mapping(address => uint)) internal allowed;\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Constructor\n', '    // ------------------------------------------------------------------------\n', '    function CGTToken() public {\n', '        symbol = "CGT";\n', '        name = "Cryptov Group Token";\n', '        decimals = 2;\n', '        _totalSupply = 10000000 * 10**uint(decimals);\n', '        balances[msg.sender] = _totalSupply;\n', '        Transfer(address(0), msg.sender, _totalSupply);\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Total supply\n', '    // ------------------------------------------------------------------------\n', '    function totalSupply() public view returns (uint) {\n', '        return _totalSupply - balances[address(0)];\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Get the token balance for account `tokenOwner`\n', '    // ------------------------------------------------------------------------\n', '    function balanceOf(address tokenOwner) public constant returns (uint balance) {\n', '        return balances[tokenOwner];\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', "    // Transfer the balance from token owner's account to `to` account\n", "    // - Owner's account must have sufficient balance to transfer\n", '    // - 0 value transfers are allowed\n', '    // ------------------------------------------------------------------------\n', '    function transfer(address to, uint tokens) public returns (bool success) {\n', '        require(to != address(0));\n', '        require(tokens <= balances[msg.sender]);\n', '    \n', '        // SafeMath.sub will throw if there is not enough balance.\n', '        balances[msg.sender] = balances[msg.sender].sub(tokens);\n', '        balances[to] = balances[to].add(tokens);\n', '        Transfer(msg.sender, to, tokens);\n', '        return true;\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Token owner can approve for `spender` to transferFrom(...) `tokens`\n', "    // from the token owner's account\n", '    //\n', '    // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md\n', '    // recommends that there are no checks for the approval double-spend attack\n', '    // as this should be implemented in user interfaces \n', '    // ------------------------------------------------------------------------\n', '    function approve(address spender, uint tokens) public returns (bool success) {\n', '        allowed[msg.sender][spender] = tokens;\n', '        Approval(msg.sender, spender, tokens);\n', '        return true;\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Transfer `tokens` from the `from` account to the `to` account\n', '    // \n', '    // The calling account must already have sufficient tokens approve(...)-d\n', '    // for spending from the `from` account and\n', '    // - From account must have sufficient balance to transfer\n', '    // - Spender must have sufficient allowance to transfer\n', '    // - 0 value transfers are allowed\n', '    // ------------------------------------------------------------------------\n', '    function transferFrom(address from, address to, uint tokens) public returns (bool success) {\n', '        require(to != address(0));\n', '        require(tokens <= balances[from]);\n', '        require(tokens <= allowed[from][msg.sender]);\n', '        \n', '        balances[from] = balances[from].sub(tokens);\n', '        balances[to] = balances[to].add(tokens);\n', '        allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);\n', '        Transfer(from, to, tokens);\n', '        return true;\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Returns the amount of tokens approved by the owner that can be\n', "    // transferred to the spender's account\n", '    // ------------------------------------------------------------------------\n', '    function allowance(address tokenOwner, address spender) public view returns (uint remaining) {\n', '        return allowed[tokenOwner][spender];\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', '    // @dev Increase the amount of tokens that an owner allowed to a spender.\n', '    //\n', '    //  * approve should be called when allowed[_spender] == 0. To increment\n', '    //  * allowed value is better to use this function to avoid 2 calls (and wait until\n', '    //  * the first transaction is mined)\n', '    //  From MonolithDAO Token.sol\n', '    //  @param _spender The address which will spend the funds.\n', '    //  @param _addedValue The amount of tokens to increase the allowance by.\n', '    // ------------------------------------------------------------------------\n', '    function increaseApproval(address _spender, uint _addedValue) public returns (bool) {\n', '        allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '        Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '   // ------------------------------------------------------------------------\n', '   // @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '   //\n', '   // approve should be called when allowed[_spender] == 0. To decrement\n', '   // allowed value is better to use this function to avoid 2 calls (and wait until\n', '   // the first transaction is mined)\n', '   // From MonolithDAO Token.sol\n', '   // @param _spender The address which will spend the funds.\n', '   // @param _subtractedValue The amount of tokens to decrease the allowance by.\n', '   // ------------------------------------------------------------------------\n', '    function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {\n', '        uint oldValue = allowed[msg.sender][_spender];\n', '        if (_subtractedValue > oldValue) {\n', '        allowed[msg.sender][_spender] = 0;\n', '        } else {\n', '        allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '        }\n', '        Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '}']
