['//\n', '//     Multisend\n', '//  Crypto Duel Coin Multisend\n', '//\n', '//       Crypto Duel Coin (CDC) is a cryptocurrency for online game and online casino. Our goal is very simple. It is create and operate an online game website   where the dedicated token is used. We will develop a lot of exciting games such as cards, roulette, chess, board games and original games and build the game website where people around the world can feel free to join.\n', '\n', '// \n', '//     INFORMATION\n', '//  Name: Crypto Duel Coin \n', '//  Symbol: CDC\n', '//  Decimal: 18\n', '//  Supply: 40,000,000,000\n', '// \n', '//\n', '//\n', '//\n', '//\n', '//  Website = http://cryptoduelcoin.com/   Twitter = https://twitter.com/CryptoDuelCoin\n', '//\n', '//\n', '//  Telegram = https://t.me/CryptoDuelCoin  Medium = https://medium.com/crypto-duel-coin\n', '//\n', '//\n', '// \n', '// \n', '//\n', '// Crypto Duel Coin \n', '\n', '\n', 'pragma solidity ^0.4.11;\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control \n', ' * functions, this simplifies the implementation of "user permissions". \n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '  function Ownable() {\n', '    owner = msg.sender;\n', '  }\n', ' \n', '  modifier onlyOwner() {\n', '    if (msg.sender != owner) {\n', '      revert();\n', '    }\n', '    _;\n', '  }\n', ' \n', '  function transferOwnership(address newOwner) onlyOwner {\n', '    if (newOwner != address(0)) {\n', '      owner = newOwner;\n', '    }\n', '  }\n', '\n', '}\n', '\n', 'contract ERC20Basic {\n', '  uint public totalSupply;\n', '  function balanceOf(address who) constant returns (uint);\n', '  function transfer(address to, uint value);\n', '  event Transfer(address indexed from, address indexed to, uint value);\n', '}\n', ' \n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) constant returns (uint);\n', '  function transferFrom(address from, address to, uint value);\n', '  function approve(address spender, uint value);\n', '  event Approval(address indexed owner, address indexed spender, uint value);\n', '}\n', '\n', 'contract CyyptoDuelCoin is Ownable {\n', '\n', '    function multisend(address _tokenAddr, address[] dests, uint256[] values)\n', '    onlyOwner\n', '    returns (uint256) {\n', '        uint256 i = 0;\n', '        while (i < dests.length) {\n', '           ERC20(_tokenAddr).transfer(dests[i], values[i]);\n', '           i += 1;\n', '        }\n', '        return(i);\n', '    }\n', '}']