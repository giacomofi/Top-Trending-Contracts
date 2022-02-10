['pragma solidity ^0.4.11;\n', '\n', '/**\n', ' * Token BRAT. Dividends, remuneration, bounty, rewards - are sent continuously, all who have the token BRAT in wallet.\n', ' * Token BRAT (BRAT - translated into English as BROTHER) is the story of each brother in cryptohistory.\n', ' * Each brother should be BRAT.\n', ' * BRAT is the creator of the BRO-Consortium.io\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '  function Ownable() {\n', '    owner = msg.sender;\n', '  }\n', ' \n', '  modifier onlyOwner() {\n', '    if (msg.sender != owner) {\n', '      revert();\n', '    }\n', '    _;\n', '  }\n', ' \n', '  function transferOwnership(address newOwner) onlyOwner {\n', '    if (newOwner != address(0)) {\n', '      owner = newOwner;\n', '    }\n', '  }\n', '\n', '}\n', '\n', 'contract ERC20Basic {\n', '  uint public totalSupply;\n', '  function balanceOf(address who) constant returns (uint);\n', '  function transfer(address to, uint value);\n', '  event Transfer(address indexed from, address indexed to, uint value);\n', '}\n', ' \n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) constant returns (uint);\n', '  function transferFrom(address from, address to, uint value);\n', '  function approve(address spender, uint value);\n', '  event Approval(address indexed owner, address indexed spender, uint value);\n', '}\n', '\n', 'contract Airdropper is Ownable {\n', '\n', '    function multisend(address _tokenAddr, address[] dests, uint256[] values)\n', '    onlyOwner\n', '    returns (uint256) {\n', '        uint256 i = 0;\n', '        while (i < dests.length) {\n', '           ERC20(_tokenAddr).transfer(dests[i], values[i]);\n', '           i += 1;\n', '        }\n', '        return(i);\n', '    }\n', '}']