['pragma solidity ^0.4.25;\n', '\n', 'contract ERC20Token {\n', '    uint256 public totalSupply;\n', '    function balanceOf(address _owner) public constant returns (uint256 balance);\n', '    function transfer(address _to, uint256 _value) public returns (bool success);\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);\n', '    function approve(address _spender, uint256 _value) public returns (bool success);\n', '    function allowance(address _owner, address _spender) public constant returns (uint256 remaining);\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', 'contract FutureEdgeAirdrop {\n', '    bool public paused = false;\n', '    modifier ifNotPaused {\n', '        require(!paused);\n', '        _;\n', '    }\n', '    function drop(address tokenAddr, address[] dests, uint256[] balances) public ifNotPaused {\n', '        for (uint i = 0; i < dests.length; i++) {\n', '            ERC20Token(tokenAddr).transferFrom(msg.sender, dests[i], balances[i]);\n', '        }\n', '    }\n', '}']