['pragma solidity ^0.4.20;\n', '\n', '\n', 'contract ERC20 {\n', '    uint public totalSupply;\n', '    function balanceOf(address who) public constant returns (uint);\n', '    function allowance(address owner, address spender) public constant returns (uint);\n', '    function transfer(address to, uint value) public returns (bool ok);\n', '    function transferFrom(address from, address to, uint value) public returns (bool ok);\n', '    function approve(address spender, uint value) public returns (bool ok);\n', '    event Transfer(address indexed from, address indexed to, uint value);\n', '    event Approval(address indexed owner, address indexed spender, uint value);\n', '}\n', '\n', 'contract SafeMath {\n', '    function safeMul(uint a, uint b) internal pure returns (uint) {\n', '        uint c = a * b;\n', '        assert1(a == 0 || c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function safeDiv(uint a, uint b) internal pure returns (uint) {\n', '        assert1(b > 0);\n', '        uint c = a / b;\n', '        assert1(a == b * c + a % b);\n', '        return c;\n', '    }\n', '\n', '    function safeSub(uint a, uint b) internal pure returns (uint) {\n', '        assert1(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function safeAdd(uint a, uint b) internal pure returns (uint) {\n', '        uint c = a + b;\n', '        assert1(c >= a && c >= b);\n', '        return c;\n', '    }\n', '\n', '    function assert1(bool assertion) internal pure {\n', '        require(assertion);\n', '    }\n', '}\n', '\n', 'contract ZionToken is SafeMath, ERC20 {\n', '    string public constant name = "Zion - The Next Generation Communication Paradigm";\n', '    string public constant symbol = "Zion";\n', '    uint256 public constant decimals = 18;  \n', '\n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '\n', '    function ZionToken() public {\n', '        totalSupply = 5000000000 * 10 ** uint256(decimals);\n', '        balances[msg.sender] = totalSupply;\n', '    }\n', '\n', '    function balanceOf(address who) public constant returns (uint) {\n', '        return balances[who];\n', '    }\n', '\n', '    function transfer(address to, uint256 value) public returns (bool) {\n', '        uint256 senderBalance = balances[msg.sender];\n', '        if (senderBalance >= value && value > 0) {\n', '            senderBalance = safeSub(senderBalance, value);\n', '            balances[msg.sender] = senderBalance;\n', '            balances[to] = safeAdd(balances[to], value);\n', '            emit Transfer(msg.sender, to, value);\n', '            return true;\n', '        } else {\n', '            revert();\n', '        }\n', '    }\n', '\n', '\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool) {\n', '        if (balances[from] >= value &&\n', '        allowed[from][msg.sender] >= value &&\n', '        safeAdd(balances[to], value) > balances[to])\n', '        {\n', '            balances[to] = safeAdd(balances[to], value);\n', '            balances[from] = safeSub(balances[from], value);\n', '            allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], value);\n', '            emit Transfer(from, to, value);\n', '            return true;\n', '        } else {\n', '            revert();\n', '        }\n', '    }\n', '\n', '    function approve(address spender, uint256 value) public returns (bool) {\n', '        allowed[msg.sender][spender] = value;\n', '        emit Approval(msg.sender, spender, value);\n', '        return true;\n', '    }\n', '\n', '\n', '    function allowance(address owner, address spender) public constant returns (uint) {\n', '        uint allow = allowed[owner][spender];\n', '        return allow;\n', '    }\n', '}']
['pragma solidity ^0.4.20;\n', '\n', '\n', 'contract ERC20 {\n', '    uint public totalSupply;\n', '    function balanceOf(address who) public constant returns (uint);\n', '    function allowance(address owner, address spender) public constant returns (uint);\n', '    function transfer(address to, uint value) public returns (bool ok);\n', '    function transferFrom(address from, address to, uint value) public returns (bool ok);\n', '    function approve(address spender, uint value) public returns (bool ok);\n', '    event Transfer(address indexed from, address indexed to, uint value);\n', '    event Approval(address indexed owner, address indexed spender, uint value);\n', '}\n', '\n', 'contract SafeMath {\n', '    function safeMul(uint a, uint b) internal pure returns (uint) {\n', '        uint c = a * b;\n', '        assert1(a == 0 || c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function safeDiv(uint a, uint b) internal pure returns (uint) {\n', '        assert1(b > 0);\n', '        uint c = a / b;\n', '        assert1(a == b * c + a % b);\n', '        return c;\n', '    }\n', '\n', '    function safeSub(uint a, uint b) internal pure returns (uint) {\n', '        assert1(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function safeAdd(uint a, uint b) internal pure returns (uint) {\n', '        uint c = a + b;\n', '        assert1(c >= a && c >= b);\n', '        return c;\n', '    }\n', '\n', '    function assert1(bool assertion) internal pure {\n', '        require(assertion);\n', '    }\n', '}\n', '\n', 'contract ZionToken is SafeMath, ERC20 {\n', '    string public constant name = "Zion - The Next Generation Communication Paradigm";\n', '    string public constant symbol = "Zion";\n', '    uint256 public constant decimals = 18;  \n', '\n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '\n', '    function ZionToken() public {\n', '        totalSupply = 5000000000 * 10 ** uint256(decimals);\n', '        balances[msg.sender] = totalSupply;\n', '    }\n', '\n', '    function balanceOf(address who) public constant returns (uint) {\n', '        return balances[who];\n', '    }\n', '\n', '    function transfer(address to, uint256 value) public returns (bool) {\n', '        uint256 senderBalance = balances[msg.sender];\n', '        if (senderBalance >= value && value > 0) {\n', '            senderBalance = safeSub(senderBalance, value);\n', '            balances[msg.sender] = senderBalance;\n', '            balances[to] = safeAdd(balances[to], value);\n', '            emit Transfer(msg.sender, to, value);\n', '            return true;\n', '        } else {\n', '            revert();\n', '        }\n', '    }\n', '\n', '\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool) {\n', '        if (balances[from] >= value &&\n', '        allowed[from][msg.sender] >= value &&\n', '        safeAdd(balances[to], value) > balances[to])\n', '        {\n', '            balances[to] = safeAdd(balances[to], value);\n', '            balances[from] = safeSub(balances[from], value);\n', '            allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], value);\n', '            emit Transfer(from, to, value);\n', '            return true;\n', '        } else {\n', '            revert();\n', '        }\n', '    }\n', '\n', '    function approve(address spender, uint256 value) public returns (bool) {\n', '        allowed[msg.sender][spender] = value;\n', '        emit Approval(msg.sender, spender, value);\n', '        return true;\n', '    }\n', '\n', '\n', '    function allowance(address owner, address spender) public constant returns (uint) {\n', '        uint allow = allowed[owner][spender];\n', '        return allow;\n', '    }\n', '}']
