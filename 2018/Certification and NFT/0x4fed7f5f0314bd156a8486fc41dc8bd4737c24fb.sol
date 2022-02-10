['pragma solidity ^0.4.19;\n', '\n', 'contract Ownable {\n', '    address public owner;\n', '    \n', '    function Ownable() public {\n', '        owner = msg.sender;\n', '    }\n', '    \n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '}\n', '\n', 'contract StakeholderInc is Ownable {\n', '    address public owner;\n', '\n', '    uint public largestStake;\n', '\n', '    function purchaseStake() public payable {\n', '        // if you own a largest stake in a company, you own a company\n', '        if (msg.value > largestStake) {\n', '            owner = msg.sender;\n', '            largestStake = msg.value;\n', '        }\n', '    }\n', '\n', '    function withdraw() public onlyOwner {\n', '        // only owner can withdraw funds\n', '        msg.sender.transfer(this.balance);\n', '    }\n', '}']