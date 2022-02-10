['pragma solidity ^0.4.0;\n', '\n', 'contract Ownable {\n', '  address public owner;\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  modifier onlyOwner() {\n', '    if (msg.sender != owner)\n', '        throw;\n', '    _;\n', '  }\n', '  \n', '  modifier protected() {\n', '      if(msg.sender != address(this))\n', '        throw;\n', '      _;\n', '  }\n', '\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    if (newOwner == address(0))\n', '        throw;\n', '    owner = newOwner;\n', '  }\n', '}\n', '\n', 'contract DividendDistributorv3 is Ownable{\n', '    event Transfer(\n', '        uint amount,\n', '        bytes32 message,\n', '        address target,\n', '        address currentOwner\n', '    );\n', '    \n', '    struct Investor {\n', '        uint investment;\n', '        uint lastDividend;\n', '    }\n', '\n', '    mapping(address => Investor) investors;\n', '\n', '    uint public minInvestment;\n', '    uint public sumInvested;\n', '    uint public sumDividend;\n', '    \n', '    function DividendDistributorv3() public{ \n', '        minInvestment = 0.4 ether;\n', '    }\n', '    \n', '    function loggedTransfer(uint amount, bytes32 message, address target, address currentOwner) protected\n', '    {\n', '        if(! target.call.value(amount)() )\n', '            throw;\n', '        Transfer(amount, message, target, currentOwner);\n', '    }\n', '    \n', '    function invest() public payable {\n', '        if (msg.value >= minInvestment)\n', '        {\n', '            sumInvested += msg.value;\n', '            investors[msg.sender].investment += msg.value;\n', '            // manually call payDividend() before reinvesting, because this resets dividend payments!\n', '            investors[msg.sender].lastDividend = sumDividend;\n', '        }\n', '    }\n', '\n', '    function divest(uint amount) public {\n', '        if ( investors[msg.sender].investment == 0 || amount == 0)\n', '            throw;\n', '        // no need to test, this will throw if amount > investment\n', '        investors[msg.sender].investment -= amount;\n', '        sumInvested -= amount; \n', '        this.loggedTransfer(amount, "", msg.sender, owner);\n', '    }\n', '\n', '    function calculateDividend() constant public returns(uint dividend) {\n', '        uint lastDividend = investors[msg.sender].lastDividend;\n', '        if (sumDividend > lastDividend)\n', '            throw;\n', '        // no overflows here, because not that much money will be handled\n', '        dividend = (sumDividend - lastDividend) * investors[msg.sender].investment / sumInvested;\n', '    }\n', '    \n', '    function getInvestment() constant public returns(uint investment) {\n', '        investment = investors[msg.sender].investment;\n', '    }\n', '    \n', '    function payDividend() public {\n', '        uint dividend = calculateDividend();\n', '        if (dividend == 0)\n', '            throw;\n', '        investors[msg.sender].lastDividend = sumDividend;\n', '        this.loggedTransfer(dividend, "Dividend payment", msg.sender, owner);\n', '    }\n', '    \n', '    // OWNER FUNCTIONS TO DO BUSINESS\n', '    function distributeDividends() public payable onlyOwner {\n', '        sumDividend += msg.value;\n', '    }\n', '    \n', '    function doTransfer(address target, uint amount) public onlyOwner {\n', '        this.loggedTransfer(amount, "Owner transfer", target, owner);\n', '    }\n', '    \n', '    function setMinInvestment(uint amount) public onlyOwner {\n', '        minInvestment = amount;\n', '    }\n', '    \n', '    function () public payable onlyOwner {\n', '    }\n', '\n', '    function destroy() public onlyOwner {\n', '        selfdestruct(msg.sender);\n', '    }\n', '}']