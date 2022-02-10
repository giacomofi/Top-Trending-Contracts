['/**\n', ' *Submitted for verification at Etherscan.io on 2021-05-07\n', '*/\n', '\n', 'pragma solidity 0.5.11;\n', '\n', 'contract IToken {\n', '    function balanceOf(address) public view returns (uint256);\n', '    function transfer(address to, uint value) public;\n', '}\n', '\n', 'contract Manageable {\n', '    mapping(address => bool) public admins;\n', '    constructor() public {\n', '        admins[msg.sender] = true;\n', '    }\n', '\n', '    modifier onlyAdmins() {\n', '        require(admins[msg.sender]);\n', '        _;\n', '    }\n', '\n', '    function modifyAdmins(address[] memory newAdmins, address[] memory removedAdmins) public onlyAdmins {\n', '        for(uint256 index; index < newAdmins.length; index++) {\n', '            admins[newAdmins[index]] = true;\n', '        }\n', '        for(uint256 index; index < removedAdmins.length; index++) {\n', '            admins[removedAdmins[index]] = false;\n', '        }\n', '    }\n', '}\n', '\n', 'contract HotWallet is Manageable {\n', '    mapping(uint256 => bool) public isPaid;\n', '    event Transfer(uint256 transactionRequestId, address coinAddress, uint256 value, address payable to);\n', '    \n', '    function transfer(uint256 transactionRequestId, address coinAddress, uint256 value, address payable to) public onlyAdmins {\n', '        require(!isPaid[transactionRequestId]);\n', '        isPaid[transactionRequestId] = true;\n', '        emit Transfer(transactionRequestId, coinAddress, value, to);\n', '        if (coinAddress == address(0)) {\n', '            return to.transfer(value);\n', '        }\n', '        IToken(coinAddress).transfer(to, value);\n', '    }\n', '    \n', '    function getBalances(address coinAddress) public view returns (uint256 balance)  {\n', '        if (coinAddress == address(0)) {\n', '            return address(this).balance;\n', '        }\n', '        return IToken(coinAddress).balanceOf(address(this));\n', '    }\n', '\n', '    function () external payable {}\n', '}']