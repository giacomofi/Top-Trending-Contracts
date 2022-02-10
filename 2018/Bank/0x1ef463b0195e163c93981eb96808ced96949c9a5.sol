['pragma solidity ^0.4.18;\n', '\n', '\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  uint8 public decimals;\n', '\n', '  uint256 public totalSupply;\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '    \n', '\n', '/**\n', ' * Copyright (C) 2018  Smartz, LLC\n', ' *\n', ' * Licensed under the Apache License, Version 2.0 (the "License").\n', ' * You may not use this file except in compliance with the License.\n', ' *\n', ' * Unless required by applicable law or agreed to in writing, software\n', ' * distributed under the License is distributed on an "AS IS" BASIS,\n', ' * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND (express or implied).\n', ' */\n', ' \n', '/**\n', ' * @title SwapTokenForEther\n', ' * Swap tokens of participant1 for ether of participant2\n', ' *\n', ' * @author Vladimir Khramov <<a href="/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="27514b46434e4a4e55094c4f55464a485167544a4655535d094e48">[email&#160;protected]</a>>\n', ' */\n', 'contract Swap {\n', '\n', '    address public participant1;\n', '    address public participant2;\n', '\n', '    ERC20Basic public participant1Token;\n', '    uint256 public participant1TokensCount;\n', '\n', '    uint256 public participant2EtherCount;\n', '\n', '    bool public isFinished = false;\n', '\n', '\n', '    function Swap() public payable {\n', '\n', '        participant1 = msg.sender;\n', '        participant2 = 0x6422665474ff39b0cfce217587123521c56cf33d;\n', '\n', '        participant1Token = ERC20Basic(0x6422665474fF39B0Cfce217587123521C56cF33d);\n', '        require(participant1Token.decimals() <= 18);\n', '        \n', '        participant1TokensCount = 1000 ether / 10**(18-uint256(participant1Token.decimals()));\n', '\n', '        participant2EtherCount = 0.001 ether;\n', '        \n', '        assert(participant1 != participant2);\n', '        assert(participant1Token != address(0));\n', '        assert(participant1TokensCount > 0);\n', '        assert(participant2EtherCount > 0);\n', '        \n', '        \n', '    }\n', '\n', '    /**\n', '     * Ether accepted\n', '     */\n', '    function () external payable {\n', '        require(!isFinished);\n', '        require(msg.sender == participant2);\n', '\n', '        if (msg.value > participant2EtherCount) {\n', '            msg.sender.transfer(msg.value - participant2EtherCount);\n', '        }\n', '    }\n', '\n', '    /**\n', '     * Swap tokens for ether\n', '     */\n', '    function swap() external {\n', '        require(!isFinished);\n', '\n', '        require(this.balance >= participant2EtherCount);\n', '\n', '        uint256 tokensBalance = participant1Token.balanceOf(this);\n', '        require(tokensBalance >= participant1TokensCount);\n', '\n', '        isFinished = true;\n', '        \n', '        \n', '        //check transfer\n', '        uint token1Participant2InitialBalance = participant1Token.balanceOf(participant2);\n', '    \n', '\n', '        require(participant1Token.transfer(participant2, participant1TokensCount));\n', '        if (tokensBalance > participant1TokensCount) {\n', '            require(\n', '                participant1Token.transfer(participant1, tokensBalance - participant1TokensCount)\n', '            );\n', '        }\n', '\n', '        participant1.transfer(this.balance);\n', '        \n', '        \n', '        //check transfer\n', '        assert(participant1Token.balanceOf(participant2) >= token1Participant2InitialBalance+participant1TokensCount);\n', '    \n', '    }\n', '\n', '    /**\n', '     * Refund tokens or ether by participants\n', '     */\n', '    function refund() external {\n', '        if (msg.sender == participant1) {\n', '            uint256 tokensBalance = participant1Token.balanceOf(this);\n', '            require(tokensBalance>0);\n', '\n', '            participant1Token.transfer(participant1, tokensBalance);\n', '        } else if (msg.sender == participant2) {\n', '            require(this.balance > 0);\n', '            participant2.transfer(this.balance);\n', '        } else {\n', '            revert();\n', '        }\n', '    }\n', '    \n', '\n', '    /**\n', '     * Tokens count sent by participant #1\n', '     */\n', '    function participant1SentTokensCount() public view returns (uint256) {\n', '        return participant1Token.balanceOf(this);\n', '    }\n', '\n', '    /**\n', '     * Ether count sent by participant #2\n', '     */\n', '    function participant2SentEtherCount() public view returns (uint256) {\n', '        return this.balance;\n', '    }\n', '}']