['pragma solidity ^0.4.25;\n', '\n', 'interface token {\n', '    function transfer(address receiver, uint amount) external;\n', '    function burn(uint256 _value) external returns (bool);\n', '    function balanceOf(address _address) external returns (uint256);\n', '}\n', 'contract owned {\n', '    address public owner;\n', '\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) onlyOwner public {\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', '\n', 'contract Distribute is owned {\n', '\n', '    token public tokenReward;\n', '\n', '    /**\n', '     * Constructor function\n', '     *\n', '     * Setup the owner\n', '     */\n', '    constructor() public {\n', '        tokenReward = token(0x8432A5A61Cf1CC5ca5Bc5aB919d0665427fb513c); //Token address. Modify by the current token address\n', '    }\n', '\n', '    function changeTokenAddress(address newAddress) onlyOwner public{\n', '        tokenReward = token(newAddress);\n', '    }\n', '\n', '\n', '    function airdrop(address[] participants, uint totalAmount) onlyOwner public{ //amount with decimals\n', '        require(totalAmount<=tokenReward.balanceOf(this));\n', '        uint amount;\n', '        for(uint i=0;i<participants.length;i++){\n', '            amount = totalAmount/participants.length;\n', '            tokenReward.transfer(participants[i], amount);\n', '        }\n', '    }\n', '\n', '    function bounty(address[] participants, uint[] amounts) onlyOwner public{ //Array of amounts with decimals\n', '        require(participants.length==amounts.length);\n', '        for(uint i=0; i<participants.length; i++){\n', '            tokenReward.transfer(participants[i], amounts[i]);\n', '        }\n', '\n', '    }\n', '}']