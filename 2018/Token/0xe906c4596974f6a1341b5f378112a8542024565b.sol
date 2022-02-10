['pragma solidity ^0.4.11;\n', '\n', '// Token abstract definitioin\n', 'contract Token {\n', '    function transfer(address to, uint256 value) returns (bool success);\n', '    function transferFrom(address from, address to, uint256 value) returns (bool success);\n', '    function approve(address spender, uint256 value) returns (bool success);\n', '\n', '    function totalSupply() constant returns (uint256 totalSupply) {}\n', '    function balanceOf(address owner) constant returns (uint256 balance);\n', '    function allowance(address owner, address spender) constant returns (uint256 remaining);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '\n', 'contract WaltonTokenLocker {\n', '\n', '    address public beneficiary;\n', '    uint256 public releaseTime;\n', '\n', '    Token public token = Token(&#39;0xb7cB1C96dB6B22b0D3d9536E0108d062BD488F74&#39;);\n', '\n', '    function WaltonTokenLocker() public {\n', '        // team\n', '        // beneficiary = address(&#39;0x732f589BA0b134DC35454716c4C87A06C890445b&#39;);\n', '        // test\n', '        beneficiary = address(&#39;0xa43e4646ee8ebd9AD01BFe87995802D984902e25&#39;);\n', '        releaseTime = 1563379200;     // 2019-07-18 00:00\n', '    }\n', '\n', '    // when releaseTime reached, and release() has been called\n', '    // WaltonTokenLocker release all eth and wtc to beneficiary\n', '    function release() public {\n', '        if (block.timestamp < releaseTime)\n', '            throw;\n', '\n', '        uint256 totalTokenBalance = token.balanceOf(this);\n', '        if (totalTokenBalance > 0)\n', '            if (!token.transfer(beneficiary, totalTokenBalance))\n', '                throw;\n', '    }\n', '    // release token by token contract address\n', '    function releaseToken(address _tokenContractAddress) public {\n', '        if (block.timestamp < releaseTime)\n', '            throw;\n', '\n', '        Token _token = Token(_tokenContractAddress);\n', '        uint256 totalTokenBalance = _token.balanceOf(this);\n', '        if (totalTokenBalance > 0)\n', '            if (!_token.transfer(beneficiary, totalTokenBalance))\n', '                throw;\n', '    }\n', '\n', '\n', '    // help functions\n', '    function releaseTimestamp() public constant returns (uint timestamp) {\n', '        return releaseTime;\n', '    }\n', '\n', '    function currentTimestamp() public constant returns (uint timestamp) {\n', '        return block.timestamp;\n', '    }\n', '\n', '    function secondsRemaining() public constant returns (uint timestamp) {\n', '        if (block.timestamp < releaseTime)\n', '            return releaseTime - block.timestamp;\n', '        else\n', '            return 0;\n', '    }\n', '\n', '    function tokenLocked() public constant returns (uint amount) {\n', '        return token.balanceOf(this);\n', '    }\n', '\n', '    // functions for debug\n', '    function setReleaseTime(uint256 _releaseTime) public {\n', '        releaseTime = _releaseTime;\n', '    }\n', '\n', '}']
['pragma solidity ^0.4.11;\n', '\n', '// Token abstract definitioin\n', 'contract Token {\n', '    function transfer(address to, uint256 value) returns (bool success);\n', '    function transferFrom(address from, address to, uint256 value) returns (bool success);\n', '    function approve(address spender, uint256 value) returns (bool success);\n', '\n', '    function totalSupply() constant returns (uint256 totalSupply) {}\n', '    function balanceOf(address owner) constant returns (uint256 balance);\n', '    function allowance(address owner, address spender) constant returns (uint256 remaining);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '\n', 'contract WaltonTokenLocker {\n', '\n', '    address public beneficiary;\n', '    uint256 public releaseTime;\n', '\n', "    Token public token = Token('0xb7cB1C96dB6B22b0D3d9536E0108d062BD488F74');\n", '\n', '    function WaltonTokenLocker() public {\n', '        // team\n', "        // beneficiary = address('0x732f589BA0b134DC35454716c4C87A06C890445b');\n", '        // test\n', "        beneficiary = address('0xa43e4646ee8ebd9AD01BFe87995802D984902e25');\n", '        releaseTime = 1563379200;     // 2019-07-18 00:00\n', '    }\n', '\n', '    // when releaseTime reached, and release() has been called\n', '    // WaltonTokenLocker release all eth and wtc to beneficiary\n', '    function release() public {\n', '        if (block.timestamp < releaseTime)\n', '            throw;\n', '\n', '        uint256 totalTokenBalance = token.balanceOf(this);\n', '        if (totalTokenBalance > 0)\n', '            if (!token.transfer(beneficiary, totalTokenBalance))\n', '                throw;\n', '    }\n', '    // release token by token contract address\n', '    function releaseToken(address _tokenContractAddress) public {\n', '        if (block.timestamp < releaseTime)\n', '            throw;\n', '\n', '        Token _token = Token(_tokenContractAddress);\n', '        uint256 totalTokenBalance = _token.balanceOf(this);\n', '        if (totalTokenBalance > 0)\n', '            if (!_token.transfer(beneficiary, totalTokenBalance))\n', '                throw;\n', '    }\n', '\n', '\n', '    // help functions\n', '    function releaseTimestamp() public constant returns (uint timestamp) {\n', '        return releaseTime;\n', '    }\n', '\n', '    function currentTimestamp() public constant returns (uint timestamp) {\n', '        return block.timestamp;\n', '    }\n', '\n', '    function secondsRemaining() public constant returns (uint timestamp) {\n', '        if (block.timestamp < releaseTime)\n', '            return releaseTime - block.timestamp;\n', '        else\n', '            return 0;\n', '    }\n', '\n', '    function tokenLocked() public constant returns (uint amount) {\n', '        return token.balanceOf(this);\n', '    }\n', '\n', '    // functions for debug\n', '    function setReleaseTime(uint256 _releaseTime) public {\n', '        releaseTime = _releaseTime;\n', '    }\n', '\n', '}']
