['pragma solidity ^0.4.18;\n', '\n', 'interface OysterPearl {\n', '    function balanceOf(address _owner) public constant returns (uint256 balance);\n', '    function transfer(address _to, uint256 _value) public;\n', '}\n', '//AIRDROP SALE\n', 'contract PearlBonus {\n', '    address public pearlContract = 0x1844b21593262668B7248d0f57a220CaaBA46ab9;\n', '    OysterPearl pearl = OysterPearl(pearlContract);\n', '    \n', '    address public director;\n', '    uint256 public funds;\n', '    bool public saleClosed;\n', '    \n', '    function PearlBonus() public {\n', '        director = msg.sender;\n', '        funds = 0;\n', '        saleClosed = false;\n', '    }\n', '    \n', '    modifier onlyDirector {\n', '        // Only the director is permitted\n', '        require(msg.sender == director);\n', '        _;\n', '    }\n', '    \n', '    /**\n', '     * Director can close the crowdsale\n', '     */\n', '    function closeSale() public onlyDirector returns (bool success) {\n', '        // The sale must be currently open\n', '        require(!saleClosed);\n', '        \n', '        // Lock the crowdsale\n', '        saleClosed = true;\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Director can open the crowdsale\n', '     */\n', '    function openSale() public onlyDirector returns (bool success) {\n', '        // The sale must be currently closed\n', '        require(saleClosed);\n', '        \n', '        // Unlock the crowdsale\n', '        saleClosed = false;\n', '        return true;\n', '    }\n', '    \n', '    function transfer(address _send, uint256 _amount) public onlyDirector {\n', '        pearl.transfer(_send, _amount);\n', '    }\n', '    \n', '    /**\n', '     * Transfers the director to a new address\n', '     */\n', '    function transferDirector(address newDirector) public onlyDirector {\n', '        director = newDirector;\n', '    }\n', '    \n', '    /**\n', '     * Withdraw funds from the contract (failsafe)\n', '     */\n', '    function withdrawFunds() public onlyDirector {\n', '        director.transfer(this.balance);\n', '    }\n', '\n', '     /**\n', '     * Crowdsale function\n', '     */\n', '    function () public payable {\n', '        // Check if crowdsale is still active\n', '        require(!saleClosed);\n', '        \n', '        // Minimum amount is 1 finney\n', '        require(msg.value >= 1 finney);\n', '        \n', '        // Airdrop price is 1 ETH = 50000 PRL\n', '        uint256 amount = msg.value * 50000;\n', '        \n', '        require(amount <= pearl.balanceOf(this));\n', '        \n', '        pearl.transfer(msg.sender, amount);\n', '        \n', '        // Track ETH amount raised\n', '        funds += msg.value;\n', '        \n', '        // Auto withdraw\n', '        director.transfer(this.balance);\n', '    }\n', '}']