['pragma solidity ^0.4.24;\n', '\n', 'contract WishingWell {\n', '\n', '    event wishMade(address indexed wisher, string wish, uint256 amount);\n', '    \n', '    address owner;\n', '    \n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(\n', '            msg.sender == owner,\n', '            "Only owner can call this function."\n', '        );\n', '        _;\n', '    }\n', '\n', '    function changeOwner(address new_owner) public onlyOwner {\n', '        owner = new_owner;\n', '    }\n', '    \n', '    function makeWish(string wish) public payable {\n', '        emit wishMade(msg.sender, wish, msg.value);\n', '    }\n', '    \n', '    function withdrawAll() public onlyOwner {\n', '        address(owner).transfer(address(this).balance);\n', '    }\n', '    \n', '}']