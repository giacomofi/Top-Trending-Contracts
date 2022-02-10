['/**\n', ' *Submitted for verification at Etherscan.io on 2021-05-27\n', '*/\n', '\n', 'pragma solidity ^0.6.0;\n', '\n', 'interface Token {\n', '    function balanceOf(address _add) external view returns (uint256);\n', '    function transfer(address _to,uint256 _amount) external returns (bool);\n', '}\n', '\n', 'contract Sale {\n', '    address payable admin;\n', '    Token public tokenContract;\n', '\n', '\n', '    constructor(Token _tokenContract) public {\n', '        admin = msg.sender;\n', '        tokenContract = _tokenContract;\n', '    }\n', '\n', '    function buy() public payable{\n', '        \n', '        uint256   _numberOfTokens = msg.value / 10**14;\n', '\n', '        require(\n', '            tokenContract.balanceOf(address(this)) >= _numberOfTokens,\n', '            "Contact does not have enough tokens"\n', '        );\n', '        require(\n', '            tokenContract.transfer(msg.sender, _numberOfTokens),\n', '            "Some problem with token transfer"\n', '        );\n', '    }\n', '\n', '    function endSale() public {\n', '        require(msg.sender == admin);\n', '        require(\n', '            tokenContract.transfer(\n', '                address(0),\n', '                tokenContract.balanceOf(address(this))\n', '            ));\n', '            \n', '        selfdestruct(admin);\n', '    }\n', '    \n', '    receive() external payable {}\n', '\n', '    function exit() external {\n', '        require(msg.sender == admin);\n', '        admin.transfer(address(this).balance);\n', '    }\n', '    \n', '\n', '}']