['pragma solidity ^0.4.11;\n', '\n', '// Token abstract definitioin\n', 'contract Token {\n', '    function transfer(address to, uint256 value) returns (bool success);\n', '    function transferFrom(address from, address to, uint256 value) returns (bool success);\n', '    function approve(address spender, uint256 value) returns (bool success);\n', '\n', '    function totalSupply() constant returns (uint256 totalSupply) {}\n', '    function balanceOf(address owner) constant returns (uint256 balance);\n', '    function allowance(address owner, address spender) constant returns (uint256 remaining);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '\n', 'contract WaltonTokenLocker {\n', '\n', '    address public smnAddress;\n', '    uint256 public releaseTimestamp;\n', '    string public name;\n', '    address public wtcFundation;\n', '\n', '    Token public token = Token(&#39;0x554622209Ee05E8871dbE1Ac94d21d30B61013c2&#39;);\n', '\n', '    function WaltonTokenLocker(string _name, address _token, address _beneficiary, uint256 _releaseTime) public {\n', '        // smn account\n', '        wtcFundation = msg.sender;\n', '        name = _name;\n', '        token = Token(_token);\n', '        smnAddress = _beneficiary;\n', '        releaseTimestamp = _releaseTime;\n', '    }\n', '\n', '    // when releaseTimestamp reached, and release() has been called\n', '    // WaltonTokenLocker release all wtc to smnAddress\n', '    function release() public {\n', '        if (block.timestamp < releaseTimestamp)\n', '            throw;\n', '\n', '        uint256 totalTokenBalance = token.balanceOf(this);\n', '        if (totalTokenBalance > 0)\n', '            if (!token.transfer(smnAddress, totalTokenBalance))\n', '                throw;\n', '    }\n', '\n', '\n', '    // help functions\n', '    function releaseTimestamp() public constant returns (uint timestamp) {\n', '        return releaseTimestamp;\n', '    }\n', '\n', '    function currentTimestamp() public constant returns (uint timestamp) {\n', '        return block.timestamp;\n', '    }\n', '\n', '    function secondsRemaining() public constant returns (uint timestamp) {\n', '        if (block.timestamp < releaseTimestamp)\n', '            return releaseTimestamp - block.timestamp;\n', '        else\n', '            return 0;\n', '    }\n', '\n', '    function tokenLocked() public constant returns (uint amount) {\n', '        return token.balanceOf(this);\n', '    }\n', '\n', '    // release for safe, will never be called in normal condition\n', '    function safeRelease() public {\n', '        if (msg.sender != wtcFundation)\n', '            throw;\n', '\n', '        uint256 totalTokenBalance = token.balanceOf(this);\n', '        if (totalTokenBalance > 0)\n', '            if (!token.transfer(wtcFundation, totalTokenBalance))\n', '                throw;\n', '    }\n', '\n', '    // functions for debug\n', '    //function setReleaseTime(uint256 _releaseTime) public {\n', '    //    releaseTimestamp = _releaseTime;\n', '    //}\n', '}']