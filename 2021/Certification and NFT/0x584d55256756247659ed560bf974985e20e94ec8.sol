['pragma solidity ^0.5.0;\n', '\n', 'import "./token.sol";\n', '\n', 'contract FILXTokenSale {\n', '    address payable admin;\n', '    FilxToken public tokenContract;\n', '\n', '\n', '    constructor(FilxToken _tokenContract) public {\n', '        admin = msg.sender;\n', '        tokenContract = _tokenContract;\n', '    }\n', '\n', '    function buyTokens(uint256 _numberOfTokens) public payable{\n', '        \n', '        require(\n', '            _numberOfTokens == msg.value / 10**14,\n', '            "Number of tokens does not match with the value"\n', '        );\n', '        \n', '\n', '        require(\n', '            tokenContract.balanceOf(address(this)) >= _numberOfTokens,\n', '            "Contact does not have enough tokens"\n', '        );\n', '        require(\n', '            tokenContract.transfer(msg.sender, _numberOfTokens),\n', '            "Some problem with token transfer"\n', '        );\n', '    }\n', '\n', '    function endSale() public {\n', '        require(msg.sender == admin, "Only the admin can call this function");\n', '        require(\n', '            tokenContract.transfer(\n', '                address(0),\n', '                tokenContract.balanceOf(address(this))\n', '            ),\n', '            "Unable to transfer tokens to 0x0000"\n', '        );\n', '        // destroy contract\n', '        selfdestruct(admin);\n', '    }\n', '}']