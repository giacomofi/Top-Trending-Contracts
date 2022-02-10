['pragma solidity ^0.4.18;\n', '\n', '\n', 'contract Token {\n', '    function balanceOf(address _account) public constant returns (uint balance);\n', '\n', '    function transfer(address _to, uint _value) public returns (bool success);\n', '}\n', '\n', '\n', 'contract CrowdSale {\n', '    address owner;\n', '\n', '    address BitcoinQuick = 0xD7AA94f17d60bE06414973a45FfA77efd6443f0F;\n', '\n', '    uint public unitCost;\n', '\n', '    function CrowdSale() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    function() public payable {\n', '        // Init Bitcoin Quick contract\n', '        Token BTCQ = Token(BitcoinQuick);\n', '        // Get available supply for this account crowdsale\n', '        uint CrowdSaleSupply = BTCQ.balanceOf(this);\n', '        // Checkout requirements\n', '        require(msg.value > 0 && CrowdSaleSupply > 0 && unitCost > 0);\n', '        // Calculate and adjust required units\n', '        uint units = msg.value / unitCost;\n', '        units = CrowdSaleSupply < units ? CrowdSaleSupply : units;\n', '        // Transfer funds\n', '        require(units > 0 && BTCQ.transfer(msg.sender, units));\n', '        // Calculate remaining ether amount\n', '        uint remainEther = msg.value - (units * unitCost);\n', '        // Return remaining ETH if above 0.001 ETH (TO SAVE INVESTOR GAS)\n', '        if (remainEther >= 10 ** 15) {\n', '            msg.sender.transfer(remainEther);\n', '        }\n', '    }\n', '\n', '    function icoPrice(uint perEther) public returns (bool success) {\n', '        require(msg.sender == owner);\n', '        unitCost = 1 ether / (perEther * 10 ** 8);\n', '        return true;\n', '    }\n', '\n', '    function withdrawFunds(address _token) public returns (bool success) {\n', '        require(msg.sender == owner);\n', '        if (_token == address(0)) {\n', '            owner.transfer(this.balance);\n', '        }\n', '        else {\n', '            Token ERC20 = Token(_token);\n', '            ERC20.transfer(owner, ERC20.balanceOf(this));\n', '        }\n', '        return true;\n', '    }\n', '}']