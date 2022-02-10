['pragma solidity ^0.4.11;\n', '\n', '// Token abstract definitioin\n', 'contract Token {\n', '    function transfer(address to, uint256 value) returns (bool success);\n', '    function transferFrom(address from, address to, uint256 value) returns (bool success);\n', '    function approve(address spender, uint256 value) returns (bool success);\n', '\n', '    function totalSupply() constant returns (uint256 totalSupply) {}\n', '    function balanceOf(address owner) constant returns (uint256 balance);\n', '    function allowance(address owner, address spender) constant returns (uint256 remaining);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '\n', 'contract FreyrTokenLocker {\n', '\n', '    address public beneficiary;\n', '    uint256 public releaseTime;\n', '    string constant public name = "freyr team locker";\n', '\n', '    Token public token = Token(&#39;0x17e67d1CB4e349B9CA4Bc3e17C7DF2a397A7BB64&#39;);\n', '\n', '    function FreyrTokenLocker() public {\n', '        // team account\n', '        beneficiary = address(&#39;0x31F3EcDb1d0450AEc3e5d6d98B6e0e5B322b864a&#39;);\n', '        releaseTime = 1552492800;     // 2019-03-14 00:00\n', '    }\n', '\n', '    // when releaseTime reached, and release() has been called\n', '    // FreyrTokenLocker release all eth and wtc to beneficiary\n', '    function release() public {\n', '        if (block.timestamp < releaseTime)\n', '            throw;\n', '\n', '        uint256 totalTokenBalance = token.balanceOf(this);\n', '        if (totalTokenBalance > 0)\n', '            if (!token.transfer(beneficiary, totalTokenBalance))\n', '                throw;\n', '    }\n', '\n', '\n', '    // help functions\n', '    function releaseTimestamp() public constant returns (uint timestamp) {\n', '        return releaseTime;\n', '    }\n', '\n', '    function currentTimestamp() public constant returns (uint timestamp) {\n', '        return block.timestamp;\n', '    }\n', '\n', '    function secondsRemaining() public constant returns (uint timestamp) {\n', '        if (block.timestamp < releaseTime)\n', '            return releaseTime - block.timestamp;\n', '        else\n', '            return 0;\n', '    }\n', '\n', '    function tokenLocked() public constant returns (uint amount) {\n', '        return token.balanceOf(this);\n', '    }\n', '\n', '    // functions for debug\n', '    // function setReleaseTime(uint256 _releaseTime) public {\n', '    //     releaseTime = _releaseTime;\n', '    // }\n', '\n', '}']