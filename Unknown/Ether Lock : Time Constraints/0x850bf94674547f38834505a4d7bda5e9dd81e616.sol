['pragma solidity ^0.4.8;\n', '\n', '\n', '/*\n', ' * ERC20Basic\n', ' * Simpler version of ERC20 interface\n', ' * see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20Basic {\n', '  uint public totalSupply;\n', '  function balanceOf(address who) constant returns (uint);\n', '  function transfer(address to, uint value);\n', '  event Transfer(address indexed from, address indexed to, uint value);\n', '  function transferFrom(address from, address to, uint value);\n', '  function allowance(address owner, address spender) constant returns (uint);  \n', '}\n', '\n', '\n', '\n', 'contract DistributeTokens {\n', '    ERC20Basic public token;\n', '    address owner;\n', '    function DistributeTokens( ERC20Basic _token ) {\n', '        owner = msg.sender;\n', '        token = _token;\n', '    }\n', '    \n', '    function checkExpectedTokens( address[] holdersList, uint[] expectedBalance, uint expectedTotalSupply ) constant returns(uint) {\n', '        uint totalHoldersTokens = 0;\n', '        uint i;\n', '        \n', '        if( token.totalSupply() != expectedTotalSupply ) return 0;\n', '     \n', '        for( i = 0 ; i < holdersList.length ; i++ ) {\n', '            uint holderBalance = token.balanceOf(holdersList[i]);\n', '            if( holderBalance != expectedBalance[i] ) return 0;\n', '            \n', '            totalHoldersTokens += holderBalance;\n', '        }\n', '        \n', '        return totalHoldersTokens;\n', '    }\n', '    \n', '    function distribute( address mainHolder, uint amountToDistribute, address[] holdersList, uint[] expectedBalance, uint expectedTotalSupply ) {\n', '        if( msg.sender != owner ) throw;\n', '        if( token.allowance(mainHolder,this) < amountToDistribute ) throw;\n', '        \n', '     \n', '        uint totalHoldersTokens = checkExpectedTokens(holdersList, expectedBalance, expectedTotalSupply);\n', '        if( totalHoldersTokens == 0 ) throw;\n', '     \n', '\n', '        for( uint i = 0 ; i < holdersList.length ; i++ ) {\n', '            uint extraTokens = (amountToDistribute * expectedBalance[i]) / totalHoldersTokens;\n', '            token.transferFrom(mainHolder, holdersList[i], extraTokens);\n', '        }\n', '    }\n', '}']