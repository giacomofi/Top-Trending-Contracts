['/**\n', ' *Submitted for verification at Etherscan.io on 2019-08-19\n', '*/\n', '\n', 'pragma solidity >=0.4.22 <0.6.0;\n', '\n', '    // ----------------------------------------------------------------------------\n', '    // Safe maths\n', '    // ----------------------------------------------------------------------------\n', '    library SafeMath {\n', '        function add(uint a, uint b) internal pure returns (uint c) {\n', '            c = a + b;\n', '            require(c >= a);\n', '        }\n', '        function sub(uint a, uint b) internal pure returns (uint c) {\n', '            require(b <= a);\n', '            c = a - b;\n', '        }\n', '        function mul(uint a, uint b) internal pure returns (uint c) {\n', '            c = a * b;\n', '            require(a == 0 || c / a == b);\n', '        }\n', '        function div(uint a, uint b) internal pure returns (uint c) {\n', '            require(b > 0);\n', '            c = a / b;\n', '        }\n', '    }\n', '\n', '    // ----------------------------------------------------------------------------\n', '    // ERC Token Standard #20 Interface\n', '    // ----------------------------------------------------------------------------\n', '    contract ERC20Interface {\n', '        function totalSupply() public view returns (uint);\n', '        function balanceOf(address tokenOwner) public view returns (uint balance);\n', '        function allowance(address tokenOwner, address spender) public view returns (uint remaining);\n', '        function transfer(address to, uint tokens) public returns (bool success);\n', '        function approve(address spender, uint tokens) public returns (bool success);\n', '        function transferFrom(address from, address to, uint tokens) public returns (bool success);\n', '\n', '        event Transfer(address indexed from, address indexed to, uint tokens);\n', '        event Approval(address indexed tokenOwner, address indexed spender, uint tokens);\n', '    }\n', '\n', '    // ----------------------------------------------------------------------------\n', '    // Bimin Token Contract\n', '    // ----------------------------------------------------------------------------\n', '    contract TEEC is ERC20Interface{\n', '        using SafeMath for uint;\n', '        \n', '        string public symbol;\n', '        string public name;\n', '        uint8 public decimals;\n', '        uint _totalSupply;\n', '        mapping(address => uint) balances;\n', '        mapping(address => mapping(address => uint)) allowed;\n', '\n', '        // ------------------------------------------------------------------------\n', '        // Constructor\n', '        // ------------------------------------------------------------------------\n', '        constructor(address _owner) public{\n', '            symbol = "TEEC";\n', '            name = "Time Efficacy Entropy Coin";\n', '            decimals = 18;\n', '            _totalSupply = 88e6; //10,000,000,000\n', '            balances[_owner] = totalSupply();\n', '            emit Transfer(address(0),_owner,totalSupply());\n', '        }\n', '\n', '        function totalSupply() public view returns (uint){\n', '        return _totalSupply * 10**uint(decimals);\n', '        }\n', '\n', '        // ------------------------------------------------------------------------\n', '        // Get the token balance for account `tokenOwner`\n', '        // ------------------------------------------------------------------------\n', '        function balanceOf(address tokenOwner) public view returns (uint balance) {\n', '            return balances[tokenOwner];\n', '        }\n', '\n', '        // ------------------------------------------------------------------------\n', "        // Transfer the balance from token owner's account to `to` account\n", "        // - Owner's account must have sufficient balance to transfer\n", '        // - 0 value transfers are allowed\n', '        // ------------------------------------------------------------------------\n', '        function transfer(address to, uint tokens) public returns (bool success) {\n', '            // prevent transfer to 0x0, use burn instead\n', '            require(to != address(0));\n', '            require(balances[msg.sender] >= tokens );\n', '            require(balances[to] + tokens >= balances[to]);\n', '            balances[msg.sender] = balances[msg.sender].sub(tokens);\n', '            balances[to] = balances[to].add(tokens);\n', '            emit Transfer(msg.sender,to,tokens);\n', '            return true;\n', '        }\n', '        \n', '        // ------------------------------------------------------------------------\n', '        // Token owner can approve for `spender` to transferFrom(...) `tokens`\n', "        // from the token owner's account\n", '        // ------------------------------------------------------------------------\n', '        function approve(address spender, uint tokens) public returns (bool success){\n', '            allowed[msg.sender][spender] = tokens;\n', '            emit Approval(msg.sender,spender,tokens);\n', '            return true;\n', '        }\n', '\n', '        // ------------------------------------------------------------------------\n', '        // Transfer `tokens` from the `from` account to the `to` account\n', '        // \n', '        // The calling account must already have sufficient tokens approve(...)\n', '        // for spending from the `from` account and\n', '        // - From account must have sufficient balance to transfer\n', '        // - Spender must have sufficient allowance to transfer\n', '        // - 0 value transfers are allowed\n', '        // ------------------------------------------------------------------------\n', '        function transferFrom(address from, address to, uint tokens) public returns (bool success){\n', '            require(tokens <= allowed[from][msg.sender]); //check allowance\n', '            require(balances[from] >= tokens);\n', '            balances[from] = balances[from].sub(tokens);\n', '            balances[to] = balances[to].add(tokens);\n', '            allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);\n', '            emit Transfer(from,to,tokens);\n', '            return true;\n', '        }\n', '        // ------------------------------------------------------------------------\n', '        // Returns the amount of tokens approved by the owner that can be\n', "        // transferred to the spender's account\n", '        // ------------------------------------------------------------------------\n', '        function allowance(address tokenOwner, address spender) public view returns (uint remaining) {\n', '            return allowed[tokenOwner][spender];\n', '        }\n', '    }']