['pragma solidity ^0.4.11;\n', '\n', '\n', 'contract CarTaxiCrowdsale {\n', '    function soldTokensOnPreIco() constant returns (uint256);\n', '    function soldTokensOnIco() constant returns (uint256);\n', '}\n', '\n', 'contract CarTaxiToken {\n', '    function balanceOf(address owner) constant returns (uint256 balance);\n', '    function getOwnerCount() constant returns (uint256 value);\n', '}\n', '\n', 'contract CarTaxiBonus {\n', '\n', '    CarTaxiCrowdsale public carTaxiCrowdsale;\n', '    CarTaxiToken public carTaxiToken;\n', '\n', '\n', '    address public owner;\n', '    address public carTaxiCrowdsaleAddress = 0x77CeFf4173a56cd22b6184Fa59c668B364aE55B8;\n', '    address public carTaxiTokenAddress = 0x662aBcAd0b7f345AB7FfB1b1fbb9Df7894f18e66;\n', '\n', '    uint constant BASE = 1000000000000000000;\n', '    uint public totalTokens;\n', '    uint public totalBonuses;\n', '    uint public iteration = 0;\n', '    \n', '    bool init = false;\n', '\n', '    //mapping (address => bool) private contributors;\n', '\n', '\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function setOwner(address _owner) public onlyOwner{\n', '        require(_owner != 0x0);\n', '        owner = _owner;\n', '    }\n', '\n', '    function CarTaxiBonus() {\n', '        owner = msg.sender;\n', '        carTaxiCrowdsale = CarTaxiCrowdsale(carTaxiCrowdsaleAddress);\n', '        carTaxiToken = CarTaxiToken(carTaxiTokenAddress);\n', '    }\n', '\n', '    function sendValue(address addr, uint256 val) public onlyOwner{\n', '        addr.transfer(val);\n', '    }\n', '\n', '    function setTotalTokens(uint256 _totalTokens) public onlyOwner{\n', '        totalTokens = _totalTokens;\n', '    }\n', '\n', '    function setTotalBonuses(uint256 _totalBonuses) public onlyOwner{\n', '        totalBonuses = _totalBonuses;\n', '    }\n', '\n', '    function sendAuto(address addr) public onlyOwner{\n', '\n', '        uint256 addrTokens = carTaxiToken.balanceOf(addr);\n', '\n', '        require(addrTokens > 0);\n', '        require(totalTokens > 0);\n', '\n', '        uint256 pie = addrTokens * totalBonuses / totalTokens;\n', '\n', '        addr.transfer(pie);\n', '        \n', '    }\n', '\n', '    function withdrawEther() public onlyOwner {\n', '        require(this.balance > 0);\n', '        owner.transfer(this.balance);\n', '    }\n', '    \n', '    function () payable { }\n', '  \n', '}']