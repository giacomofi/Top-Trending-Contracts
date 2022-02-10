['// SPDX-License-Identifier: MIT\n', 'pragma solidity ^0.8.0;\n', '\n', 'import "./ERC20.sol";\n', 'import "./SafeMath.sol";\n', '\n', 'contract SbetToken is ERC20("Sport Bet Token", "SBET") {\n', '    using SafeMath for uint256;\n', '\n', '    constructor(\n', '        address team,\n', '        address marketing,\n', '        address airdrop,\n', '        address dev, \n', '        address bounty, \n', '        address crowdsale\n', '    ) {\n', '        // Fixed supply of 3 billion tokens;\n', '        uint256 fixedSupply = 3000000000000000000000000000;\n', '        // Mint the full supply\n', '        _mint(msg.sender, fixedSupply);\n', '\n', '        approve(msg.sender, totalSupply());\n', '\n', '        transferFrom(msg.sender, crowdsale, fixedSupply.div(100).mul(20));\n', '        transferFrom(msg.sender, crowdsale, fixedSupply.div(100).mul(30));\n', '\n', '        transferFrom(msg.sender, crowdsale, fixedSupply.div(100).mul(35));\n', '\n', '        transferFrom(msg.sender, team, fixedSupply.div(100).mul(10));\n', '        transferFrom(msg.sender, marketing, fixedSupply.div(100).mul(2));\n', '        transferFrom(msg.sender, airdrop, fixedSupply.div(100).mul(1));\n', '        transferFrom(msg.sender, dev, fixedSupply.div(100).mul(1));\n', '        transferFrom(msg.sender, bounty, fixedSupply.div(100).mul(1));\n', '    }\n', '    \n', '\n', '}']