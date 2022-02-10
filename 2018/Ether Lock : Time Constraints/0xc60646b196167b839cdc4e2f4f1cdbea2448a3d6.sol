['pragma solidity 0.4.24;\n', '\n', 'contract Ownable {\n', '\n', '   address public owner;\n', '\n', '   constructor() public {\n', '       owner = msg.sender;\n', '   }\n', '\n', '   function setOwner(address _owner) public onlyOwner {\n', '       owner = _owner;\n', '   }\n', '\n', '   modifier onlyOwner {\n', '       require(msg.sender == owner);\n', '       _;\n', '   }\n', '\n', '}\n', '\n', 'contract Vault is Ownable {\n', '\n', '   function () public payable {\n', '\n', '   }\n', '\n', '   function getBalance() public view returns (uint) {\n', '       return address(this).balance;\n', '   }\n', '\n', '   function withdraw(uint amount) public onlyOwner {\n', '       require(address(this).balance >= amount);\n', '       owner.transfer(amount);\n', '   }\n', '\n', '   function withdrawAll() public onlyOwner {\n', '       withdraw(address(this).balance);\n', '   }\n', '}\n', '\n', 'contract CappedVault is Vault { \n', '\n', '    uint public limit;\n', '    uint withdrawn = 0;\n', '\n', '    constructor() public {\n', '        limit = 33333 ether;\n', '    }\n', '\n', '    function () public payable {\n', '        require(total() + msg.value <= limit);\n', '    }\n', '\n', '    function total() public view returns(uint) {\n', '        return getBalance() + withdrawn;\n', '    }\n', '\n', '    function withdraw(uint amount) public onlyOwner {\n', '        require(address(this).balance >= amount);\n', '        owner.transfer(amount);\n', '        withdrawn += amount;\n', '    }\n', '\n', '}']